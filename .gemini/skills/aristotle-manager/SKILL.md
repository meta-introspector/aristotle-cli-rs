---
name: "aristotle-manager"
description: "Aristotle Manager — Rust CLI tool for polling the Aristotle API, downloading Lean4 project tarballs, extracting them, splitting declarations into per-file Nix flakes, and indexing results. Use when downloading Aristotle projects, running split-all on Lean math projects, or working with Aristotle API results."
---

# aristotle-manager — Aristotle Project Pipeline

**Location:** `/mnt/data1/time-2026/05-may/07/arist/`
**Binary:** `target/release/aristotle-manager` (8.0 MB)
**Lines:** ~1,600 Rust across `src/main.rs`, `src/index.rs`, `src/notebooklm.rs`

## Quick Start

```bash
cd /mnt/data1/time-2026/05-may/07/arist

# Build
cargo build --release

# Show help
cargo run -- --help

# Key commands
cargo run -- download -j 2              # Download all Aristotle projects
cargo run -- download --limit 10        # Download first 10
cargo run -- split-all                  # Split all projects into decl flakes
cargo run -- split-all --dry-run        # Preview split
cargo run -- index                      # Generate aristotle-blocks.json
cargo run -- results                    # Show build results
cargo run -- configure show             # Show config
```

## Architecture

```
aristotle.harmonic.fun/api/v3
        │
        ▼
┌──────────────────────────────────┐
│  aristotle-manager download       │  Paginated API polling
│  164 projects → 960MB             │  Parallel downloads (tokio)
│  aristotles_results/*_aristotle/  │  Gzip extraction, retry logic
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  aristotle-manager split-all      │  Calls split-aristotle-project.sh
│  Per project:                     │  for each *_aristotle/ dir
│  1. Detect RequestProject module  │
│  2. Build with shared mathlib     │
│  3. Run SplitDecls.lean           │
│  4. Emit per-decl flake.nix       │
└──────────────┬───────────────────┘
               │
               ▼
        split-results/              │  Per-project decls
        mathlib-split/              │  Deduplicated unified pool
```

## Commands

| Command | Description |
|---------|-------------|
| `download -j N --limit M` | Download projects from Aristotle API |
| `split-all --dry-run` | Preview split plan |
| `split-all` | Run SplitDecls on all projects |
| `index` | Scan aristotle runs, produce DASL blocks.json |
| `split` | Lean declaration-level splitter (legacy) |
| `merge` | Merge split results |
| `decl-table` | Build canonical declaration table |
| `refresh` | Full pipeline: download → split → decl-table |
| `notebooklm --project-dir` | Export project to NotebookLM text |
| `configure set --api-key` | Set Aristotle API key |
| `configure show` | Show configuration |

## Configuration

Default config at `~/.config/aristotle-manager/config.toml`:

```toml
base_dir = "aristotles_results"       # All paths relative to CWD
results_dir = "aristotles_results"    # Downloaded tarballs + extraction
git_base = "aristotles_results"       # Project directories
max_parallel_downloads = 4
retry_wait_seconds = 10
max_retries = 3
```

## Dependencies

- **Rust crates:** tokio, reqwest, clap, serde, serde_json, toml, flate2, tar,
  chrono, tracing, walkdir, rusqlite, dirs
- **Lean4:** lake, lean (from nix store)
- **Mathlib:** v4.28.0 (cached in splitter-engine/.lake/packages/)
- **Nix:** flake.nix with devShell (rust, openssl, pkg-config)

## Key Files

| File | Purpose |
|------|---------|
| `src/main.rs` | CLI dispatcher + download, build, split, merge commands |
| `src/index.rs` | DASL blocks.json indexer (Monster, CFSG, Lean categories) |
| `src/notebooklm.rs` | NotebookLM text export (word limit chunking) |
| `src/tests.rs` | Unit + integration tests |
| `flake.nix` | Nix dev shell + package |
| `split-aristotle-project.sh` | Per-project split wrapper |
| `dedup-split.py` | Deduplicate + fix flake paths |
| `prime-stratify.py` | j-invariant prime band stratification |

## API Key

Set via env var or CLI:
```bash
export ARISTOTLE_API_KEY=arstl_...
cargo run -- configure set --api-key arstl_...
```

## Related Skills

- [[aristotle-splitter]] — SplitDecls engine and per-project splitting
- [[aristotle-mathlib-split]] — Unified deduplicated declaration pool
- [[aristotle-j-invariant]] — j-invariant q-expansion prime stratification
- [[lean-split]] — Per-module Nix flakes for Lean 4 projects
- [[aristo-tools]] — Downloading and processing Aristotle projects
