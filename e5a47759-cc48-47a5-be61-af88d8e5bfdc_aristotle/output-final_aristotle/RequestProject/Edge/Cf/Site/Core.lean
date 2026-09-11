/-
# The bundle reader and the plan builder, in the browser

`coreJs` is the browser-side twin of the Lean pipeline: gunzip, the ustar
walk, the FNV-1a content hash, the selection model and the plan builder,
so a `.tgz` dropped on the page becomes the same plan the CLI writes.
-/
import RequestProject.Edge.Cf.Site.Inline

namespace CfDeploy
namespace Site

/-! ## The bundle reader and the plan builder, in the browser

This is the browser-side twin of `Cf.Inflate` + `Cf.Tar` + `Cf.Bundle` +
`Cf.JsEmit.planStep`: gzip is handed to the platform's own
`DecompressionStream`, the tar walk mirrors `Tar.entries`, the hashing
mirrors `Bundle.fnv1a64`/`hex16`, and every step it builds is the step
`JsEmit.planStep` emits for the corresponding `Action` — including the
role that signs it and the permission groups its token may carry.
`web/site-test.mjs` checks that correspondence on a real archive, against
the plan the Lean CLI itself wrote. -/
def coreJs : String :=
r##"// scratch: the browser core, mirroring the Lean model

let KERNEL = null;
export function useKernel(exports) { KERNEL = exports; }

const FNV_OFFSET = 14695981039346656037n;
const FNV_PRIME = 1099511628211n;
const MASK64 = (1n << 64n) - 1n;

/** FNV-1a 64, the content hash of `Bundle.fnv1a64`. */
export function fnv1a64(bytes) {
  if (KERNEL) {
    let h = BigInt.asUintN(64, KERNEL.fnv_offset());
    for (let i = 0; i < bytes.length; i++) {
      h = BigInt.asUintN(64, KERNEL.fnv1a_step(h, BigInt(bytes[i])));
    }
    return h;
  }
  let h = FNV_OFFSET;
  for (let i = 0; i < bytes.length; i++) h = ((h ^ BigInt(bytes[i])) * FNV_PRIME) & MASK64;
  return h;
}

const hexDigit = (n) => (KERNEL
  ? String.fromCharCode(Number(BigInt.asUintN(64, KERNEL.hex_lo(BigInt(n)))))
  : '0123456789abcdef'[Number(n)]);

/** Sixteen hex digits of a 64-bit value (`Bundle.hex16`). */
export function hex16(v) {
  let out = '';
  for (let i = 15; i >= 0; i--) out += hexDigit((v >> BigInt(4 * i)) & 15n);
  return out;
}

/** MIME type from the extension (`Bundle.contentTypeOf`). */
export function contentTypeOf(path) {
  const parts = path.split('.');
  const ext = parts[parts.length - 1];
  if (ext === 'html' || ext === 'htm') return 'text/html; charset=utf-8';
  if (ext === 'css') return 'text/css; charset=utf-8';
  if (ext === 'js' || ext === 'mjs') return 'text/javascript; charset=utf-8';
  if (ext === 'json') return 'application/json';
  if (ext === 'svg') return 'image/svg+xml';
  if (ext === 'png') return 'image/png';
  if (ext === 'jpg' || ext === 'jpeg') return 'image/jpeg';
  if (ext === 'webp') return 'image/webp';
  if (ext === 'ico') return 'image/x-icon';
  if (ext === 'wasm') return 'application/wasm';
  if (ext === 'txt' || ext === 'md' || ext === 'lean' || ext === 'toml') {
    return 'text/plain; charset=utf-8';
  }
  return 'application/octet-stream';
}

export const stripTopLevel = (p) => p.split('/').slice(1).join('/');
export const servedPath = (strip, p) => '/' + (strip ? stripTopLevel(p) : p);

/** gzip → bytes, using the platform's own DecompressionStream. */
export async function gunzip(bytes) {
  const stream = new Blob([bytes]).stream().pipeThrough(new DecompressionStream('gzip'));
  return new Uint8Array(await new Response(stream).arrayBuffer());
}

const readStr = (data, off, len) => {
  let s = '';
  for (let i = 0; i < len; i++) {
    const b = data[off + i];
    if (b === 0 || b === undefined) break;
    s += String.fromCharCode(b);
  }
  return s;
};

const parseOctal = (data, off, len) => {
  let v = 0;
  for (let i = 0; i < len; i++) {
    const b = data[off + i];
    if (b >= 48 && b <= 55) v = v * 8 + (b - 48);
  }
  return v;
};

const isZeroBlock = (data, off) => {
  for (let i = 0; i < 512; i++) if (data[off + i] !== 0) return false;
  return true;
};

