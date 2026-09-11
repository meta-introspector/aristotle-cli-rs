/-
# The browser / node front end, and the logging it emits

Everything in this file is *text* that `cfdeploy emit` writes next to the
generated deployment client:

* `logModuleJs` (`cf-log.mjs`) — the structured log used by every other
  piece.  A deployment must never be silent: each step announces itself
  before it runs, reports the request it is about to make (with the
  credential redacted), and reports the response, the Cloudflare error
  codes, and how long it took.  Failures that used to be invisible — a
  module that would not load, an admin token that cannot read the
  permission-group catalog, a CORS-blocked `fetch` — all arrive here as
  events with a level and a hint.
* `tokenClientJs` (`cf-tokens.mjs`) — minting one least-privilege token
  per role, logging every request and quoting Cloudflare's own error text
  when one fails.
* `uiHtml` (`index.html`) — the page, emitted *into the output directory*
  so that the plan, the client and the assets it fetches are always its
  own siblings.  The log console is live from the moment the page loads,
  and window errors and unhandled rejections are routed into it.

The Lean model is unchanged by any of this: the page renders the plan and
the token contracts that `planSteps` produced, and can only ask for what
they declare.
-/

namespace CfDeploy
namespace JsEmit

/-- `cf-log.mjs`: structured events, redaction, and a text renderer shared
by the deployment client, the token minter, the node runner and the page.
-/
def logModuleJs : String :=
r##"// Generated from Lean by RequestProject.Cf.WebUi — do not edit.
//
// The log every other module writes to.  An event is a plain object
//   { t, level, kind, msg, ...fields }
// so it can be rendered as text, filtered by level, or shipped as JSON.

export const LEVELS = { debug: 10, info: 20, warn: 30, error: 40 };

/** A credential is never logged: only its length and last four chars. */
export function redact(secret) {
  if (typeof secret !== 'string' || secret.length === 0) return '(none)';
  if (secret.length <= 8) return `(${secret.length} chars)`;
  return `(${secret.length} chars, ends ${secret.slice(-4)})`;
}

export function redactHeaders(headers = {}) {
  const out = {};
  for (const [k, v] of Object.entries(headers)) {
    out[k] = /^authorization$/i.test(k)
      ? 'Bearer ' + redact(String(v).replace(/^Bearer\s+/i, ''))
      : v;
  }
  return out;
}

/** A short, safe rendering of a request or response body. */
export function preview(body, max = 400) {
  if (body === undefined || body === null) return null;
  if (typeof body !== 'string') {
    const len = body.byteLength ?? body.length ?? 0;
    return `<${len} bytes>`;
  }
  return body.length > max ? body.slice(0, max) + `… (${body.length} chars)` : body;
}

/** Cloudflare's own error list, as readable strings. */
export function cfErrors(json) {
  const errs = (json && json.errors) || [];
  return errs.map((e) => {
    const head = `${e.code ?? '?'}: ${e.message ?? JSON.stringify(e)}`;
    const chain = (e.error_chain ?? []).map((c) => `${c.code ?? '?'}: ${c.message ?? ''}`);
    return chain.length ? `${head} (${chain.join('; ')})` : head;
  });
}

/** The public API prefix every generated URL starts with. */
export const CF_API = 'https://api.cloudflare.com/client/v4';

/** Send a request through a proxy instead of api.cloudflare.com.
 *
 * Three shapes of proxy are understood, so that any of the usual CORS
 * proxies can be pointed at:
 *   /cf                     — a prefix: the API path is appended
 *   https://p.dev/?apiurl=  — the whole API URL, encoded, as a parameter
 *   https://p.dev/?u={url}  — the whole API URL, encoded, at a placeholder
 */
export function rewriteApi(url, apiBase) {
  if (!apiBase || !url.startsWith(CF_API)) return url;
  if (apiBase.includes('{url}')) return apiBase.replace('{url}', encodeURIComponent(url));
  if (/[?&][A-Za-z_]+=$/.test(apiBase)) return apiBase + encodeURIComponent(url);
  if (/[?&]apiurl$/.test(apiBase)) return apiBase + '=' + encodeURIComponent(url);
  return apiBase.replace(/\/$/, '') + url.slice(CF_API.length);
}

export function event(level, kind, msg, fields = {}) {
  return { t: new Date().toISOString(), level, kind, msg, ...fields };
}

