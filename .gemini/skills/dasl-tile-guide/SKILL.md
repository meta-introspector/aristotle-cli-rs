---
name: "dasl-tile-guide"
description: "Complete guide for creating, deploying, and monitoring DASL tiles. Covers tile schema, IPLD shmem storage, system-manager deployment, nginx reverse proxy, dynamic tile discovery (systemd/tmux/nginx), and the tile dashboard server."
---

# DASL Tile Guide

**Location:** `~/projects/dasl-tiles-rust-wt/`
**Binary:** `tile-server` (port 8081)
**Public:** `https://solana.solfunmeme.com/tiles/`

## Quick Start

```bash
# Build & deploy
cd ~/projects/dasl-tiles-rust-wt
bash deploy-tile.sh

# Check status
bash check-tiles.sh

# Store tile in IPLD shmem
echo '{"id":"my-tile","title":"My Tile","kind":"http-tile","port":9000}' | \
  letta-ipld-memory put "tiles/my-tile" "Description"
```

## Schema

```json
{
  "id": "test-result-tile",
  "title": "⚡ DASL Tile Dashboard",
  "description": "Fuzz harnesses + dynamic systemd/tmux/nginx tiles",
  "kind": "aggregator-tile",
  "endpoint": "http://127.0.0.1:8081",
  "port": 8081,
  "language": "Rust",
  "tags": ["dasl", "tiles", "fuzzing", "dashboard"],
  "endpoints": [
    {"path": "/health", "method": "GET"},
    {"path": "/meta", "method": "GET"},
    {"path": "/dynamic", "method": "GET"}
  ],
  "version": "0.2.0",
  "depends_on": ["ipld-car-shmem"]
}
```

## Endpoints

| URL | Description |
|-----|-------------|
| `/health` | Health check |
| `/` | Dashboard: 21 fuzz + ~226 dynamic tiles |
| `/meta` | JSON: all harness metas with tech vectors |
| `/meta/tile/{lang}/{impl}/vector` | Tech vector + phase projections + shard |
| `/meta/tile/{lang}/{impl}/badges` | Badge HTML strip |
| `/dynamic` | JSON: systemd services, nginx locations, tmux panes |
| `/tiles` | Raw tile listing |
| `/registry` | IPLD shmem registry browser |

## Dynamic Tiles

At startup, `tile-server` discovers runtime tiles:
- **systemd**: 157 services with status, memory, load badges
- **nginx**: 69 location blocks with proxy targets
- **tmux**: sessions and panes (when running)

Each dynamic tile carries tech vector coordinates in ℝ⁸
(nora, git, flake.nix, system-manager, nginx, shmem, perf, cargo/bun/uv).

## Deployment

### Method 1: deploy-tile.sh (recommended)

```bash
bash deploy-tile.sh
# Builds → stops service → copies binary → starts → verifies
```

### Method 2: system-manager

```bash
cd ~/projects/dasl-tiles-rust-wt
nix build .#systemConfigs.dasl-tiles --no-link --print-out-paths
sudo system-manager switch --flake .#dasl-tiles
```

### Method 3: Manual

```bash
cd ~/projects/dasl-tiles-rust-wt
cargo build --bin tile-server
sudo systemctl stop test-result-tile
cp target/debug/tile-server /mnt/data1/dasl-tiles-rust-review/target/debug/
sudo systemctl start test-result-tile
```

## Nginx Config

```nginx
# /etc/nginx/locations.d/test-result-tile.conf
location ^~ /tiles/           { proxy_pass http://127.0.0.1:8081/; ... }
location ^~ /tile/test-result-tile/ { proxy_pass http://127.0.0.1:8081/; ... }
location ^~ /dynamic          { proxy_pass http://127.0.0.1:8081/dynamic; ... }
```

## Monitoring

```bash
# Health
curl https://solana.solfunmeme.com/tiles/health

# Meta count
curl https://solana.solfunmeme.com/tiles/meta | jq .count

# Dynamic tiles
curl https://solana.solfunmeme.com/tiles/dynamic | jq .by_kind

# Service
systemctl status test-result-tile ipld-car-shmem nginx

# Logs
journalctl -u test-result-tile -f
```

## Key Files

| File | Purpose |
|------|---------|
| `src/server.rs` | Axum server, gallery rendering, meta endpoints |
| `src/meta.rs` | Tech vector space, TileMeta, badges, shard coords |
| `src/meta_collector.rs` | Shell out to git/nix/shmem/nora/perf |
| `src/tile_dynamic.rs` | SystemdSnapshot, TmuxSnapshot, NginxSnapshot |
| `src/server_loader.rs` | IPLD shmem resolver (stable ID → pointer → version) |
| `src/ipld_car.rs` | Unix socket client for ipld-car-shmem |
| `deploy-tile.sh` | Build + deploy script |
| `check-tiles.sh` | Health + metadata verification |
| `system-manager.nix` | Standalone deployment config |
| `/etc/nginx/locations.d/test-result-tile.conf` | Nginx proxy |

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| nginx won't start | Ports 80/443 held by pastebin — use `sudo fuser -k 80/tcp` then start |
| shmem connection refused | `sudo systemctl start ipld-car-shmem` |
| Health 500 | `journalctl -u test-result-tile -n 30` for panic |
| Cache takes too long | Normal on restart (~2 mins for 21 harnesses + 226 dynamic) |
