# `aristotle-wasm`

The Aristotle Manager browser module. It is compiled once and served as an
**immutable static artifact** from Cloudflare Pages.

## Immutability contract

This crate contains **no operator-specific or account-specific data**. There
are no account IDs, Pages project names, or operator domains compiled in, so
the same bytes serve every visitor and nothing account-specific is recoverable
from the deployed `.wasm`.

A unit test enforces this — `no_account_data_is_compiled_into_the_artifact`
scans the shipped portion of this source for 32-hex account IDs and
`.pages.dev` hosts and fails the build if either appears. To confirm against
the real artifact:

```bash
cargo build --release --target wasm32-unknown-unknown
grep -c '[0-9a-f]\{32\}' target/wasm32-unknown-unknown/release/aristotle_wasm.wasm
```

The only network endpoint compiled in is `DEFAULT_API_BASE_URL`, the shared
public Aristotle service. It identifies a service, not an operator, and a
session may override it.

## Session configuration

All account and deployment configuration arrives from the client at runtime.

### Via an explicit call

```js
import init, * as aristo from './aristotle_wasm.js';

await init();
aristo.init_panic_hook();

aristo.set_session_config(JSON.stringify({
  account_id: '<32 hex chars>',   // required to be present for a deployment
  default_domain: 'my-app.pages.dev',
  api_base_url: 'https://aristotle.harmonic.fun/api/v3',  // optional
}));
```

`account_id` is validated as 32 hex characters and lowercased. Anything else is
rejected with an error rather than silently accepted.

### Via the session cookie, on reload

`set_session_config` persists the configuration to a cookie so a page reload
does not require the user to re-enter it. To restore on load:

```js
if (!aristo.load_session_from_cookie()) {
  // First visit, or the cookie expired: show the account setup form.
}
```

The cookie:

| Property | Value |
| --- | --- |
| Name | `aristo_session` |
| Value | base64url-encoded JSON of the session |
| Attributes | `Path=/`, `Max-Age=2592000` (30 days), `SameSite=Strict` |
| `Secure` | added when the page is served over HTTPS |

The JSON is base64url-encoded because RFC 6265 cookie values may not contain
whitespace, `"`, `,`, `;` or `\`. A malformed, undecodable, or invalid cookie
is ignored and reported through the console rather than thrown, so a stale
cookie cannot wedge the app.

## What never goes in the cookie

**The API key.** `set_api_key` stores it in wasm memory only; it is never
serialised to the cookie and never leaves the browser except in the `x-api-key`
request header. A cookie is readable by any script on the origin, so putting a
credential there would turn any XSS into full credential theft.

The Cloudflare account ID *is* persisted, because it is an identifier rather
than a credential and on its own authorises nothing — a token is still required
to deploy.

`clear_session` expires the cookie and clears both the session and the API key,
so signing out leaves nothing behind.

## Reading configuration

```js
aristo.session_is_configured();        // has an account been supplied?
aristo.get_cloudflare_account_id();    // '' when unset — never a default
aristo.get_cloudflare_default_domain();// '' when unset — never a default
aristo.get_session_config();           // JSON, effective values
```

`get_cloudflare_account_id()` and `get_cloudflare_default_domain()` return an
empty string rather than a compiled-in fallback, so a caller can always tell
"not configured" from "configured".

`deploy_project` refuses to run until a session is configured. The
`generate_deploy_config` and `get_deploy_instructions` helpers do not throw, so
they stay usable for previewing a plan; they report `"configured": false` and
omit the `--account-id` flag instead.

## Building

```bash
rustup target add wasm32-unknown-unknown
cargo build --release --target wasm32-unknown-unknown
wasm-bindgen --target web --out-dir www \
  target/wasm32-unknown-unknown/release/aristotle_wasm.wasm
```

Tests are pure logic — base64url, cookie round-tripping, session validation —
and run on the host without a wasm runtime:

```bash
cargo test
```