/** The regular files of a tar archive, in order (`Tar.entries`). */
export function tarEntries(data) {
  const out = [];
  let off = 0;
  let longName = null;
  while (off + 512 <= data.length && !isZeroBlock(data, off)) {
    const name = readStr(data, off, 100);
    const prefix = readStr(data, off + 345, 155);
    const size = parseOctal(data, off + 124, 12);
    const mode = parseOctal(data, off + 100, 8);
    const typeflag = data[off + 156];
    const dataOff = off + 512;
    const padded = Math.floor((size + 511) / 512) * 512;
    if (typeflag === 76) {
      longName = readStr(data.subarray(dataOff, dataOff + size), 0, size);
    } else {
      const fullName = longName !== null ? longName : (prefix === '' ? name : prefix + '/' + name);
      longName = null;
      if (typeflag === 48 || typeflag === 0) {
        out.push({ path: fullName, contents: data.subarray(dataOff, dataOff + size), mode });
      }
    }
    off = dataOff + padded;
  }
  return out;
}

/** Archive members → assets (`Bundle.assetsOfEntries`), with their bodies. */
export function assetsOfEntries(strip, entries) {
  const out = [];
  for (const e of entries) {
    const path = servedPath(strip, e.path);
    if (path === '/') continue;
    out.push({
      path,
      contentType: contentTypeOf(e.path),
      size: e.contents.length,
      hash: hex16(fnv1a64(e.contents)),
      contents: e.contents,
    });
  }
  return out;
}

export async function assetsOfTgz(strip, tgz) {
  return assetsOfEntries(strip, tarEntries(await gunzip(tgz)));
}

// ---------------------------------------------------------------- the plan
// One `planStep` per `Action`, exactly as `RequestProject.Cf.JsEmit` emits
// them: the role that signs it, the request, the permission groups its
// token must carry, and the resources that token is scoped to.

const accountKey = (a) => 'com.cloudflare.api.account.' + a;
const zoneKey = (z) => 'com.cloudflare.api.account.zone.' + z;
const userKey = (u) => 'com.cloudflare.api.user.' + u;

const step = (o) => ({
  role: o.role,
  method: o.method,
  url: CF_API + o.path,
  body: o.body ?? null,
  groups: o.groups ?? [],
  resources: o.resources ?? [],
  payload: o.payload ?? null,
  describe: o.describe,
});

export function kvUploadSteps(cfg, assets) {
  return assets.map((a) => step({
    role: `kv-write@${cfg.account}/${cfg.kvNamespace}`,
    method: 'PUT',
    path: `/accounts/${cfg.account}/storage/kv/namespaces/${cfg.kvNamespace}/values/${a.hash}`,
    groups: ['Workers KV Storage Edit'],
    resources: [accountKey(cfg.account)],
    payload: a.hash,
    describe: `write KV ${cfg.kvNamespace}/${a.hash}`,
  }));
}

export function workerSiteSteps(cfg, assets) {
  return kvUploadSteps(cfg, assets).concat([step({
    role: `worker-write@${cfg.account}`,
    method: 'PUT',
    path: `/accounts/${cfg.account}/workers/scripts/${cfg.project}`,
    groups: ['Workers Scripts Edit'],
    resources: [accountKey(cfg.account)],
    payload: 'worker:' + cfg.project,
    describe: `upload Worker script ${cfg.project}`,
  })]);
}

export function pagesSiteSteps(cfg, assets) {
  const branch = cfg.branch || 'main';
  const steps = [
    step({
      role: `pages-create@${cfg.account}`,
      method: 'POST',
      path: `/accounts/${cfg.account}/pages/projects`,
      body: { name: cfg.project, production_branch: branch },
      groups: ['Pages Write'],
      resources: [accountKey(cfg.account)],
      describe: `create Pages project ${cfg.project}`,
    }),
    step({
      role: `pages-upload-token@${cfg.account}`,
      method: 'POST',
      path: `/accounts/${cfg.account}/pages/projects/${cfg.project}/upload-token`,
      groups: ['Pages Write'],
      resources: [accountKey(cfg.account)],
      describe: `get a one-project upload JWT for ${cfg.project}`,
    }),
    step({
      role: `pages-assets@${cfg.account}/${cfg.project}`,
      method: 'POST',
      path: '/pages/assets/check-missing',
      describe: `ask which assets of ${cfg.project} are missing`,
    }),
    step({
      role: `pages-assets@${cfg.account}/${cfg.project}`,
      method: 'POST',
      path: '/pages/assets/upload',
      body: assets.map((a) => ({
        key: a.hash,
        base64: true,
        metadata: { contentType: a.contentType },
        path: a.path,
        size: a.size,
      })),
      describe: `upload ${assets.length} asset(s) to ${cfg.project}`,
    }),
    step({
      role: `pages-deploy@${cfg.account}`,
      method: 'POST',
      path: `/accounts/${cfg.account}/pages/projects/${cfg.project}/deployments`,
      groups: ['Pages Write'],
      resources: [accountKey(cfg.account)],
      describe: `create a deployment of ${cfg.project}`,
    }),
  ];
  if (cfg.hostname) {
    steps.push(step({
      role: `pages-domain@${cfg.account}`,
      method: 'POST',
      path: `/accounts/${cfg.account}/pages/projects/${cfg.project}/domains`,
      body: { name: cfg.hostname },
      groups: ['Pages Write'],
      resources: [accountKey(cfg.account)],
      describe: `attach domain ${cfg.hostname} to ${cfg.project}`,
    }));
  }
  return steps;
}

