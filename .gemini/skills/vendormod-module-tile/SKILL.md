---
name: "vendormod-module-tile"
description: "Interactive HTML tile visualizing cargo-vendormod's refactored module structure. Tree view of 30+ modules, animated refactor replay (26 items moving from main.rs to utils.rs), file size metrics, and DASL architecture badges. Zero-dependency single HTML file. Use when building tile visualizations, documenting module architecture, or onboarding new agents."
---

# vendormod-module-tile — Module Tree Visualization

> Interactive standalone HTML tile that visualizes the refactored
> cargo-vendormod module structure.

**Task:** `tasks/vendormod-module-tile/` in the refactor-main worktree
**Status:** Pending (spec written, awaiting agent execution)
**Output:** `vendormod-module-tile.html` (single file, zero dependencies)

## Quick Start

```bash
cd /mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/worktrees/refactor-main/tasks/vendormod-module-tile
./runme.sh
```

## What It Shows

### 🌳 Module Tree View
- Collapsible tree of all 30+ cargo-vendormod modules
- Color-coded by category: core, cli, analysis, atlas, integration
- Import edges between modules
- `utils.rs` highlighted as the **new** shared dependency hub (1093 lines, 26 public items)

### 🔄 Refactor Replay
- Side-by-side: main.rs before (1703 lines) vs after (646 lines)
- 26 items animate from main.rs into their 6 destination sections in utils.rs
- Click "replay" to watch the transition

### 📊 File Metrics
- Bar chart: main.rs 1703→646 reduction
- Pie chart: what moved to utils vs stayed
- Per-module line count table

### 🔍 Search
- Filter modules and items by name
- Jump to matched item in tree

## DASL Badges

Items with DASL architecture relevance are badged:
- 🧬 **Hecke/Entropy** — FileSample, compute_entropy, compute_hecke_score
- 🔗 **IPLD Shmem** — shmem_put, SHMEM_MAX_SIZE, IPLD_MEMORY_BIN
- #️⃣ **CID** — compute_cid
- 🧹 **Dependency Graph** — handle_memecache_gc, parse_crate_version, dir_size

## Technical Spec

- **Zero dependencies** — single HTML file, no npm, no CDN
- **Dark theme** — DASL color scheme (deep blue bg, cyan/amber accents)
- **All data embedded** — module data as inline JSON (no network requests)
- **URL hash routing** — `#module=utils` deep-links to module
- **Responsive** — works desktop + mobile

## Views

| View | Hotkey | Description |
|------|--------|-------------|
| 🌳 Tree | `t` | Collapsible module hierarchy |
| 🔄 Replay | `r` | Animated refactor transition |
| 📊 Metrics | `m` | Bar/pie charts of file sizes |
| 🔍 Search | `/` | Filter by name |

## After Building

```bash
# Serve locally
python3 -m http.server 8765
# Open http://localhost:8765/vendormod-module-tile.html

# Deploy to nginx (see plan.org)
# → https://solana.solfunmeme.com/tile/vendormod-modules/
```

## Related Skills

- [[cargo-vendormod]] — the vendormod project itself
- [[dasl-tile-onboarding]] — tile creation and registration pattern
- [[dasl-tiles]] — tile TUI dashboards
- [[dasl-tiles-publication]] — self-publishing tile registry
- [[nix-flakes]] — flake management (task flake.nix)
