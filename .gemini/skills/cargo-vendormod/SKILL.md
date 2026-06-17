---
name: "cargo-vendormod"
description: "Cargo-vendormod — git submodule vendoring for Cargo. 8 subcommands (ingest, memecache-upgrade, memecache-gc, scan-index, scan-delta, scan-catalog, scan-tree, deep-scan) + compile-to-shmem + MCP server + module tree visualization tile. Use when managing cargo dependencies as git submodules, compiling crates to IPLD CAR shmem, running file scanners with Hecke spectral scoring, or working with NORA registry integration."
---

# cargo-vendormod — Git Submodule Vendoring for Cargo

**Location:** `~/dasl/IMPL/cargo-vendormod/` (or worktrees under `worktrees/`)
**Worktree:** `refactor-main` for active development
**Lines:** ~17K across 30+ modules, 22+ binaries

## Quick Start

```bash
cd ~/dasl/IMPL/cargo-vendormod

# Build
cargo build --release

# Show help
cargo run -- --help

# All commands (10+)
cargo run -- ingest --source-dir ~/dasl --output-dir /tmp/registry
cargo run -- memecache-upgrade --workspace-path . --strategy conservative
cargo run -- memecache-gc --registry-path /tmp/registry
cargo run -- scan-index --file-list files.txt --index-dir /tmp/idx --format json
cargo run -- scan-delta --dir .
cargo run -- scan-catalog
cargo run -- scan-tree
cargo run -- deep-scan
cargo run -- compile-to-shmem --crate-path . --workflow all
cargo run --bin cargo-vendormod-mcp  # MCP server (stdio)
```

## New (2026-06-12): compile-to-shmem + MCP Server

### compile-to-shmem (47MB binary)

Compiles any Rust crate and pushes build artifacts + metadata to IPLD CAR shared
memory, then applies vendormod workflows.

```bash
cargo run --bin compile-to-shmem -- --crate-path /path/to/crate
cargo run --bin compile-to-shmem -- --crate-path . --skip-build --workflow normalize,nix
cargo run --bin compile-to-shmem -- --help
```

Options: `--crate-path`, `--skip-build`, `--workflow`, `--output-dir`,
`--shmem-socket`, `--dry-run`, `-v`.

### MCP Server (cargo-vendormod-mcp)

Model Context Protocol server over stdio. 5 tools:

| Tool | Description |
|------|-------------|
| `compile_to_shmem` | Compile → IPLD shmem + workflows |
| `normalize_cargo_toml` | Sort deps, ensure `[package]` fields |
| `generate_flake_nix` | Generate `flake.nix` |
| `scan_crates` | Find all `Cargo.toml` in tree |
| `dasl_index` | Register in DASL `grep_rs.txt` |

```bash
# Test
printf '{"jsonrpc":"2.0","id":1,"method":"initialize",...}' | cargo-vendormod-mcp
```

### Pi Extension

**Path:** `~/.pi/agent/extensions/vendormod.ts`

Registers 4 pi tools: `vendormod_compile_to_shmem`, `vendormod_normalize`,
`vendormod_generate_flake`, `vendormod_dasl_index`. Each shells out to
`compile-to-shmem` binary.

Load: `pi -e ~/.pi/agent/extensions/vendormod.ts`

### NORA Registry Config

`.cargo/config.toml` in vendormod root:

```toml
[source.crates-io]
replace-with = "nora"

[source.nora]
registry = "sparse+http://127.0.0.1:4000/cargo/index/"

[patch.crates-io]
ipld-car-ipc-shmem-linux = { path = "/home/mdupont/dasl/ipld-car-ipc-shmem-linux" }
```

## Architecture (post-refactoring, jun 7)

```
src/
├── main.rs          (646 lines) — CLI dispatcher + vendoring handlers
├── lib.rs           — 30+ module declarations + re-exports
├── utils.rs         (1093 lines) — shared utilities (6 sections)
│   ├── CID & Hash:       compute_cid()
│   ├── IPLD Shmem:       SHMEM_MAX_SIZE, shmem_put()
│   ├── File Sampler:     FileSample, sample_file(), entropy, Hecke score
│   ├── IngestedSubmodule struct
│   ├── Memecache:        handle_memecache_upgrade/gc, parse_crate_version
│   └── Scan Index:       ScannedFile, handle_scan_index, read_parquet_index
├── args.rs          — CLI argument parsing (Commands enum, all Args structs)
├── vendoring.rs     — Core vendoring (submodule operations)
├── vendoring_cmds.rs — High-level vendoring commands
├── global_dep_graph.rs — Dependency graph analysis
├── layer_processor.rs  — Topological crate processing
├── workflow.rs      — High-level workflow orchestration
├── git_wrapper.rs   — Git operations
├── lockfile_parser.rs — Cargo.lock parsing
├── group_atlas.rs   — Finite simple groups atlas
├── visualization.rs — Atlas tile rendering
├── pastbin_atlas.rs — Pastbin integration
├── warm_manager.rs  — Directory warming commands
├── nora_indexer.rs  — NORA index building
├── nur_flake.rs     — NUR flake.nix generation
├── crate_flake.rs   — Per-crate flake generation
└── ... 20+ more modules
```

