/-
# JavaScript extraction

The deployment tool has to run where Cloudflare credentials live: in a
browser tab, in a Worker, or in `node`.  Rather than reimplement the
permission logic there — and risk it drifting from the model that the
theorems are about — the JavaScript is *generated from the Lean values*.

`planSteps` turns a workflow into a list of records, one per action,
carrying the role that signs it, the request it makes, and the
permission-group names its token must have.  `deployClientJs` embeds that
list verbatim in an ES module whose only job is to walk it, look up
`CF_TOKEN_<role>` for each step, and `fetch`.  The JavaScript therefore
cannot ask for a permission the Lean model did not, and
`planSteps_roles` / `planStep_groups` pin that correspondence down.

`workerJs` emits the other side: the Worker that serves the uploaded
bundle out of a KV namespace, using a manifest generated from the same
`Asset` values.

The client reports what it is doing through the structured log of
`RequestProject.Cf.WebUi` (`cf-log.mjs`): every step announces itself, the
request it sends (credential redacted), the response, Cloudflare's own
error codes, and how long it took.  The front ends that consume it — the
node runner and the page — live in that file too.
-/
import RequestProject.Edge.Cf.Bundle
import RequestProject.Edge.Cf.Token
import RequestProject.Edge.Cf.WebUi

namespace CfDeploy
namespace JsEmit

/-- One step of the emitted plan. -/
structure PlanStep where
  role : String
  method : String
  url : String
  body : Option Json
  /-- the Cloudflare permission-group names the step's token must carry -/
  groups : List String
  /-- the resource keys the token is scoped to -/
  resources : List String
  /-- for a step that uploads bytes, the key of the payload in the caller's
  asset map (the Worker script, or an asset's content hash) -/
  payload : Option String
  describe : String
  deriving Inhabited

/-- The plan step of an action. -/
def planStep (userId : String) (a : Action) : PlanStep :=
  { role := a.role
    method := a.request.method.name
    url := a.request.url
    body := a.request.body
    groups := a.required.map Perm.groupName
    resources := a.required.map (fun p => p.scope.resourceKey userId)
    payload :=
      match a with
      | .putKvValue _ _ key => some key
      | .putR2Object _ _ key => some key
      | .putWorkerScript _ script => some ("worker:" ++ script)
      | _ => none
    describe := a.describe }

/-- The plan of a workflow: one step per action, in order. -/
def planSteps (userId : String) (w : Workflow) : List PlanStep :=
  w.actions.map (planStep userId)

theorem planSteps_roles (userId : String) (w : Workflow) :
    (planSteps userId w).map PlanStep.role = w.actions.map Action.role := by
  simp [planSteps, planStep, List.map_map, Function.comp]

/-- The permission groups a step asks for are exactly the groups of the
grants its action requires — the emitted JavaScript cannot widen the
contract. -/
theorem planStep_groups (userId : String) (a : Action) :
    (planStep userId a).groups = a.required.map Perm.groupName := rfl

theorem planStep_role (userId : String) (a : Action) :
    (planStep userId a).role = a.role := rfl

/-- Composition is preserved by extraction: the plan of `w₁.seq w₂` is the
plan of `w₁` followed by the plan of `w₂`. -/
theorem planSteps_seq (userId : String) (w₁ w₂ : Workflow) :
    planSteps userId (.seq w₁ w₂) = planSteps userId w₁ ++ planSteps userId w₂ := by
  simp [planSteps]

/-! ## Rendering -/

def stepJson (s : PlanStep) : Json :=
  .obj [("role", .str s.role), ("method", .str s.method), ("url", .str s.url),
        ("body", match s.body with | some b => b | none => .null),
        ("groups", .arr (s.groups.map Json.str)),
        ("resources", .arr (s.resources.map Json.str)),
        ("payload", match s.payload with | some k => .str k | none => .null),
        ("describe", .str s.describe)]

def planJson (userId : String) (w : Workflow) : Json :=
  .obj [("version", .num 1),
        ("steps", .arr ((planSteps userId w).map stepJson))]

/-- The part of `cf-deploy.mjs` that does not depend on the plan. -/
def deployClientBodyJs : String :=
r##"export function requiredTokens(plan = PLAN) {
  const out = new Map();
  for (const s of plan.steps) {
    if (s.groups.length === 0) continue;
    const cur = out.get(s.role) ?? { groups: new Set(), resources: new Set() };
    s.groups.forEach((g) => cur.groups.add(g));
    s.resources.forEach((r) => cur.resources.add(r));
    out.set(s.role, cur);
  }
  return [...out].map(([role, v]) => ({
    role,
    groups: [...v.groups],
    resources: [...v.resources],
  }));
}

// A step built before its token existed refers to it as `{token:ROLE}`
// (see `Action.mintedIdRef`).  Substitute the id of the token this run
// minted for that role; a reference that cannot be resolved is reported,
// and its step is refused rather than sent.
export function resolveTokenRefs(url, ids = {}) {
  let missing = null;
  const out = url.replace(/\{token:([^}]*)\}/g, (m, role) => {
    const id = (ids ?? {})[role];
    if (id === undefined || id === null || id === '') { missing = role; return m; }
    return encodeURIComponent(id);
  });
  return missing === null ? { url: out } : { url, missing };
}

