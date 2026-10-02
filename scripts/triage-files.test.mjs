// triage-files.test.mjs — the two gates, and the ways they must fail closed.

import assert from "node:assert/strict";
import { mkdtempSync, writeFileSync, mkdirSync, symlinkSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  scanSecrets, buildIndex, triageFile, triage, digestFile, VERDICT, MAX_BYTES,
} from "./triage-files.mjs";

let checks = 0;
const check = (name, fn) => { fn(); checks += 1; console.log(`  ok  ${name}`); };

const dir = mkdtempSync(join(tmpdir(), "triage-"));
const write = (name, body) => {
  const p = join(dir, name);
  writeFileSync(p, body);
  return p;
};

// ── gate 1: secrets ────────────────────────────────────────────────────
console.log("the secrets gate");

check("finds an AWS key and never echoes it", () => {
  const secret = "AKIAIOSFODNN7EXAMPLE";
  const found = scanSecrets(`key = "${secret}"`);
  assert.equal(found.length, 1);
  assert.equal(found[0].rule, "aws-access-key");
  assert.equal(found[0].line, 1);
  assert.ok(!JSON.stringify(found).includes(secret), "the secret is not in the finding");
  assert.match(found[0].preview, /\*{4,}/, "the middle is masked");
  assert.notEqual(found[0].preview, secret, "the preview is not the secret");
  assert.ok(!found[0].preview.includes(secret.slice(3, -3)), "the body is not recoverable");
});

check("finds a private key block", () => {
  assert.equal(scanSecrets("-----BEGIN RSA PRIVATE KEY-----").length, 1);
});

check("finds a nix store key", () => {
  const k = `${"a".repeat(64)}-${"b".repeat(86)}`;
  assert.equal(scanSecrets(`path = ${k}`).length, 1);
});

check("finds credentials embedded in a url", () => {
  const f = scanSecrets("git clone https://user:hunter2pass@example.com/repo.git");
  assert.equal(f.length, 1);
  assert.equal(f[0].rule, "basic-auth-url");
  assert.ok(!JSON.stringify(f).includes("hunter2pass"), "the password is not echoed");
});

check("reports the line a secret is on", () => {
  assert.equal(scanSecrets("a\nb\nc\nAKIAIOSFODNN7EXAMPLE\n")[0].line, 4);
});

check("ordinary prose is not a secret", () => {
  assert.deepEqual(scanSecrets("theorem foo : 1 + 1 = 2 := by rfl\n"), []);
});

check("a file with a secret is blocked", () => {
  const p = write("leaky.lean", 'def key := "AKIAIOSFODNN7EXAMPLE"');
  const r = triageFile(p, null, dir);
  assert.equal(r.verdict, VERDICT.BLOCKED);
  assert.ok(!JSON.stringify(r).includes("AKIAIOSFODNN7EXAMPLE"), "still not echoed");
});

// ── gate 2: provenance ─────────────────────────────────────────────────
console.log("the provenance gate");

const upstream = mkdtempSync(join(tmpdir(), "upstream-"));
writeFileSync(join(upstream, "Nat.lean"), "theorem t : 1 + 1 = 2 := by rfl\n");
const index = buildIndex(upstream);

check("the index is built from content, not filenames", () => {
  assert.equal(index.files, 1);
  assert.equal(Object.keys(index.digests).length, 1);
});

check("a file matching an upstream digest is shareable", () => {
  const p = write("copy.lean", "theorem t : 1 + 1 = 2 := by rfl\n");
  const r = triageFile(p, index, dir);
  assert.equal(r.verdict, VERDICT.OPEN);
  assert.match(r.upstream, /Nat\.lean/);
});

check("the same bytes under another name still match", () => {
  const p = write("renamed-entirely.lean", "theorem t : 1 + 1 = 2 := by rfl\n");
  assert.equal(triageFile(p, index, dir).verdict, VERDICT.OPEN);
});

check("novel work with no upstream match is private", () => {
  const p = write("novel.lean", "theorem myOwnResult : ∀ n, n + 0 = n := by simp\n");
  const r = triageFile(p, index, dir);
  assert.equal(r.verdict, VERDICT.PRIVATE);
  assert.equal(r.upstream, undefined);
});

check("no index at all means everything is private", () => {
  const p = write("orphan.lean", "theorem q : True := trivial\n");
  assert.equal(triageFile(p, null, dir).verdict, VERDICT.PRIVATE);
});

check("one changed byte makes it private again", () => {
  const p = write("almost.lean", "theorem t : 1 + 1 = 2 := by simp\n");
  assert.equal(triageFile(p, index, dir).verdict, VERDICT.PRIVATE);
});

// ── failing closed ─────────────────────────────────────────────────────
console.log("failing closed");

check("a symlink is private, never followed", () => {
  const link = join(dir, "sneaky.lean");
  symlinkSync(join(upstream, "Nat.lean"), link);
  const r = triageFile(link, index, dir);
  assert.equal(r.verdict, VERDICT.PRIVATE);
  assert.deepEqual(r.reasons, ["symlink"]);
});

check("a missing file is private", () => {
  const r = triageFile(join(dir, "nope.lean"), index, dir);
  assert.equal(r.verdict, VERDICT.PRIVATE);
  assert.match(r.reasons[0], /unreadable/);
});

check("an oversized file is private rather than hashed", () => {
  const r = digestFile(write("big.bin", "x"));
  assert.equal(r.ok, true, "small enough to hash");
  const big = join(dir, "huge.bin");
  writeFileSync(big, Buffer.alloc(MAX_BYTES + 1));
  const rb = digestFile(big);
  assert.equal(rb.ok, false);
  assert.match(rb.reason, /too large/);
  assert.equal(triageFile(big, index, dir).verdict, VERDICT.PRIVATE);
});

check("a directory walks to its regular files only", () => {
  const sub = join(dir, "pkg");
  mkdirSync(sub, { recursive: true });
  writeFileSync(join(sub, "a.lean"), "theorem a : True := trivial\n");
  symlinkSync(join(upstream, "Nat.lean"), join(sub, "b.lean"));
  const rows = triage([sub], index, dir);
  assert.equal(rows.length, 2, "the symlink is reported, not skipped silently");
  assert.equal(rows.filter((r) => r.verdict === VERDICT.OPEN).length, 0,
    "the symlink does not inherit the upstream file's shareability");
  assert.equal(rows.filter((r) => r.verdict === VERDICT.PRIVATE).length, 2);
  assert.ok(rows.some((r) => r.reasons.includes("symlink")), "and it says why");
});

check("a secret outranks an upstream match", () => {
  // Even if these bytes were upstream, a credential blocks them.
  const p = write("both.lean", 'AKIAIOSFODNN7EXAMPLE');
  const r = triageFile(p, index, dir);
  assert.equal(r.verdict, VERDICT.BLOCKED);
});

check("every verdict is one of the three", () => {
  const rows = triage([dir], index, dir);
  const allowed = new Set(Object.values(VERDICT));
  for (const r of rows) assert.ok(allowed.has(r.verdict), `${r.verdict} is a known verdict`);
});

console.log(`\n${checks} checks passed`);