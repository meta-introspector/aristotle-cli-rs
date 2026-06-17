---
name: "cargo-vendormod-processing"
description: "Process Rust crates in topological order with Nix flake generation. Use for building workspaces."
---

# Cargo-Vendormod Crate Processing

## Process Crates (Topological Order)

```bash
# Full processing with flakes and compilation
cargo run --bin processing -- crates \
  --workspace-path /path/to/workspace \
  --output-dir ./processed \
  --generate-flakes \
  --compile-standalone \
  --layered-processing
```

## Process All Crates from File

```bash
# Process crates listed in file (one per line)
cargo run --bin processing -- all \
  --input-file crates.txt \
  --output-dir ./output \
  --max-parallel 8
```

## Run Full Workflow

```bash
# Standard workflow: full analysis + processing
cargo run --bin processing -- workflow \
  --workspace-path /path/to/workspace \
  --output-dir ./output \
  --workflow-type standard

# Minimal workflow: basic processing only
cargo run --bin processing -- workflow \
  --workspace-path . \
  --workflow-type minimal

# CI workflow: read-only analysis
cargo run --bin processing -- workflow \
  --workspace-path . \
  --workflow-type ci
```

## Generate Report

```bash
# Generate crate report
cargo run --bin processing -- report \
  --workspace-path /path/to/workspace \
  --output-dir ./crate_report
```

## Layer Processing

The tool ensures:
1. Dependencies are processed before dependents
2. Cycle detection prevents infinite loops
3. Parallel processing via Rayon
4. Layer-based processing for complex workspaces

## Nix Flake Generation

```bash
# Generate flakes for each crate
cargo run --bin processing -- crates . --generate-flakes

# Build Nix pipeline
cargo run --bin processing -- workflow /path/to/flakes --max-parallel 8
```

## Key Options

| Flag | Description |
|------|-------------|
| `--generate-flakes` | Create Nix flakes for each crate |
| `--compile-standalone` | Build each crate independently |
| `--layered-processing` | Process in dependency layers |
| `--max-parallel` | Number of parallel threads |
| `--workflow-type` | standard/minimal/ci |

## Output Directories

- `processed/` - Compiled crates
- `flakes/` - Nix flake definitions
- `analysis/` - Processing logs and reports
- `partitions/` - Graph partition output
