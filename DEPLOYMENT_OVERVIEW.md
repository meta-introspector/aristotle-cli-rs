# AristotVM Deployment — Unified Overview

**Project**: f4e10742-bd72-442a-88b0-b1a915a3f51b (Hodge VM)  
**Date**: 2026-10-22  
**Status**: **Live** (Pages) | **Worker pending** (bundle fix)  

---

## Deployment Layers

The AristotVM project deploys across **5 infrastructure layers**:

### 1. 📦 Nix Flake (Base)
- **Location**: `/home/mdupont/projects/system-manager/`
- **Flake**: `flake.nix` with modules list (tiles, lean4, kant, aristotle, nora, twitterstorm, otc-desk, web, infra, jev-api, nginx, zone42, agentsview)
- **Deploy**: `sudo system-manager switch --flake /etc/system-manager#all-services`
- **Special args**: pastebin-src, nora-src, dasl-tiles-rust, kant-zk-pastebin-src, ipld-car-shmem-src, tracker-following-mitmp

### 2. 🔧 Systemd Services (Application)
| Service | Status | Description |
|---------|--------|-------------|
| `aristotle-manager.service` | ✅ | Polls Aristotle, syncs results |
| `aristotle-secrets.service` | ✅ | Materializes `ARISTOTLE_API_KEY` from SOPS vault |
| `nora.service` | ✅ | Artifact registry (Cargo/npm) on `:4000` |
| `nora-dir.service` | ✅ | Creates `/mnt/data1/nora/{storage,config}` |
| `nora-ci-pipeline.service` | ✅ | Builds, tests, fizzes, perf, covers |
| `trunk-relay.service` | ✅ | Cloudflare Workers relay |
| `ipld-car-shmem.service` | ✅ | IPLD CAR dedup + memory management |
| `aristotle-web.service` | ❌ DISABLED | Per-run UUID directory gone |
| `cid-index-aristotle.service` | ❌ DISABLED | Not currently needed |
| `cid-index-mathlib.service` | ❌ DISABLED | Not currently needed |

### 3. 🌐 Nginx (Web Server & Proxy)
- **Domain**: `solana.solfunmeme.com`
- **SSL**: Let's Encrypt
- **Routes**:
  - `/` → `/var/www/solana.solfunmeme.com/index.html`
  - `/aristo/hodge-vm/` → `/var/www/solana.solfunmeme.com/aristotle-sites/f4e10742-.../`
  - `/nora/` → proxy to `localhost:4000` (Nora registry)
  - `/relay` → proxy to `localhost:8787` (kant-zk relay WebSocket)
  - `/pastebin` → `/var/www/solana.solfunmeme.com/pastebin`
  - `/aristo/` → Aristotle sites

### 4. ☁️ Cloudflare (Edge)
| Layer | Status | URL | Notes |
|-------|--------|-----|-------|
| Pages (static) | ✅ Live | `https://8e7df5ca.hodge-vm.pages.dev/` | Hodge VM static docs |
| Worker (P2P) | ⚠️ Broken | — | `p2p-worker.mjs` needs `workerify()` fix |
| Worker (MLVM) | Pending | — | MiniLean VM edge worker |
| Worker relay | ✅ Live | `kant-relay-v1.purple-fire-b881.workers.dev` | KANT-ZK relay |

### 5. 🔗 IPFS / CAR Shmem (Storage)
- **Module**: `ipld-car-shmem.nix`
- **Binaries**:
  - `shmem-dedup` — IPLD CAR deduplication
  - `tantivy-indexer` — Fast search over CAR metadata
  - `letta-ipld-memory` — Le'tta temporal IPLD memory bridge
- **Storage**: `/var/lib/lean4-cbor-bridge`
- **Lean 4 bridge**: `/home/mdupont/dasl/ipld-car-ipc-shmem-linux/target/release/lean4-cbor-bridge`

---

## Credential Management

All secrets via **SOPS + age** (never hardcoded):

```
Vault:          /etc/tracker-vault/secrets/cloudflare-*.enc.json
Age key:        ~/.config/sops/age/keys.txt
Runtime env:    /run/aristotle-key.env (created by aristotle-secrets.service)
                /run/gui2proof/cloudflare.env (GUI2PROOF runtime)
SOPS init:      /mnt/data1/kant/pastebin/scripts/sops-init.sh
```

| Secret | File | Usage |
|--------|------|-------|
| Cloudflare Pages token | `cloudflare-pages-token.enc.json` | Pages deploy (`cfat_...`) |
| Cloudflare Account ID | `cloudflare-account-0-id.enc.json` | Account scope (32-char hex) |
| Cloudflare Worker token | `cloudflare-account-0-token.enc.json` | Worker deploy |
| Aristotle API key | `credentials.enc.json` | aristotle-manager fetch |

---

## Deploy Commands

### Quick Reference

```bash
# Full system deploy (all services)
sudo system-manager switch --flake /etc/system-manager#all-services

# Individual service management
sudo systemctl start aristotle-manager
sudo systemctl restart nora

# Cloudflare Pages deploy (Hodge VM)
aristotle-manager deploy cloudflare f4e10742-bd72-442a-88b0-b1a915a3f51b --pages

# Cloudflare Worker deploy (after bundle fix)
aristotle-manager deploy cloudflare f4e10742-bd72-442a-88b0-b1a915a3f51b --worker

# List all deployable projects
aristotle-manager list

# Check any project's deploy status
aristotle-manager check <UUID>
```

### Service Status

