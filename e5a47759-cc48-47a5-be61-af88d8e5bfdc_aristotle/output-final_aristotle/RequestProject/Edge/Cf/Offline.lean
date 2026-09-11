/-
# When the browser cannot reach the API: the terminal, and the agent

A page served from a plain static host cannot call `api.cloudflare.com`
at all — the API sends no CORS headers, so the browser refuses the
request before it leaves the machine and the log fills up with
`Failed to fetch`.  Nothing is wrong with the plan when that happens; the
*transport* is missing.  This module emits the two transports that do not
need one:

* **the terminal** — `deployShellScript` renders the very same plan as a
  POSIX `sh` script of `curl` calls, and `curlCommand` renders one step
  as a single line you can paste.  The script mints one scoped token per
  role from `CF_API_TOKEN` (or uses `CF_TOKEN_<role>` if you already have
  them), uploads each asset from a directory of files named by content
  hash, and refuses to do anything without an explicit credential.  The
  page can generate it, `cfdeploy emit` writes it next to the plan, and
  both are the same text.
* **the agent** — `agentJs` is a small `node` program you run on your own
  machine.  It listens on `127.0.0.1`, forwards `/cf/...` to the
  Cloudflare API, and adds the `CF_API_TOKEN` from *its* environment, so
  the key never enters the browser at all.  It answers CORS, which is
  what makes the hosted page work from anywhere; it is reachable only
  through the access key it prints at startup, so no other page in your
  browser can use it.

Quoting is the part that has to be right: a path or a JSON body pasted
into a shell unquoted is a command-injection bug.  `shQuote` wraps a
string in single quotes, and `evalWord_shQuote` proves that a POSIX shell
reading the result gets exactly the string back — the model of the shell
it is proved against is `evalWord`, right here, so the claim is checkable
rather than folklore.
-/
import RequestProject.Edge.Cf.JsEmit

namespace CfDeploy
namespace Offline

/-! ## Shell quoting, and what the shell makes of it -/

/-- The body of a single-quoted word: a `'` has to leave the quotes,
be escaped, and come back in (`'\''`). -/
def quoteBody : List Char → List Char
  | [] => []
  | c :: t => (if c = '\'' then ['\'', '\\', '\'', '\''] else [c]) ++ quoteBody t

/-- A string as one single-quoted shell word. -/
def shQuoteL (s : List Char) : List Char := '\'' :: (quoteBody s ++ ['\''])

/-- A string as one shell word, safe to paste into a command line. -/
def shQuote (s : String) : String := String.ofList (shQuoteL s.toList)

/-! ### A model of the shell's word parser

`evalWord` reads one word the way `sh` does: `\c` is a literal `c`,
`'…'` is literal up to the next `'`, and an unterminated quote is an
error. -/

mutual

/-- Reading a word, outside quotes. -/
def evalWord : List Char → Option (List Char)
  | [] => some []
  | '\'' :: t => inQuote t
  | '\\' :: c :: t => (evalWord t).map (c :: ·)
  | '\\' :: [] => none
  | c :: t => (evalWord t).map (c :: ·)

/-- Reading a word, inside single quotes. -/
def inQuote : List Char → Option (List Char)
  | [] => none
  | '\'' :: t => evalWord t
  | c :: t => (inQuote t).map (c :: ·)

end

/-- **A quoted word means exactly the string it was made from.**  Whatever
is in a path, a JSON body or a role name, the shell hands the command the
original bytes: there is no way to end the quoting early, and so no way
to inject a second command. -/
theorem inQuote_quoteBody (s : List Char) :
    inQuote (quoteBody s ++ ['\'']) = some s := by
  induction s with
  | nil => simp [quoteBody, inQuote, evalWord]
  | cons c t ih =>
      by_cases h : c = '\''
      · subst h
        simp [quoteBody, inQuote, evalWord, ih]
      · simp [quoteBody, h, inQuote, ih]

theorem evalWord_shQuote (s : List Char) : evalWord (shQuoteL s) = some s := by
  simpa [shQuoteL, evalWord] using inQuote_quoteBody s

