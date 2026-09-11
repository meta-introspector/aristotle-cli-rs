/-
# The self-contained site: one page, and the Worker that serves it

Everything in `RequestProject.Cf.WebUi` and `RequestProject.Cf.JsEmit` is
emitted *next to a plan*: a directory that `cfdeploy emit` wrote for one
bundle, served together.  This module emits the other shape — the tool
itself, as a site you install once:

* `singlePageHtml` — one HTML file with no external reference of any
  kind.  The structured log, the token minter, the deployment client, a
  `.tgz` reader, the plan builder and the WebAssembly kernel are all
  inlined into it, so the page can read a bundle you drop on it, compute
  the plan and its per-role tokens, mint them and run them, with nothing
  else installed anywhere.  Upload the one file and the tool is up.
* `workerFileJs` — the same page embedded in a Cloudflare Worker that
  serves it and, at `/cf`, proxies `api.cloudflare.com` on its own origin.
  That proxy is what makes a browser deployment possible at all: the
  Cloudflare API does not answer cross-origin browser requests, and a
  same-origin path is not a cross-origin request.  The proxy carries no
  credential of its own, forwards only Cloudflare API paths, drops
  cookies both ways, and answers no origin but its own.
* `coreModuleMjs` — the bundle reader and plan builder as an ordinary ES
  module, so `web/site-test.mjs` can check, against a real archive, that
  the plan the page builds in the browser is byte for byte the plan
  `cfdeploy emit` writes from the Lean workflow.

The pieces the page shares with the emitted directory (`logModuleJs`,
`tokenClientJs`, `deployClientBodyJs`) are *the same strings*, inlined by
`inlineModule`: there is one deployment client in this project, not two.
-/
import RequestProject.Edge.Cf.Site.Worker
