---
name: "cargo-vendormod-atlas"
description: "Finite simple group theory repository classification and ZKperf integration. Use for mathematical analysis of codebases."
---

# Cargo-Vendormod Mathematical Atlas

## Repository Classification

Repositories are classified using finite simple group theory:

| Family | Complexity Range | Characteristics |
|--------|------------------|-----------------|
| Cyclic | 0.0 - 1.0 | Prime order groups, low complexity |
| Alternating | 1.0 - 2.0 | Aₙ for n ≥ 5, moderate complexity |
| Lie Type | 2.0 - 3.0 | Classical groups, high complexity |
| Sporadic | 3.0+ | Exceptional groups, excellent coverage |

## Run Atlas Generation

```bash
# Generate mathematical atlas for repository
cargo run --bin group_atlas -- --path /path/to/repo --output ./atlas.json

# Simple group atlas mode
cargo run --bin simple_group_atlas
```

## Tile Renderer

```bash
# Run interactive CLI tile renderer
cargo run --bin final_cli_tile_renderer

# Simple repository atlas
cargo run --bin repository_mathematical_atlas
```

## ZKperf Integration

```bash
# Run ZKperf coverage tests
./zkperf_coverage_test_runner

# Run ZKperf integration tests
./zkperf_integration_test_runner

# Run comprehensive ZKperf testing
./zkperf_coverage_performance_test_runner
```

## Test Suite

```bash
# Run standalone test suite
./final_standalone_test_runner

# Run integration test suite
./integration_test_runner

# Run benchmark tests
./final_benchmark_runner
```

## Metrics Calculated

- **Complexity Score**: Based on stars, forks, contributors, size, activity
- **Group Order**: Mathematical order of the group
- **Group Rank**: Mathematical hierarchy rank
- **Tile Size**: Logarithmic scale based on group order
- **Tile Color**: Family identification (red, teal, blue, green)

## Output Formats

- JSON: `atlas.json` - Full mathematical analysis
- HTML: `atlas.html` - Visual tile representation
- Markdown: `atlas.md` - Human-readable report
