---
name: dasl-gui
description: >-
  DASL GUI Dashboard — tile dashboard architecture with diagonalize tile
  (block tree + pivot tables), vector space viewer, pipeline phase DAG,
  and IPLD CAR shmem integration. Use when building or navigating the
  DASL tile GUI, registering new tiles, or extending the dashboard.
---

# dasl-gui — DASL Tile Dashboard

## Live Tiles

| Tile ID | URL | Endpoints |
|---------|-----|-----------|
| `diagonalize-tile` | `https://solana.solfunmeme.com/tile/diagonalize/` | tree, flat, pivot, stats, health |
| `qa-team-tile` | `http://127.0.0.1:18142` | health, compare, batch |
| `fuzzing-team-tile` | `http://127.0.0.1:18143` | health, coverage, trigger |

## How to Query Tiles

```bash
# Diagonalize tile — block tree stats
curl -s https://solana.solfunmeme.com/tile/diagonalize/api/stats | jq .

# Pivot by DASL ontology category
curl -s 'https://solana.solfunmeme.com/tile/diagonalize/api/pivot?by=category' | jq .

# Pivot by depth
curl -s 'https://solana.solfunmeme.com/tile/diagonalize/api/pivot?by=depth' | jq .

# Flat block list (first 10)
curl -s https://solana.solfunmeme.com/tile/diagonalize/api/flat | jq '.[:10]'

# Raw tree (first 200 chars)
curl -s https://solana.solfunmeme.com/tile/diagonalize/api/tree | head -c 200
```

## How to Find the Tile

1. **Browser:** Open `https://solana.solfunmeme.com/tile/diagonalize/`
2. **API:** `curl https://solana.solfunmeme.com/tile/diagonalize/api/stats`
3. **IPLD Shmem:** `letta-ipld-memory get "tiles/diagonalize-tile"`
4. **Pastebin:** `bash services/tile-registry.sh get diagonalize-tile`
5. **TUI:** `cd ~/projects/dasl-tiles-rust && cargo run --bin tile-tui`

## GUI Architecture

```
Tile Dashboard (tile-tui / web / pastebin)
    ├── diagonalize-tile    :8082  ← LIVE
    ├── vector-space-tile   :8083  ← PLANNED
    ├── pipeline-phase-tile  —    ← PLANNED (aggregator)
    ├── hypermorphism-tile   —    ← LATER
    └── cid-signature-tile   —    ← LATER
         ↓
    IPLD CAR Shmem (tiles/ prefix)
         ↓
    blocks.json + vendormod-blocks.json (360K blocks)
```

## Registering a New Tile

1. Create tile JSON following the schema:
```json
{
  "id": "my-tile",
  "title": "🆕 My Tile",
  "description": "...",
  "kind": "http-tile",
  "endpoint": "http://127.0.0.1:PORT",
  "port": 18900,
  "language": "Python",
  "tags": ["tile"],
  "endpoints": [
    {"path": "/health", "method": "GET", "description": "Health check"}
  ],
  "version": "0.1.0",
  "depends_on": []
}
```

2. Store in IPLD shmem:
```bash
letta-ipld-memory put "tiles/my-tile" "Description" < my-tile.json
```

3. Add to `~/dasl/dasl-testing/services/tile-registry.sh` TILES array

4. Add compose_tile case in tile-registry.sh

5. Republish:
```bash
cd ~/dasl/dasl-testing
bash services/tile-registry.sh compose
bash services/tile-registry.sh publish
```

## Vector Space Model (ℝ⁸)

Basis vectors: {crates.io/getnora.io, git, flake.nix, system-manager, nginx, shmem, perf, cargo/bun/uv}

Pipeline phases as subspaces:
- V_spec = span(e₂, e₁)
- V_code = span(e₂, e₈)
- V_compile = span(e₃, e₈)
- V_debug = span(e₂, e₆)
- V_perf = span(e₇, e₅, e₆)
- V_fuzz = span(e₈, e₆)

Sheaf gluing via CID/DAG-CBOR across phase overlaps.

## Key Files

| File | Purpose |
|------|---------|
| `~/dasl/ipld-car-ipc-shmem-linux/tasks/diagonalize/GUI_PLAN.md` | Full GUI plan |
| `~/dasl/ipld-car-ipc-shmem-linux/tasks/diagonalize/tile-server/server.py` | Tile HTTP server |
| `~/dasl/ipld-car-ipc-shmem-linux/tasks/diagonalize/tile-server/system-manager-config.nix` | Systemd + nginx config |
| `~/dasl/ipld-car-ipc-shmem-linux/tasks/diagonalize/deploy.sh` | Deploy script (6 options incl switch) |
| `~/dasl/dasl-testing/services/tile-registry.sh` | Tile registry |
| `~/DOCS/DASL_DIAGONALIZE_TILE.md` | Full documentation |
| `~/dasl/plan.org` | Master project plan |
| `~/.kilocode/skills/system-manager/SKILL.md` | Deployment patterns reference |