## 8 Commands

| Command | Purpose | Speed |
|---------|---------|-------|
| `ingest` | Read submodules, build vendormod-registry.json + vendormod.lock | ~60s/597 |
| `memecache-upgrade` | Force-upgrade crate dependencies to latest | varies |
| `memecache-gc` | Clean stale crate versions (>1 version per crate) | ~5s/12K |
| `scan-index` | Multi-source file scanner (text lists, dirs, .gitmodules, parquet, plocate) + file sampler | ~30s/27K |
| `scan-delta` | Fast change detection via IPLD shmem snapshots (stub) | 0.1s |
| `scan-catalog` | Three-tier memory catalog (full/partial/index) (stub) | 0.7s |
| `scan-tree` | Directory tree + git tree capture + diff (stub) | 0.1–2s |
| `deep-scan` | Apply deep scanner to shmem blobs, functor arrows, Hecke scores | 78s/153 |

## Refactoring (jun 7)

26 public items moved from `main.rs` → `utils.rs`:

- **CID & Hash:** `compute_cid()`
- **IPLD Shmem:** `SHMEM_MAX_SIZE`, `IPLD_MEMORY_BIN`, `shmem_put()`
- **File Sampler:** `FileSample`, 4 constants, `sample_file()`, `compute_entropy()`, `compute_hecke_score()`, `count_cids()`
- **Ingested:** `IngestedSubmodule`
- **Memecache:** `handle_memecache_upgrade()`, `count_dependencies()`, `handle_memecache_gc()`, `parse_crate_version()`, `dir_size()`
- **Scan:** `ScannedFile`, `ScannedGitmodule`, `handle_scan_index()`, `read_file_list()`, `read_gitmodules_file()`, `plocate_gitmodules()`, `read_parquet_index()`

Result: main.rs 1703→646 lines (-62%). Full doc at `~/DOCS/VENDORMOD_REFACTOR_MAIN_RS.md`.

## DASL Integration

Vendormod connects to the broader DASL architecture:

- **File Sample + Hecke scores** — `compute_hecke_score()` produces spectral scores used by DASL's hypermorphism analysis of byte-level 0xD8→0x2A Markov transitions
- **IPLD Shmem** — `shmem_put()` stores blocks in the same CAR shmem server used by pastebin, diagonalize, and fuzzing pipelines
- **CID Computation** — `compute_cid()` generates content-addressed identifiers for the vendormod.lock registry
- **Deep Scanner** — `deep-scan` command applies the 2-category hypermorphism analysis to all 153+ IPLD blobs
- **Tile Integration** — tile_composer binary registers tiles in pastebin/nginx

## Key Files

| File | Purpose |
|------|---------|
| `src/main.rs` | CLI dispatcher (646 lines post-refactor) |
| `src/utils.rs` | Shared utilities (1093 lines, 26 public items) |
| `src/lib.rs` | Library root + re-exports |
| `src/args.rs` | CLI argument definitions |
| `src/bin/tile_composer.rs` | Tile composer for pastebin |
| `src/bin/dasl_mitigate.rs` | Mitigation vector generator |
| `src/bin/deep-scanner.rs` | Deep scanner (Hecke/entropy/CID analysis) |
| `src/bin/compile_to_shmem.rs` | Compile to IPLD CAR shmem + vendormod workflows |
| `src/bin/mcp_server.rs` | MCP JSON-RPC server (5 tools) |
| `.cargo/config.toml` | NORA registry config (sparse+http) |
| `flake.nix` | Nix build (uses cargoVendorDir + vendored deps) |
| `vendormod.toml` | Runtime config (warm_dirs, git_path, etc.) |
| `vendormod-registry.json` | Ingest output — submodule registry |
| `vendormod.lock` | CID-indexed submodule lock file |

## Build (Nix)

```bash
cd ~/dasl/IMPL/cargo-vendormod
nix build .#cargo-vendormod
# Or via task flake in worktree
cd worktrees/refactor-main
nix develop
cargo build --release
```

## Related Skills

- [[vendormod-module-tile]] — interactive module tree visualization tile
- [[vendormod-mcp]] — MCP server + pi extension for AI agent invocation
- [[merge-vendor-deps-main]] — vendoring pattern (cargo vendor + cargoVendorDir)
- [[ipld-car-shmem]] — IPLD CAR shmem server (vendormod uses for shmem_put)
- [[nora-car-shmem]] — NORA artifact registry (vendormod nora-indexer feeds)
- [[dasl-tile-onboarding]] — tile creation pattern (vendormod tile_composer)
- [[d8-2a-crane-libbpf]] — crane build pattern (vendormod crane usage in aya-nix)
- [[dasl-testing]] — fuzzing harnesses (vendormod deep-scan feeds results)
- [[nix-flakes]] — flake management (vendormod flake.nix pattern)
- [[nix-build]] — build verification (vendormod cargo check + nix build)