export function dnsSteps(cfg, target) {
  if (!cfg.zone || !cfg.hostname) return [];
  return [
    step({
      role: `dns-write@${cfg.account}/${cfg.zone}`,
      method: 'POST',
      path: `/zones/${cfg.zone}/dns_records`,
      body: { type: 'CNAME', name: cfg.hostname, content: target, proxied: true },
      groups: ['DNS Edit'],
      resources: [zoneKey(cfg.zone)],
      describe: `create DNS record ${cfg.hostname} in zone ${cfg.zone}`,
    }),
    step({
      role: `cache-purge@${cfg.account}/${cfg.zone}`,
      method: 'POST',
      path: `/zones/${cfg.zone}/purge_cache`,
      body: { purge_everything: true },
      groups: ['Cache Purge'],
      resources: [zoneKey(cfg.zone)],
      describe: `purge the cache of zone ${cfg.zone}`,
    }),
  ];
}

/** The plan `cfdeploy emit` writes: the publishing recipe, then DNS. */
export function buildPlan(cfg, assets) {
  const publish = cfg.pages ? pagesSiteSteps(cfg, assets) : workerSiteSteps(cfg, assets);
  const target = `https://${cfg.project}.pages.dev`;
  return { version: 1, steps: publish.concat(dnsSteps(cfg, target)) };
}

/** The bootstrap plan: verify, read the catalog, mint one token per role. */
export function bootstrapPlan(plan, userId) {
  const roles = [...new Set(plan.steps.filter((s) => s.groups.length).map((s) => s.role))];
  return {
    version: 1,
    steps: [
      step({ role: 'verify', method: 'GET', path: '/user/tokens/verify',
             describe: 'verify the current token' }),
      step({ role: 'groups-read', method: 'GET', path: '/user/tokens/permission_groups',
             groups: ['API Tokens Read'], resources: [userKey(userId)],
             describe: 'list permission groups' }),
    ].concat(roles.map((r) => step({
      role: 'token-mint', method: 'POST', path: '/user/tokens', body: { name: r },
      groups: ['API Tokens Edit'], resources: [userKey(userId)],
      describe: 'mint the scoped token for role ' + r,
    }))),
  };
}

// ------------------------------------------------------- the served Worker
// `JsEmit.workerJs`: the read-only front end that serves the uploaded
// bundle out of KV.  Rendered here byte for byte as the CLI writes it.

/** `Json.pretty`, so the generated Worker matches the one `cfdeploy emit` writes. */
export function prettyJson(indent, v) {
  const pad = ' '.repeat(indent + 2);
  const close = ' '.repeat(indent);
  if (Array.isArray(v)) {
    if (v.length === 0) return '[]';
    return '[\n' + v.map((x) => pad + prettyJson(indent + 2, x)).join(',\n') + '\n' + close + ']';
  }
  if (v !== null && typeof v === 'object') {
    const ks = Object.keys(v);
    if (ks.length === 0) return '{}';
    return '{\n' + ks.map((k) => pad + JSON.stringify(k) + ': ' + prettyJson(indent + 2, v[k]))
      .join(',\n') + '\n' + close + '}';
  }
  return JSON.stringify(v);
}

export function manifestOf(assets) {
  const out = {};
  for (const a of assets) out[a.path] = { key: a.hash, type: a.contentType, size: a.size };
  return out;
}

export function workerScript(assets) {
  return 'export const MANIFEST = ' + prettyJson(0, manifestOf(assets)) + ';\n' +
    WORKER_BODY;
}

const WORKER_BODY = `
// Generated from Lean by RequestProject.Cf.JsEmit — do not edit.
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    let path = decodeURIComponent(url.pathname);
    if (path.endsWith('/')) path += 'index.html';
    const entry = MANIFEST[path] ?? MANIFEST[path + '/index.html'];
    if (!entry) return new Response('not found', { status: 404 });
    const etag = '\\"' + entry.key + '\\"';
    if (request.headers.get('If-None-Match') === etag) {
      return new Response(null, { status: 304 });
    }
    const body = await env.ASSETS.get(entry.key, { type: 'arrayBuffer' });
    if (body === null) return new Response('missing asset', { status: 502 });
    return new Response(body, {
      headers: {
        'Content-Type': entry.type,
        'ETag': etag,
        'Cache-Control': 'public, max-age=300',
      },
    });
  },
};
`;

