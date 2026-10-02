# Work Summary — `fix/vaciu-pass-safe-proof`

27 commits ahead of `main`, 0 behind. Branch tip `66080d06a`.
Verified locally: `cargo check --all-targets` clean (36 warnings),
`cargo check --bin arist-kant` clean (17 warnings), `cargo test --bins`
→ 5 + 38 passed.

## What this branch actually contains

### 1. `arist-kant` binary (commit `0285a4eab`)

`src/main.rs` was restored and a second binary was added at
`src/bin/arist-kant/main.rs`. It pulls in three modules via `#[path]`:

- `src/kant_relay/` — room and pass management for the Kant pastebin relay
- `src/search.rs` — tantivy project index (shared with the main binary)
- `src/sops_integration/` — Cloudflare credential loading

Commands: `search`, `search-index`, `search-shmem`, `relay`, `sops-setup`, `health`.

`src/kant_relay/service.rs` implements `KantRelay` with in-memory rooms,
limited-use passes, and atomic consumption under a `tokio::sync::RwLock`.
`start()` is a placeholder — there is no HTTP server yet.

### 2. Search fixes (`7b24c6595`, `57c919803`)

- removed a duplicate `export_to_shmem` definition
- fixed an `unwrap_or_else(|_| …)` closure that should have been `||`
- fixed `SearchResults` path resolution and the `index_projects` `.to_path_buf()` call
- added the missing `STORED` flag to the indexed `status` field schema
- dereferenced boolean flags in `src/main.rs` match arms
- test: create the index directory before indexing

### 3. GUI2Proof capture service

- `gui2lean4/capture-proof.mjs`, `a11y-extractor.ts`, `render-a11y.py`,
  `hesper-gif.cjs` — Playwright-based accessibility capture and GIF export
- `gui2lean4/server.mjs` + `cli.ts` — control surface on port 9890
- `systemd/gui2proof.service`, `systemd/aristotle-manager.service`
- `nginx/gui2proof.conf`, `nginx/aristo.conf` — vhost fragments for
  `solana.solfunmeme.com`

### 4. sops-backed Cloudflare credential flow

`scripts/load-sops-cloudflare-env.mjs` reads the Pages token from the
`/etc/tracker-vault` sops vault and materialises it to a `0600` runtime env
file. `scripts/bootstrap-cloudflare-pages-token.mjs` mints a Pages-Write-only
token from a one-time bootstrap token and writes it `0600` without printing it.
`scripts/import-cloudflare-home-to-vault.mjs` ingests existing home-directory
credentials into the vault.

### 5. Vaciu room tooling

`scripts/make-invite-vaciu.mjs` mints a limited child pass from an operator-held
invite and prints only the derived URL. `scripts/simulate-vaciu-room.mjs` drives
the twin chat UI with Playwright. `scripts/guiproof-invite-test.mjs` is the
invite-flow test driver.

**Known limitation:** `scripts/simulate-vaciu-room.mjs` intercepts the page's
`/room/**` POST with `page.route` and fulfills it locally, then issues the real
POST from Node against a hardcoded relay host. The resulting screenshot is a
*simulation*, not evidence that the browser performed the post. Artifacts under
`data/gui2lean4/proofs/run-vaciu-room-simulation/` should be cited as
simulated only.

### 6. Documentation

- `README.md` — new deps and split-scripts notes
- `DEPLOYMENT.md`, `KANT_PASTEBIN_CLOUDFLARE_TWIN_SPEC.md`,
  `LEAN_WORKER_DEPLOY_SPEC.md` — deployment and threat-model notes
- `goal-base.md` — 18 system goals

## Not in git

`aristotle-wasm/` and `www/` are untracked directories. The WASM build, the
`getrandom`/`js` feature fix, and the generated bindings referenced in earlier
revisions of this file exist only in the working tree and have never been
committed. There is no `src/kant_profile.rs` in this branch or any other.

## Known issues

- `src/kant_relay/service.rs` compares pass secrets with `==`, which is not
  constant-time. These are bearer credentials.
- `scripts/make-invite-vaciu.mjs` `import()`s modules fetched at runtime from
  `kant-zk-pastebin.pages.dev`.
- `src/search.rs` has a vacuous `assert!(results.total >= 0)` on a `usize`
  (compiler warns `unused_comparisons`); the fixture supports `>= 1`.
- `systemd/*.service`, `nginx/aristo.conf`, and `src/main.rs` hardcode
  `/home/mdupont` and `/mnt/data1/time-2026/05-may/07/arist`.
- `gui2lean4/README.md` contains a real Cloudflare account ID.