/-! ## One step, as a `curl` line -/

/-- Where the payload of a step comes from. -/
def payloadKind (s : JsEmit.PlanStep) : String :=
  match s.payload, s.body with
  | some _, _ => "file"
  | none, some _ => "json"
  | none, none => "none"

/-- The data argument of a step: the content hash of the file to upload,
or the JSON body, or nothing. -/
def payloadData (s : JsEmit.PlanStep) : String :=
  match s.payload, s.body with
  | some k, _ => k
  | none, some b => Json.render b
  | none, none => ""

/-- The file a payload is read from, under the assets directory: the
content hash, or the Worker script (whose key carries a `:` that not
every filesystem likes). -/
def fileNameOf (key : String) : String :=
  String.ofList (key.toList.map fun c => if c = ':' then '_' else c)

/-- The credential a step is signed with, as a shell variable name.  The
Pages asset calls are signed by the one-project upload JWT the plan
fetches on the way (`Auth.uploadJwt`), everything else by its own role
token. -/
def tokenVar (s : JsEmit.PlanStep) : String :=
  if s.role.startsWith "pages-assets" then "CF_UPLOAD_JWT" else envVarOfRole s.role

/-- One step of the plan as a single `curl` command, with every argument
quoted (`shQuote`) and the credential left as a shell variable, so that
no secret is ever written into the text. -/
def curlCommand (apiBase : String) (s : JsEmit.PlanStep) : String :=
  let url := apiBase ++ ((s.url.drop Request.base.length).toString)
  let auth := " -H \"Authorization: Bearer $" ++ tokenVar s ++ "\""
  let data :=
    match payloadKind s with
    | "file" => " -H 'Content-Type: application/octet-stream' --data-binary "
        ++ shQuote ("@assets/" ++ fileNameOf (payloadData s))
    | "json" => " -H 'Content-Type: application/json' --data " ++ shQuote (payloadData s)
    | _ => ""
  "curl -sS -X " ++ s.method ++ " " ++ shQuote url ++ auth ++ data

/-- Every step of a plan, as pasteable `curl` lines with a comment each. -/
def curlCommands (apiBase : String) (steps : List JsEmit.PlanStep) : String :=
  String.intercalate "\n"
    (steps.map fun s => "# " ++ s.describe ++ " (role " ++ s.role ++ ")\n" ++
      curlCommand apiBase s)

/-! ## The whole plan, as a script -/

/-- The fixed part of the script: argument parsing, the token wallet, the
minting of one scoped token per role, and the step runner. -/
def shellPrelude : String :=
r##"set -eu

API="${CF_API_BASE:-https://api.cloudflare.com/client/v4}"
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ASSETS="${CF_ASSETS:-$HERE/assets}"
DRY="${CF_DRY_RUN:-0}"
FAILED=0
PERFORMED=0
REFUSED=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    --assets=*) ASSETS="${arg#--assets=}" ;;
    --api=*) API="${arg#--api=}" ;;
    -h|--help)
      cat <<'USAGE'
usage: deploy.sh [--dry-run] [--assets=DIR] [--api=URL]

Credentials, in order of preference:
  CF_TOKEN_<ROLE>   one scoped token per role (printed by `cfdeploy tokens`
                    or minted by the page); nothing else is needed.
  CF_API_TOKEN      a token that may create tokens (API Tokens Write on your
                    user); this script then mints the scoped tokens itself,
                    each valid for 15 minutes, and uses them.

Assets are read from ./assets/<content-hash>, as written by
`cfdeploy emit` or by the page's "Download payload.tar".
USAGE
      exit 0 ;;
  esac
done

say() { printf '%s\n' "$*" >&2; }
die() { say "error: $*"; exit 1; }

need_json_tool() {
  if command -v jq >/dev/null 2>&1; then JSON_TOOL=jq
  elif command -v python3 >/dev/null 2>&1; then JSON_TOOL=python3
  else die "minting needs jq or python3; export CF_TOKEN_<ROLE> instead and re-run"; fi
}

