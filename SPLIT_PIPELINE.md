# Aristotle Split Pipeline

## Overview
Batch-split all Aristotle projects into per-declaration pools, then merge them into one deduplicated pool.

## Recipe
1. Discover projects with decl-bearing `RequestProject/*.lean` under `BASE_DIR` (shell globs, no `find`).
2. Borrow a fully-built mathlib v4.28.0 from a DONOR project's `.lake/packages` (no downloads, no lake builds of mathlib).
3. Precompile each RequestProject module olean with `lean -o` (skip if fresh).
4. Run the kernel splitter: `lake env lean --run split-arist-entry.lean <cfg.json>` with `LEAN_PATH = projBuild:donorPkgs:toolBuild:toolchainLib`.
5. Merge all pools with `SplitDecls/IO/Merger.lean` (FNV-1a content-hash dedup).

## Usage
```bash
split-arist.sh [PROJECT_SUBSTR]  # optional: restrict to projects whose name contains substring
```

## Environment Variables
- `BASE_DIR`: Project base directory (default: `/mnt/data1/aristotle-git-versions`)
- `OUT_BASE`: Output directory (default: `/mnt/data1/aristotle-splits`)
- `MERGED_OUT`: Merged output directory (default: `/mnt/data1/aristotle-splits/merged`)
- `SPLIT_TOOL`: Split tool path (default: `/home/mdupont/projects/lean-split-tool`)
- `DONOR`: Donor project path (default: `/mnt/data1/aristotle-git-versions/0ba6a6e2-a70b-4d06-ac37-73e25ccdd949`)
- `LEAN_BIN`: Lean binary path (default: `/home/mdupont/.elan/bin`)

## Notes
- `find` is used ONLY inside individual project `RequestProject` dirs (bounded, dozens of files) — never on `BASE_DIR` roots, per the locate-not-find rule.
- Uses shared mathlib cache at `/mnt/data1/lean/mathlib` (7.9GB pre-built).
- Supports parallel processing with `MAX_JOBS` environment variable.
- Resource knobs: `HEARTBEAT` for lean compilation timeout, `STACK` for ulimit.

## Split Pipeline Status
- **Status**: ✅ Ready for new Aristotle projects
- **Recent Fetch**: 1 new project (`meta-introspector-lean-split-tool-8a5edab282632443`)
- **Total Projects**: 606 (583 completed, 1 in progress, 22 queued)
- **Next Steps**: Build new split pipeline with lean-split-tool