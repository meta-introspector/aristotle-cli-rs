# Aristotle Manager — Private Workspace

**This repository contains private project data, intermediate artifacts, and
experimental tooling. Do not push to public remotes.**

The Rust CLI at `src/` is the same binary published as `aristotle-cli-rs`.
This workspace adds the full data tree, Python DASL pipeline scripts, and
per-project Lean output.

## What's in here

| Path | Purpose |
|------|---------|
| `src/*.rs` | Rust CLI (poll, fetch, split, merge, index, pipeline, replay, …) |
| `*.sh` | Shell drivers for split, refresh, bug reports, NotebookLM batch |
| `*.py` | DASL ingestion, dedup, submit, prime-stratify, scan-index helpers |
| `aristotle_results/` | Downloaded `*_aristotle.tar.gz` tarballs + extracted dirs |
| `aristotles_results/` | Same, nested layout with per-project git repos |
| `consolidated-dasl/` | Unified DASL Lean4 corpus (`ConsolidatedDasl/`) |
| `findings-*/` | Lean4 declaration scans and metadata |
| `split-results*/` | Per-declaration split output (per project or DASL) |
| `split-by-band/` | Prime-band partitioned splits (`band-q0` … `band-q4`) |
| `merged-results/` | Post-dedup unified declaration pool |
| `cid-index/`, `arrow-lattice/`, `atomized-lattice/` | DASL content-addressed indexes |
| `dep-graph/`, `j-keyed-lattice/`, `mycelium-graph/`, `spec-cid-index/` | Dependency / lattice graphs |
| `webarchive/` | Archived web pages (Brauer, Monster character table) |
| `nix-flakes/` | Per-band Nix flake outputs |

## Requirements

| Tool | Version | Notes |
|------|---------|-------|
| Rust | 1.85+ | `cargo 1.94+` |
| Lean 4 | v4.28.0+ | `lake` on `PATH` or `LEAN_BIN` |
| Python | 3.10+ | for DASL scripts |
| Nix | — | optional, `nix-shell` / `nix build` |
| Git | — | project dirs are git repos |
| Network | — | `aristotle.harmonic.fun/api/v3` |

### Crate registry

The global `~/.cargo/config` may point at a private Nora mirror (`localhost:4000`).
To build cleanly against crates.io sparse:

```bash
CARGO_REGISTRIES_CRATES_IO_INDEX="sparse+https://index.crates.io/" cargo build
```

If the local nora index is missing versions the lock file pins (e.g. `chrono 0.4.45`,
`http 1.4.2`), regenerate the lock first:

```bash
cargo update
```

## Installation

```bash
# Nix shell (recommended, uses local nixpkgs + nora rust overlay)
nix-shell
cargo build --release

# Or plain cargo (may need CARGO_REGISTRIES_CRATES_IO_INDEX override)
cargo build --release
```

The binary is `target/release/aristotle-manager`.

## Quick Start

```bash
# 1. Configure API key
export ARISTOTLE_API_KEY=your-key
cargo run -- configure set

# 2. Fetch latest projects (incremental)
cargo run -- fetch

# 3. Split declarations (requires SplitDecls.lean in splitter-engine/)
cargo run -- split-all

# 4. Build / verify
cargo run -- build

# 5. Merge into unified pool
cargo run -- merge

# 6. One-shot pipeline
cargo run -- pipeline
```

## Configuration

First run creates `~/.config/aristotle-manager/config.toml`:

```toml
base_dir = "aristotles_results"
results_dir = "aristotles_results"
git_base = "aristotles_results"
max_parallel_downloads = 4
retry_wait_seconds = 10
max_retries = 3
```

- `base_dir` — logs, `aristotle_processed.txt`, `aristotle_projects.json`
- `results_dir` — downloaded `*.tar.gz` tarballs
- `git_base` — extracted `*_aristotle/` project directories

**Note:** `src/main.rs:267` contains a hard-coded fallback that sets `git_base`
to the original dev directory `/mnt/data1/time-2026/05-may/07/arist` when
running from that path. Override via `config.toml` or `--input-dir`.

## CLI Commands

```bash
cargo run --release -- <command> [flags]
```

