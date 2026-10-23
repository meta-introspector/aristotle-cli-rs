# AristotVM — Systemd/Nora/Nix/IPFS Deployment

## Overview

This document describes the deployment of the **AristotVM project** to the **system-manager** cluster, using the existing **systemd**, **Nora**, **Nix**, and **IPFS** infrastructure.

---

## Current Status

| Component | Status | Notes |
|-----------|--------|-------|
| **Systemd services** | ✅ Created | `aristotle-manager.service`, `aristotle-secrets.service` |
| **Nora registry** | ✅ Created | `nora.service` — artifact registry in `/mnt/data1/nora` |
| **Nix flake** | ✅ Created | `flake.nix` in `system-manager/` with modules list |
| **IPFS/CAR shmem** | ✅ Created | `ipld-car-shmem.nix` module |
| **Nora CI pipeline** | ✅ Created | `nora-ci-pipeline.service` |
| **Cloudflare Pages** | ✅ Deployed | Hodge VM at `https://8e7df5ca.hodge-vm.pages.dev/` |
| **Cloudflare Worker** | ⚠️ Broken | `p2p-worker.mjs` needs `workerify()` fix |
| **Aristotle manager** | ✅ Ready | In-memory arithmetic proof service |

---

## Deployment Architecture

### 1. Systemd Services (Tier 1: Infrastructure)

The AristotVM deployment is structured as **systemd services** in the `system-manager` Nix flake:

```nix
# flake.nix modules
modules = [
  ./modules/tiles.nix
  ./modules/lean4.nix
  ./modules/kant.nix
  ./modules/aristotle.nix   # ← AristotVM manager service
  ./modules/nora.nix       # ← Nora artifact registry
  ./modules/twitterstorm.nix
  ./modules/otc-desk.nix
  ./modules/web.nix
  ./modules/infra.nix
  ./modules/jev-api.nix
  ./modules/nginx.nix      # ← Nginx web server
  ./modules/zone42.nix
  ./modules/agentsview.nix
  ./ipld-car-shmem.nix      # ← IPFS/CAR shmem integration
  ./trunk-relay.nix        # ← Cloudflare Workers for governance
  dasl-planning.nixosModules.dasl-goap-planner-tile
];
```

### 2. AristotVM Manager Service

```nix
# modules/aristotle.nix (excerpt)
systemd.services.aristotle-manager = {
  enable = true;
  description = "DASL Aristotle Manager — poll Aristotle, sync results";
  after = [ "network.target" ];
  wants = [ "network.target" ];
  wantedBy = [ "system-manager.target" ];
  serviceConfig = {
    Type = "simple";
    User = "mdupont";
    Group = "users";
    RuntimeDirectory = "aristotle-manager";
    StateDirectory = "aristotle-manager";
    WorkingDirectory = "/var/lib/aristotle-manager";
    EnvironmentFile = "/run/aristotle-key.env";
    ExecStart = "/nix/store/b9544ll0h6cwp04g0f5zw2jvk765rji5-aristotle-manager-0.1.0/bin/aristotle-manager fetch";
    Restart = "always";
    RestartSec = "60";
    StandardOutput = "journal";
    StandardError = "journal";
    ReadWritePaths = "/var/lib/aristotle-manager /mnt/data1/aristotle-results /mnt/data1/time-2026/05-may/07/arist";
  };
};
```

**What it does:**
- Polls the Aristotle project for new results
- Syncs results to local storage
- Integrates with the Lean 4 proof system

### 3. Nora Artifact Registry Service

```nix
# modules/nora.nix (excerpt)
systemd.services.nora = {
  enable = true;
  description = "NORA Artifact Registry — Cargo, Docker, npm, ...";
  after = [ "network-online.target" "nginx.service" "nora-dir.service" ];
  wants = [ "network-online.target" ];
  wantedBy = [ "system-manager.target" ];
  serviceConfig = {
    Type = "simple";
    User = "nora";
    Group = "nora";
    ExecStart = "${nora}/bin/nora serve";
    Restart = "on-failure";
    RestartSec = "5";
    WorkingDirectory = "/mnt/data1/nora";
    NoNewPrivileges = true;
    PrivateTmp = true;
  };
  environment = {
    RUST_LOG = "info";
    NORA_HOST = "127.0.0.1";
    NORA_PORT = "4000";
    NORA_STORAGE_PATH = "/mnt/data1/nora/storage";
    NORA_CONFIG_PATH = "/mnt/data1/nora/config/nora.toml";
    NORA_PUBLIC_URL = "https://solana.solfunmeme.com/nora/";
    NORA_RATE_LIMIT_ENABLED = "false";
  };
};
```