/** The manifest file `cfdeploy emit` writes next to the plan. */
export function manifestJson(assets) {
  return prettyJson(0, assets.map((a) => ({
    path: a.path, contentType: a.contentType, size: a.size, hash: a.hash,
  }))) + '\n';
}

// ------------------------------------------------------------- the selection
// The browser twin of `RequestProject.Cf.Select`: which members of the
// bundle are published, where they are served, and why the others are
// not.  The preset and the cap below are the Lean values, emitted into
// this file, so the two cannot drift.

const segsOf = (p) => String(p ?? '').split('/').filter((s) => s !== '');
const joinSegs = (s) => s.join('/');
const isPrefix = (a, b) => a.length <= b.length && a.every((x, i) => x === b[i]);
const ancestorsOf = (segs) => segs.map((_, i) => segs.slice(0, i + 1).join('/'));

/** A pattern, read into tokens (`Select.tokenize`). */
export function tokenizePattern(pat) {
  const out = [];
  for (let i = 0; i < pat.length; ) {
    if (pat[i] === '*' && pat[i + 1] === '*') { out.push('**'); i += 2; }
    else if (pat[i] === '*') { out.push('*'); i += 1; }
    else if (pat[i] === '?') { out.push('?'); i += 1; }
    else { out.push({ lit: pat[i] }); i += 1; }
  }
  return out;
}

/** Match a tokenized pattern against a path (`Select.matchToks`). */
export function matchToks(p, s) {
  if (p.length === 0) return s.length === 0;
  const [t, ...rest] = p;
  if (t === '*') {
    if (s.length === 0) return matchToks(rest, s);
    return matchToks(rest, s) || (s[0] !== '/' && matchToks(p, s.slice(1)));
  }
  if (t === '**') {
    if (s.length === 0) return matchToks(rest, s);
    return matchToks(rest, s) || matchToks(p, s.slice(1));
  }
  if (s.length === 0) return false;
  if (t === '?') return s[0] !== '/' && matchToks(rest, s.slice(1));
  return t.lit === s[0] && matchToks(rest, s.slice(1));
}

export const globMatch = (pat, s) => matchToks(tokenizePattern(pat), [...s]);

/** One pattern against one path (`Select.patMatchL`): a pattern with no
 * `/` matches any segment, one with a `/` the path or a directory of it. */
export function patMatch(pat, rel) {
  let p = pat.startsWith('/') ? pat.slice(1) : pat;
  if (p.endsWith('/')) p += '**';
  const segs = segsOf(rel);
  if (p.includes('/')) return ancestorsOf(segs).some((a) => globMatch(p, a));
  return segs.some((s) => globMatch(p, s));
}

export const emptySelection = () =>
  ({ subdir: '', includes: [], excludes: [], dropPaths: [], maxBytes: 0 });

/** The preset for an Aristotle bundle (`Select.defaultSelection`). */
export const defaultSelection = () =>
  ({ ...emptySelection(), excludes: LEAN_PRESET.slice(), maxBytes: CF_MAX_ASSET });

/** Why a file is, or is not, published (`Select.verdict`). */
export function verdict(sel, a) {
  const sub = segsOf(sel.subdir);
  const all = segsOf(a.path);
  if (!isPrefix(sub, all)) {
    return { tag: 'outside-subdir', reason: 'outside the chosen subdirectory' };
  }
  if ((sel.dropPaths ?? []).some((p) => joinSegs(segsOf(p)) === joinSegs(all))) {
    return { tag: 'pruned', reason: 'struck out by hand' };
  }
  const rel = joinSegs(all.slice(sub.length));
  if ((sel.includes ?? []).length && !sel.includes.some((p) => patMatch(p, rel))) {
    return { tag: 'not-included', reason: 'not in the include list' };
  }
  const hit = (sel.excludes ?? []).find((p) => patMatch(p, rel));
  if (hit !== undefined) return { tag: 'excluded', pat: hit, reason: 'excluded by ' + hit };
  if (sel.maxBytes !== 0 && sel.maxBytes < a.size) {
    return { tag: 'too-big', reason: `larger than the ${sel.maxBytes}-byte cap` };
  }
  return { tag: 'keep', reason: 'published' };
}

export const keepAsset = (sel, a) => verdict(sel, a).tag === 'keep';