```bash
# Check all relevant services
systemctl status aristotle-manager nora nora-dir nora-ci-pipeline trunk-relay ipld-car-shmem aristotle-secrets

# Check nginx routes
sudo nginx -t
sudo systemctl status nginx

# Check logs
journalctl -u aristotle-manager --no-pager | tail -50
journalctl -u nora --no-pager | tail -50
journalctl -u trunk-relay --no-pager | tail -50
```

---

## File Inventory

### System Manager
```
/home/mdupont/projects/system-manager/
├── flake.nix                    ← Nix flake with all module definitions
├── all-services.nix             ← Main config (users, tmpfiles, nginx vhost)
├── ipld-car-shmem.nix           ← IPFS/CAR shmem + tantivy + leta modules
├── trunk-relay.nix              ← Cloudflare Workers relay
├── modules/
│   ├── aristotle.nix            ← aristotle-manager, aristotle-secrets services
│   ├── nora.nix                 ← nora registry + CI pipeline
│   ├── nginx.nix                ← nginx web server config
│   ├── lean4.nix                ← Lean 4 toolchain services
│   ├── kant.nix                 ← KANT-ZK pastebin relay
│   └── ...                      ← tiles, web, infra, jev-api, etc.
├── nginx/
│   ├── apps.conf                ← App index locations
│   ├── services.d/              ← Modular location configs
│   │   └── aristo.conf          ← Aristotle routes
│   └── ...
└── scripts/
    ├── deploy-hodge-vm-cloudflare.sh   ← Legacy Hodge VM deploy (pages live)
    └── sops-init.sh                    ← Age key initialization
```

### Hodge VM Project
```
/home/mdupont/projects/arist/f4e10742-bd72-442a-88b0-b1a915a3f51b/
├── hodge-vm/
│   ├── www/index.html           ← Static site (deployed to Pages)
│   ├── tools/make_p2p.js        ← Bundle generator (needs workerify() fix)
│   ├── dist/
│   │   ├── p2p-worker.mjs       ← Worker bundle (broken)
│   │   └── wrangler-p2p.toml    ← Worker config
│   └── p2p/                     ← P2P collaboration modules
│       ├── cid.js               ← Content ID module
│       ├── qr.js                ← QR code generation
│       ├── p2p-core.js          ← P2P core
│       ├── infographic.js       ← Infographic generation
│       └── p2p-api.js           ← API module
├── create_static_site.py       ← Static site generator
└── wrangler.toml               ← (empty/placeholder)
```

### Deployment CLI
```
/home/mdupont/projects/arist/
├── bin/aristotle-manager        ← CLI wrapper
├── scripts/
│   ├── aristotle-manager-deploy-cloudflare.sh  ← Core deployer
│   └── deploy-cloudflare/       ← Per-project scripts
│       ├── f2265b5a-...sh       ← MiniLean MLVM (ready)
│       ├── f4e10742-...sh       ← Hodge VM (pages live, worker pending)
│       └── ...                  ← 8 other projects (not ready)
└── dotagents/tasks/T019-aristo-project-deploy/
    ├── CLOUDFLARE_DEPLOY.md
    ├── CLOUDFLARE_DEPLOY_GUIDE.md
    └── CLOUDFLARE_DEPLOY_FINAL.md
```

---

## Blocker: Hodge VM Worker Bundle Fix

**Problem**: esbuild (ESM mode) statically resolves all `require()` calls in `p2p-worker.mjs`, including dead branches guarded by `NODE ? require()`.

**Symptoms**:
```
Cannot find module './infographic.js' imported from dist/p2p-worker.mjs
```

**Fix in `hodge-vm/tools/make_p2p.js`**: Add `workerify()` function before bundle creation:

```javascript
function workerify(txt) {
  return txt
    .replace(/const CID = NODE \? require\('\.\/cid\.js'\) : root\.HodgeCID;/g, 'const CID = root.HodgeCID;')
    .replace(/const QR = NODE \? require\('\.\/qr\.js'\) : root\.HodgeQR;/g, 'const QR = root.HodgeQR;')
    .replace(/const P2P = NODE \? require\('\.\/p2p-core\.js'\) : root\.HodgeP2P;/g, 'const P2P = root.HodgeP2P;')
    .replace(/const INF = NODE \? require\('\.\/infographic\.js'\) : root\.HodgeInfographic;/g, 'const INF = root.HodgeInfographic;')
    .replace(/const NODE = typeof module !== 'undefined' \&\& module\.exports;/g, '');
}
```

Apply to the bundle inline:
```javascript
['p2p/cid.js', 'p2p/qr.js', 'p2p/p2p-core.js', 'p2p/infographic.js', 'p2p/p2p-api.js']
  .map((rel) => workerify(read(rel))).join('\n')
```

---

## Integration Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  AristotVM  │     │  Lean 4     │     │  IPLD/CAR   │     │  Cloudflare │
│  Manager    │     │  CBor       │     │  Shmem      │     │  Workers    │
│  (:18100)   │◄───▶│  Bridge     │◄───▶│  (memory)   │◄───▶│  (edge)      │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Nora       │     │  Systemd    │     │  Systemd    │     │  Cloudflare │
│  Registry   │◄───▶│  Services   │     │  Journal    │     │  Pages      │
│  (:4000)    │     │             │     │  (logs)     │     │  (static)   │
└──────┬──────┘     └──────┬──────┘     └─────────────┘     └─────────────┘
       │                   │
       ▼                   ▼
┌─────────────┐     ┌─────────────┐
│  Nginx      │     │  Monitor/   │
│  Proxy      │     │  Debug      │
│  (:80/443)  │     │  Tools     │
└─────────────┘     └─────────────┘
```

---

*Generated: 2026-10-22*  
*All services managed via `system-manager` Nix flake*  
*Credentials via SOPS + age — never stored in plaintext*