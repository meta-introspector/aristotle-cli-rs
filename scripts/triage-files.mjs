// triage-files.mjs — decide what may be shared, and what may not.
//
// Two independent gates, both failing closed:
//
//   1. secrets    a credential anywhere in a file blocks it outright.
//                 Nothing is ever printed in the clear: findings carry a
//                 rule name, a line number and a masked preview only.
//   2. provenance a file is "open source" only if its exact content
//                 digest appears in an index built from a known upstream
//                 checkout. Everything else — novel work, an unreadable
//                 file, a symlink, a file too large to hash — is private.
//
// The default is private. A file only becomes shareable by positively
// matching a known upstream, because publishing work that was meant to
// stay private cannot be undone by deleting it.
//
//   node scripts/triage-files.mjs build-index <dir> [--out index.json]
//   node scripts/triage-files.mjs triage <dir...> [--index i.json] [--json r.json]
//
// Exit status is 1 when anything is blocked, so it can gate a pipeline.

import { createHash } from "node:crypto";
import { readFileSync, readdirSync, lstatSync, writeFileSync } from "node:fs";
import { join, relative, basename } from "node:path";

// ------------------------------------------------------------- secrets

/** Credential shapes worth stopping a file for. Deliberately noisy:
 *  a false positive costs a human a glance, a false negative costs a
 *  leaked key. */
export const SECRET_RULES = [
  ["aws-access-key", /\bAKIA[0-9A-Z]{16}\b/g],
  ["github-token", /\bgh[pousr]_[A-Za-z0-9]{36,}\b/g],
  ["slack-token", /\bxox[abprs]-[A-Za-z0-9-]{10,}\b/g],
  ["private-key", /-----BEGIN (?:RSA |EC |OPENSSH |PGP )?PRIVATE KEY-----/g],
  ["jwt", /\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b/g],
  ["anthropic-key", /\bsk-ant-[A-Za-z0-9_-]{20,}\b/g],
  ["openai-key", /\bsk-[A-Za-z0-9]{32,}\b/g],
  ["google-api-key", /\bAIza[0-9A-Za-z_-]{35}\b/g],
  ["sops-age-key", /\bAGE-SECRET-KEY-1[0-9A-Z]{58}\b/g],
  ["nix-key", /(?<![A-Za-z0-9])[a-zA-Z0-9]{64}-[A-Za-z0-9=]{86}(?![A-Za-z0-9])/g],
  ["basic-auth-url", /\b[a-z][a-z0-9+.-]*:\/\/[^\s/:@]+:[^\s/@]+@/gi],
  ["assigned-secret", /\b(?:api[_-]?key|secret|passwd|password|token)\b\s*[:=]\s*["'][^"'\s]{8,}["']/gi],
];

/** Never echo a matched credential: keep only enough to recognise it. */
const mask = (s) => {
  if (s.length <= 8) return "*".repeat(s.length);
  return `${s.slice(0, 3)}${"*".repeat(Math.min(12, s.length - 6))}${s.slice(-3)}`;
};

/** Scan text for credentials. Returns rule/line/masked, never the secret. */
export function scanSecrets(text) {
  const findings = [];
  for (const [rule, re] of SECRET_RULES) {
    const rx = new RegExp(re.source, re.flags.includes("g") ? re.flags : `${re.flags}g`);
    for (const m of text.matchAll(rx)) {
      const line = text.slice(0, m.index).split("\n").length;
      findings.push({ rule, line, preview: mask(m[0]) });
    }
  }
  return findings;
}

// ------------------------------------------------------------ provenance

export const sha256 = (bytes) => createHash("sha256").update(bytes).digest("hex");

/** Files above this are not hashed: they are reported private. */
export const MAX_BYTES = 8 * 1024 * 1024;

/** Hash one path, or explain why it cannot be trusted. */
export function digestFile(path) {
  let st;
  try {
    st = lstatSync(path);
  } catch (e) {
    return { ok: false, reason: `unreadable: ${e.code ?? e.message}` };
  }
  if (st.isSymbolicLink()) return { ok: false, reason: "symlink" };
  if (!st.isFile()) return { ok: false, reason: "not a regular file" };
  if (st.size > MAX_BYTES) return { ok: false, reason: `too large (${st.size} bytes)` };
  let bytes;
  try {
    bytes = readFileSync(path);
  } catch (e) {
    return { ok: false, reason: `unreadable: ${e.code ?? e.message}` };
  }
  return { ok: true, bytes, size: st.size, sha256: sha256(bytes) };
}

/** Walk a tree, yielding regular files (never following symlinks). */
export function* walk(dir, depth = 0) {
  let entries;
  try {
    entries = readdirSync(dir, { withFileTypes: true });
  } catch {
    return;
  }
  for (const e of entries) {
    if (e.name === ".git" || e.name === "node_modules" || e.name === "target") continue;
    const p = join(dir, e.name);
    if (e.isDirectory()) yield* walk(p, depth + 1);
    else yield p;
  }
}

