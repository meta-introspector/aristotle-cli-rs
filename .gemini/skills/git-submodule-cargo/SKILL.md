---
name: "git-submodule-cargo"
description: "Working with git submodules in cargo projects - initializing, updating, handling untracked content. Use when user encounters submodule issues in cargo workspaces."
---

# Git Submodules in Cargo Projects

## Basic Workflow

### Check submodule status
```bash
git submodule status
```

### Initialize and update
```bash
git submodule update --init
git submodule update --init --recursive  # for nested submodules
```

### Add new submodule
```bash
git submodule add <url> <path>
```

## Common Issues

### "untracked content" in submodules
```
modified:   workload/workspaces/cargo-rail (untracked content)
```
This means the submodule has untracked files in its working directory.

**Solutions**:
- Commit inside submodule: `cd path && git add . && git commit`
- Or ignore: `.gitignore` the parent, not the submodule content

### Submodule blocks `git add .`

Error: `error: 'newroot/' does not have a commit checked out`

**Solutions**:
1. Initialize: `git submodule update --init`
2. Add files individually (skip submodule): `git add file1.rs file2.rs`
3. Remove from index: `git rm --cached path` (if accidentally added)

### Detached HEAD in submodule

Submodules can end up in detached HEAD state.

**Fix**:
```bash
cd submodule/path
git checkout <branch>
```

## Cargo-specific Patterns

When cargo dependencies are in submodules:
- Ensure `.cargo/config.toml` points to local paths
- Use `patch` section in workspace Cargo.toml to redirect dependencies
- Example:
```toml
[patch.crates-io]
some-crate = { path = "../external/some-crate" }
```

## Checking which submodules exist
```bash
cat .gitmodules
```

## Bulk Submodule Operations

### Add multiple submodules from list
```bash
while read repo path; do
  git submodule add "$repo" "$path"
done < submodules.txt
```

### Initialize all at once
```bash
git submodule update --init --recursive
```

### Remove submodule
```bash
git submodule deinit -f path/to/submodule
rm -rf .git/modules/path/to/submodule
git rm -f path/to/submodule
```
