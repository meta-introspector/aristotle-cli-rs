/-
# The Worker, the static shape, and the checks on the emitted text

`workerFileJs` is the page inside a Cloudflare Worker that also proxies
the Cloudflare API at `/cf` on its own origin; the static shape is the
same page with nothing beside it that a Pages direct upload would read as
a build step.
-/
import RequestProject.Edge.Cf.Site.Page

namespace CfDeploy
namespace Site

/-! ## The Worker -/

/-- What `/version.json` serves and `cfdeploy version` prints: the build
stamp of the page, the size of the WebAssembly kernel, and the shape of
the configuration this build understands. -/
def versionJson : Json :=
  .obj [("tool", .str "cfdeploy"),
        ("build", .str buildId),
        ("page", .num (singlePageHtml.length : Int)),
        ("kernelBytes", .num (WasmKernel.kernelBytes.size : Int)),
        ("configKeys", .arr (Config.knownKeys.map Json.str)),
        ("profiles", .arr (Config.registered.map fun p => Json.str p.name))]

/-- The Worker body: serve the page, proxy the Cloudflare API at `/cf`. -/
def workerBodyJs : String :=
r##"// Generated from Lean by RequestProject.Cf.Site — do not edit.
//
// Two jobs, and nothing else:
//   * serve the self-contained cfdeploy page (inlined below, so this file
//     is deployable on its own with `wrangler deploy`);
//   * proxy the Cloudflare API at /cf, on this same origin, so that the
//     browser's CORS rules do not apply to a deployment.
//
// The proxy holds no credential of its own.  It forwards the caller's
// Authorization header and nothing else: no cookie in, no cookie out, no
// logging, and only Cloudflare API paths are forwarded at all.  It answers
// cross-origin callers with this origin only, so no other site can use it.

const CF_API = 'https://api.cloudflare.com/client/v4';
const PROXY = '/cf';
const API_PATH = /^\/(user|accounts|zones|pages|memberships|certificates|radar|ips)(\/|$)/;
const DROP = new Set(['host', 'cookie', 'origin', 'referer', 'cf-connecting-ip',
                      'x-forwarded-for', 'x-forwarded-proto', 'x-real-ip']);

const text = (status, body, extra = {}) =>
  new Response(body, { status, headers: { 'content-type': 'text/plain; charset=utf-8', ...extra } });

async function proxy(request, url) {
  const rest = url.pathname.slice(PROXY.length) || '/';
  if (request.method === 'OPTIONS') {
    return new Response(null, {
      status: 204,
      headers: {
        'access-control-allow-origin': url.origin,
        'access-control-allow-methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
        'access-control-allow-headers': 'authorization, content-type',
        'access-control-max-age': '600',
      },
    });
  }
  if (!API_PATH.test(rest)) {
    return text(400, `cfdeploy proxy: ${rest} is not a Cloudflare API path\n`);
  }
  const headers = new Headers();
  for (const [k, v] of request.headers) if (!DROP.has(k.toLowerCase())) headers.set(k, v);
  const init = { method: request.method, headers, redirect: 'manual' };
  if (request.method !== 'GET' && request.method !== 'HEAD') {
    init.body = await request.arrayBuffer();
  }
  let res;
  try {
    res = await fetch(CF_API + rest + url.search, init);
  } catch (e) {
    return text(502, `cfdeploy proxy: could not reach the Cloudflare API: ${e && e.message ? e.message : e}\n`);
  }
  // `fetch` has already decoded the body, so the upstream framing headers
  // would be a lie; the cookies are not ours to pass on either.
  const SKIP = new Set(['set-cookie', 'content-encoding', 'content-length', 'transfer-encoding']);
  const out = new Response(res.body, { status: res.status, statusText: res.statusText });
  for (const [k, v] of res.headers) {
    if (SKIP.has(k.toLowerCase())) continue;
    out.headers.set(k, v);
  }
  out.headers.set('access-control-allow-origin', url.origin);
  out.headers.set('vary', 'origin');
  return out;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname === PROXY || url.pathname.startsWith(PROXY + '/')) {
      return proxy(request, url);
    }
    if (url.pathname === '/healthz') return text(200, 'ok\n');
    if (url.pathname === '/version.json') {
      return new Response(JSON.stringify(VERSION) + '\n', {
        headers: { 'content-type': 'application/json; charset=utf-8', 'cache-control': 'no-store' },
      });
    }
    if (env && env.ASSETS && typeof env.ASSETS.fetch === 'function') {
      const res = await env.ASSETS.fetch(request);
      if (res.status !== 404) return res;
    }
    return new Response(INDEX_HTML, {
      headers: {
        'content-type': 'text/html; charset=utf-8',
        'cache-control': 'no-store',
        'x-content-type-options': 'nosniff',
        'referrer-policy': 'no-referrer',
      },
    });
  },
};
"##