export function formatEvent(ev) {
  const time = String(ev.t ?? new Date().toISOString()).slice(11, 23);
  const head = `${time} ${String(ev.level).toUpperCase().padEnd(5)} ` +
    `${String(ev.kind).padEnd(12)} ${ev.msg}`;
  const rest = { ...ev };
  delete rest.t; delete rest.level; delete rest.kind; delete rest.msg;
  const detail = Object.entries(rest)
    .filter(([, v]) => v !== undefined && v !== null && !(Array.isArray(v) && v.length === 0))
    .map(([k, v]) => `${k}=${typeof v === 'string' ? v : JSON.stringify(v)}`);
  return detail.length ? head + '\n' + detail.map((d) => '        ' + d).join('\n') : head;
}

/** A sink that prints to the console, at or above `minLevel`. */
export function consoleLogger(minLevel = 'info') {
  return (ev) => {
    if (LEVELS[ev.level] < LEVELS[minLevel]) return;
    const line = formatEvent(ev);
    if (ev.level === 'error') console.error(line);
    else if (ev.level === 'warn') console.warn(line);
    else console.log(line);
  };
}

// Wrap a sink so that callers can just say emit(level, kind, msg, fields).
// `undefined` means "log to the console" — silence has to be asked for
// explicitly, by passing null.  A sink that throws never breaks a run.
export function emitter(onEvent) {
  const sink = onEvent === undefined ? consoleLogger('debug') : onEvent;
  return (level, kind, msg, fields = {}) => {
    const ev = event(level, kind, msg, fields);
    if (sink) {
      try { sink(ev); } catch { /* a broken log must not break a deployment */ }
    }
    return ev;
  };
}
"##

/-- `cf-tokens.mjs`: turns the plan into the `POST /user/tokens` bodies
that create exactly the tokens the plan needs.  Permission-group ids are
resolved at run time from `GET /user/tokens/permission_groups`, so no id is
ever hard-coded, and every step of the exchange is logged. -/
def tokenClientJs : String :=
r##"// Generated from Lean by RequestProject.Cf.WebUi — do not edit.
// Mint one least-privilege token per role of a plan.  The admin token is
// used here and nowhere else; it is never logged and never attached to a
// deployment request.
import { emitter, redact, cfErrors, preview, rewriteApi, CF_API } from './cf-log.mjs';

const API = CF_API;

async function readJson(res) {
  let text = '';
  try {
    text = typeof res.text === 'function'
      ? await res.text()
      : JSON.stringify(typeof res.json === 'function' ? await res.json() : {});
  } catch { text = ''; }
  let json = {};
  try { json = text ? JSON.parse(text) : {}; } catch { json = {}; }
  return { text, json };
}

/** The `name -> id` catalog of permission groups this user may grant. */
export async function permissionGroups(adminToken, fetchImpl = fetch, onEvent, apiBase) {
  const emit = emitter(onEvent);
  const url = rewriteApi(API + '/user/tokens/permission_groups', apiBase);
  emit('info', 'catalog', 'reading the permission-group catalog', {
    url, credential: redact(adminToken),
  });
  const t0 = Date.now();
  let res;
  try {
    res = await fetchImpl(url, { headers: { 'Authorization': 'Bearer ' + adminToken } });
  } catch (e) {
    emit('error', 'catalog', `could not reach Cloudflare: ${e && e.message ? e.message : e}`, {
      url,
      hint: 'a browser CORS block, an offline network, or a proxy that rejected the request',
    });
    throw e;
  }
  const { text, json } = await readJson(res);
  const errors = cfErrors(json);
  if (!res.ok || json.success === false) {
    emit('error', 'catalog', `HTTP ${res.status}` + (errors.length ? ': ' + errors.join('; ') : ''), {
      url, ms: Date.now() - t0, response: preview(text, 600),
      hint: res.status === 403 || res.status === 401
        ? 'the token you pasted needs the "API Tokens Read/Write" permission on your user'
        : undefined,
    });
    throw new Error(`permission_groups: HTTP ${res.status}` +
      (errors.length ? ' — ' + errors.join('; ') : ''));
  }
  const map = new Map();
  for (const g of json.result ?? []) map.set(g.name, g.id);
  emit('info', 'catalog', `catalog has ${map.size} permission group(s)`, {
    ms: Date.now() - t0,
  });
  if (map.size === 0) {
    emit('warn', 'catalog', 'the catalog came back empty; no group id can be resolved', {
      response: preview(text, 300),
    });
  }
  return map;
}

