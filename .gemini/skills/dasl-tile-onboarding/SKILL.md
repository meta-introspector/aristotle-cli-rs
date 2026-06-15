---
name: dasl-tile-onboarding
description: Create, compose, store, and publish DASL tiles as DAG-CBOR objects in IPLD CAR-of-CARs shared memory. Covers tile schema, tile-registry.sh, tile-composer, tile-tui, and pastebin integration.
---

# DASL Tile Onboarding

Create and manage DAG-CBOR tile objects representing CBOR decoder implementations, QA aggregators, and fuzzing coverage dashboards. Tiles are content-addressed JSON objects stored in the IPLD CAR-of-CARs shared memory server and discoverable via pastebin.

## Quick Start

```bash
# 1. Ensure tile servers are running
cd ~/dasl/dasl-testing
bash services/deploy-system-manager.sh launch

# 2. Compose tiles into IPLD shmem
bash services/tile-registry.sh compose

# 3. List stored tiles
bash services/tile-registry.sh list

# 4. Publish tile registry as pastebin paste
bash services/tile-registry.sh publish

# 5. Launch TUI to browse tiles
cd ~/projects/dasl-tiles-rust && cargo run --bin tile-tui
```

## Tile Schema

Every tile is a DAG-CBOR JSON object with this structure:

```json
{
  "id": "unique-tile-id",
  "title": "Display Title (can include emoji)",
  "description": "What this tile does, what data it exposes",
  "kind": "http-tile | aggregator-tile | harness-tile | pipeline-tile",
  "endpoint": "http://127.0.0.1:PORT",
  "port": 18142,
  "language": "Rust | Python | Go | JS | C",
  "tags": ["tile", "discovery", "keywords"],
  "endpoints": [
    {"path": "/health", "method": "GET", "description": "Health check"},
    {"path": "/decode", "method": "POST", "description": "Decode hex CBOR"}
  ],
  "metadata": { "custom": "data" },
  "version": "0.1.0",
  "depends_on": ["other-tile-id"]
}
```

### Tile Kinds

| Kind | Purpose | Example |
|---|---|---|
| `http-tile` | Wraps an HTTP service endpoint | serde_ipld_dagcbor, n0_dasl, libipld |
| `aggregator-tile` | Aggregates multiple tiles into one view | QA Team Tile, Fuzzing Team Tile |
| `harness-tile` | Wraps a fuzz harness with syscalls | 21 harnesses from dasl-testing |
| `pipeline-tile` | DAG of syscalls connected by data flow | Cross-impl roundtrip pipeline |

## Tile Registry

All tiles are stored in IPLD shmem under the `tiles/` prefix.

```bash
# List all tiles
letta-ipld-memory query "tiles/"

# Get a tile's JSON
letta-ipld-memory get "tiles/qa-team-tile"

# Store a new tile
letta-ipld-memory put "tiles/my-tile" "Description" < my-tile.json
```

### Currently Registered Tiles

| Tile ID | Title | Kind | Port | Endpoints |
|---|---|---|---|---|
| `qa-team-tile` | 🧪 QA Team Tile | aggregator | 18142 | 5 |
| `fuzzing-team-tile` | 🐛 Fuzzing Team Tile | aggregator | 18143 | 6 |
| `serde-ipld-dagcbor-tile` | 🔧 serde_ipld_dagcbor | http-tile | 18007 | 4 |
| `n0-dasl-tile` | ⚠️ n0_dasl | http-tile | 18009 | 4 |
| `libipld-tile` | 🔓 libipld | http-tile | 18011 | 4 |

## Creating a New Tile

### Step 1: Define the tile JSON

Save as `~/dasl/dasl-testing/tile-defs/my-tile.json`:

```json
{
  "id": "my-tile",
  "title": "🆕 My New Tile",
  "description": "Description of what this tile provides",
  "kind": "http-tile",
  "endpoint": "http://127.0.0.1:PORT",
  "port": 18500,
  "language": "Rust",
  "tags": ["my-tag", "tile"],
  "endpoints": [
    {"path": "/health", "method": "GET", "description": "Health check"},
    {"path": "/api", "method": "POST", "description": "Main API"}
  ],
  "metadata": {},
  "version": "0.1.0",
  "depends_on": []
}
```

### Step 2: Store in IPLD shmem

```bash
letta-ipld-memory put "tiles/my-tile" "My new tile" < my-tile.json
```

### Step 3: Add to tile-registry.sh

Edit `services/tile-registry.sh` and add your tile ID to the `TILES` array.
Also add a `compose_tile` case for your tile.

### Step 4: Publish