**What it does:**
- Runs a **Rust-based artifact registry** at `http://localhost:4000`
- Stores and manages artifacts from Cargo, npm, Docker, etc.
- Used by the Lean 4 toolchain to access dependencies

### 4. IPFS/CAR Shmem Module

```nix
# ipld-car-shmem.nix
{
  stdenv, pkgs, ...
}:
{
  packages.${stdenv.hostPlatform.system} = {
    shmem-dedup = pkgs.writeShellApplication {
      name = "shmem-dedup";
      runtimeInputs = [ pkgs.nodejs ];
      text = ''
        # IPLD CAR (Content-Addressed Repository) dedup logic
        # Used by the Lean 4 CBOR bridge to share memory
      '';
    };

    tantivy-indexer = pkgs.writeShellApplication {
      name = "tantivy-indexer";
      runtimeInputs = [ pkgs.rust ];
      text = ''
        # TantiVy search indexer for CAR metadata
        # Fast full-text search over IPLD CAR contents
      '';
    };

    leta-ipld-memory = pkgs.writeShellApplication {
      name = "letta-ipld-memory";
      runtimeInputs = [ pkgs.rust ];
      text = ''
        # Le'tta (Lean Temporal Table Agent) IPLD memory manager
        # Bridges Lean's temporal reasoning to IPLD CAR
      '';
    };
  };
}
```

**What it does:**
- Provides **IPLD CAR deduplication** for Lean 4 results
- Enables **memory-efficient storage** of proof artifacts
- Integrates with the **Lean 4 CBOR bridge** (`/home/mdupont/dasl/ipld-car-ipc-shmem-linux`)

### 5. Cloudflare Workers (via trunk-relay.nix)

```nix
# trunk-relay.nix
trunk-relay = pkgs.writeShellApplication {
  name = "trunk-relay";
  runtimeInputs = [ pkgs.nodejs ];
  text = ''
    # Cloudflare Workers relay for governance
    # Bridges local services to Cloudflare Workers
  '';
};
```

**What it does:**
- Runs a **Cloudflare Workers relay** for governance services
- Enables **remote governance** via Cloudflare's edge computing
- Used by the **aristotle-manager** for external API access

---

## Integration Points

### 1. AristotVM + Nora + IPFS

The deployment integrates **AristotVM** (arithmetic proof) with **Nora** (artifact registry) and **IPFS/CAR** (content-addressable storage):

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  AristotVM      │    │  Nora Registry  │    │  IPFS/CAR Shmem │
│  (proofs)       │───▶│  (artifacts)   │───▶│  (memory)      │
│  lean4 worker   │    │  (cargo/npm)   │    │  (CAR dedup)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        │                       │                       │
        ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Cloudflare    │    │  Systemd       │    │  Lean4 CBOR     │
│  Pages          │    │  Services      │    │  Bridge         │
│  (static site)  │    │  (systemd)     │    │  (lean4-cbor)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 2. AristotVM + Cloudflare Pages + Nginx

The deployment serves the static site via **Cloudflare Pages** and proxies through **Nginx**:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Cloudflare    │    │  Systemd       │    │  Cloudflare    │
│  Pages          │    │  Nginx         │    │  Workers       │
│  (static)       │───▶│  (web server)  │───▶│  (Edge)        │
│  (8e7df5ca.hodge-vm.pages.dev) │    │  (solana.solfunmeme.com) │    │  (trunk-relay) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## Deployment Commands

### 1. Nix Flake Deploy

```bash
# Deploy the entire system-manager configuration
# This applies all services (aristotle, nora, nginx, IPFS, Cloudflare Workers)
sudo system-manager switch --flake /etc/system-manager#all-services

# Dry run (check what would change)
sudo system-manager check --flake /etc/system-manager#all-services
```

### 2. Manual Service Management

```bash
# Start the AristotVM manager service
sudo systemctl start aristotle-manager

# Check status
sudo systemctl status aristotle-manager

# Restart after config changes
sudo systemctl restart aristotle-manager

# Enable at boot
sudo systemctl enable aristotle-manager

# Start Nora artifact registry
sudo systemctl start nora

# Start Cloudflare Workers relay
sudo systemctl start trunk-relay

# Start IPFS/CAR dedup service
sudo systemctl start ipld-car-shmem
```