/-- The deployable Worker: the page, embedded, plus the proxy.  Deploy it
on its own (`wrangler deploy`), or drop it into a Pages directory as
`_worker.js`, where it serves the directory's own files first. -/
def workerFileJs : String :=
  "const INDEX_HTML = `" ++ quoteTemplate singlePageHtml ++ "`;\n" ++
  "const VERSION = " ++ Json.render versionJson ++ ";\n\n" ++ workerBodyJs

/-- The bundle reader and plan builder as a plain ES module, for node and
for the conformance test. -/
def coreModuleMjs : String :=
  "// Generated from Lean by RequestProject.Cf.Site — do not edit.\n" ++
  "export const CF_API = 'https://api.cloudflare.com/client/v4';\n" ++
  generatedConstsJs ++ configConstsJs ++ coreJs

/-- `wrangler.toml` for `workerFileJs`. -/
def wranglerToml (name : String) (host : Option String) : String :=
  "# Generated from Lean by RequestProject.Cf.Site.\n" ++
  "name = \"" ++ name ++ "\"\n" ++
  "main = \"_worker.js\"\n" ++
  "compatibility_date = \"2025-01-01\"\n" ++
  "workers_dev = true\n\n" ++
  (match host with
   | some h =>
      "# The hostname this tool is served from.  The zone has to be on the\n" ++
      "# account you deploy with.\n" ++
      "routes = [{ pattern = \"" ++ h ++ "\", custom_domain = true }]\n"
   | none =>
      "# Serve it on your own hostname (the zone has to be on this account):\n" ++
      "# routes = [{ pattern = \"cf.example.net\", custom_domain = true }]\n")

/-! ## The static shape: one page, no Worker, no build

A Pages *direct upload* refuses a directory that looks like a project to
build — a `wrangler.toml`, a `package.json`, a `functions/` directory —
and asks you to run `wrangler deploy` instead.  This is the shape that
carries none of them: an `index.html`, the same page as `404.html` so any
path reaches it, and the two plain-text files Pages reads as data.  There
is no Worker in it, so there is no `/cf` proxy either; the page says so,
and its terminal panel is the way through. -/

/-- Response headers for the static upload.  `_headers` is data that
Pages reads, not a build step. -/
def headersFile : String :=
  "# Generated from Lean by RequestProject.Cf.Site.\n" ++
  "/*\n" ++
  "  X-Content-Type-Options: nosniff\n" ++
  "  Referrer-Policy: no-referrer\n" ++
  "  Permissions-Policy: geolocation=(), camera=(), microphone=(), payment=()\n" ++
  "  Cross-Origin-Opener-Policy: same-origin\n" ++
  -- the page is one inline module, hashes bundles with WebAssembly,
  -- previews them from blob URLs, and talks to whatever API base you
  -- give it; nothing is ever loaded from another origin.
  "  Content-Security-Policy: default-src 'none'; script-src 'unsafe-inline' " ++
    "'wasm-unsafe-eval'; style-src 'unsafe-inline'; img-src 'self' data: blob:; " ++
    "font-src data:; frame-src blob:; connect-src *; form-action 'none'; base-uri 'none'\n"

/-- Every path shows the one page. -/
def redirectsFile : String :=
  "# Generated from Lean by RequestProject.Cf.Site.\n" ++
  "# One page, so every path is that page.\n" ++
  "/*    /index.html   200\n"

