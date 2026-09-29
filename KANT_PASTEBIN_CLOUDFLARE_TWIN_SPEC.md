# Kant Pastebin Cloudflare Twin

**Status:** proposed
**Owner:** local Kant Pastebin operator
**Scope:** deploy a public static chat twin while keeping Cloudflare credentials
and room authority on the local server.

## 1. Goals

- Let the local operator deploy/update a Cloudflare Pages twin.
- Let the operator mint one-time or limited-use room invites.
- Let invitees chat through the relay without accounts or API keys.
- Keep Cloudflare credentials, SOPS plaintext, and room-management authority
  off the public page.
- Make deployment and invite creation replayable as GUI2Proof evidence.

## 2. Non-goals

- Do not expose a public Cloudflare deployment API.
- Do not put Cloudflare tokens in HTML, JavaScript, invite URLs, screenshots,
  traces, videos, or relay messages.
- Do not treat a room invite as an unlimited operator credential.
- Do not deploy private pastebin source or private room data to Pages.

## 3. Trust model

### Local operator server

- Runs the SOPS/age vault and the deployment command.
- Decrypts `cloudflare-pages-token` only into a mode `0600` runtime file.
- Mints passes from an operator-held room invite/secret.
- May deploy only the fixed Pages project configured for the Kant twin.

### Cloudflare Pages twin

- Serves static assets only.
- Contains no Cloudflare token and no room secret.
- Accepts a guest-provided invite fragment locally in the browser.
- Connects directly to the configured relay.

### Relay

- Authorizes posts using the `x-kant-pass` header.
- Enforces the pass limit server-side.
- Stores/archives room messages according to relay policy.
- Must return valid CORS headers for browser `GET`, `POST`, and `OPTIONS`.

## 4. User flows

### Deploy twin

1. Operator starts the local service that loads the SOPS credential.
2. Operator runs the deploy wrapper locally.
3. Wrapper downloads/builds only the public static site.
4. Wrapper creates or updates the fixed Pages project.
5. Wrapper prints only project name, deployment URL, and byte count.
6. Operator verifies the public page and relay health.

Recommended command:

```bash
/mnt/data1/time-2026/05-may/07/arist/scripts/deploy-cloudflare.sh deploy
```

### Mint invite

1. Operator supplies an existing room invite/pass through stdin.
2. Local tool derives a fresh limited pass from the room secret.
3. Tool sets the relay to the CORS-safe Cloudflare relay twin by default.
4. Tool prints exactly one fresh share URL.
5. Operator sends the URL privately to the guest.

```bash
printf '%s\n' 'CURRENT_INVITE_OR_PASS' \
  | node scripts/make-invite-vaciu.mjs vaciu 1
```

Group passes may use a larger explicit limit, up to the configured maximum:

```bash
printf '%s\n' 'CURRENT_INVITE_OR_PASS' \
  | node scripts/make-invite-vaciu.mjs vaciu 1000
```

The source pass must never be logged, committed, or posted to the room.

### Guest chat

1. Guest opens the Cloudflare Pages URL containing the pass fragment.
2. Browser parses the fragment locally and joins the room.
3. Browser posts a witnessed `kzchat` line to the relay with `x-kant-pass`.
4. Relay decrements the pass counter atomically.
5. A spent pass returns HTTP `429` and the UI displays “pass spent”.

## 5. Deployment interface

The deploy helper must accept only configuration values, never credentials on
the command line:

```text
GUI2PROOF_RUNTIME_ENV=/run/gui2proof/cloudflare.env
GUI2PROOF_PAGES_PROJECT=kant-zk-pastebin-twin
GUI2PROOF_SITE_SOURCE=https://kant-zk-pastebin.pages.dev
```

Required runtime values, loaded from SOPS by systemd:

```text
CLOUDFLARE_ACCOUNT_ID
CLOUDFLARE_API_TOKEN
```

The token should be an account-scoped Pages Write token with an expiry. The
deploy process must use a fixed project allowlist and reject arbitrary source
URLs, local paths, shell fragments, or project names supplied by guests.

## 6. Security requirements

- Public `/api/run` must not trigger a real Cloudflare deployment.
- Real deployment is local CLI-only or requires a separate local operator
  session protected by the tracker-vault bearer mechanism.
- Runtime credential files are mode `0600`, owned by the service user.
- Logs redact `Authorization`, `x-kant-pass`, URL fragments, cookies, and
  `CLOUDFLARE_*` values.
- Proof manifests contain hashes and public URLs only.
- Invite URLs are bearer credentials; never place them in public commits,
  screenshots, or shared logs.
- Pass limits are enforced by the relay, not by page JavaScript.
- The relay must use atomic/idempotent pass consumption to prevent replay races.

## 7. CORS requirements

The browser-facing relay must return exactly one `Access-Control-Allow-Origin`
header and support:

```text
OPTIONS /room/<room>
GET     /room/<room>
POST    /room/<room>
```

Required allowed headers:

```text
content-type, x-kant-pass, x-kant-invite
```

The Cloudflare relay twin is the default browser relay until the local proxy
has been verified to emit non-duplicated CORS headers.

## 8. GUI2Proof acceptance tests

The recorded proof must show:

1. Local operator deploy command succeeds using SOPS-loaded credentials.
2. Public twin loads without exposing credentials.
3. Fresh one-post invite opens the intended room.
4. One post is accepted and appears through the relay.
5. Reusing the same one-post pass returns `429`.
6. A group pass accepts multiple posts until its limit.
7. The proof manifest contains no invite fragment or authorization value.

The default automated test is pass-safe and must not read spool-file invites or
consume a user-provided pass. A real relay test requires an explicitly supplied
fresh test pass.

## 9. Rollback

- Re-deploy the previous static asset bundle to the fixed Pages project.
- Revoke the Pages token in Cloudflare if credentials are suspected exposed.
- Issue new room passes; spent passes cannot be restored.
- Keep the relay room and archive unchanged unless the room secret is revoked.

## 10. Completion criteria

- [ ] Static twin deployment is implemented and allowlisted.
- [ ] SOPS/systemd credential loading is verified.
- [ ] Cloudflare relay twin has valid CORS behavior.
- [ ] Invite minting defaults to the browser-safe relay.
- [ ] Local operator authentication gates real deployment.
- [ ] GUI2Proof records deploy, invite, post, and spent-pass evidence.
- [ ] No secret appears in logs, artifacts, commits, or public URLs beyond the
      intentionally bearer-style invite fragment sent to its recipient.