/** Where a published file is served (`Select.servedOf`). */
export function servedOf(sel, a) {
  const sub = segsOf(sel.subdir);
  if (sub.length === 0) return a.path;
  return '/' + joinSegs(segsOf(a.path).slice(sub.length));
}

/** What a selection publishes (`Select.apply`), payloads and all. */
export function applySelection(sel, assets) {
  return assets.filter((a) => keepAsset(sel, a))
    .map((a) => ({ ...a, path: servedOf(sel, a) }));
}

/** Every file of the bundle with its verdict (`Select.report`). */
export const selectionReport = (sel, assets) =>
  assets.map((a) => ({ asset: a, verdict: verdict(sel, a) }));

export const totalBytes = (assets) => assets.reduce((n, a) => n + a.size, 0);

// ------------------------------------------------------ cfdeploy.toml, in the page
// The browser twin of `RequestProject.Cf.Config`: the same file format,
// the same key names, the same layering (later layers win) and the same
// site-directory detection.  A bundle that carries a `cfdeploy.toml`
// therefore configures itself identically here and in the CLI.

/** Cut a line off at an unquoted `#` (`Config.stripComment`). */
export function stripTomlComment(line) {
  let out = '';
  let inQ = false;
  for (let i = 0; i < line.length; i++) {
    const c = line[i];
    if (c === '#' && !inQ) break;
    if (c === '\\' && inQ) { out += c + (line[i + 1] ?? ''); i++; continue; }
    if (c === '"') inQ = !inQ;
    out += c;
  }
  return out;
}

/** The quoted strings of a line, in order (`Config.collectStrs`). */
export function collectStrings(s) {
  const out = [];
  let cur = '';
  let inQ = false;
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (c === '\\' && inQ) { cur += (s[i + 1] ?? ''); i++; continue; }
    if (c === '"') {
      if (inQ) { out.push(cur); cur = ''; inQ = false; } else inQ = true;
      continue;
    }
    if (inQ) cur += c;
  }
  return out;
}

/** One value, as `Config.parseValueC` reads it. */
export function parseTomlValue(raw) {
  const t = String(raw).trim();
  if (t === '') return undefined;
  if (t.startsWith('"')) {
    const xs = collectStrings(t);
    return xs.length === 1 ? xs[0] : undefined;
  }
  if (t.startsWith('[')) return collectStrings(t);
  if (t === 'true') return true;
  if (t === 'false') return false;
  if (/^[0-9]+$/.test(t)) return Number(t);
  return t;
}

export const canonConfigKey = (k) => (CONFIG_SHORT_KEYS[k] ?? k);

/** **Read a `cfdeploy.toml`** into `[key, value]` pairs with dotted keys
 * (`Config.parseDoc`). */
export function parseToml(text) {
  const out = [];
  let sect = '';
  for (const raw of String(text ?? '').split('\n')) {
    const line = stripTomlComment(raw).trim();
    if (line === '') continue;
    if (line.startsWith('[') && line.endsWith(']')) {
      sect = line.slice(1, -1).trim();
      continue;
    }
    const eq = line.indexOf('=');
    if (eq < 0) continue;
    const key0 = line.slice(0, eq).trim();
    const key = sect === '' ? canonConfigKey(key0) : sect + '.' + key0;
    const val = parseTomlValue(line.slice(eq + 1));
    if (val === undefined) continue;
    out.push([key, val]);
  }
  return out;
}

const asStr = (v) => (Array.isArray(v) ? undefined : String(v));
const asBool = (v) => (typeof v === 'boolean' ? v
  : (v === 'true' ? true : (v === 'false' ? false
    : (typeof v === 'number' ? v !== 0 : undefined))));
const asNum = (v) => (typeof v === 'number' ? v
  : (typeof v === 'string' ? parseSizeValue(v) : undefined));
const asList = (v) => (Array.isArray(v) ? v
  : (v === '' ? [] : (typeof v === 'string' ? [v] : undefined)));

/** `5M`, `800k`, `1234` (`Config.parseByteSize`). */
export function parseSizeValue(s) {
  const t = String(s ?? '');
  const mult = { k: 1024, K: 1024, m: 1048576, M: 1048576, g: 1073741824, G: 1073741824 };
  const last = t.slice(-1);
  const m = mult[last] ?? 1;
  const digits = [...t].filter((c) => c >= '0' && c <= '9').join('');
  return (digits === '' ? 0 : Number(digits)) * m;
}

/** Set one key of a configuration (`Config.Resolved.set`); an unknown
 * key, or a value of the wrong shape, changes nothing. */
export function setConfigKey(cfg, k, v) {
  const spec = CONFIG_FIELDS[k];
  if (!spec) return cfg;
  const [field, kind] = spec;
  const x = kind === 'str' ? asStr(v)
    : kind === 'bool' ? asBool(v)
      : kind === 'num' ? asNum(v) : asList(v);
  if (x === undefined) return cfg;
  return { ...cfg, [field]: x };
}