```bash
bash services/tile-registry.sh publish
# → https://solana.solfunmeme.com/pastebin/paste/...
```

### Step 5: Use in TUI

Launch `tile-tui` to see your tile in the Tiles tree.

## Pastebin Integration

Users can compose new tiles by pasting JSON definitions into pastebin:

```
POST https://solana.solfunmeme.com/pastebin/api/paste
Content-Type: application/json

{
  "content": "{ \"id\": \"my-tile\", \"title\": \"...\", ... }",
  "title": "my-tile.json",
  "language": "json"
}
```

The tile-composer binary can then ingest pasted tiles:

```bash
tile-composer ingest <paste-url>
```

## Architecture

```
User pastes tile JSON → pastebin
     │
     ▼
tile-registry.sh compose
     │
     ▼
letta-ipld-memory put "tiles/<id>"
     │
     ▼
IPLD CAR-of-CARs Shmem (content-addressed)
     │
     ▼
tile-tui discovers tiles via IPLD query
     │
     ├──→ Renders in terminal (ratatui 3-panel)
     ├──→ QA tile aggregates health across all tiles
     └──→ Fuzz tile shows coverage + can trigger runs
```

## Key Files

| File | Purpose |
|---|---|
| `~/dasl/dasl-testing/services/tile-registry.sh` | Compose, list, get, publish tiles |
| `~/dasl/dasl-testing/services/deploy-system-manager.sh` | Launch tile servers |
| `~/dasl/dasl-testing/tile-defs/*.json` | Tile JSON definitions |
| `~/dasl/ipld-car-ipc-shmem-linux/target/release/letta-ipld-memory` | IPLD CLI |
| `~/projects/dasl-tiles-rust/src/bin/tile-tui.rs` | Terminal UI |
| `~/projects/dasl-tiles-rust/src/bin/tile-server.rs` | Tile HTTP server |
| `~/projects/dasl-tiles-rust/src/syscall.rs` | Harness/Pipeline tile types |
| `tools/cargo-vendormod/src/bin/tile_composer.rs` | Rust tile composer |
| `tools/cargo-vendormod/src/bin/dasl_mitigate.rs` | Mitigation vector generator |

## Adding a New Tile Server Implementation

When adding a new CBOR decoder (e.g., a Go or JS implementation):

1. **Build the service binary** (like `harnesses/*/src/bin/service.rs`)
2. **Add to deploy script** in `services/deploy-system-manager.sh`:
   - Add port to `PORTS` array
   - Add binary path to `BINARIES` array
3. **Create tile definition** following the schema above
4. **Store in IPLD** via `tile-registry.sh compose`
5. **Update QA tile** if it should be included in cross-impl comparison
6. **Update fuzz tile** if it should be included in fuzz coverage

## Commands Reference

```bash
# Tile lifecycle
bash services/tile-registry.sh compose     # Create + store all tiles
bash services/tile-registry.sh list        # List stored tiles
bash services/tile-registry.sh get <id>    # Get tile JSON
bash services/tile-registry.sh publish     # Publish to pastebin

# IPLD operations
letta-ipld-memory put "tiles/<id>" "desc" < file.json
letta-ipld-memory get "tiles/<id>"
letta-ipld-memory query "tiles/"

# Tile servers
bash services/deploy-system-manager.sh launch    # Start all
bash services/deploy-system-manager.sh diagnose  # Health check
bash services/deploy-system-manager.sh stop      # Stop all

# TUI
cd ~/projects/dasl-tiles-rust
cargo run --bin tile-tui              # Interactive
cargo run --bin tile-tui -- --demo   # 10-step auto-demo

# Tile composition (Rust)
cargo run --bin tile-composer -- create
cargo run --bin tile-composer -- query
cargo run --bin tile-composer -- publish
```

## Vendormod Module Tile

A new tile type visualizes cargo-vendormod's refactored module architecture:
- Shows 30+ modules as a collapsible tree with import edges
- Animated refactor replay: 26 items fly from main.rs to utils.rs
- File size metrics (before/after the 62% reduction)
- DASL badges for items connected to Hecke scoring, IPLD shmem, CID computation

**Task:** `worktrees/refactor-main/tasks/vendormod-module-tile/`
**Skill:** [[vendormod-module-tile]]

To add this tile to the registry after building:

```bash
# Store the tile in IPLD shmem
letta-ipld-memory put "tiles/vendormod-module" "Vendormod module tree" \
  < vendormod-module-tile.html

# Add to tile-registry.sh TILES array
# TILES+=(vendormod-module)

# Publish
bash services/tile-registry.sh publish
```