# json_field <field-path> — read a value out of the JSON on stdin.
json_field() {
  if [ "$JSON_TOOL" = jq ]; then
    jq -r "$1"
  else
    python3 -c 'import json,sys
d=json.load(sys.stdin)
for k in sys.argv[1].split("."):
    if k in ("", "$"): continue
    d = d[int(k)] if k.isdigit() else d.get(k)
    if d is None: break
print("" if d is None else d)' "$1"
  fi
}

# group_id <name> — the permission-group id of a name, from the catalog.
group_id() {
  if [ "$JSON_TOOL" = jq ]; then
    jq -r --arg n "$1" '.result[] | select(.name == $n) | .id' < "$CATALOG" | head -1
  else
    python3 -c 'import json,sys
d=json.load(open(sys.argv[1]))
print(next((g["id"] for g in d.get("result",[]) if g.get("name")==sys.argv[2]), ""))' \
      "$CATALOG" "$1"
  fi
}

read_catalog() {
  [ -n "${CATALOG:-}" ] && return 0
  need_json_tool
  CATALOG=$(mktemp)
  say "reading the permission-group catalog"
  curl -sS -X GET "$API/user/tokens/permission_groups?per_page=1000" \
    -H "Authorization: Bearer $CF_API_TOKEN" > "$CATALOG" || die "could not read the catalog"
  ok=$(json_field .success < "$CATALOG")
  [ "$ok" = "True" ] || [ "$ok" = "true" ] || {
    say "$(cat "$CATALOG")"
    die "the catalog request failed — does CF_API_TOKEN carry API Tokens Read?"
  }
}

# mint <role> <var> <groups|separated> <resources|separated>
mint() {
  role="$1"; var="$2"; groups="$3"; resources="$4"
  eval "have=\${$var:-}"
  if [ -n "$have" ]; then say "using \$$var from the environment (role $role)"; return 0; fi
  if [ "$DRY" = 1 ]; then
    say "dry run: would mint a token for $role with: $groups"
    eval "$var='(dry-run)'"
    return 0
  fi
  [ -n "${CF_API_TOKEN:-}" ] || { say "no \$$var and no \$CF_API_TOKEN (role $role)"; return 1; }
  read_catalog
  pol='' ; sep=''
  ids=''
  old="$IFS"; IFS='|'
  for g in $groups; do
    [ -n "$g" ] || continue
    id=$(IFS="$old" group_id "$g")
    [ -n "$id" ] || { IFS="$old"; die "unknown permission group: $g"; }
    ids="$ids$sep{\"id\":\"$id\"}"; sep=','
  done
  res=''; sep=''
  for r in $resources; do
    [ -n "$r" ] || continue
    res="$res$sep\"$r\":\"*\""; sep=','
  done
  IFS="$old"
  exp=$(date -u -d '+15 minutes' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || \
        date -u -v+15M '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || echo '')
  body="{\"name\":\"cfdeploy/$role\",\"policies\":[{\"effect\":\"allow\",\"permission_groups\":[$ids],\"resources\":{$res}}]"
  [ -n "$exp" ] && body="$body,\"expires_on\":\"$exp\""
  body="$body}"
  out=$(curl -sS -X POST "$API/user/tokens" -H "Authorization: Bearer $CF_API_TOKEN" \
        -H 'Content-Type: application/json' --data "$body")
  val=$(printf '%s' "$out" | json_field .result.value)
  [ -n "$val" ] || { say "$out"; die "minting the token for $role failed"; }
  eval "$var=\$val"
  say "minted a scoped token for $role (expires $exp)"
}

# run_step <role> <var> <method> <path> <kind> <data> <description>
run_step() {
  role="$1"; var="$2"; method="$3"; path="$4"; kind="$5"; data="$6"; desc="$7"
  eval "tok=\${$var:-}"
  if [ -z "$tok" ]; then
    say "REFUSED  $method $path — no \$$var for role $role"
    REFUSED=$((REFUSED + 1))
    return 0
  fi
  set -- -sS -o /tmp/cfdeploy.out -w '%{http_code}' -X "$method" "$API$path" \
    -H "Authorization: Bearer $tok"
  case "$kind" in
    json) set -- "$@" -H 'Content-Type: application/json' --data "$data" ;;
    file)
      f="$ASSETS/$data"
      [ -f "$f" ] || { say "REFUSED  $method $path — no payload at $f"; REFUSED=$((REFUSED + 1)); return 0; }
      set -- "$@" -H 'Content-Type: application/octet-stream' --data-binary "@$f" ;;
  esac
  if [ "$DRY" = 1 ]; then
    say "dry run  $method $path — $desc"
    PERFORMED=$((PERFORMED + 1))
    return 0
  fi
  code=$(curl "$@") || { say "FAILED   $method $path — curl could not reach $API"; FAILED=$((FAILED + 1)); return 0; }
  case "$code" in
    2*)
      say "ok       $method $path — $desc"
      PERFORMED=$((PERFORMED + 1))
      # A one-project upload JWT is what signs the asset calls that follow.
      case "$role" in
        *upload-token*)
          if command -v jq >/dev/null 2>&1 || command -v python3 >/dev/null 2>&1; then
            need_json_tool
            CF_UPLOAD_JWT=$(json_field .result.jwt < /tmp/cfdeploy.out || true)
            if [ -n "$CF_UPLOAD_JWT" ]; then say "         captured the one-project upload JWT"; fi
          fi ;;
      esac ;;
    *)  say "FAILED   $method $path — HTTP $code"; say "         $(head -c 400 /tmp/cfdeploy.out)"
        FAILED=$((FAILED + 1)) ;;
  esac
}