| Command | Description |
|---------|-------------|
| `fetch` | Incremental poll + download (skips processed IDs) |
| `download [-j N] [--limit N]` | Bulk download all Aristotle projects |
| `check [ID] [--limit N]` | Query project status or list recent |
| `submit <prompt> [--project-dir DIR] [--wait]` | Submit to Aristotle API |
| `download-result <ID> [--output-dir DIR]` | Download tarball for one project |
| `build [--input-dir DIR]` | Run `lake build` in every project |
| `test [--no-fail-fast] [-v]` | Alias for build |
| `poll [--download-only] [-j N]` | Git-pull projects then build |
| `split [--input-dir] [--output-dir]` | Run SplitDecls on one project |
| `split-all [--output-dir] [-j N] [--dry-run]` | Split every project |
| `merge [--input-dir] [--output-dir]` | Merge per-decl `.lean` files |
| `decl-table [--split-dir] [--output]` | Build canonical `decl-table.json` |
| `refresh [-j N] [--limit N]` | download → split → decl-table |
| `pipeline [-j N] [--limit N] [--dry-run]` | fetch → split → verify → version → merge |
| `replay [--output-dir] [--dry-run]` | Rebuild archive chronologically |
| `version [--results-dir] [--output-dir]` | Git-commit each project with metadata |
| `index [--output]` | Write DASL `blocks.json` |
| `scan-index [--index-dir] [--output-dir] [--prefix-filter]` | Ingest file lists / grep results |
| `notebooklm --project-dir DIR` | Export text for NotebookLM |
| `configure set\|show` | API key and settings |
| `results` | Print `result.txt` |
| `clean` | Remove `result.txt` |

Flags: `-j/--parallel`, `--limit`, `--dry-run`, `--input-dir`, `--output-dir`,
`--verbose`, `--trace {console,file,both}`.

## Makefile Targets

```bash
make test            # build + test all Lean4 projects
make poll            # git-pull + build
make poll-results    # fetch new + test
make results         # show result.txt
make refresh         # download → split → decl-table
make clean           # remove result.txt

# Split (Rust+Lean, replaces old Python static_split.py)
make split           # split all via Rust CLI
make split-all       # batch split via shell driver
make split-one PROJ=<uuid>  # split single project
make split-clean     # rm -rf split-results
make decl-table      # canonical decl-table.json
make merge           # merge split results
make index           # DASL blocks.json

# DASL helpers
make dedup-dasl      # split ~/dasl/ Lean files
make dedup-dasl-dry  # count declarations in ~/dasl/

# Rust development
make rust-build      # cargo build --release
make rust-run        # cargo run --release -- <cmd>
make rust-test       # cargo test
make rust-fmt        # cargo fmt
make rust-clippy     # clippy
make help            # full target list
```

## Python Scripts

| Script | Purpose |
|--------|---------|
| `build-dasl-module.py` | Build canonical DASL Lean module (ipld, cbor, monster, …) |
| `build-unified-dasl.py` | Create lake project from DASL module with per-decl `.lean` + `flake.nix` |
| `dedup-split.py` | Deduplicate split output into unified `mathlib-split/` |
| `dasl-index-scanner.py` | Scan DASL index for IPLD/CBOR terms, merge with mathlib subgraph |
| `dasl-term-filter.py` | DASL subgraph with mega-hub filtering (Nat, Eq, Bool removed) |
| `detect-stale.py` | Find projects updated on API since last download |
| `fix-unified-imports.py` | Replace `Split.*` stubs with proper Mathlib imports |
| `locate2proof-collect.py` | Collect locate results, dedup, prepare for locate2proof |
| `partition-dasl.py` | Spectral clustering + community detection on DASL subgraph |
| `prime-stratify.py` | j-invariant prime stratification by q-expansion band |
| `split-source.py` | Source-level Lean splitter (declaration boundaries, original code) |
| `submit-chunks.py` | Submit unified DASL chunks to Aristotle with rate limiting |
| `submit-to-aristotle.py` | Chunk 751 declarations and submit as new project |

## Shell Scripts

| Script | Purpose |
|--------|---------|
| `split-aristotle-project.sh` | Build + SplitDecls on one Aristotle project |
| `split-lean-project.sh` | Low-level SplitDecls on a single Lean module |
| `dedup-split.sh` | Bash wrapper around `dedup-split.py` |
| `refresh.sh` | DASL pipeline: download → git-track → split → dedup → build |
| `run_notebooklm_all.sh` | Batch `notebooklm` export for all projects |
| `test_download.sh` | Quick API connectivity + auth smoke test |
| `bugreport.sh` | Dump environment info for bug reports |

## Data Layout

