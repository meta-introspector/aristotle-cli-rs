---
name: dag-cbor-restriction-morphisms
description: Build, test, and verify CBOR, DAG-CBOR, DRISL, IPLD, libipld, serde_ipld_dagcbor, rust-ipld-core, rust-ipld-dagpb, fuzz, and test-suite crates with cargo-vendormod. Use for dag-cbor workload management, flake coverage, encoding/decoding tests, fuzzing, and compliance tooling.
---

# DAG-CBOR Restricted-Morphisms Workflow

## Scope

This skill focuses on the CBOR serialization ecosystem around `~/dasl`:

- rust-ipld-core
- serde_ipld_dagcbor
- libipld
- libipld-fuzz
- rust-ipld-dagpb
- pyfisch/cbor
- dasl-testing (conformance fixtures)
- Supporting repos: cddl, daslbench

## Detect Dag-CBOR Projects

```bash
python3 ~/dasl/IMPL/dag-cbor-services.nix ...   # or repo-scope metadata
cargo run --bin cargo-vendormod -- flake-check --flakes-dir path/to/flakes
```

## Generate Flake Coverage Report

```bash
cargo run --bin cargo-vendormod -- flake-check \
  --flakes-dir ./final_processing_output/flakes \
  --json report.json
```

Closure:
- `crate2nix` build via Nix
- `cargo test`, `cargo fuzz run`
- `serde_ipld_dagcbor` encode/decode roundtrip
- `libipld` IPLD traversal

## Build Only CBOR/IPLD Targets

```bash
cargo run --bin processing -- crates ./flakes/ipld-core ./flakes/serde_ipld_dagcbor \
  --generate-flakes --compile-standalone
```

## Add New Unit Test

```bash
cp tests/basic_tests.rs tests/dag_cbor_tests.rs
# edit
cargo test --test dag_cbor_tests
```

## Fuzz Workflow

```bash
cargo run --bin processing -- fuzz libipld-fuzz-libipld-fuzz
```

## Key Libraries Used

- `cargo_vendormod::flake_check::check_flake_coverage`
- `cargo_vendormod::config::Config`
- `cargo_vendormod::global_dep_graph::{GlobalDependencyGraphBuilder, DependencyNode, DependencyEdgeType}`
- `toml_edit::DocumentMut`
- `serde::{Serialize, Deserialize}`

## New Unit Test Patterns

```rust
use cargo_vendormod::{self, config::Config};
use tempfile::tempdir;
use std::path::PathBuf;

#[test]
fn test_target_project_construction() {
    let proj = TargetProject { ... };
    assert_eq!(proj.category, ProjectCategory::CborLib);
}

#[test]
fn test_target_projects_includes_ipld_crates() {
    let projects = target_projects();
    let names: Vec<_> = projects.iter().map(|p| p.name.as_str()).collect();
    assert!(names.contains(&"serde_ipld_dagcbor"));
    assert!(names.contains(&"ipld-core"));
    assert!(names.contains(&"libipld (w/ fuzz)"));
}

#[test]
fn test_dag_cbor_crate_names_normalized() {
    let dir = tempdir().unwrap();
    let toml = dir.path().join("Cargo.toml");
    std::fs::write(&toml, r#"[package]\nname = "serde-ipld-dag-cbor"\nversion = "0.1.0"\n"#).unwrap();
    // exercise detector / parser paths
}
```

Create tests files at:
- `tests/dag_cbor_tests.rs`
- `tests/serde_ipld_dagcbor_roundtrip_tests.rs`
- `tests/libipld_fuzz_tests.rs`