async function readBody(res) {
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

const headerOf = (res, name) => {
  try {
    return res.headers && typeof res.headers.get === 'function'
      ? (res.headers.get(name) ?? undefined) : undefined;
  } catch { return undefined; }
};

// Run the plan.  `onEvent` receives every log event; omit it and the run
// prints to the console, so a deployment is never silent.  Pass null for
// no logging at all.
export async function runPlan(tokens, {
  plan = PLAN, assets = {}, fetchImpl = fetch, dryRun = false, onEvent, timeoutMs = 60000,
  apiBase = null, tokenIds = {},
} = {}) {
  const emit = emitter(onEvent);
  if (apiBase) emit('info', 'plan-start', `sending every request through the proxy at ${apiBase}`);
  const log = [];
  const started = Date.now();
  const needs = requiredTokens(plan);
  const held = needs.filter((n) => tokens[n.role]).map((n) => n.role);
  const missing = needs.filter((n) => !tokens[n.role]).map((n) => n.role);
  emit('info', 'plan-start',
    `running ${plan.steps.length} step(s)` + (dryRun ? ' — dry run, nothing is sent' : ''),
    { roles: needs.map((n) => n.role), held, missing });
  if (missing.length && !dryRun) {
    emit('warn', 'no-credential',
      `no token for ${missing.length} role(s); their steps will be refused`, { missing });
  }
  let i = 0;
  for (const s of plan.steps) {
    i++;
    const tag = `${i}/${plan.steps.length}`;
    const needsToken = s.groups.length > 0;
    const token = tokens[s.role] ?? tokens['upload-jwt'];
    const resolved = resolveTokenRefs(s.url, tokenIds);
    const url = rewriteApi(resolved.url, apiBase);
    emit('info', 'step-start', `${tag} ${s.role}: ${s.describe ?? s.method + ' ' + s.url}`,
      { step: i, role: s.role, method: s.method, url, groups: s.groups });
    if (resolved.missing !== undefined && !dryRun) {
      emit('warn', 'step-denied',
        `${tag} refused: no token of role ${resolved.missing} was minted by this run`,
        { step: i, role: s.role, ref: resolved.missing });
      log.push({ step: s.role, index: i, status: 'denied',
                 reason: 'no minted token id for role ' + resolved.missing });
      continue;
    }
    const noCredential = needsToken && !tokens[s.role];
    if (noCredential && !dryRun) {
      emit('warn', 'step-denied', `${tag} refused: no credential for role ${s.role}`,
        { step: i, role: s.role, groups: s.groups });
      log.push({ step: s.role, index: i, status: 'denied', reason: 'no credential for this role' });
      continue;
    }
    if (!needsToken) {
      emit('debug', 'step-start', `${tag} needs no API token`, { step: i, role: s.role });
    }
    let body = s.body === null ? undefined : JSON.stringify(s.body);
    let contentType = s.body === null ? undefined : 'application/json';
    if (s.payload !== null && s.payload !== undefined) {
      const bytes = assets[s.payload];
      if (bytes === undefined) {
        emit('error', 'step-denied', `${tag} refused: payload ${s.payload} was not supplied`,
          { step: i, role: s.role, payload: s.payload,
            hint: 'the asset bodies live in assets/ next to the plan' });
        log.push({ step: s.role, index: i, status: 'denied',
                   reason: 'payload ' + s.payload + ' not supplied' });
        continue;
      }
      body = bytes;
      contentType = 'application/octet-stream';
    }
    const headers = {
      'Authorization': 'Bearer ' + token,
      ...(contentType === undefined ? {} : { 'Content-Type': contentType }),
    };
    const init = { method: s.method, headers, ...(body === undefined ? {} : { body }) };
    emit('debug', 'request', `${tag} ${s.method} ${url}`,
      { step: i, headers: redactHeaders(headers), body: preview(body),
        credential: noCredential ? '(none: dry run)' : redact(token) });
    if (dryRun) {
      emit('info', 'step-dry-run', `${tag} would ${s.method} ${url}`,
        { step: i, role: s.role, body: preview(body, 200),
          credential: noCredential ? `a token for ${s.role} would be minted first` : redact(token) });
      log.push({ step: s.role, index: i, status: 'dry-run', method: s.method, url });
      continue;
    }
    let timer, res;
    if (timeoutMs > 0 && typeof AbortController !== 'undefined') {
      const ac = new AbortController();
      init.signal = ac.signal;
      timer = setTimeout(() => ac.abort(), timeoutMs);
    }
    const t0 = Date.now();
    try {
      res = await fetchImpl(url, init);
    } catch (e) {
      const msg = e && e.message ? e.message : String(e);
      emit('error', 'step-error', `${tag} the request never completed: ${msg}`,
        { step: i, role: s.role, url, ms: Date.now() - t0,
          hint: /abort/i.test(msg)
            ? `no answer within ${timeoutMs} ms`
            : 'a browser CORS block, an offline network, or a bad URL' });
      log.push({ step: s.role, index: i, status: 'error', reason: msg });
      break;
    } finally {
      if (timer !== undefined) clearTimeout(timer);
    }
    const ms = Date.now() - t0;
    const { text, json } = await readBody(res);
    const errors = cfErrors(json);
    const ray = headerOf(res, 'cf-ray');
    for (const m of (json.messages ?? [])) {
      emit('info', 'cf-message', `${tag} ${m.code ?? ''} ${m.message ?? JSON.stringify(m)}`.trim(),
        { step: i });
    }
    if (res.ok && json.success !== false) {
      emit('info', 'step-ok', `${tag} ok — HTTP ${res.status} in ${ms} ms`,
        { step: i, role: s.role, ray, response: preview(text, 200) });
      log.push({ step: s.role, index: i, status: 'ok', http: res.status, ms, body: json });
    } else {
      emit('error', 'step-failed',
        `${tag} HTTP ${res.status}` + (errors.length ? ': ' + errors.join('; ') : ''),
        { step: i, role: s.role, ray, ms, response: preview(text, 600),
          hint: res.status === 403
            ? 'the scoped token for this role does not carry the permission this step needs'
            : undefined });
      log.push({ step: s.role, index: i, status: 'error', http: res.status, ms, body: json,
                 errors, reason: errors.join('; ') || ('HTTP ' + res.status) });
      break;
    }
  }
  const count = (st) => log.filter((l) => l.status === st).length;
  const failed = count('error');
  emit(failed ? 'error' : 'info', 'plan-end',
    `finished: ${count('ok')} ok, ${count('denied')} denied, ${failed} failed, ` +
    `${count('dry-run')} dry-run, in ${Date.now() - started} ms`,
    { ok: count('ok'), denied: count('denied'), failed, dryRun: count('dry-run'),
      of: plan.steps.length });
  return log;
}
"##

/-- The deployment client: an ES module that runs a plan, one scoped token
per step.  It refuses a step whose token is absent instead of falling back
to a broader credential, mirroring `Exec.step`.  Every step reports what
it is about to do, what it sent (with the credential redacted) and what
came back, through the shared log in `cf-log.mjs`. -/
def deployClientJs (userId : String) (w : Workflow) : String :=
  "// Generated from Lean by RequestProject.Cf.JsEmit — do not edit.\n" ++
  "// Each step is signed by its own scoped Cloudflare API token, taken\n" ++
  "// from tokens['<role>'].  A missing token fails that step; the client\n" ++
  "// never falls back to another credential.\n" ++
  "import { emitter, redact, redactHeaders, preview, cfErrors, rewriteApi }\n" ++
  "  from './cf-log.mjs';\n\n" ++
  "export const PLAN = " ++ Json.pretty 0 (planJson userId w) ++ ";\n\n" ++
  deployClientBodyJs

/-- The manifest the Worker serves from: served path → KV key, type, size. -/
def manifestJs (assets : List Asset) : String :=
  "export const MANIFEST = " ++
    Json.pretty 0 (.obj (assets.map fun a =>
      (a.path, Json.obj [("key", .str a.hash), ("type", .str a.contentType),
                         ("size", .num (a.size : Int))]))) ++ ";\n"

/-- The Worker that serves an uploaded bundle out of Workers KV.  It is a
read-only front end: it holds no API token and can only read the assets
bound to it. -/
def workerJs (assets : List Asset) : String :=
  manifestJs assets ++
  "\n// Generated from Lean by RequestProject.Cf.JsEmit — do not edit.\n" ++
  "export default {\n" ++
  "  async fetch(request, env) {\n" ++
  "    const url = new URL(request.url);\n" ++
  "    let path = decodeURIComponent(url.pathname);\n" ++
  "    if (path.endsWith('/')) path += 'index.html';\n" ++
  "    const entry = MANIFEST[path] ?? MANIFEST[path + '/index.html'];\n" ++
  "    if (!entry) return new Response('not found', { status: 404 });\n" ++
  "    const etag = '\\\"' + entry.key + '\\\"';\n" ++
  "    if (request.headers.get('If-None-Match') === etag) {\n" ++
  "      return new Response(null, { status: 304 });\n" ++
  "    }\n" ++
  "    const body = await env.ASSETS.get(entry.key, { type: 'arrayBuffer' });\n" ++
  "    if (body === null) return new Response('missing asset', { status: 502 });\n" ++
  "    return new Response(body, {\n" ++
  "      headers: {\n" ++
  "        'Content-Type': entry.type,\n" ++
  "        'ETag': etag,\n" ++
  "        'Cache-Control': 'public, max-age=300',\n" ++
  "      },\n" ++
  "    });\n" ++
  "  },\n" ++
  "};\n"

end JsEmit
end CfDeploy
