---
name: "lsof-paths-tile"
description: "Reusable tile that collects paths from lsof output across tmux sessions. Provides CLI, HTTP server, and tile GUI for workspace path analysis."
---

# lsof-paths-tile — Path Collection Service

**Location:** `~/dotagents/lsof-paths-tile/`
**Port:** 18080
**Tile kind:** `http-tile`

## Quick Start

```bash
# CLI: collect and cache paths
cargo run --bin lsof-paths collect

# CLI: start HTTP server
cargo run --bin lsof-tile-server serve --bind 127.0.0.1:18080

# Server endpoints
curl http://127.0.0.1:18080/health
curl http://127.0.0.1:18080/api/paths
curl http://127.0.0.1:18080/api/paths/gitrepo
```

## Architecture

```
┌─────────────────┐
│   tmux panes    │
└────────┬────────┘
         │ list-panes -F
         ▼
┌─────────────────┐
│ lsof-paths CLI  │ (collect + cache)
└────────┬────────┘
         │ JSON cache
         ▼
┌─────────────────┐
│ HTTP Server     │ :18080
│ /api/paths      │
│ /api/cache      │
└────────┬────────┘
         │ tile-tui
         ▼
┌─────────────────┐
│ Tile GUI        │
└─────────────────┘
```

## Path Categories

| Category | Pattern |
|----------|---------|
| `GitRepo` | Path contains `.git` |
| `Worktree` | Path contains `worktree` |
| `DaslProject` | Path contains `dasl` |
| `RustProject` | Path contains `Cargo.toml` or `rust` |
| `LeanProject` | Path contains `lean` or `.lean` |
| `Unknown` | Everything else |

## Deployment

```bash
cd ~/dotagents/lsof-paths-tile
./deploy.sh
```

Or manually:
```bash
nix build .#lsof-paths
nix run github:numtide/system-manager -- switch --flake .#lsof-paths
```

## Related Skills

- [[backlog]] — Task management
- [[tmux]] — Session management
- [[dasl-tiles]] — Tile system
