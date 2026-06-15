---
name: tile-usage
description: >-
  Everyday DASL tile operations — check health, browse tiles, query data
  via API and TUI, and diagnose common issues.
---

# Tile Usage — How to Use DASL Tiles

**Everyday operations:** check health, browse tiles, query data.

## Quick Reference

```bash
# See all tiles
check-tiles                    # health-check every tile via HTTP
check-tiles --json             # JSON output for scripts

# Nagios dashboard (web)
open https://solana.solfunmeme.com/tile/nagios/

# Deploy tile (web)
open https://solana.solfunmeme.com/tile/deploy/

# Terminal TUI
cd ~/projects/dasl-tiles-rust && cargo run --bin tile-tui

# Query tile data from shmem
letta-ipld-memory get tiles/qa-team-tile     # tile definition
letta-ipld-memory query tiles/               # list all tiles
```

## Tile URLs

| Tile | URL |
|------|-----|
| Nagios Monitor | `https://solana.solfunmeme.com/tile/nagios/` |
| Deploy Panel | `https://solana.solfunmeme.com/tile/deploy/` |
| Diagonalize | `https://solana.solfunmeme.com/tile/diagonalize/` |
| Pastebin | `https://solana.solfunmeme.com/pastebin/` |
| Zombie CFT | `https://solana.solfunmeme.com/zombie-cft/` |

## API Calls

```bash
# Health — any tile
curl http://127.0.0.1:8800/health          # nagios
curl http://127.0.0.1:8810/health          # deploy

# Live status — nagios
curl http://127.0.0.1:8800/api/status      # all tiles with health

# Deploy — deploy tile
curl http://127.0.0.1:8810/api/tiles       # list deployable tiles
curl -X POST http://127.0.0.1:8810/api/deploy/nagios-monitor  # deploy one

# Tile TUI terminal UI
cargo run --bin tile-tui
# Navigate: arrows, Enter to expand, / to search, q to quit
```

## Diagnose Everything

```bash
bash ~/DOCS/diagnostic.sh          # full health snapshot
bash ~/DOCS/all-services-deploy.sh --diag  # same, via deploy script
```

## Common Issues

| Symptom | Fix |
|---------|-----|
| Tile returns 404 | Backend process down — deploy via tile or system-manager |
| Nginx 404 for /tile/* | Location block missing — deploy all-services |
| Shmem blocks empty | Server down — `ipld-car-shmem-server &` | 
| Port already in use | Kill old process: `pkill -f nagios-tile-server` |
