---
name: wire-tile-tui-live
description: >-
  Wire tile-tui TreeNode::Tile variant to live :18142 (QA Team) and :18143
  (Fuzz Team) tile servers. Add Tile node kind to TreeState tree, fetch tile
  JSON from IPLD shmem on selection, display tile metadata in detail panel.
  Use when connecting the TUI to live services, adding health polling, or
  building interactive tile dashboards.
---

# Wire tile-tui to Live QA and Fuzz Tile Servers

**Priority:** LOW
**Area:** Tiles
**Status:** Pending
**Source:** status.org

## Goal

Connect the tile-tui (terminal UI) to live tile servers so users can browse
tile metadata, health status, and dependency graphs from the terminal.

## Tile Servers

| Server    | Port  | Purpose                          |
|-----------|-------|----------------------------------|
| QA Team   | 18142 | /health, /compare, /batch, /tile |
| Fuzz Team | 18143 | /health, /summary, /languages, /afl, /fuzz |

## Current State

- tile-tui compiles, 8/8 tests pass
- TreeNode has variants but no Tile variant
- TreeState tree has no Tile node kind

## Implementation

1. Add `Tile` variant to `TreeNode` enum:
```rust
enum TreeNode {
    // existing variants...
    Tile { name: String, url: String, port: u16 }
}
```

2. Add Tile node kind to `TreeState`:
```rust
// In tree building, add tile nodes for :18142 and :18143
```

3. Fetch tile JSON on selection:
```rust
// HTTP GET to tile server /tile endpoint
// Parse JSON response into detail panel
```

4. Display tile metadata in detail panel:
- Endpoints (/health, /compare, etc.)
- Health status (green/grey/red)
- Dependency graph

5. Add live health polling:
```rust
// Background task: poll /health every 5s
// Update node color based on response
```

## Source Files

- `~/projects/dasl-tiles-rust/src/syscall.rs` — HarnessTile, SyscallSpec, PipelineTile
- `~/projects/dasl-tiles-rust/src/lib.rs` — 21 harnesses, TreeNode tree, HarnessKind enum

## Build

```bash
cd ~/projects/dasl-tiles-rust
cargo build --bin tile-tui
cargo test
```

## Depends On

Nothing — this is a leaf task.

## Blocks

Nothing directly.