/** Apply one layer (`Config.Resolved.applyDoc`). */
export const applyConfigDoc = (cfg, doc) =>
  (doc ?? []).reduce((c, [k, v]) => setConfigKey(c, k, v), { ...cfg });

/** **Resolve a stack of layers**, later layers winning
 * (`Config.resolve`). */
export const resolveConfig = (layers) =>
  (layers ?? []).reduce((c, d) => applyConfigDoc(c, d), { ...CONFIG_DEFAULTS });

/** Everything a file sets outside a `[profiles.…]` section. */
export const configFileBase = (doc) =>
  (doc ?? []).filter(([k]) => !k.startsWith('profiles.'));

/** The `[profiles.NAME]` sections of a file (`Config.fileProfiles`). */
export function configFileProfiles(doc) {
  const names = [];
  for (const [k] of doc ?? []) {
    const parts = k.split('.');
    if (parts[0] === 'profiles' && parts.length > 2 && !names.includes(parts[1])) {
      names.push(parts[1]);
    }
  }
  return names.map((n) => ({
    name: n,
    about: 'from ' + CONFIG_FILE_NAME,
    sets: (doc ?? []).filter(([k]) => k.split('.')[0] === 'profiles' && k.split('.')[1] === n)
      .map(([k, v]) => [canonConfigKey(k.split('.').slice(2).join('.')), v]),
  }));
}

/** The last layer that sets a key (`Config.provenance`). */
export function configProvenance(layers, key) {
  let src = null;
  for (const [name, doc] of layers ?? []) {
    if ((doc ?? []).some(([k]) => k === key)) src = name;
  }
  return src;
}

/** What a configuration publishes (`Config.Resolved.selection`). */
export function selectionOfConfig(cfg) {
  return {
    subdir: cfg.subdir === 'auto' ? '' : cfg.subdir,
    includes: cfg.includes.slice(),
    excludes: (cfg.noPrune ? [] : LEAN_PRESET.slice()).concat(cfg.excludes),
    dropPaths: cfg.drops.slice(),
    maxBytes: cfg.noPrune ? 0 : cfg.maxSize,
  };
}