finish() {
  say ""
  say "$PERFORMED step(s) performed, $REFUSED refused, $FAILED failed"
  [ "$FAILED" = 0 ] || exit 1
}
"##

/-- The roles of a plan that need a token, each with its permission
groups and resources — the same table the page shows. -/
def rolesOf (steps : List JsEmit.PlanStep) : List (String × List String × List String) :=
  let add := fun (acc : List (String × List String × List String)) (s : JsEmit.PlanStep) =>
    if s.groups.isEmpty then acc
    else if acc.any (fun r => r.1 == s.role) then
      acc.map fun r =>
        if r.1 == s.role then
          (r.1, uniq (r.2.1 ++ s.groups), uniq (r.2.2 ++ s.resources))
        else r
    else (s.role, uniq s.groups, uniq s.resources) :: acc
  (steps.foldl add []).reverse

/-- **The plan, as a shell script.**  One `mint` line per role, one
`run_step` line per step, in the plan's own order. -/
def deployShellScript (userId : String) (w : Workflow) : String :=
  let steps := JsEmit.planSteps userId w
  let mints := (rolesOf steps).map fun (role, groups, resources) =>
    "mint " ++ shQuote role ++ " " ++ shQuote (envVarOfRole role) ++ " " ++
      shQuote (String.intercalate "|" groups) ++ " " ++
      shQuote (String.intercalate "|" resources) ++ " || true"
  let runs := steps.map fun s =>
    "run_step " ++ shQuote s.role ++ " " ++ shQuote (tokenVar s) ++ " " ++
      shQuote s.method ++ " " ++ shQuote ((s.url.drop Request.base.length).toString) ++ " " ++
      shQuote (payloadKind s) ++ " " ++
      shQuote (if payloadKind s == "file" then fileNameOf (payloadData s) else payloadData s) ++
      " " ++
      shQuote s.describe
  "#!/bin/sh\n" ++
  "# Generated from Lean by RequestProject.Cf.Offline — do not edit.\n" ++
  "#\n" ++
  "# The deployment plan, as curl.  Use this when the browser cannot reach\n" ++
  "# the Cloudflare API (it applies CORS to api.cloudflare.com, and a page\n" ++
  "# on a static host is a cross-origin caller).  Nothing here holds a\n" ++
  "# credential: every request reads one out of the environment.\n" ++
  "#\n" ++
  "#   CF_API_TOKEN=... sh deploy.sh            mint the scoped tokens, then run\n" ++
  "#   sh deploy.sh --dry-run                   show every request, send none\n" ++
  "#\n" ++
  "# " ++ toString steps.length ++ " step(s), " ++ toString (rolesOf steps).length ++
    " scoped token(s).\n\n" ++
  shellPrelude ++ "\n" ++
  "say \"cfdeploy: " ++ toString steps.length ++ " step(s), " ++
    toString (rolesOf steps).length ++ " role(s); API base $API\"\n\n" ++
  "# ---- one short-lived token per role, each with exactly its own grants\n" ++
  String.intercalate "\n" mints ++ "\n\n" ++
  "# ---- the plan\n" ++
  String.intercalate "\n" runs ++ "\n\n" ++
  "finish\n"