/-- The notes that ship with the static directory. -/
def spaReadmeMd (host : Option String) : String :=
  let h := host.getD "your Pages project"
  "# cfdeploy — the single-page app, with no build step\n\n" ++
  "Generated from Lean by `cfdeploy spa`.  Everything here is static:\n\n" ++
  "| file | what it is |\n" ++
  "| --- | --- |\n" ++
  "| `index.html` | the whole tool in one file: the `.tgz` reader, the selection, the preview, the plan builder, the token minter, the deployment client and the WebAssembly kernel, all inlined. No external script, style, font, image or fetch. |\n" ++
  "| `404.html` | the same page, so any path reaches the app |\n" ++
  "| `_headers`, `_redirects` | two lines of configuration Pages reads as data |\n\n" ++
  "There is deliberately **no `wrangler.toml`, no `_worker.js`, no\n" ++
  "`package.json` and no `functions/`** — that is what makes a Pages\n" ++
  "direct upload treat this as a project to build and send you to\n" ++
  "`wrangler deploy`.\n\n" ++
  "## Upload it\n\n" ++
  "Drag this directory into the Cloudflare Pages dashboard (*Create a\n" ++
  "project → Direct Upload*), or, if you have the CLI:\n\n" ++
  "```\n" ++
  "npx wrangler pages deploy .    # optional; the dashboard needs nothing\n" ++
  "```\n\n" ++
  "It works just as well on GitHub Pages, S3, Netlify, or a USB stick:\n" ++
  "`index.html` is the whole program, so `open index.html` runs it too.\n\n" ++
  "## What it can and cannot do from a static host\n\n" ++
  "Reading the bundle, pruning it, previewing it, building the plan and\n" ++
  "the per-role token table all happen in the page and work anywhere.\n" ++
  "The deployment requests are the exception: browsers apply CORS to\n" ++
  "`api.cloudflare.com`, and a page on " ++ h ++ " is a cross-origin\n" ++
  "caller, so those requests are refused before they are sent. That is a\n" ++
  "browser rule, not a missing feature. The page's last panel gives you\n" ++
  "three ways through, in increasing order of setup:\n\n" ++
  "1. **Download `deploy.sh` and `payload.tar`** and run the plan\n" ++
  "   yourself — one `curl` per step, one scoped token per role, nothing\n" ++
  "   in the file but the plan.\n" ++
  "2. **Run the agent** (`cf-agent.mjs`) on the machine your key is\n" ++
  "   already on, and paste the URL it prints into *API base*.\n" ++
  "3. **Deploy the gate** (`cfdeploy gate`) — a Worker that answers CORS\n" ++
  "   and forwards only requests signed by a client you enrolled.\n\n" ++
  "Nothing here phones home, and the API token is never stored.\n"

