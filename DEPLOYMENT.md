# Aristo Deployment

This documents the working local and Cloudflare deployment without storing
API keys, Cloudflare tokens, account identifiers, or private key paths.

## Local systemd service

The service is installed as `aristotle-manager.service` and runs as the
`mdupont` user:

```text
aristotle-manager serve --port 9876 --forward
```

The unit is defined in `systemd/aristotle-manager.service`. It reads the
Aristotle API key from the normal per-user configuration, so credentials are
not placed in the unit or repository.

Useful checks:

```bash
sudo systemctl status aristotle-manager.service
sudo journalctl -u aristotle-manager.service -f
curl http://127.0.0.1:9876/health
```

The local API implements the `/api/v3/project` routes and `/health`.

## Nginx

`nginx/aristo.conf` is installed as `/etc/nginx/services.d/aristo.conf` and is
included by the existing TLS virtual host:

- `/aristo/` serves the WASM UI from this repository's `www/` directory.
- `/aristo/health` proxies to the systemd service.
- `/aristo/api/*` proxies to the local service after removing the `/aristo`
  prefix.

After changing the snippet:

```bash
sudo nginx -t
sudo systemctl reload nginx
curl -k https://localhost/aristo/health -H 'Host: solana.solfunmeme.com'
```

## WASM build

Build and regenerate the browser bindings with the installed Rust and
`wasm-bindgen` toolchains:

```bash
cargo build --manifest-path aristotle-wasm/Cargo.toml \
  --target wasm32-unknown-unknown --release
wasm-bindgen \
  aristotle-wasm/target/wasm32-unknown-unknown/release/aristotle_wasm.wasm \
  --out-dir www --target web
```

The generated files in `www/` are deployment artifacts and are ignored by the
repository's `www/.gitignore`; rebuild them rather than committing credentials
or machine-specific output.

## Cloudflare Worker

`wrangler.worker.toml` deploys `src/alias_web_worker.js` as
`aristotle-alias-editor`:

```bash
export CLOUDFLARE_ACCOUNT_ID="<account-id>"
export CLOUDFLARE_API_TOKEN="<token>"
wrangler --config wrangler.worker.toml deploy
```

The deployed worker currently has a `workers.dev` URL. Custom routes/domains
are intentionally not committed here.

## Cloudflare Pages

Create the Pages project once, then deploy the generated `www/` directory:

```bash
wrangler pages project create aristotle-manager --production-branch main
wrangler pages deploy www --project-name aristotle-manager \
  --branch main --commit-dirty=true
```

The current production site is available at the default
`aristotle-manager.pages.dev` address. Add a custom domain through Cloudflare
only after DNS and certificate ownership are confirmed.

## Verification checklist

1. Confirm `systemctl is-active aristotle-manager.service`.
2. Check the local health endpoint.
3. Check the nginx health endpoint and one WASM asset.
4. Check the Worker HTML response.
5. Check the Pages HTML and WASM responses.
6. For future browser proof sessions, use the hosted Pages UI through the
   nginx/Cloudflare path and record the Playwright/VNC session separately from
   this deployment configuration.

## Redaction policy

Do not commit values from `~/.cloudflare`, `~/.cloudflare-account.id`, API-key
files, browser storage, session recordings containing secrets, or generated
deployment logs that contain authorization headers.
