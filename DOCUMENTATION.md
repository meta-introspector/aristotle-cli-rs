# Aristotle Manager — Complete System Documentation

## Overview

A Rust + Lean4 pipeline that:
1. **Downloads** Aristotle API projects (169 mathematical formalizations)
2. **Splits** each project into per-declaration Nix flakes using the Lean4 kernel API
3. **Deduplicates** into a unified `mathlib-split/` — 5,790 unique declarations
4. Each declaration is a standalone Nix package with relative dependency paths

## Architecture

```
aristotle.harmonic.fun API
        │
        ▼
┌──────────────────────────────────┐
│  aristotle-manager download      │  Rust CLI (tokio, reqwest)
│  -j 2 --limit N                  │  Parallel downloads, pagination
│  164 projects → 960MB tarballs   │  UUID tracking, retry logic
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  aristotle-manager split-all     │  Calls split-aristotle-project.sh
│  Per-project:                    │  for each *_aristotle/ dir
│  1. Copy RequestProject/*.lean   │
│  2. lake build (shared mathlib)  │
│  3. Run SplitDecls.lean          │
│  4. Emit per-declaration flake   │
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  split-results/                  │  43 projects, 6,698 total
│  <project>/Split/<decl>/         │  Per-project transitive closures
│    ├── <decl>.lean               │
│    └── flake.nix                 │
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  dedup-split.py                  │  Deduplication + path fixer
│  mathlib-split/                  │  5,790 unique, 5,792 flakes
│  Split/<decl>/                   │  11.3 MB, relative paths
│    ├── <decl>.lean               │  DAG: 5,792 nodes
│    └── flake.nix                 │
└──────────────────────────────────┘
```

## Commands

### Download
```bash
cargo run --release -- download -j 2          # All projects
cargo run --release -- download --limit 50    # First 50
cargo run --release -- download --verbose    # With debug output
```

### Split
```bash
cargo run --release -- split-all             # All projects
cargo run --release -- split-all --dry-run   # Preview
```

### Deduplicate
```bash
python3 dedup-split.py
```

### Other
```bash
cargo run --release -- index                 # Generate blocks.json
cargo run --release -- results               # Show build results
cargo run --release -- configure show        # Show config
cargo run --release -- notebooklm --project-dir <dir>  # Export for NotebookLM
```

## Directory Layout

```
aristotle-manager/
├── src/
│   ├── main.rs           # CLI, download, split, config, build, merge
│   ├── index.rs          # DASL blocks.json indexer with categorization
│   ├── notebooklm.rs     # NotebookLM text export
│   └── tests.rs          # Unit + integration tests
├── splitter-engine/      # Lean4 splitter (from Aristotle project fa51bcab)
│   ├── lakefile.toml     # Builds splitdecls + mathlib v4.28.0
│   ├── RequestProject/
│   │   ├── SplitDecls.lean    # 274L: Multi-root BFS, iterative DFS topo sort
│   │   ├── DupFinder.lean     # Exact duplicate detection
│   │   ├── GradedCodeModel.lean  # Graded algebra model
│   │   └── ... (37 Lean files)
│   └── .lake/packages/mathlib/  # Cached mathlib (573MB)
├── split-aristotle-project.sh   # Wrapper: build+split per project
├── split-lean-project.sh        # Low-level: split single module
├── dedup-split.py               # Deduplicate + fix flake paths
├── flake.nix                    # Nix dev shell + package
└── Cargo.toml                   # Rust dependencies
```

## SplitDecls Algorithm

The core splitter (`RequestProject/SplitDecls.lean`, 274 lines):

1. **importModules** — loads the Lean4 environment with mathlib
2. **declsInModules** — kernel-level module index lookup (precise, not regex)
3. **bfsClosure** — multi-root BFS within the declaration universe
4. **topoSort** — iterative depth-first post-order (O(V+E), cycle-safe)
5. **emitDeclFile** — one `.lean` stub per declaration with `import Split.<dep>`
6. **emitDeclFlake** — one `flake.nix` per declaration with `path:../<dep>` inputs
7. **emitDag** — full dependency graph as JSON

Key improvements over local `lean-split-decls/SplitDecls.lean`:
- Multi-root BFS instead of single-root
- Kernel `getModuleIdxFor?` instead of string prefix matching
- Iterative DFS topo sort instead of O(n²) loop
- Portable `path:...` flake inputs instead of hardcoded git URLs

## Configuration

Default config at `~/.config/aristotle-manager/config.toml`:

```toml
base_dir = "aristotles_results"       # Logs, processed.txt, projects.json
results_dir = "aristotles_results"    # Downloaded tarballs
git_base = "aristotles_results"       # Extracted project directories
max_parallel_downloads = 4
retry_wait_seconds = 10
max_retries = 3
```

All paths are relative to CWD (no hardcoded /home/mdupont).

## mathlib-split Structure

Each declaration in `mathlib-split/Split/<name>/`:

**`eq_self.lean`**:
```lean
import Split.True
import Split.eq_true
import Split.Eq
import Split.rfl

-- eq_self from environment
-- theorem eq_self : ...
-- Stub: this file represents the declaration `eq_self`
```

**`eq_self/flake.nix`**:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    True.url = "path:../True";        # ← relative!
    eq_true.url = "path:../eq_true";
    Eq.url = "path:../Eq";
    rfl.url = "path:../rfl";
  };
  outputs = { self, nixpkgs, flake-utils, True, eq_true, Eq, rfl }:
    # Standard Nix derivation wrapping the .lean file
}
```

## Statistics

| Metric | Value |
|--------|-------|
| Projects downloaded | 164 |
| Projects split | 43 (others: no RequestProject/ or build failed) |
| Total declarations (before dedup) | 6,698 |
| Unique declarations (after dedup) | 5,790 |
| DAG nodes | 5,792 |
| mathlib-split size | 11.3 MB (files), 71 MB (with DAG) |
| Duplication ratio | 1.15x |
| Top project | MicroLean (4,410 decls) |
| Average decls per project | 156 |
| Most duplicated decl | Unit, String, SizeOf (4 projects each) |

## Dependencies

- **Rust**: tokio, reqwest, clap, serde, flate2, tracing, rusqlite
- **Lean4**: lake, lean, mathlib4 v4.28.0
- **Nix**: nixpkgs-unstable, nora rust toolchain

## Build

```bash
nix-shell                    # Enter dev environment
cargo build --release        # Build Rust binary
cd splitter-engine && lake build splitdecls  # Build splitter (first time: fetches mathlib)
```
