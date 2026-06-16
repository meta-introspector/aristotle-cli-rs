---
name: "backlog"
description: "Backlog task tracker for DASL projects. Integrates with llm-agents.nix backlog-md to manage dotagents tasks, worktrees, and tmux sessions. Provides unified view of all work-in-progress across the monorepo."
---

# Backlog — Task & Work Management

**Location:** `~/projects/dotagents/`
**Status:** Active
**Source:** plan.org

## Quick Start

```bash
# Install
nix profile add github:numtide/llm-agents.nix#backlog-md

# Launch TUI board
backlog board

# List tasks
backlog task list --plain

# Create task
backlog task create "Title" -d "Description"

# Capture all tmux panes
bash ~/projects/tmux/capture.sh
```

## Current Worktree Sessions

| Session | Path | Status |
|---------|------|--------|
| Window 0 | `/mnt/data1/time-2026/02-february/22/dasl/worktrees/test2` | Idle |
| Window 5 | `/mnt/data1/nix/.../cargo-vendormod/worktrees/refactor-main` | Active |
| Window 11 | `/mnt/data1/time-2026/06/07/sparql-gui` | SPARQL development |
| Window 6 | `/home/mdupont/projects/lean-split-tool` | Aristotle splitting |
| Window 4 | `/mnt/data1/.../ipld-car-ipc-shmem-linux/tasks/diagonalize` | Tile server |
| Window 7 | `zombie_driver2` | Zombie CFT |

## Key Tasks by Priority

| Priority | Task | Status |
|----------|------|--------|
| P0 | fix-nginx-tile-locations | ✅ Done |
| P1 | d8-2a-tile-dashboard | ✅ Complete (coded, pending deploy) |
| P1 | build-vendormod-tile-server | ✅ Done |
| P2 | fix-nix-system-manager-sandbox | Pending |
| P2 | merge-vendor-deps-main | Pending |
| P2 | deep-scan-all-blobs | Pending |
| P3 | build-3-category | Pending |

## Integration Commands

```bash
# Capture tmux state
~/projects/tmux/capture.sh

# Run task via pi agent
cd ~/projects/dotagents/tasks/<task>
nix develop -c pi --offline "Task: <name> Skills: <skills>" < GEMINI.md

# Deploy dasl-tiles-rust
cd ~/dasl-tiles-rust
nix run github:numtide/system-manager -- switch --flake .#dasl-tiles
```

## Related Skills

- [[cargo-vendormod]] — Central vendormod skill
- [[dasl-tiles]] — Tile system
- [[system-manager]] — Deployment tool
- [[lsof-paths-tile]] — Lsof path collector service