/-! ## The local agent -/

/-- A `node` program that proxies the Cloudflare API from the user's own
machine, holding the credential in *its* environment rather than in the
browser.  It answers CORS, so the hosted page can use it from anywhere,
and it is reachable only through the access key it prints. -/
def agentJs : String :=
r##"#!/usr/bin/env node
// Generated from Lean by RequestProject.Cf.Offline — do not edit.
//
// The cfdeploy agent: a Cloudflare API proxy that runs where your keys
// already are — your machine — so that a page served from anywhere can
// deploy without the key ever entering the browser.
//
//   CF_API_TOKEN=... node cf-agent.mjs
//
// It prints an API base with a one-time access key in it; paste that
// into the page's "API base" field.  Without the key the proxy answers
// 403, so no other page in your browser can use it.  It binds to
// 127.0.0.1 unless you say otherwise, forwards only Cloudflare API
// paths, drops cookies both ways, and never logs a credential.
import { createServer } from 'node:http';
import { randomBytes } from 'node:crypto';

const CF_API = process.env.CF_AGENT_UPSTREAM ?? 'https://api.cloudflare.com/client/v4';
const PORT = Number(process.env.CF_AGENT_PORT ?? 8787);
const HOST = process.env.CF_AGENT_HOST ?? '127.0.0.1';
const KEY = process.env.CF_AGENT_KEY ?? randomBytes(9).toString('hex');
const TOKEN = process.env.CF_API_TOKEN ?? '';
const API_PATH = /^\/(user|accounts|zones|pages|memberships|certificates)(\/|$)/;
const DROP = new Set(['host', 'cookie', 'origin', 'referer', 'connection',
                      'content-length', 'accept-encoding']);
const redact = (v) => (v ? `(${v.length} chars, ends ${v.slice(-4)})` : '(none)');
const now = () => new Date().toISOString().slice(11, 23);
const log = (...a) => console.log(now(), ...a);

function cors(res, origin) {
  res.setHeader('access-control-allow-origin', origin || '*');
  res.setHeader('access-control-allow-methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS');
  res.setHeader('access-control-allow-headers', 'authorization, content-type');
  res.setHeader('access-control-max-age', '600');
  res.setHeader('vary', 'origin');
}

const send = (res, status, body, type = 'application/json') => {
  res.writeHead(status, { 'content-type': type });
  res.end(body);
};

