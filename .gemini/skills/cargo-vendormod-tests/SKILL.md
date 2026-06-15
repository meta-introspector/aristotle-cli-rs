---
name: cargo-vendormod-tests
description: Run and extend the cargo-vendormod Rust test suite. Use when the user asks to run tests, add unit tests, check coverage, or debug test failures for cargo-vendormod.
---

# Cargo-Vendormod Test Workflow

## Run Tests

```bash
cargo test
cargo test --test basic_tests
cargo test --test global_graph_tests
cargo test --test topological_tests
cargo test --test integration_tests
```

## Test File Map

| File | Covers |
|------|--------|
| tests/basic_tests.rs | Config defaults, version branch formatting, Args construction, sample config generation |
| tests/global_graph_tests.rs | DependencyNode, DependencyEdge, DependencyEdgeType, GlobalDependencyGraphBuilder, PartitioningAlgorithm, FeatureSet, GraphMetrics |
| tests/topological_tests.rs | Dependency ordering validation, workspace vs external filtering, cycle detection, DAG sorting |
| tests/integration_tests.rs | Filesystem operations, temp dirs, Cargo.toml read/write, path manipulation, error handling |
| tests/layer_processor_tests.rs | Graph node/edge lookup, node map consistency, external vs workspace member identification |

## Add a New Unit Test

1. Identify the module under `src/` that lacks coverage.
2. Add a `#[cfg(test)] mod tests` block at the bottom of that file, or create a new file under `tests/`.
3. Use `tempfile::tempdir()` for filesystem tests.
4. Construct real `cargo_vendormod::` types instead of local copies.
5. Run `cargo test` and fix compiler errors before committing.

## Guidelines

- Prefer behavior tests over mocking.
- Keep tests deterministic; avoid network calls.
- Use `tempfile` for any filesystem side effects.
- Group related tests in the same `mod tests` block.
