---
name: cloudflare-devops
description: Automated bootstrap engine for Cloudflare deployments via wrangler and cloudflared. Use for deploying frontends to Workers/Pages, managing wrangler versions, configuring CI/CD pipelines (GitHub Actions), debugging edge routing, domain management, and zero-trust tunnel setup.
---

# Cloudflare DevOps

> Automated bootstrap engine for Cloudflare deployments, wrangler version management, and CI/CD pipeline orchestration. Use for deploying frontends, managing Workers/Pages, and debugging edge routing.

---

## Tools Installed

| Tool | Version | Role |
|------|---------|------|
| `wrangler` | 4.93.0 | Deploy, version management, secrets, domains |
| `cloudflared` | 2026.5.0 | Zero-trust tunnel ingress |

Both installed globally via `npm install -g`.

---

## Architecture

```
[ GitHub push to master ]
        │
        ▼
[ GitHub Actions: deploy-web.yml ]
├── bun install --frozen-lockfile
├── bun run build (Astro static output → dist/)
├── wrangler versions upload src/entry.js --assets=./dist
└── wrangler versions deploy <latest> --percentage 100
        │
        ▼
[ Cloudflare Edge — testudo.vip ]
```

---

## Projects

### testudo-web (Astro, static)

| Setting | Value |
|---------|-------|
| Type | Workers (assets + entry script) |
| Worker name | `testudo-web` |
| Entry point | `src/entry.js` |
| Assets dir | `./dist` |
| Build command | `bun run build` |
| Deploy workflow | `.github/workflows/deploy-web.yml` |
| Custom domain | `testudo.vip` |

**Manual deploy (if CI is down):**
```bash
cd testudo-web
bun run build
npx wrangler versions upload src/entry.js --assets=./dist
# Get the new version ID from the output or:
LATEST=$(npx wrangler versions list 2>&1 | head -12 | grep "Version ID" | head -1 | awk '{print $3}')
npx wrangler versions deploy "$LATEST" --percentage 100
```

---

## GitHub Actions Secrets Required

Add these in GitHub → Settings → Secrets and variables → Actions:

| Secret | Value |
|--------|-------|
| `CLOUDFLARE_API_TOKEN` | API token with Workers edit permission |
| `CLOUDFLARE_ACCOUNT_ID` | `3d7608549b2fb58c0ce446bc3c5892ed` |

The account ID is already known from `~/.wrangler/cache/wrangler-account.json`.

---

## Deploy Commands (Quick Reference)

```bash
# Check current deployment
npx wrangler versions list | head -20

# See what's at 100% right now
npx wrangler versions list 2>&1 | grep -A5 "current deployment"

# Deploy latest version at 100%
LATEST=$(npx wrangler versions list 2>&1 | head -12 | grep "Version ID" | head -1 | awk '{print $3}')
npx wrangler versions deploy "$LATEST" --percentage 100

# Rollback to a known-good version
npx wrangler versions deploy <version-id> --percentage 100

# Manage domains
npx wrangler domains list
npx wrangler domains create <domain>
```

---

## cloudflared Setup (if needed for local dev ingress)

```bash
# Authenticate
cloudflared tunnel login

# Create tunnel
cloudflared tunnel create testudo-dev

# Configure ingress (~/.cloudflared/config.yaml)
cat > ~/.cloudflared/config.yaml << 'EOF'
tunnel: ${TUNNEL_ID}
credentials-file: /home/m0xu/.cloudflared/${TUNNEL_ID}.json

ingress:
  - hostname: dev.testudo.vip
    service: http://localhost:8080
  - service: http_status:404
EOF

# Run
cloudflared tunnel run testudo-dev
```

Not currently in use — `testudo.vip` is served directly via Workers, not via tunnel.