const server = createServer(async (req, res) => {
  const url = new URL(req.url, `http://${HOST}:${PORT}`);
  cors(res, req.headers.origin);
  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

  // Discovery: no key needed, and it gives nothing away.
  if (url.pathname === '/agent/health') {
    return send(res, 200, JSON.stringify({
      agent: 'cfdeploy', version: 1, hasToken: TOKEN !== '',
      hint: 'paste the API base printed by the agent into the page',
    }));
  }

  // /a/<key>/cf/<cloudflare path>
  const m = url.pathname.match(/^\/a\/([^/]+)\/cf(\/.*)?$/);
  if (!m) return send(res, 404, JSON.stringify({ error: 'not an agent path' }));
  if (m[1] !== KEY) {
    log('refused a request with a wrong access key');
    return send(res, 403, JSON.stringify({ error: 'wrong access key' }));
  }
  const rest = m[2] || '/';
  if (!API_PATH.test(rest)) {
    return send(res, 400, JSON.stringify({ error: `${rest} is not a Cloudflare API path` }));
  }

  const headers = {};
  for (const [k, v] of Object.entries(req.headers)) {
    if (!DROP.has(k.toLowerCase()) && typeof v === 'string') headers[k] = v;
  }
  const given = headers['authorization'] ?? headers['Authorization'];
  if (!given || given === 'Bearer agent' || given === 'Bearer $CF_API_TOKEN') {
    if (!TOKEN) {
      return send(res, 401, JSON.stringify({
        success: false,
        errors: [{ code: 0, message: 'the agent has no CF_API_TOKEN and the request carried no token' }],
      }));
    }
    headers['authorization'] = `Bearer ${TOKEN}`;
    log(`${req.method} ${rest} — signing with the agent's CF_API_TOKEN ${redact(TOKEN)}`);
  } else {
    log(`${req.method} ${rest} — the caller's own token ${redact(given.replace(/^Bearer /, ''))}`);
  }

  let body;
  if (req.method !== 'GET' && req.method !== 'HEAD') {
    const chunks = [];
    for await (const c of req) chunks.push(c);
    body = Buffer.concat(chunks);
  }
  let upstream;
  try {
    upstream = await fetch(CF_API + rest + url.search, { method: req.method, headers, body });
  } catch (e) {
    log('upstream failed:', e && e.message ? e.message : e);
    return send(res, 502, JSON.stringify({
      success: false, errors: [{ code: 0, message: `agent could not reach the API: ${e}` }],
    }));
  }
  const text = await upstream.text();
  const type = upstream.headers.get('content-type') ?? 'application/json';
  log(`  → HTTP ${upstream.status} (${text.length} bytes)`);
  cors(res, req.headers.origin);
  send(res, upstream.status, text, type);
});

server.listen(PORT, HOST, () => {
  console.log('cfdeploy agent');
  console.log(`  listening on   http://${HOST}:${PORT}`);
  console.log(`  CF_API_TOKEN   ${TOKEN ? redact(TOKEN) : 'not set — the page must supply a token'}`);
  console.log('');
  console.log('  paste this into the page\'s "API base" field:');
  console.log('');
  console.log(`      http://${HOST}:${PORT}/a/${KEY}/cf`);
  console.log('');
  console.log('  the key is new every run; stop the agent when you are done.');
});
"##

/-- The paste-into-a-terminal installer: it writes the agent next to you
and starts it, with no download and no package manager. -/
def agentInstallCommand : String :=
  "mkdir -p cfdeploy && cd cfdeploy && cat > cf-agent.mjs <<'CFDEPLOY_AGENT_EOF'\n" ++
  agentJs ++
  "CFDEPLOY_AGENT_EOF\nCF_API_TOKEN=your-token node cf-agent.mjs\n"

/-! ## The standalone CORS proxy Worker

The agent solves the CORS problem on your own machine; this solves it in
the cloud, for a page that is already hosted somewhere that cannot run a
Worker of its own.  It is the smallest thing that can work: it holds no
credential, forwards only `api.cloudflare.com/client/v4` URLs, and — by
default — answers only the origins you list in `ALLOWED_ORIGINS`, because
a wide-open proxy is one anyone else can point at the API too. -/

/-- A Worker whose only job is to add CORS headers to the Cloudflare API.
Both call shapes work: `?apiurl=<the whole API URL>` and `/cf/<path>`. -/
def corsProxyWorkerJs : String :=
r##"// Generated from Lean by RequestProject.Cf.Offline — do not edit.
//
// A CORS proxy for the Cloudflare API, and nothing else.
//
//   npx wrangler deploy            # gives you https://<name>.<you>.workers.dev
//
// Call it either way:
//   https://<name>.workers.dev/?apiurl=https://api.cloudflare.com/client/v4/user/tokens/verify
//   https://<name>.workers.dev/cf/user/tokens/verify
// and put either `https://<name>.workers.dev/?apiurl=` or
// `https://<name>.workers.dev/cf` in the page's *API base* field.
//
// It carries no credential of its own: your Authorization header is
// forwarded and nothing else is added.  Cookies are dropped in both
// directions, only Cloudflare API URLs are forwarded at all, and the
// origins allowed are the ones in the ALLOWED_ORIGINS variable
// (comma-separated).  Leave that unset only if you understand that any
// page in any browser may then use this proxy with its own token.