/** Build a provenance index: every content digest under `dir`. */
export function buildIndex(dir) {
  const digests = {};
  let files = 0;
  for (const p of walk(dir)) {
    const d = digestFile(p);
    if (!d.ok) continue;
    files += 1;
    digests[d.sha256] = { path: relative(dir, p), size: d.size };
  }
  return { version: 1, root: dir, files, digests };
}

export const loadIndex = (path) => JSON.parse(readFileSync(path, "utf8"));

// ------------------------------------------------------------- triage

export const VERDICT = { BLOCKED: "blocked", OPEN: "open-source", PRIVATE: "novel-private" };

/** Triage one path against a provenance index. Fails closed. */
export function triageFile(path, index, root = process.cwd()) {
  const d = digestFile(path);
  const rel = relative(root, path) || basename(path);

  if (!d.ok) return { path: rel, verdict: VERDICT.PRIVATE, reasons: [d.reason], secrets: [] };

  // Secrets are checked on bytes-as-text; a binary file simply yields none.
  const text = d.bytes.toString("utf8");
  const secrets = scanSecrets(text);
  if (secrets.length > 0) {
    return {
      path: rel, size: d.size, sha256: d.sha256,
      verdict: VERDICT.BLOCKED,
      reasons: [`${secrets.length} credential(s) found`],
      secrets,
    };
  }

  const hit = index?.digests?.[d.sha256];
  if (hit) {
    return {
      path: rel, size: d.size, sha256: d.sha256,
      verdict: VERDICT.OPEN,
      reasons: [`matches upstream ${hit.path}`],
      upstream: hit.path,
      secrets: [],
    };
  }

  return {
    path: rel, size: d.size, sha256: d.sha256,
    verdict: VERDICT.PRIVATE,
    reasons: ["no matching upstream digest — treated as novel work"],
    secrets: [],
  };
}

export function triage(paths, index, root) {
  const files = paths.flatMap((p) => {
    try {
      return lstatSync(p).isDirectory() ? [...walk(p)] : [p];
    } catch {
      return [p];
    }
  });
  // Report paths relative to something readable. Without an explicit root
  // the cwd would turn every /tmp target into a stack of `../`.
  const base = root ?? commonAncestor(files);
  return files.map((p) => triageFile(p, index, base)).sort((a, b) => a.path.localeCompare(b.path));
}

/** The deepest directory containing every path. */
function commonAncestor(paths) {
  if (!paths.length) return process.cwd();
  const split = (p) => p.split("/").filter(Boolean);
  let parts = split(paths[0]);
  for (const p of paths.slice(1)) {
    const q = split(p);
    let i = 0;
    while (i < parts.length && i < q.length && parts[i] === q[i]) i += 1;
    parts = parts.slice(0, i);
  }
  return `/${parts.join("/")}` || "/";
}

// ------------------------------------------------------------------ cli

const summarise = (rows) => {
  const n = (v) => rows.filter((r) => r.verdict === v).length;
  return {
    total: rows.length,
    [VERDICT.OPEN]: n(VERDICT.OPEN),
    [VERDICT.PRIVATE]: n(VERDICT.PRIVATE),
    [VERDICT.BLOCKED]: n(VERDICT.BLOCKED),
  };
};

const main = (argv) => {
  const [cmd, ...rest] = argv;
  const flag = (name, dflt) => {
    const i = rest.indexOf(`--${name}`);
    return i >= 0 ? rest[i + 1] : dflt;
  };
  const paths = rest.filter((a, i) => !a.startsWith("--") && !(i > 0 && rest[i - 1].startsWith("--")));

  if (cmd === "build-index") {
    if (!paths[0]) throw new Error("usage: build-index <dir> [--out index.json]");
    const idx = buildIndex(paths[0]);
    const out = flag("out");
    if (out) writeFileSync(out, `${JSON.stringify(idx, null, 2)}\n`);
    console.log(`indexed ${idx.files} files from ${idx.root}`);
    return 0;
  }

  if (cmd === "triage") {
    if (!paths.length) throw new Error("usage: triage <dir...> [--index i.json] [--json r.json]");
    const idxPath = flag("index");
    const index = idxPath ? loadIndex(idxPath) : null;
    const rows = triage(paths, index);
    const out = flag("json");
    if (out) writeFileSync(out, `${JSON.stringify({ summary: summarise(rows), files: rows }, null, 2)}\n`);
    for (const r of rows) {
      const tag = { [VERDICT.OPEN]: "share", [VERDICT.PRIVATE]: "PRIVATE", [VERDICT.BLOCKED]: "BLOCKED" }[r.verdict];
      console.log(`  ${tag.padEnd(8)} ${r.path}  ${r.reasons.join("; ")}`);
    }
    const s = summarise(rows);
    console.log(`\n${s.total} files: ${s[VERDICT.OPEN]} shareable, ${s[VERDICT.PRIVATE]} private, ${s[VERDICT.BLOCKED]} blocked`);
    return s[VERDICT.BLOCKED] > 0 ? 1 : 0;
  }

  throw new Error(`unknown command: ${cmd ?? "(none)"}`);
};

if (import.meta.url === `file://${process.argv[1]}`) {
  try {
    process.exit(main(process.argv.slice(2)));
  } catch (e) {
    console.error(`triage-files: ${e.message}`);
    process.exit(2);
  }
}