```
aristotles_results/
├── aristotle_processed.txt          # UUIDs already downloaded
├── aristotle_projects.json          # Full API listing snapshot
├── download.log
├── <UUID>_aristotle/
│   ├── aristotle_metadata.json      # extracted_at, project_dir, tarball size
│   ├── aristotle_status.json        # Raw API status response
│   └── output-final_aristotle/
│       ├── ARISTOTLE_SUMMARY.md
│       ├── *.tar.gz                 # Raw download (cleaned after extract)
│       └── RequestProject/
│           ├── Main.lean
│           ├── SplitDecls.lean      # Project-specific copy
│           └── *.lean
└── split-results/
    └── <UUID>_aristotle/
        ├── Band/
        ├── Math/
        ├── Godel/
        └── …                       # Per-declaration flake.nix trees
```

After `dedup-split.py`:

```
mathlib-split/
└── Split/
    └── <DeclName>/
        ├── <DeclName>.lean
        └── flake.nix               # path:../<dep> inputs, self-contained
```

## DASL Indexes

These live at the repo root and are **private** (content-addressed metadata):

- `cid-index/` — `cid-by-band.json`, `cid-by-prime.json`, `cid-by-ws.json`,
  `cid-index.json`, `cid-manifest.json`
- `arrow-lattice/` — `arrow-lattice.json` (3.6 MB), `arrow-fusion-rules.md`,
  `arrow-lattice.mermaid`
- `atomized-lattice/` — `value-lattice.json` (1 MB), `atomic-imports.md`
- `dep-graph/` — `dep-graph.json`, `dep-graph.dot`, `dep-manifest.json`
- `j-keyed-lattice/` — `j-keyed-lattice.json`, `j-shelf-map.md`
- `mycelium-graph/` — `mycelium-graph.json`, `mycelium-manifest.json`,
  `spore-classification.json`
- `spec-cid-index/` — `spec-by-path.json`, `spec-decl-links.json`,
  `spec-index.json`, `spec-manifest.json`

## Splitter Engine

`split` / `split-all` shell out to `SplitDecls.lean` via `lake env lean --run`.

```bash
export LEAN_SPLITTER=/path/to/SplitDecls.lean
export LEAN_BIN=/path/to/lean/bin
```

If unset, the tool searches the working tree and Nix store paths
(`/nix/store/*lean*/bin/lake`).

The engine is maintained as a separate project
(`/home/mdupont/2026/06-june/26/lean-split-decls`).

## Nix Flake

```nix
{
  inputs = {
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=omaster";
    crane.url = "git+file:///mnt/data1/git/github.com/ipetkov/crane.git?ref=omaster";
    flake-utils.url = "git+file:///mnt/data1/git/github.com/numtide/flake-utils.git?ref=omain";
    rust-overlay.url = "git+file:///mnt/data1/git/github.com/oxalica/rust-overlay.git?ref=omaster";
  };

  outputs = { self, nixpkgs, crane, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ rust-overlay.overlays.default ]; };
        craneLib = crane.mkLib pkgs;
        rawGitSrc = builtins.fetchGit {
          url = "git+file:///mnt/data1/git/github.com/arist/aristotle-manager.git";
          rev = "b96e6c36e52572544389700ed8a437b6e8973d90";
        };
        cleanedSrc = craneLib.cleanCargoSource rawGitSrc;
        cargoArtifacts = craneLib.buildDepsOnly {
          src = cleanedSrc;
          buildInputs = [ pkgs.libgit2 pkgs.openssl.dev pkgs.zlib ];
        };
        myCrate = craneLib.buildPackage {
          src = cleanedSrc;
          cargoArtifacts = cargoArtifacts;
          buildInputs = [ pkgs.libgit2 pkgs.openssl.dev pkgs.zlib ];
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.cargo pkgs.rustc pkgs.rustfmt pkgs.clippy
                       pkgs.libgit2 pkgs.curl pkgs.openssl.dev pkgs.zlib
                       pkgs.nghttp2 pkgs.pkg-config pkgs.cargo-edit ];
          ARISTOTLE_API_KEY = "";
        };
        packages.default = myCrate;
        apps.default = { type = "app"; program = "${myCrate}/bin/aristotle-manager"; };
      }
    );
}
```

```bash
nix build           # build package
nix develop         # enter dev shell
```

## Tracing

```bash
RUST_LOG=debug cargo run -- download --trace both
```

Accepted levels: `error`, `warn`, `info`, `debug`, `trace`.

## Known Issues

- `src/main.rs:267` hard-codes the original dev directory
  `/mnt/data1/time-2026/05-may/07/arist` as a `git_base` fallback.
- `splitter-engine/lean-toolchain` is pinned to `v4.28.0` here; the public
  `aristotle-cli-rs` release targets `v4.29.1`.
- `aristotles_results/` contains nested git repos for ~160 projects; treat
  them as submodules if you clone this workspace.