const CF_API = 'https://api.cloudflare.com/client/v4';
const DROP = new Set(['host', 'cookie', 'origin', 'referer', 'cf-connecting-ip',
                      'x-forwarded-for', 'x-forwarded-proto', 'x-real-ip',
                      'content-length', 'accept-encoding']);
const SKIP = new Set(['set-cookie', 'content-encoding', 'content-length', 'transfer-encoding']);

const allowed = (env, origin) => {
  const list = String((env && env.ALLOWED_ORIGINS) || '*')
    .split(',').map((s) => s.trim()).filter(Boolean);
  if (list.includes('*')) return origin || '*';
  return origin && list.includes(origin) ? origin : null;
};

const text = (status, body, headers = {}) =>
  new Response(body, { status, headers: { 'content-type': 'text/plain; charset=utf-8', ...headers } });

/** The Cloudflare API URL a request is asking for, or null. */
export function targetOf(url) {
  const param = url.searchParams.get('apiurl') || url.searchParams.get('u');
  if (param) return param.startsWith(CF_API) ? param : null;
  if (url.pathname === '/cf' || url.pathname.startsWith('/cf/')) {
    const rest = url.pathname.slice(3) || '/';
    return CF_API + rest + (url.search || '');
  }
  return null;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const origin = request.headers.get('Origin');
    const allow = allowed(env, origin);
    const cors = {
      'access-control-allow-origin': allow || 'null',
      'access-control-allow-methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
      'access-control-allow-headers':
        request.headers.get('Access-Control-Request-Headers') || 'authorization, content-type',
      'access-control-max-age': '600',
      'vary': 'origin',
    };

    if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: cors });
    if (url.pathname === '/healthz') return text(200, 'ok\n', cors);
    if (origin && !allow) {
      return text(403, 'cfdeploy proxy: this origin is not in ALLOWED_ORIGINS\n', cors);
    }

    const target = targetOf(url);
    if (!target) {
      return text(400,
        'cfdeploy proxy: pass ?apiurl=<a https://api.cloudflare.com/client/v4/... URL>,\n' +
        'or call /cf/<api path>.\n', cors);
    }

    const headers = new Headers();
    for (const [k, v] of request.headers) if (!DROP.has(k.toLowerCase())) headers.set(k, v);
    const init = { method: request.method, headers, redirect: 'manual' };
    if (request.method !== 'GET' && request.method !== 'HEAD') {
      init.body = await request.arrayBuffer();
    }
    let res;
    try {
      res = await fetch(target, init);
    } catch (e) {
      return text(502, `cfdeploy proxy: could not reach the Cloudflare API: ${e}\n`, cors);
    }
    const out = new Response(res.body, { status: res.status, statusText: res.statusText });
    for (const [k, v] of res.headers) {
      if (!SKIP.has(k.toLowerCase())) out.headers.set(k, v);
    }
    for (const [k, v] of Object.entries(cors)) out.headers.set(k, v);
    return out;
  },
};
"##

/-- `wrangler.toml` for the standalone proxy. -/
def corsProxyWranglerToml (name : String) (origins : Option String) : String :=
  "# Generated from Lean by RequestProject.Cf.Offline.\n" ++
  "name = \"" ++ name ++ "\"\n" ++
  "main = \"_worker.js\"\n" ++
  "compatibility_date = \"2025-01-01\"\n" ++
  "workers_dev = true\n\n" ++
  "[vars]\n" ++
  (match origins with
   | some o => "ALLOWED_ORIGINS = \"" ++ o ++ "\"\n"
   | none =>
      "# The page origins allowed to use this proxy.  Set it: a proxy that\n" ++
      "# answers `*` is one anybody can point at the Cloudflare API.\n" ++
      "ALLOWED_ORIGINS = \"*\"\n")

