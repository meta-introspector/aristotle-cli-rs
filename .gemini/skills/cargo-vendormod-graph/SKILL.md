---
name: cargo-vendormod-graph
description: Building, analyzing, and partitioning Rust dependency graphs for Solana universe. Use with global-graph commands.
---

# Cargo-Vendormod Dependency Graph Operations

## Build Dependency Graph

```bash
# Build graph from workspace using cargo metadata
cargo run --bin vendormod -- build-graph --workspace-path /path/to/solana/workspace

# Include dev and build dependencies
cargo run --bin vendormod -- build-graph \
  --workspace-path . \
  --include-dev \
  --include-build \
  --output-dir ./graph_output
```

## Analyze Graph

```bash
# Analyze graph structure and metrics
cargo run --bin vendormod -- analyze-graph --input-path graph.json --output-dir ./analysis

# Output includes:
# - Node count, edge count
# - Strongly connected components
# - Topological ordering
# - Circular dependency detection
```

## Visualize Graph

```bash
# Generate DOT format for Graphviz
cargo run --bin vendormod -- visualize-graph \
  --input-path graph.json \
  --output-path graph.dot

# Convert to SVG
dot -Tsvg graph.dot -o graph.svg
```

## Partition Graph

```bash
# Partition for parallel processing (Kaminpar algorithm)
cargo run --bin vendormod -- partition-graph \
  --input-path graph.json \
  --partition-count 8

# Partition for Nix builds
cargo run --bin vendormod -- partition-graph \
  --input-path graph.json \
  --partition-count 4 \
  --algorithm kaminpar \
  --output-dir ./nix_partitions
```

## TOML Structure Analysis

```bash
# Analyze Cargo.toml patterns across workspace
cargo run --bin vendormod -- graph toml-structure \
  --input-path graph.json \
  --output-dir ./toml-analysis
```

## Key Data Structures

- `GlobalDependencyGraph` - Main graph container
- `DependencyNode` - Crate representation (id, version, features)
- `DependencyEdge` - Dependency relationships (Direct, Transitive, Dev, Build)
- `TomlStructure` - Cargo.toml schema analysis
- `GraphPartition` - Partition for parallel builds

## Output Files

- `graph.json` - Full graph data
- `partitions/*.json` - Per-partition crate lists
- `analysis/*.json` - Metrics and analysis