/-- The install instructions that ship with the directory. -/
def readmeMd (host : Option String) : String :=
  let h := host.getD "cf.example.net"
  "# cfdeploy — install once, deploy bundles from the browser\n\n" ++
  "Generated from Lean by `cfdeploy site`.  Four files, and only the\n" ++
  "first two matter:\n\n" ++
  "| file | what it is |\n" ++
  "| --- | --- |\n" ++
  "| `index.html` | the whole tool in one file: bundle reader, plan builder, token minter, deployment client, WebAssembly kernel. No external reference of any kind. |\n" ++
  "| `_worker.js` | the same page, embedded in a Worker that also proxies the Cloudflare API at `/cf` on this origin. |\n" ++
  "| `cf-core.mjs` | the bundle reader and plan builder as a module, for node and for `web/site-test.mjs`. |\n" ++
  "| `wrangler.toml` | so `wrangler deploy` works with no arguments. |\n\n" ++
  "## Install it (pick one)\n\n" ++
  "**A Worker, with the API proxy — recommended.**  Everything works from\n" ++
  "the browser, because `/cf` is same-origin and the browser's CORS rules\n" ++
  "never come into it:\n\n" ++
  "```\n" ++
  "cd <this directory>\n" ++
  "npx wrangler deploy            # then add " ++ h ++ " as a custom domain\n" ++
  "```\n\n" ++
  "**Cloudflare Pages, direct upload.**  Drag this whole directory into\n" ++
  "the Pages dashboard, or, from the directory *above* this one,\n" ++
  "`npx wrangler pages deploy " ++ "site" ++ "`.  Pages runs `_worker.js` for you, so\n" ++
  "`/cf` works there too.  (Run it from above: the `wrangler.toml` in here\n" ++
  "is the Worker configuration, and `wrangler pages` would read it as its\n" ++
  "own.)\n\n" ++
  "**One file, anywhere.**  Upload `index.html` on its own to any static\n" ++
  "host.  Everything works except the deployment requests themselves: the\n" ++
  "Cloudflare API refuses cross-origin browser calls, so put a proxy in\n" ++
  "the *API base* field, or run the plan the page hands you\n" ++
  "(`Download deploy-plan.json`) from a terminal.\n\n" ++
  "## Use it\n\n" ++
  "1. Drop an Aristotle `.tgz` on the page. It is read *in the page* —\n" ++
  "   gunzipped, untarred, hashed — and never uploaded anywhere.\n" ++
  "2. Fill in the account id, the Worker/Pages name and the KV namespace\n" ++
  "   id. They are remembered in this browser; the API token never is.\n" ++
  "3. Read the plan and the token table: one token per role, each with\n" ++
  "   exactly the permission groups its own steps need.\n" ++
  "4. Tick *dry run* and press **Deploy** to see every request without\n" ++
  "   sending any.\n" ++
  "5. Untick it, paste a token that may create tokens (*API Tokens Write*\n" ++
  "   on your user), and press **Deploy**. The page mints the scoped\n" ++
  "   tokens, uses each one for its own steps only, revokes them again\n" ++
  "   when the run finishes (untick *revoke the minted tokens* to keep\n" ++
  "   them until they expire), and forgets the admin token when you\n" ++
  "   close the tab.\n\n" ++
  "The log records every step, the request (credential redacted), the\n" ++
  "HTTP status, Cloudflare's own error codes and the timing, and it can\n" ++
  "be copied or downloaded as text or JSON.\n\n" ++
  "## The proxy\n\n" ++
  "`/cf/...` is forwarded to `https://api.cloudflare.com/client/v4/...`.\n" ++
  "It holds no credential: it passes your `Authorization` header through\n" ++
  "and nothing else. Cookies are dropped in both directions, only\n" ++
  "Cloudflare API paths are forwarded, and cross-origin callers are\n" ++
  "refused — the only browser that can use it is one on `" ++ h ++ "`\n" ++
  "itself.\n"

/-! ## Checks on the emitted text -/

-- `inlineModule` drops the import lines and the export keywords.
#guard inlineModule "import { a } from './b.mjs';\nexport const x = 1;\nconst y = 2;" ==
  "const x = 1;\nconst y = 2;"

-- but not inside a template literal, where those lines are data.
#guard inlineModule "const S = `\nexport default 1;\nimport x;\n`;\nexport const y = 2;" ==
  "const S = `\nexport default 1;\nimport x;\n`;\nconst y = 2;"

-- base64, on the classic test vectors.
#guard base64 "Man".toUTF8 == "TWFu"
#guard base64 "Ma".toUTF8 == "TWE="
#guard base64 "M".toUTF8 == "TQ=="
#guard base64 "".toUTF8 == ""

-- the page really is self-contained, and really does carry the kernel.
#guard (singlePageHtml.splitOn "<script src=").length == 1
#guard (singlePageHtml.splitOn "<link ").length == 1
#guard (singlePageHtml.splitOn "src=\"http").length == 1
#guard (singlePageHtml.splitOn "href=\"http").length == 1
#guard (singlePageHtml.splitOn ("const KERNEL_WASM_B64 = '" ++ base64 WasmKernel.kernelBytes)).length == 2
-- no `import`/`export` statement survives outside a template literal:
-- the page is one script, not a module graph.
#guard moduleStatements pageScript == 0

-- the deployment client in the page is the one the CLI emits.
#guard (singlePageHtml.splitOn "async function runPlan(tokens").length == 2
#guard (singlePageHtml.splitOn "async function mintTokens(adminToken").length == 2

-- the Worker embeds that same page, and proxies the API.
#guard (workerFileJs.splitOn "const PROXY = '/cf';").length == 2
#guard (workerFileJs.splitOn "const INDEX_HTML = `").length == 2

end Site
end CfDeploy
