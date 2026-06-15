---
name: cargo-vendormod-vendoring
description: Git submodule vendoring workflow for cargo-vendormod. Use when initializing vendoring, fetching upstream, rebasing, managing releases, or patching .cargo/config.toml.
---

# Cargo-Vendormod Vendoring Workflow

## Initialize Vendoring

```bash
cargo run --bin vendoring -- init --source-repo .
```

Creates:
- `submodules/` — working copies of each git dependency
- `vendor/` — vendored registry crates
- `.cargo/config.toml` — patch and source entries

## Fetch Upstream

```bash
cargo run --bin vendoring -- fetch-upstream
```

Fetches all upstream remotes into bare mirrors in parallel.

## Rebase Submodules

```bash
cargo run --bin vendoring -- rebase
```

Rebases local submodule commits on top of upstream.

## Release Branches

```bash
cargo run --bin vendoring -- releases
```

Fetches tags and creates version branches in mirrors using `version-branch-format`.

## Sync (Full Cycle)

```bash
cargo run --bin vendoring -- sync
```

Runs fetch → rebase → patch in one step.

## Patch .cargo/config.toml

```bash
cargo run --bin vendoring -- patch
```

Regenerates `[patch.crates-io]` entries pointing to local submodules.

## Submodule Status

```bash
cargo run --bin vendoring -- status
```

Shows commit drift between submodules and mirrors/upstream.

## Configuration

```toml
# vendormod.toml
git-path = "git"
vendor-dir = "vendor"
submodules-dir = "submodules"
mirrors-dir = "~/git"
target-branch = "main"
version-branch-format = "v{}"
create-version-branches = false
default-threads = 8
```

Environment overrides: `VENDORMOD_GIT_PATH`, `VENDORMOD_VENDOR_DIR`, `VENDORMOD_SUBMODULES_DIR`, `VENDORMOD_MIRRORS_DIR`, `VENDORMOD_TARGET_BRANCH`, `VENDORMOD_CREATE_VERSION_BRANCHES`, `VENDORMOD_THREADS`.