/** A configuration written back out as a `cfdeploy.toml`. */
export function renderToml(cfg) {
  const q = (s) => '"' + String(s).replace(/[\\"]/g, (c) => '\\' + c) + '"';
  const v = (x) => (Array.isArray(x) ? '[' + x.map(q).join(', ') + ']'
    : (typeof x === 'boolean' || typeof x === 'number' ? String(x) : q(x)));
  let out = '# cfdeploy.toml — written by the hosted page.\n\n[site]\n';
  for (const [key, [field]] of Object.entries(CONFIG_FIELDS)) {
    const short = key.split('.')[1];
    if (key.startsWith('publish.')) continue;
    const same = JSON.stringify(cfg[field]) === JSON.stringify(CONFIG_DEFAULTS[field]);
    out += (same ? '# ' : '') + short + ' = ' + v(cfg[field]) + '\n';
  }
  out += '\n[publish]\n';
  for (const [key, [field]] of Object.entries(CONFIG_FIELDS)) {
    if (!key.startsWith('publish.')) continue;
    const short = key.split('.')[1];
    const same = JSON.stringify(cfg[field]) === JSON.stringify(CONFIG_DEFAULTS[field]);
    out += (same ? '# ' : '') + short + ' = ' + v(cfg[field]) + '\n';
  }
  return out;
}

/** Is this path an `index.html` (`Config.isIndex`)? */
export const isIndexPath = (p) => segsOf(p).slice(-1)[0] === 'index.html';

/** **The site directory** of a bundle: the shallowest directory with an
 * `index.html` in it (`Config.detectSiteDir`).  `''` is the bundle
 * root, `null` if there is no page at all. */
export function detectSiteDir(assets) {
  const dirs = [];
  for (const a of assets ?? []) {
    if (!isIndexPath(a.path)) continue;
    const d = segsOf(a.path).slice(0, -1).join('/');
    if (!dirs.includes(d)) dirs.push(d);
  }
  if (dirs.length === 0) return null;
  const depth = (d) => segsOf(d).length;
  let best = dirs[0];
  for (const d of dirs) if (depth(d) < depth(best)) best = d;
  return best;
}

/** A configuration resolved against a bundle: `publish.subdir = "auto"`
 * becomes the detected site directory (`Config.Resolved.withDetectedSubdir`). */
export function withDetectedSubdir(cfg, assets) {
  if (cfg.subdir !== 'auto') return cfg;
  return { ...cfg, subdir: detectSiteDir(assets) ?? '' };
}

/** **What the CLI publishes from this bundle under this configuration**:
 * the site directory detected first, then the usual pruning
 * (`Config.Resolved.withDetectedSubdir` followed by `.selection`). */
export const selectionForBundle = (cfg, assets) =>
  selectionOfConfig(withDetectedSubdir(cfg, assets));

/** The `cfdeploy.toml` a bundle carries at its root, if it carries one
 * (`Cli.bundleConfigDoc`). */
export function bundleConfigDoc(assets) {
  const hit = (assets ?? []).find((a) => a.path === '/' + CONFIG_FILE_NAME);
  if (!hit || !hit.contents) return null;
  return parseToml(new TextDecoder().decode(hit.contents));
}

/** The directories a bundle offers, for the subdirectory picker. */
export function topDirs(assets) {
  const out = new Set();
  for (const a of assets) {
    const segs = segsOf(a.path);
    for (let i = 1; i < segs.length; i++) out.add(segs.slice(0, i).join('/'));
  }
  return [...out].sort();
}

// -------------------------------------------------------------- the terminal
// `RequestProject.Cf.Offline`, in the browser: the same plan as a shell
// script of curl calls, for when this page cannot reach the API at all.

/** One shell word (`Offline.shQuote`) — proved in Lean to read back as
 * exactly this string. */
export const shQuote = (s) => "'" + String(s).split("'").join("'\\''") + "'";

export const fileNameOf = (key) => String(key).split(':').join('_');

export const payloadKind = (s) => (s.payload ? 'file' : (s.body ? 'json' : 'none'));
export const payloadData = (s) =>
  (s.payload ? s.payload : (s.body ? JSON.stringify(s.body) : ''));

/** The environment variable a role's token is read from (`envVarOfRole`). */
export const envVarOfRole = (role) => 'CF_TOKEN_' +
  [...String(role)].map((c) => (/[A-Za-z0-9]/.test(c) ? c.toUpperCase() : '_')).join('');

export const tokenVar = (s) =>
  (s.role.startsWith('pages-assets') ? 'CF_UPLOAD_JWT' : envVarOfRole(s.role));

/** One step as a pasteable curl line (`Offline.curlCommand`). */
export function curlCommand(apiBase, s) {
  const url = (apiBase || CF_API) + s.url.slice(CF_API.length);
  const auth = ` -H "Authorization: Bearer $${tokenVar(s)}"`;
  const kind = payloadKind(s);
  const data = kind === 'file'
    ? " -H 'Content-Type: application/octet-stream' --data-binary " +
      shQuote('@assets/' + fileNameOf(payloadData(s)))
    : (kind === 'json'
      ? " -H 'Content-Type: application/json' --data " + shQuote(payloadData(s))
      : '');
  return 'curl -sS -X ' + s.method + ' ' + shQuote(url) + auth + data;
}

export const curlCommands = (apiBase, steps) => steps
  .map((s) => `# ${s.describe} (role ${s.role})\n` + curlCommand(apiBase, s)).join('\n');

/** The roles of a plan, in order, with their grants (`Offline.rolesOf`). */
export function rolesOf(steps) {
  const out = [];
  for (const s of steps) {
    if (!s.groups.length) continue;
    const cur = out.find((r) => r.role === s.role);
    if (cur) {
      cur.groups = [...new Set([...cur.groups, ...s.groups])];
      cur.resources = [...new Set([...cur.resources, ...s.resources])];
    } else {
      out.push({ role: s.role, groups: [...new Set(s.groups)], resources: [...new Set(s.resources)] });
    }
  }
  return out;
}

/** The whole plan as a shell script — the same text `cfdeploy script`
 * writes (`Offline.deployShellScript`); `web/site-test.mjs` checks that. */
export function deployShellScript(plan) {
  const steps = plan.steps;
  const roles = rolesOf(steps);
  const mints = roles.map((r) => 'mint ' + shQuote(r.role) + ' ' + shQuote(envVarOfRole(r.role)) +
    ' ' + shQuote(r.groups.join('|')) + ' ' + shQuote(r.resources.join('|')) + ' || true');
  const runs = steps.map((s) => 'run_step ' + shQuote(s.role) + ' ' + shQuote(tokenVar(s)) +
    ' ' + shQuote(s.method) + ' ' + shQuote(s.url.slice(CF_API.length)) + ' ' +
    shQuote(payloadKind(s)) + ' ' +
    shQuote(payloadKind(s) === 'file' ? fileNameOf(payloadData(s)) : payloadData(s)) + ' ' +
    shQuote(s.describe));
  return '#!/bin/sh\n' +
    '# Generated from Lean by RequestProject.Cf.Offline — do not edit.\n' +
    '#\n' +
    '# The deployment plan, as curl.  Use this when the browser cannot reach\n' +
    '# the Cloudflare API (it applies CORS to api.cloudflare.com, and a page\n' +
    '# on a static host is a cross-origin caller).  Nothing here holds a\n' +
    '# credential: every request reads one out of the environment.\n' +
    '#\n' +
    '#   CF_API_TOKEN=... sh deploy.sh            mint the scoped tokens, then run\n' +
    '#   sh deploy.sh --dry-run                   show every request, send none\n' +
    '#\n' +
    `# ${steps.length} step(s), ${roles.length} scoped token(s).\n\n` +
    SHELL_PRELUDE + '\n' +
    `say "cfdeploy: ${steps.length} step(s), ${roles.length} role(s); API base $API"\n\n` +
    '# ---- one short-lived token per role, each with exactly its own grants\n' +
    mints.join('\n') + '\n\n' +
    '# ---- the plan\n' +
    runs.join('\n') + '\n\n' +
    'finish\n';
}

// ------------------------------------------------------------ payload.tar
// The script uploads each asset from `assets/<content hash>`; this is how
// the page hands you that directory without a server: one ustar archive.

const octal = (n, len) => n.toString(8).padStart(len - 1, '0') + '\0';

/** A ustar archive of `[{name, bytes}]`, for `tar xf payload.tar`. */
export function tarOf(files) {
  const enc = new TextEncoder();
  const blocks = [];
  for (const f of files) {
    const header = new Uint8Array(512);
    const put = (s, off, len) => {
      const b = enc.encode(s);
      header.set(b.subarray(0, len), off);
    };
    put('assets/' + f.name, 0, 100);
    put(octal(0o644, 8), 100, 8);
    put(octal(0, 8), 108, 8);
    put(octal(0, 8), 116, 8);
    put(octal(f.bytes.length, 12), 124, 12);
    put(octal(Math.floor(Date.now() / 1000), 12), 136, 12);
    put('        ', 148, 8);
    header[156] = 48; // '0', a regular file
    put('ustar', 257, 6);
    header[263] = 48; header[264] = 48; // version "00"
    let sum = 0;
    for (const b of header) sum += b;
    put(sum.toString(8).padStart(6, '0') + '\0 ', 148, 8);
    blocks.push(header);
    blocks.push(f.bytes);
    const pad = (512 - (f.bytes.length % 512)) % 512;
    if (pad) blocks.push(new Uint8Array(pad));
  }
  blocks.push(new Uint8Array(1024));
  const total = blocks.reduce((n, b) => n + b.length, 0);
  const out = new Uint8Array(total);
  let off = 0;
  for (const b of blocks) { out.set(b, off); off += b.length; }
  return out;
}

// ---------------------------------------------------------------- preview
// The published site, rendered from memory: every asset becomes a blob
// URL and the references between them are rewritten to point at those
// URLs, so the preview is the files as they will be served, with no
// server and nothing uploaded.

/** Resolve a reference in a document at `base`; null if it is external. */
export function resolvePath(base, ref) {
  const r = String(ref).trim();
  if (r === '' || /^[a-zA-Z][a-zA-Z0-9+.\-]*:/.test(r) || r.startsWith('//') ||
      r.startsWith('#')) return null;
  const clean = r.split('?')[0].split('#')[0];
  const dir = base.slice(0, base.lastIndexOf('/') + 1);
  const out = [];
  for (const seg of (clean.startsWith('/') ? clean : dir + clean).split('/')) {
    if (seg === '' || seg === '.') continue;
    if (seg === '..') out.pop();
    else out.push(seg);
  }
  return '/' + out.join('/');
}

/** Rewrite `src=`, `href=` and `url(...)` to whatever `urlFor` returns. */
export function rewriteRefs(text, base, urlFor) {
  const one = (ref) => {
    const p = resolvePath(base, ref);
    if (p === null) return null;
    const u = urlFor(p);
    return u === undefined || u === null ? null : u;
  };
  return String(text)
    .replace(/(\s(?:src|href|poster|data-src)\s*=\s*)(["'])([^"']*)\2/gi,
      (m, pre, q, ref) => { const u = one(ref); return u === null ? m : pre + q + u + q; })
    .replace(/url\(\s*(["']?)([^)"']+)\1\s*\)/gi,
      (m, q, ref) => { const u = one(ref); return u === null ? m : `url(${q}${u}${q})`; });
}

/** The entry document of a site, if it has one. */
export function entryOf(assets) {
  const names = ['/index.html', '/index.htm'];
  for (const n of names) if (assets.some((a) => a.path === n)) return n;
  const html = assets.filter((a) => a.path.endsWith('.html'));
  return html.length ? html[0].path : (assets[0] ? assets[0].path : null);
}
"##

end Site
end CfDeploy