export function tokenRequest(role, groups, resources, catalog, expiresOn) {
  const missing = groups.filter((g) => !catalog.has(g));
  if (missing.length) throw new Error('unresolved permission groups: ' + missing.join(', '));
  const resourceObj = {};
  for (const r of resources) resourceObj[r] = '*';
  return {
    name: 'aristotle-deploy/' + role,
    policies: [{
      effect: 'allow',
      resources: resourceObj,
      permission_groups: groups.map((g) => ({ id: catalog.get(g), name: g })),
    }],
    expires_on: expiresOn,
  };
}

// Revoke tokens this run minted.  `ids` maps role -> token id, as filled
// in by `mintTokens`.  Nothing else is ever deleted: the ids are the ones
// Cloudflare returned for the tokens minted here, and the request carries
// only the id, never the token value.
export async function revokeTokens(adminToken, ids, fetchImpl = fetch, onEvent, apiBase) {
  const emit = emitter(onEvent);
  const roles = Object.keys(ids ?? {});
  emit('info', 'revoke-start', `revoking ${roles.length} minted token(s)`, { roles });
  const out = {};
  for (const role of roles) {
    const id = ids[role];
    if (!id) {
      emit('warn', 'revoke-failed', `${role}: no token id was recorded, nothing to revoke`,
        { role });
      out[role] = 'unknown-id';
      continue;
    }
    let res;
    const t0 = Date.now();
    try {
      res = await fetchImpl(rewriteApi(API + '/user/tokens/' + encodeURIComponent(id), apiBase), {
        method: 'DELETE',
        headers: { 'Authorization': 'Bearer ' + adminToken },
      });
    } catch (e) {
      emit('error', 'revoke-failed',
        `${role}: could not reach Cloudflare: ${e && e.message ? e.message : e}`,
        { role, id, hint: 'the token stays live until it expires' });
      out[role] = 'error';
      continue;
    }
    const { text, json } = await readJson(res);
    const errors = cfErrors(json);
    if (!res.ok || json.success === false) {
      emit('error', 'revoke-failed', `${role}: HTTP ${res.status}` +
        (errors.length ? ': ' + errors.join('; ') : ''),
        { role, id, ms: Date.now() - t0, response: preview(text, 300),
          hint: 'the token stays live until it expires' });
      out[role] = 'failed';
      continue;
    }
    emit('info', 'revoke-ok', `${role}: revoked`, { role, id, ms: Date.now() - t0 });
    out[role] = 'revoked';
  }
  const done = Object.values(out).filter((v) => v === 'revoked').length;
  emit(done === roles.length ? 'info' : 'warn', 'revoke-end',
    `revoked ${done} of ${roles.length} minted token(s)`, { result: out });
  return out;
}

