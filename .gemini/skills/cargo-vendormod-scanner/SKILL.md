---
name: "cargo-vendormod-scanner"
description: "Discover and classify repositories, crates, and sanitized references in cargo-vendormod workloads. Use when scanning directories for Cargo.toml files, collecting repo info, or cleaning git references."
---

# Cargo-Vendormod Scanner

## Purpose

`reposcan`, `repofilter`, and reference-cleaning tools turn a directory tree into cleaned metadata and repeatable scan output.

## CLI / Script Entrypoints

```bash
# Basic scan
python3 scripts/reposcan.py ~/dasl/IMPL --output scan.json

# Sanitize git refs
bash scripts/clean_git_refs.sh
```

## Rust Library Entrypoints

```rust
use cargo_vendormod::repo_collection::{RepoIdentifier, collect_repo_info};
use cargo_vendormod::submodule_discovery::discover_submodules;
use cargo_vendormod::workspace::{discover_all_git_repositories, find_workspace_cargo_files};
```

## Key Outcomes

- `all_cargo_tomls.txt`
- `all_git_refs.txt`
- `clean_git_refs.txt`
- scan report JSON

## Workflow

1. Clone or mirror target repos into a workspace.
2. Run repo scan to enumerate Cargo.toml and git remotes.
3. Run `collect_repo_info_from_lock` on each lockfile to build `RepoIdentifier` map.
4. Sanitize refs before binding to Nix or LLM pipelines.