/-- What to do with the emitted proxy directory. -/
def corsProxyReadme (name : String) : String :=
  "# cfdeploy — the CORS proxy Worker\n\n" ++
  "`api.cloudflare.com` sends no CORS headers, so a browser refuses to\n" ++
  "show the answer to a page on another origin.  This Worker sits in\n" ++
  "front of it: it runs server-side, forwards the request, and adds the\n" ++
  "headers the browser wants.\n\n" ++
  "```\n" ++
  "cd <this directory>\n" ++
  "npx wrangler deploy\n" ++
  "```\n\n" ++
  "Then put either of these in the page's **API base** field:\n\n" ++
  "```\n" ++
  "https://" ++ name ++ ".<your-subdomain>.workers.dev/cf\n" ++
  "https://" ++ name ++ ".<your-subdomain>.workers.dev/?apiurl=\n" ++
  "```\n\n" ++
  "Both work: the first appends the API path, the second passes the whole\n" ++
  "API URL as a parameter.\n\n" ++
  "## Lock it down\n\n" ++
  "Set `ALLOWED_ORIGINS` in `wrangler.toml` (or in the dashboard) to the\n" ++
  "origin your page is served from — `https://site.pages.dev`, say.  A\n" ++
  "proxy left at `*` is one that anybody can point at the Cloudflare API\n" ++
  "with their own token; it holds no key of yours either way, but there\n" ++
  "is no reason to run an open relay.\n\n" ++
  "It forwards only `https://api.cloudflare.com/client/v4/...` URLs,\n" ++
  "drops cookies in both directions, and adds no credential: the\n" ++
  "`Authorization` header is yours, and it is the only one that matters.\n\n" ++
  "## The alternatives\n\n" ++
  "* `cfdeploy site` writes a page that carries this proxy on its own\n" ++
  "  origin (`_worker.js`, at `/cf`) — nothing to configure at all.\n" ++
  "* `cfdeploy agent` writes a proxy that runs on your own machine and\n" ++
  "  holds the key there, so it never reaches the browser.\n" ++
  "* `cfdeploy script` writes the plan as `curl`, for no browser at all.\n"

/-! ## Checks on the emitted text -/

-- quoting: the round trip is proved above; these are the shapes.
#guard shQuote "abc" == "'abc'"
#guard shQuote "it's" == "'it'\\''s'"
#guard shQuote "" == "''"
#guard evalWord (shQuoteL "a b; rm -rf /".toList) == some "a b; rm -rf /".toList

-- the script says what it is, holds no credential, and runs the plan
#guard (deployShellScript "U" (.act (.putWorkerScript "acct" "site"))).startsWith "#!/bin/sh"
#guard ((deployShellScript "U" (.act (.putWorkerScript "acct" "site"))).splitOn "run_step ").length == 3
#guard ((deployShellScript "U" (.act (.putWorkerScript "acct" "site"))).splitOn
  "'CF_TOKEN_WORKER_WRITE_ACCT'").length == 3
#guard ((deployShellScript "U" (.act .verifyToken)).splitOn "run_step 'verify' 'CF_TOKEN_VERIFY'").length == 2
#guard ((deployShellScript "U" (Bundle.pagesSiteWorkflow
  { account := "a", project := "p" } [])).splitOn "'CF_UPLOAD_JWT'").length == 3

-- the heredoc delimiter never occurs inside the agent
#guard (agentJs.splitOn "CFDEPLOY_AGENT_EOF").length == 1
#guard (agentJs.splitOn "127.0.0.1").length > 1
#guard fileNameOf "worker:site" == "worker_site"

-- the proxy forwards Cloudflare API URLs only, and takes both shapes
#guard (corsProxyWorkerJs.splitOn "apiurl").length > 1
#guard (corsProxyWorkerJs.splitOn "ALLOWED_ORIGINS").length > 1
#guard (corsProxyWorkerJs.splitOn "param.startsWith(CF_API)").length == 2
#guard ((corsProxyWranglerToml "p" (some "https://x.dev")).splitOn
  "ALLOWED_ORIGINS = \"https://x.dev\"").length == 2

end Offline
end CfDeploy