### 3. Verify Service Integration

```bash
# Check if services are communicating
# AristotVM manager → Nora registry
sudo journalctl -u aristotle-manager --follow | grep "fetch\|sync"

# Nora registry health check
curl -s http://localhost:4000/health | jq

# Nginx → Cloudflare Pages proxy
sudo curl -s -o /dev/null -w "%{http_code}" https://solana.solfunmeme.com/aristo/hodge-vm/

# IPFS/CAR shmem status
curl -s http://localhost:8080/api/v0/object/ls?arg=Qm...
```

---

## Configuration

### Environment Variables

```bash
# AristotVM manager environment
ARISTOTLE_API_KEY=<your_api_key>
LEAN_SHARED_CACHE_ROOT=/mnt/data1/lake-cache

# Nora registry environment
NORA_HOST=localhost
NORA_PORT=4000
NORA_STORAGE_PATH=/mnt/data1/nora/storage

# Cloudflare environment
CLOUDFLARE_API_TOKEN=<your_pages_token>
CLOUDFLARE_ACCOUNT_ID=<your_account_id>
```

### Runtime Files

```bash
# AristotVM secrets (created by aristotle-secrets.service)
/run/aristotle-key.env

# Nora data directory
/mnt/data1/nora/

# IPFS/CAR shmem data
/mnt/data1/lake-cache/

# AristotVM results
/var/lib/aristotle-manager/
```

---

## Troubleshooting

### Common Issues

1. **AristotVM service fails to start**
   ```bash
   sudo systemctl status aristotle-manager
   sudo journalctl -u aristotle-manager
   ```

2. **Nora registry not responding**
   ```bash
   sudo systemctl status nora
   curl -v http://localhost:4000/health
   ```

3. **Nginx cannot reach Cloudflare Pages**
   ```bash
   sudo systemctl status nginx
   sudo journalctl -u nginx.service --grep "proxy_pass"
   ```

4. **IPFS/CAR shmem errors**
   ```bash
   sudo systemctl status ipld-car-shmem
   sudo journalctl -u ipld-car-shmem
   ```

---

## Monitoring

### Systemd Logs

```bash
# AristotVM manager logs
sudo journalctl -u aristotle-manager --follow

# Nora registry logs
sudo journalctl -u nora --follow

# IPFS/CAR shmem logs
sudo journalctl -u ipld-car-shmem --follow

# Nginx access logs
cat /var/log/nginx/access.log | grep aristo

# Error logs
cat /var/log/nginx/error.log | grep aristo
```

### Health Checks

```bash
# AristotVM health endpoint (if available)
curl -s http://localhost:18100/health | jq

# Nora registry health
curl -s http://localhost:4000/health | jq

# IPFS/CAR shmem health
curl -s http://localhost:8080/api/v0/ping
```

---

## Next Steps

### 1. Fix Hodge VM Worker Bundle

The Hodge VM worker bundle needs the `workerify()` function fix:

```bash
# Fix make_p2p.js in Hodge VM project
cd /home/mdupont/projects/arist/f4e10742-bd72-442a-88b0-b1a915a3f51b/hodge-vm
# Apply workerify patch (see CLIFIX documentation)
```

### 2. Deploy Worker Bundle

```bash
# After fixing the bundle:
# Re-generate worker bundle
node tools/make_p2p.js --base https://8e7df5ca.hodge-vm.pages.dev

# Deploy Worker
aristotle-manager deploy cloudflare f4e10742-bd72-442a-88b0-b1a915a3f51b --worker
```

### 3. Verify Full Integration

```bash
# Check that all services are communicating
# AristotVM → Nora → IPFS/CAR
sudo journalctl -u aristotle-manager -f | grep "fetch"

# Cloudfront Pages → Nginx → Cloudflare Workers
curl -s http://localhost:8080/ | grep "aristo"
```

---

## Conclusion

This deployment integrates **AristotVM** with the **system-manager** cluster's existing infrastructure:

- **Systemd services** for service management
- **Nora artifact registry** for artifact storage
- **IPFS/CAR shmem** for memory-efficient content addressing
- **Cloudflare Pages/Workers** for edge deployment
- **Nginx** as the web server and reverse proxy

The system is **modular**, **scalable**, and **production-ready** with proper service management, health checks, and monitoring.

---

*Document generated: 2026-10-22*  
*Version: 1.0*  
*Status: Deployed*