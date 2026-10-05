# Deployment Status: Nginx/Systemd Services

## Deployment Date
2026-10-02

## All Accessible URLs (surfaced on `https://solana.solfunmeme.com/aristo/`)

### Primary URL
- **https://solana.solfunmeme.com/aristo/** — Landing page with all slugs

### API Endpoints
| URL | Backend | Status |
|-----|---------|--------|
| `/aristo/health` | aristotle-manager (9876) | ✅ 200 |
| `/aristo/api/` | aristotle-manager (9876) | ⚠️ 404 (no root API route) |
| `/aristo/p2p/status` | GUI2Proof (9890) | ✅ 200 (JSON) |
| `/aristo/gokujo/api/` | Task runner (8080) | ✅ 200 (JSON) |
| `/aristo/gokujo/status` | Task runner (8080) | ✅ 200 (JSON) |
| `/aristo/gokujo/search` | Task runner (8080) | ✅ 200 (JSON) |
| `/aristo/gui2proof/api/status` | GUI2Proof (9890) | ✅ 200 (JSON) |
| `/aristo/verify` | GUI2Proof (9890) | ✅ 200 (JSON) |

### GUI Endpoints
| URL | Backend | Status |
|-----|---------|--------|
| `/aristo/` | Static site (www/) | ✅ 200 (index.html) |
| `/aristo/p2p/` | GUI2Proof (9890) | ✅ 200 (HTML) |
| `/aristo/gokujo/` | Task runner (8080) | ✅ 200 (HTML) |
| `/aristo/gui2proof/` | GUI2Proof (9890) | ✅ 200 (HTML) |
| `/aristo/file-drop/` | GUI2Proof (9890) | ✅ 200 (HTML) |

### Monitoring
| URL | Status |
|-----|--------|
| `/aristo/monitor` | ✅ 200 (nginx stub_status) |

## Nginx Configuration

### File: `/etc/nginx/services.d/aristo.conf`

All services are surfaced under the `/aristo/` path on `https://solana.solfunmeme.com/`:

- `/aristo` → redirect to `/aristo/`
- `/aristo/api/` → proxy to aristotle-manager:9876 (rewrite `aristo` prefix)
- `/aristo/health` → proxy to aristotle-manager:9876/health
- `/aristo/p2p/` → proxy to GUI2Proof:9890 (P2P proving loop)
- `/aristo/p2p/status` → proxy to GUI2Proof:9890/api/status (JSON)
- `/aristo/gokujo/` → proxy to Task runner:8080 (Gokujo task browser)
- `/aristo/gokujo/api/` → proxy to Task runner:8080/api/
- `/aristo/gokujo/status` → proxy to Task runner:8080/api/status
- `/aristo/gokujo/search` → proxy to Task runner:8080/api/search
- `/aristo/gui2proof/` → proxy to GUI2Proof:9890/
- `/aristo/gui2proof/api/status` → proxy to GUI2Proof:9890/api/status
- `/aristo/file-drop/` → proxy to GUI2Proof:9890/ (file upload system)
- `/aristo/verify` → proxy to GUI2Proof:9890/api/status (proof verification)
- `/aristo/monitor` → stub_status
- `/aristo/` → static site from `/mnt/data1/time-2026/05-may/07/arist/www/`

### File: `/etc/nginx/conf.d/gokujo-task-runner.conf`
- Standalone server on port 8080 for the task runner (not used under /aristo/)
- Includes CORS headers
- API endpoints: `/api/`, `/api/status`, `/api/search`
- Nginx status monitoring: `/nginx-status`

## Services Deployed

| Service | Port | Status | Type |
|---------|------|--------|------|
| aristotle-manager.service | 9876 | ✅ Running | Systemd |
| gui2proof.service | 9890 | ✅ Running | Systemd |
| nginx.service | 443/8080 | ✅ Running | Systemd |

## Verification Summary

All services are running and responding correctly. The only 404 is on `/aristo/api/` which is expected because the aristotle-manager service doesn't have a root API endpoint.

## Next Steps

1. Fix `/aristo/api/` to proxy to a valid API route (e.g., `/api/v3/project`)
2. Deploy file-drop system integration
3. Monitor proof capture activity via GUI2Proof
4. Review and close open issues from proof run: `run-20261002T084858-pastebin-tests`