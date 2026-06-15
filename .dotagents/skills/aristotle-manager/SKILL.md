---
name: aristotle-manager
description: >-
  Rust CLI for polling Aristotle API, downloading Lean4 results,
  splitting declarations, building per-decl flake lattices, and
  generating DASL-compatible indexes. Use when working with
  ~/projects/arist/ or any Aristotle result management task.
---

# Aristotle Manager — Rust CLI

Rust binary (`aristotle-manager`) that orchestrates the full Aristotle → Lean → Nix pipeline.

## When to Use

- "Poll Aristotle for new results"
- "Download Aristotle projects"
- "Split Lean declarations"
- "Build declaration table"
- "Refresh all Aristotle data"

## Commands

```bash
cargo run --release -- <command>

# Full pipeline
refresh              # poll + download + split + decl-table
poll                 # Check API for new projects
download             # Fetch tarballs from Aristotle API
build                # lake build all projects
split                # Run Lean SplitDecls per project
split-all            # Batch split via shell script driver
decl-table           # Build canonical declaration table from splits
merge                # Merge split results
index                 # Generate DASL-compatible blocks.json
results              # Show last build results
clean                # Remove result file
configure set -k KEY  # Set API key
```

## Key Flags

- `--parallel N` / `-j N` — concurrency (default 4)
- `--limit N` — cap number of projects
- `--dry-run` — show what would happen (split-all)
- `--verbose` / `-v` — extra output
- `--no-fail-fast` — continue on errors (build)

## Architecture

```
aristotle-manager (Rust)
├── src/main.rs       — CLI + all command implementations
├── src/index.rs      — DASL blocks.json indexer
├── src/notebooklm.rs — NotebookLM text generator
├── src/tests.rs      — Integration tests
├── Cargo.toml        — deps: clap, reqwest, tokio, serde, rusqlite
└── flake.nix         — Nix build (nora + local nixpkgs)

splitter-engine/ (Lean project)
├── lakefile.toml     — Lean 4 v4.28.0 + Mathlib
├── RequestProject/   — SplitDecls.lean + MicroLean.lean
└── split-lean-project.sh / split-aristotle-project.sh
```

## Data Flow

```
Aristotle API
  → download → aristotles_results/<uuid>_aristotle/
  → split    → split-results/<uuid>/  (one dir per decl)
  → decl-table → merged declarations
  → index   → aristotle-blocks.json (DASL-compatible)
```

## Config

- Location: `~/.config/aristotle-manager/config.toml`
- Key fields: `base_dir`, `results_dir`, `git_base`, `max_parallel_downloads`
- API key: `ARISTOTLE_API_KEY` env or `configure set`

## Build

```bash
cargo build --release
# Or via Nix:
nix develop -c cargo build --release
```

## Makefile Targets (Rust-driven)

```bash
make all          # cargo run --release -- build
make poll         # cargo run --release -- poll
make split        # cargo run --release -- split
make split-all    # cargo run --release -- split-all
make results      # cargo run --release -- results
make clean        # cargo run --release -- clean
```
