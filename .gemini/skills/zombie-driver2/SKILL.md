---
name: zombie-driver2
description: Rust compiler analysis suite with IPLD CAR shared memory, Monster group theory integration, spectral analysis, and OCI deployment. Use when working with the zombie_driver2 project, its 200+ analysis binaries, IPLD thought store, conformal field theory plugin, or OCI/Terraform deployment.
---

# Zombie Driver 2

Comprehensive semantic analysis and code intelligence system for Rust compiler internals, integrated with IPLD CAR shared memory for content-addressed compiler thoughts.

## Project Structure

```
zombie_driver2/
├── src/                   # Core library modules
│   ├── analysis_store.rs  # Analysis data store with IPLD integration
│   ├── plugin_driver.rs   # Monadic plugin driver with IPLD event storage
│   ├── main.rs            # Rustc driver integration entry point
│   ├── p2p_server.rs      # P2P compilation cluster server
│   └── api_v1.rs          # REST API v1
├── zombie-ipld-memory/    # IPLD CAR shared memory backend
│   ├── src/thought_store.rs  # CompilerThoughtStore: connect, store, query
│   ├── src/thought_types.rs  # Shared types: LlmIteration, CompileResult, etc.
│   └── src/zombie_types.rs   # Zombie-specific: AstFragment, MirFragment, etc.
├── zombie-cft/            # Conformal field theory → DA51 CBOR shards
│   ├── src/lib.rs         # Monster-64 barrel hash, syn AST → CFT
│   └── src/main.rs        # CLI: analyze single file or batch directory
├── terraform/             # OCI deployment (ARM A1.Flex, Always Free)
├── ~200 .rs analysis bins # Self-contained analysis tools
└── flake.nix              # Nix build with IPLD CAR dependencies
```

## When to Use This Skill

- Editing any `.rs` file in the zombie_driver2 project
- Working with the IPLD CAR shared memory (`zombie-ipld-memory`)
- Working with the conformal field theory plugin (`zombie-cft`)
- Debugging IPLD thought store connections
- Deploying to OCI via Terraform
- Running analysis binaries
- Understanding the rustc plugin driver integration
- Working with system-manager deployment

## Key Architecture Decisions

### IPLD CAR Shared Memory Integration

Both `AnalysisDataStore` and `PluginDriver` now integrate with `CompilerThoughtStore` from `zombie-ipld-memory`. This provides content-addressed storage with CID-based deduplication.

**Pattern**: Each struct has an `Option<CompilerThoughtStore>` field. If the IPLD CAR shmem server is available (abstract Unix socket), store operations are mirrored there. If not, they fall back to file-backed storage.

```rust
// Graceful degradation pattern
let thought_store = CompilerThoughtStore::connect()
    .map_err(|e| { tracing::debug!("IPLD not available: {e}"); e })
    .ok();
```

### Thought Types (shared between zos-server and zombie_driver2)

All types are in `compiler/` path prefix. Both projects share:
- `LlmIteration` — LLM fix loop iterations
- `CompileResult` — Compilation attempt results
- `AnalysisArtifact` — Tool-produced analysis data
- `TypeMapEntry` — Rustc type context entries
- `PluginEvent` — Compiler plugin events

Zombie-specific extensions:
- `AstFragment`, `HirFragment`, `MirFragment` — Intercepted compiler IR
- `PtraceEvent` — System call traces
- `SpectralResult` — Frequency analysis
- `EigenmatrixResult` — Eigenvalue decomposition

### Monster-64 Barrel Hash

The `zombie-cft` crate uses a custom barrel hash with 20 Monster-group primes for rotation. Hash is collision-resistant for AST dedup across crates.

## Common Tasks

### Build & Test

```bash
# Build all binaries
cargo build

# Run all tests
cargo test

# Build specific analysis binary
cargo run --bin semantic_signature_generator

# Test the IPLD thought store (expects no server — tests graceful failure)
cargo test -p zombie-ipld-memory
```

### Run Analysis

```bash
# Semantic analysis
cargo run --bin semantic_signature_generator

# Spectral analysis
cargo run --bin spectral_zombie_rustc

# Monster group analysis
cargo run --bin monster_group_connection

# Conformal field theory (Rust AST → DA51 CBOR)
cargo run -p zombie-cft -- analyze path/to/file.rs
cargo run -p zombie-cft -- batch path/to/src/ -o output/
```

### Deploy (System Manager)

```bash
# Build the system-manager config
nix build ".#systemConfigs.zombie-driver2" --no-link --print-out-paths

# Apply to system (requires sudo)
nix run github:numtide/system-manager -- switch --flake .#zombie-driver2 --sudo
# Or use local:
./deploy.sh
```

### Deploy (OCI)

```bash
# Quick deploy to Oracle Cloud Always Free
./deploy-oci.sh

# Manual with Terraform
cd terraform && terraform init && terraform apply

# Rust-based deployer
cargo run --bin oci_deployer -- "<compartment_id>"
```

## File Creation Guidelines

### New analysis binary
- Single `.rs` file at project root
- Add `[[bin]]` entry to `Cargo.toml`
- Add a test module at the bottom of the file

### Extending thought store
- Add new type to `zombie-ipld-memory/src/thought_types.rs` (shared) or `zombie_types.rs` (zombie-specific)
- Add store method to `CompilerThoughtStore` in `thought_store.rs`
- Add path constructor function
- Wire into `AnalysisDataStore` or `PluginDriver` if needed

### Adding a workspace member
- Create directory with `Cargo.toml`
- Add to workspace `members` in root `Cargo.toml`
- If it has a `flake.nix` reference, ensure `flake.nix` in root has path

## Dependencies

| Crate | Purpose |
|-------|---------|
| `zombie-ipld-memory` | IPLD CAR shared memory for compiler thoughts |
| `ipld-car-ipc-shmem-linux` | Underlying IPC client (path: `~/dasl/ipld-car-ipc-shmem-linux`) |
| `zombie-cft` | Conformal field theory → DA51 CBOR shards |
| `syn` | Rust AST parsing (v2, full features) |
| `libloading` | Dynamic `.so` plugin loading |
| `libp2p` | P2P compilation cluster |
| `nalgebra` | Linear algebra for eigenmatrix |
| `goblin` | ELF binary analysis |
| `arrow` / `parquet` | Columnar data export |

## Integration with ZOS Server

The zombie_driver2 and zos-server share the same IPLD CAR shmem server at `@ipld_car_shmem`. Both write to the `compiler/` path prefix, enabling cross-process introspection where LLM iterations from zos-server and AST/HIR/MIR fragments from zombie_driver2 coexist in the same content-addressed store.