// `ids` is an out-parameter: the id Cloudflare gives each minted token is
// recorded there, so the run can revoke exactly what it created.
export async function mintTokens(adminToken, needs, expiresOn, fetchImpl = fetch, onEvent, apiBase, ids = {}) {
  const emit = emitter(onEvent);
  if (apiBase) emit('info', 'mint-start', `minting through the proxy at ${apiBase}`);
  emit('info', 'mint-start', `minting ${needs.length} scoped token(s), valid until ${expiresOn}`, {
    roles: needs.map((n) => n.role),
  });
  if (!adminToken) {
    emit('error', 'mint-start', 'no admin token was given; nothing can be minted');
    throw new Error('no admin token');
  }
  const catalog = await permissionGroups(adminToken, fetchImpl, onEvent, apiBase);
  const out = {};
  for (const n of needs) {
    let body;
    try {
      body = tokenRequest(n.role, n.groups, n.resources, catalog, expiresOn);
    } catch (e) {
      emit('error', 'mint-failed', `${n.role}: ${e.message}`, {
        role: n.role, groups: n.groups,
        hint: 'the permission-group name has to match Cloudflare\'s catalog exactly',
      });
      throw e;
    }
    emit('info', 'mint-request', `${n.role}: asking for ${n.groups.length} permission group(s)`, {
      role: n.role, groups: n.groups, resources: n.resources, name: body.name,
    });
    const t0 = Date.now();
    let res;
    try {
      res = await fetchImpl(rewriteApi(API + '/user/tokens', apiBase), {
        method: 'POST',
        headers: { 'Authorization': 'Bearer ' + adminToken, 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });
    } catch (e) {
      emit('error', 'mint-failed', `${n.role}: could not reach Cloudflare: ${e && e.message ? e.message : e}`, {
        role: n.role,
        hint: 'a browser CORS block, an offline network, or a proxy that rejected the request',
      });
      throw e;
    }
    const { text, json } = await readJson(res);
    const errors = cfErrors(json);
    if (!res.ok || json.success === false || !json.result || !json.result.value) {
      emit('error', 'mint-failed', `${n.role}: HTTP ${res.status}` +
        (errors.length ? ': ' + errors.join('; ') : ''), {
        role: n.role, ms: Date.now() - t0, response: preview(text, 600),
      });
      throw new Error(`minting ${n.role} failed: HTTP ${res.status}` +
        (errors.length ? ' — ' + errors.join('; ') : ''));
    }
    out[n.role] = json.result.value;
    if (json.result.id) ids[n.role] = json.result.id;
    emit('info', 'mint-ok', `${n.role}: minted`, {
      role: n.role, id: json.result.id, expires_on: json.result.expires_on ?? expiresOn,
      ms: Date.now() - t0, token: redact(json.result.value),
    });
  }
  emit('info', 'mint-end', `minted ${Object.keys(out).length} of ${needs.length} token(s)`);
  return out;
}
"##

/-- `run-deploy.mjs`: the node runner, emitted next to the plan it runs.
It prints the same structured events as the page, can write them to a
file, and can stream them as newline-delimited JSON. -/
def nodeRunnerJs : String :=
r##"// Generated from Lean by RequestProject.Cf.WebUi — do not edit.
//
// Run this plan against the real Cloudflare API, from the directory
// `cfdeploy emit` wrote:
//
//   CF_ADMIN_TOKEN=... node run-deploy.mjs [--dry-run] [--verbose|--quiet]
//                                          [--json] [--log FILE]
//                                          [--api-base https://proxy.example]
//                                          [--keep-tokens]
//
// The scoped tokens this run mints are revoked again when it finishes,
// unless --keep-tokens says otherwise.
//
// The admin token is used for one thing only: minting the scoped tokens
// the plan declares (it needs `API Tokens Write` on the user, and nothing
// else).  Every deployment request is then signed by the scoped token of
// its own role, and the admin token is never sent again — nor logged.
import { readFile, readdir, writeFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const { formatEvent, LEVELS } = await import('./cf-log.mjs');
const client = await import('./cf-deploy.mjs');
const tokensMod = await import('./cf-tokens.mjs');

const argv = process.argv.slice(2);
const has = (f) => argv.includes(f);
const valueOf = (f) => (argv.includes(f) ? argv[argv.indexOf(f) + 1] : undefined);
const dryRun = has('--dry-run');
const asJson = has('--json');
const logFile = valueOf('--log');
const minLevel = has('--verbose') ? 'debug' : has('--quiet') ? 'warn' : 'info';
const apiBase = valueOf('--api-base') ?? null;
const keepTokens = has('--keep-tokens');

const events = [];
const onEvent = (ev) => {
  events.push(ev);
  if (asJson) { console.log(JSON.stringify(ev)); return; }
  if (LEVELS[ev.level] < LEVELS[minLevel]) return;
  const line = formatEvent(ev);
  if (ev.level === 'error') console.error(line); else console.log(line);
};
const say = (level, kind, msg, fields = {}) =>
  onEvent({ t: new Date().toISOString(), level, kind, msg, ...fields });

const finish = async (code) => {
  if (logFile) {
    await writeFile(logFile, events.map(formatEvent).join('\n') + '\n');
    console.log(`wrote ${logFile} (${events.length} events)`);
  }
  process.exit(code);
};

say('info', 'run', `plan: ${client.PLAN.steps.length} step(s) from ${here}`,
  { dryRun, level: minLevel });

const admin = process.env.CF_ADMIN_TOKEN;
if (!admin && !dryRun) {
  say('error', 'run', 'CF_ADMIN_TOKEN is not set (use --dry-run to see the plan instead)');
  await finish(2);
}

const needs = client.requiredTokens();
for (const n of needs) {
  say('info', 'tokens', `role ${n.role}`, { groups: n.groups, resources: n.resources });
}

// the asset bodies the plan refers to, as written by `cfdeploy emit`
const assets = {};
try {
  for (const name of await readdir(resolve(here, 'assets'))) {
    assets[name] = await readFile(resolve(here, 'assets', name));
  }
  say('info', 'assets', `${Object.keys(assets).length} asset body(s) read from assets/`);
} catch (e) {
  say('warn', 'assets', 'no assets/ directory: ' + e.message);
}
const workerStep = client.PLAN.steps.find((s) => s.payload?.startsWith('worker:'));
if (workerStep) {
  try {
    assets[workerStep.payload] = await readFile(resolve(here, 'worker.mjs'));
    say('info', 'assets', 'read worker.mjs');
  } catch (e) {
    say('error', 'assets', 'could not read worker.mjs: ' + e.message);
  }
}

if (dryRun) {
  const out = await client.runPlan({}, { assets, dryRun: true, onEvent, apiBase });
  say('info', 'run', `dry run: ${out.length} step(s) inspected, nothing sent`);
  await finish(0);
}

const expiresOn = new Date(Date.now() + 15 * 60 * 1000).toISOString().replace(/\.\d+Z$/, 'Z');
const mintedIds = {};
let tokens;
try {
  tokens = await tokensMod.mintTokens(admin, needs, expiresOn, fetch, onEvent, apiBase, mintedIds);
} catch (e) {
  say('error', 'run', 'could not mint the scoped tokens: ' + e.message);
  if (!keepTokens && Object.keys(mintedIds).length) {
    await tokensMod.revokeTokens(admin, mintedIds, fetch, onEvent, apiBase);
  }
  await finish(3);
}

const out = await client.runPlan(tokens, { assets, onEvent, apiBase, tokenIds: mintedIds });
if (keepTokens) {
  say('warn', 'revoke-end', 'the minted tokens were kept; they expire at ' + expiresOn,
    { roles: Object.keys(mintedIds) });
} else {
  await tokensMod.revokeTokens(admin, mintedIds, fetch, onEvent, apiBase);
}
const bad = out.filter((l) => l.status !== 'ok');
say(bad.length ? 'error' : 'info', 'run',
  bad.length ? `${bad.length} step(s) did not succeed` : 'deployment finished cleanly',
  { steps: out.length });
await finish(bad.length ? 1 : 0);
"##

/-- `index.html`: the page, emitted into the same directory as the plan it
runs.  The log is live from page load, so a run is never silent. -/
def uiHtml : String :=
r##"<!doctype html>
<!-- Generated from Lean by RequestProject.Cf.WebUi — do not edit. -->
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>cfdeploy — least-privilege Cloudflare deployment</title>
<style>
  :root { color-scheme: light dark; }
  body { font: 15px/1.5 ui-monospace, SFMono-Regular, Menlo, monospace; margin: 2rem auto;
         max-width: 60rem; padding: 0 1rem; }
  h1 { font-size: 1.3rem; }
  fieldset { border: 1px solid #8886; border-radius: 6px; margin: 1rem 0; }
  legend { padding: 0 .4rem; opacity: .8; }
  input[type=password], input[type=text] { width: 100%; font: inherit; padding: .35rem; }
  button { font: inherit; padding: .35rem .8rem; margin-right: .4rem; }
  select { font: inherit; }
  table { border-collapse: collapse; width: 100%; font-size: .9em; }
  td, th { text-align: left; padding: .2rem .5rem; border-bottom: 1px solid #8883; vertical-align: top; }
  #log { background: #8881; padding: .6rem; border-radius: 6px; height: 26rem; overflow: auto;
         white-space: pre-wrap; word-break: break-word; font-size: .85em; }
  .row { display: flex; align-items: center; gap: .6rem; flex-wrap: wrap; margin-bottom: .5rem; }
  .l-debug { opacity: .65; }
  .l-info  { color: inherit; }
  .l-warn  { color: #b80; }
  .l-error { color: #c33; }
  .l-ok    { color: #2a7; }
  .badge { border: 1px solid #8886; border-radius: 999px; padding: 0 .5rem; font-size: .8em; }
</style>
</head>
<body>
<h1>cfdeploy</h1>
<p>Publish an Aristotle bundle to Cloudflare. Every step of the plan below
is signed by its own short-lived API token, carrying exactly the
permissions that step needs — the plan, the permissions and the token
requests are all generated from the Lean model in this repository.</p>

<fieldset>
  <legend>1 — the plan</legend>
  <p>Produced by <code>lake exe cfdeploy emit &lt;outdir&gt; &lt;bundle.tgz&gt; --account … --project …</code>;
  this page is served from that directory, next to <code>deploy-plan.json</code>.</p>
  <div id="plan">loading <code>deploy-plan.json</code>…</div>
</fieldset>

<fieldset>
  <legend>2 — the tokens this plan needs</legend>
  <div id="needs">waiting for the plan…</div>
</fieldset>

<fieldset>
  <legend>3 — authorize</legend>
  <p>Paste a token that may <em>create tokens</em> (<code>API Tokens Write</code> on your
  user). It is used once, to mint the scoped tokens above, and is never
  sent with a deployment request, never logged, and never stored: closing
  the tab forgets it.</p>
  <input id="admin" type="password" placeholder="Cloudflare API token with API Tokens Write" autocomplete="off">
  <p>
    <label><input id="dry" type="checkbox" checked> dry run (show the requests, send nothing)</label>
    <label><input id="revoke" type="checkbox" checked> revoke the minted tokens when the run
      finishes</label>
  </p>
  <p>
    <label>API base — leave empty for <code>api.cloudflare.com</code>, or give
    your own proxy Worker if the browser blocks it by CORS:<br>
    <input id="apibase" type="text" placeholder="https://cf-proxy.example.workers.dev/client/v4" autocomplete="off">
    </label>
  </p>
  <button id="go">Deploy</button>
  <button id="check">Check connectivity</button>
  <span id="state" class="badge">idle</span>
</fieldset>

<fieldset>
  <legend>4 — log</legend>
  <div class="row">
    <label>level
      <select id="level">
        <option value="debug">debug</option>
        <option value="info" selected>info</option>
        <option value="warn">warn</option>
        <option value="error">error</option>
      </select>
    </label>
    <label><input id="follow" type="checkbox" checked> follow</label>
    <span id="counts" class="badge">0 events</span>
    <button id="copy">Copy</button>
    <button id="save">Download .log</button>
    <button id="savejson">Download .json</button>
    <button id="clear">Clear</button>
  </div>
  <div id="log"></div>
</fieldset>

<script type="module">
const $ = (id) => document.getElementById(id);

// ---------------------------------------------------------------- the log
// It exists before anything else is attempted, so every failure below —
// including a module that will not load — is visible on the page.
const EVENTS = [];
let LEVELS = { debug: 10, info: 20, warn: 30, error: 40 };
let fmt = (ev) => `${String(ev.t).slice(11, 23)} ${String(ev.level).toUpperCase().padEnd(5)} ` +
  `${String(ev.kind).padEnd(12)} ${ev.msg}`;

function render() {
  const min = LEVELS[$('level').value];
  const frag = document.createDocumentFragment();
  let shown = 0;
  for (const ev of EVENTS) {
    if (LEVELS[ev.level] < min) continue;
    shown++;
    const div = document.createElement('div');
    div.className = 'l-' + (ev.kind === 'step-ok' || ev.kind === 'mint-ok' ? 'ok' : ev.level);
    div.textContent = fmt(ev);
    frag.appendChild(div);
  }
  const log = $('log');
  log.replaceChildren(frag);
  const errs = EVENTS.filter((e) => e.level === 'error').length;
  const warns = EVENTS.filter((e) => e.level === 'warn').length;
  $('counts').textContent = `${EVENTS.length} events · ${shown} shown · ${warns} warn · ${errs} error`;
  if ($('follow').checked) log.scrollTop = log.scrollHeight;
}

function push(ev) {
  EVENTS.push(ev);
  render();
}

function say(level, kind, msg, fields = {}) {
  push({ t: new Date().toISOString(), level, kind, msg, ...fields });
}

$('level').addEventListener('change', render);
$('clear').addEventListener('click', () => { EVENTS.length = 0; render(); say('info', 'log', 'log cleared'); });
$('copy').addEventListener('click', async () => {
  try {
    await navigator.clipboard.writeText(EVENTS.map(fmt).join('\n'));
    say('info', 'log', 'log copied to the clipboard');
  } catch (e) {
    say('warn', 'log', 'could not copy: ' + e.message);
  }
});
const download = (name, text, type) => {
  const url = URL.createObjectURL(new Blob([text], { type }));
  const a = document.createElement('a');
  a.href = url; a.download = name; a.click();
  URL.revokeObjectURL(url);
  say('info', 'log', 'wrote ' + name);
};
$('save').addEventListener('click', () =>
  download('cfdeploy.log', EVENTS.map(fmt).join('\n') + '\n', 'text/plain'));
$('savejson').addEventListener('click', () =>
  download('cfdeploy-log.json', JSON.stringify(EVENTS, null, 2) + '\n', 'application/json'));

window.addEventListener('error', (e) =>
  say('error', 'window', 'uncaught error: ' + (e.message ?? e), {
    source: e.filename ? `${e.filename}:${e.lineno}` : undefined,
  }));
window.addEventListener('unhandledrejection', (e) =>
  say('error', 'window', 'unhandled rejection: ' +
    ((e.reason && e.reason.message) || String(e.reason))));

const setState = (s) => { $('state').textContent = s; };

say('info', 'page', 'page loaded', { url: location.href });
if (location.protocol === 'file:') {
  say('error', 'page', 'this page is opened from the filesystem; ES modules and fetch are blocked',
    { hint: 'serve the directory instead, e.g. `python3 -m http.server` inside it' });
}

// ------------------------------------------------------------ the modules
let client = null, tokensMod = null, log = null;
try {
  say('info', 'load', 'importing ./cf-log.mjs, ./cf-deploy.mjs, ./cf-tokens.mjs');
  log = await import('./cf-log.mjs');
  client = await import('./cf-deploy.mjs');
  tokensMod = await import('./cf-tokens.mjs');
  LEVELS = log.LEVELS;
  fmt = log.formatEvent;
  say('info', 'load', 'generated client loaded', { steps: client.PLAN.steps.length });
} catch (e) {
  say('error', 'load', 'could not load the generated client: ' + e.message, {
    hint: 'this page must be served from the directory `cfdeploy emit` wrote ' +
          '(cf-deploy.mjs, cf-tokens.mjs, cf-log.mjs, deploy-plan.json, assets/)',
  });
  setState('not ready');
}

// --------------------------------------------------------------- the plan
let PLAN = client ? client.PLAN : null;
if (client) {
  try {
    const res = await fetch('./deploy-plan.json');
    if (!res.ok) throw new Error(`HTTP ${res.status} for ${new URL('./deploy-plan.json', location.href)}`);
    const disk = await res.json();
    const same = JSON.stringify(disk) === JSON.stringify(client.PLAN);
    say(same ? 'info' : 'warn', 'plan',
      same ? `deploy-plan.json matches the generated client (${disk.steps.length} steps)`
           : 'deploy-plan.json and cf-deploy.mjs disagree; using the client, re-run `cfdeploy emit`',
      { steps: disk.steps.length });
  } catch (e) {
    say('warn', 'plan', 'could not read deploy-plan.json: ' + e.message,
      { hint: 'the plan embedded in cf-deploy.mjs is used instead' });
  }
}

if (PLAN) {
  const rows = PLAN.steps.map((s, i) =>
    `<tr><td>${i + 1}</td><td>${s.method}</td>` +
    `<td>${s.url.replace('https://api.cloudflare.com/client/v4', '')}</td>` +
    `<td>${s.role}</td><td>${s.describe ?? ''}</td></tr>`).join('');
  $('plan').innerHTML =
    `<table><tr><th>#</th><th>method</th><th>path</th><th>role</th><th>what it does</th></tr>${rows}</table>`;
  setState('ready');
} else {
  $('plan').innerHTML = '<em>no plan — see the log below</em>';
  $('needs').innerHTML = '<em>no plan — see the log below</em>';
}

const needs = client ? client.requiredTokens() : [];
if (client) {
  $('needs').innerHTML = '<table><tr><th>role</th><th>permission groups</th><th>resources</th></tr>' +
    needs.map((n) => `<tr><td>${n.role}</td><td>${n.groups.join('<br>')}</td>` +
      `<td>${n.resources.join('<br>')}</td></tr>`).join('') + '</table>';
  say('info', 'tokens', `this plan needs ${needs.length} scoped token(s)`,
    { roles: needs.map((n) => n.role) });
  const free = PLAN.steps.filter((s) => s.groups.length === 0).length;
  if (free) say('info', 'tokens', `${free} step(s) need no API token at all`);
}

// ------------------------------------------------------------- the assets
async function loadAssets() {
  const assets = {};
  let manifest = [];
  try {
    const res = await fetch('./manifest.json');
    if (!res.ok) throw new Error('HTTP ' + res.status);
    manifest = await res.json();
    say('info', 'assets', `manifest lists ${manifest.length} asset(s)`);
  } catch (e) {
    say('warn', 'assets', 'no manifest.json: ' + e.message);
  }
  let bytes = 0, missing = 0;
  for (const a of manifest) {
    const res = await fetch('./assets/' + a.hash);
    if (res.ok) {
      const buf = await res.arrayBuffer();
      assets[a.hash] = buf;
      bytes += buf.byteLength;
    } else {
      missing++;
      say('warn', 'assets', `missing body for ${a.path ?? a.hash} (HTTP ${res.status})`);
    }
  }
  const workerStep = PLAN.steps.find((s) => s.payload && s.payload.startsWith('worker:'));
  if (workerStep) {
    try {
      const res = await fetch('./worker.mjs');
      if (!res.ok) throw new Error('HTTP ' + res.status);
      assets[workerStep.payload] = await res.arrayBuffer();
      say('info', 'assets', 'loaded worker.mjs');
    } catch (e) {
      say('error', 'assets', 'could not load worker.mjs: ' + e.message);
    }
  }
  say('info', 'assets', `${Object.keys(assets).length} payload(s) ready, ${bytes} byte(s)` +
    (missing ? `, ${missing} missing` : ''));
  return assets;
}

// ------------------------------------------------------------------- run
const apiBase = () => $('apibase').value.trim() || null;

$('check').addEventListener('click', async () => {
  const target = (apiBase() ?? 'https://api.cloudflare.com/client/v4') + '/user/tokens/verify';
  say('info', 'check', `GET ${target} (no credential) — is the API reachable from here?`);
  try {
    const res = await fetch(target);
    say('info', 'check', `reachable: HTTP ${res.status} (401/403 is the expected answer)`);
  } catch (e) {
    say('error', 'check', 'not reachable: ' + e.message, {
      hint: 'browsers apply CORS to api.cloudflare.com — run `node run-deploy.mjs .` ' +
            'from this directory, or point the client at your own proxy Worker',
    });
  }
});

$('go').addEventListener('click', async () => {
  if (!client) { say('error', 'run', 'the generated client is not loaded; nothing to run'); return; }
  $('go').disabled = true;
  const dry = $('dry').checked;
  setState(dry ? 'dry run…' : 'deploying…');
  say('info', 'run', dry ? 'starting a dry run (nothing is sent)' : 'starting a deployment');
  try {
    const assets = await loadAssets();
    if (dry) {
      const out = await client.runPlan({}, { assets, dryRun: true, onEvent: push, apiBase: apiBase() });
      const denied = out.filter((l) => l.status === 'denied').length;
      say('info', 'run', `dry run finished: ${out.length} step(s), ${denied} would be refused`);
      setState('dry run done');
      return;
    }
    const admin = $('admin').value.trim();
    if (!admin) {
      say('error', 'run', 'no admin token given; paste one, or tick "dry run"');
      setState('idle');
      return;
    }
    const expiresOn = new Date(Date.now() + 15 * 60 * 1000).toISOString().replace(/\.\d+Z$/, 'Z');
    const mintedIds = {};
    const tokens = await tokensMod.mintTokens(admin, needs, expiresOn, fetch, push, apiBase(),
      mintedIds);
    const out = await client.runPlan(tokens,
      { assets, onEvent: push, apiBase: apiBase(), tokenIds: mintedIds });
    if ($('revoke').checked) {
      await tokensMod.revokeTokens(admin, mintedIds, fetch, push, apiBase());
    } else {
      say('warn', 'revoke-end', 'the minted tokens were kept; they expire at ' + expiresOn);
    }
    const bad = out.filter((l) => l.status !== 'ok');
    say(bad.length ? 'error' : 'info', 'run',
      bad.length ? `finished with ${bad.length} problem step(s)` : 'deployment finished cleanly');
    setState(bad.length ? 'failed' : 'done');
  } catch (e) {
    say('error', 'run', 'aborted: ' + (e && e.message ? e.message : e));
    setState('failed');
  } finally {
    $('go').disabled = false;
  }
});
</script>

<p><small>Note: browsers apply CORS to <code>api.cloudflare.com</code>. Serve this
page from an allowed origin, run the same plan with
<code>node run-deploy.mjs .</code> from this directory, or point the client at
your own proxy Worker. Every attempt, and every reason one did not
happen, is in the log above.</small></p>
</body>
</html>
"##

end JsEmit
end CfDeploy
