---
name: cargo-vendormod-workload
description: Collect repo info, build actions plans, run recursive workload vendoring, and generate workload reports. Use for workload processing and DASL workloads.
---

# Cargo-Vendormod Workload

## Recursive Workload Processing

```bash
cargo run --bin workload_processor -- /path/to/workspace
cargo run --bin processing -- workload --workspace-path ~/dasl/IMPL
```

## Repo Discovery

```bash
cargo run --bin scanner -- ~/dasl/IMPL
cargo run --bin full_scan -- ~/dasl/IMPL
cargo run --bin extract_git_refs -- --repo-dir ~/dasl/IMPL
cargo run --bin scan_mirrors -- --mirrors-dir ~/git
```

## Workload Report

```bash
cargo run --bin workload_report -- --input ./workload_output --output ./report
```

## Key Library Types

- `RepoIdentifier`
- `RepoAction`
- `WorkloadMetrics`
- `RepoProcessDetail`

## Entrypoints

- `collect_repo_info(ctx)`
- `create_actions_plan(ctx, repo_info_map)`
- `process_workload_recursive(root)`
