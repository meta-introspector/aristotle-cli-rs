---
name: "system-manager-tmpfiles-fix"
description: "Fix system-manager activation errors related to tmpfiles.d configuration. Debug and fix recurring system-manager errors caused by /etc/tmpfiles.d conflicts."
---

# Skill: Fixing system-manager Activation Error for `tmpfiles.d`

This skill details how to debug and fix a recurring activation error in `system-manager` related to `tmpfiles.d` configuration.

## The Problem

When activating a `system-manager` profile, the process may fail with an error similar to this:

```
[ERROR system_manager_engine::activate] Error during activation: Failed to get the canonical path of /nix/store/...-tmpfiles.d/00-system-manager.conf

Caused by:
    No such file or directory (os error 2)
```

This error occurs when the `system-manager` activation script tries to process a file that it expects to exist in the Nix store but is missing.

### Root Cause Analysis

1.  The error originates in the Rust activation script (`crates/system-manager-engine/src/activate/etc_files.rs`).
2.  The script recursively scans a directory of configuration files destined for `/etc`.
3.  During this scan, it calls `fs::canonicalize(path)` on every file, which resolves symlinks.
4.  The `system-manager` Nix module `nix/modules/tmpfiles.nix` is responsible for generating a `tmpfiles.d` directory containing symlinks to `tmpfiles.d` configurations from various packages.
5.  A bug or misconfiguration can cause one of these symlinks to be **broken**. The build-time checks may not catch this.
6.  When the activation script encounters this broken symlink and calls `fs::canonicalize` on it, the operation fails with "No such file or directory", crashing the activation.

## The Fix: Patching the `system-manager` Engine

The most robust solution is to patch the `system-manager` Rust source code to make the activation script resilient to broken symlinks.

**File to Edit:** `crates/system-manager-engine/src/activate/etc_files.rs`

**Logic:** In the `list_static_entries` function, instead of calling `fs::canonicalize` directly, we first check if the path is a valid, non-broken symlink. If it is broken, we log a warning and skip it.

### Implementation

Replace the original block of code inside the `for file in dir_content` loop:

**Original Code (`list_static_entries` loop):**
```rust
let canon_path = fs::canonicalize(file.path()).context(format!(
    "Failed to get the canonical path of {}",
    file.path().display()
))?;
if canon_path.is_dir() {
    // ... logic for directory
} else {
    // ... logic for file
}
```

**Patched Code (`list_static_entries` loop):**
```rust
let file_path = file.path();

// First, check for broken symlinks and skip them
if file_path.is_symlink() {
    if let Ok(target_path) = fs::read_link(&file_path) {
        if !target_path.exists() {
            log::warn!("Skipping broken symlink: {} -> {}", file_path.display(), target_path.display());
            continue;
        }
    } else {
        log::warn!("Skipping unreadable symlink: {}", file_path.display());
        continue;
    }
}

// Then, proceed with canonicalization, adding a fallback for other errors
let canon_path = match fs::canonicalize(&file_path) {
    Ok(path) => path,
    Err(e) => {
        log::warn!("Failed to get canonical path for {}: {}. Skipping.", file_path.display(), e);
        continue;
    }
};

// Original logic for handling valid files and directories
if canon_path.is_dir() {
    log::debug!("{} is a dir", canon_path.display());
    let dirname = file.file_name();
    let mut path_from_root = dir.path_from_root.clone();
    path_from_root.push(dirname);
    dirs_to_visit.push(DirToVisit {
        absolute_path: canon_path,
        path_from_root,
    });
} else {
    log::debug!("{} is a file", file.path().display());
    let target = dir.path_from_root.clone().join(file.file_name());
    // ... rest of the original logic for file handling
    let replace_existing = config_entries
        .entries
        .iter()
        .find(|e| e.1.target == target)
        .map(|e| e.1.replace_existing)
        .unwrap_or(false);
    let etc_file = EtcFile {
        source: StorePath {
            store_path: canon_path,
        },
        target: PathBuf::from("/etc").join(target),
        uid: 0,
        gid: 0,
        group: "".to_string(),
        user: "".to_string(),
        mode: "symlink".to_string(),
        replace_existing,
    };
    log::debug!(
        "add file: {:?}, path_from_root: {:?}, absolute_path: {:?}",
        etc_file,
        dir.path_from_root,
        dir.absolute_path
    );
    files.push(etc_file);
}
```

## Applying the Fix

After modifying the source code of your local `system-manager` checkout, you must ensure your project's `flake.nix` is pointing to this modified version.

**Example `flake.nix` input:**
```nix
inputs = {
  # ... other inputs
  system-manager = {
    # Path to your local, patched system-manager checkout
    url = "git+file:///path/to/your/system-manager/repo";
  };
};
```

Then, rebuild and deploy your project. The activation should now succeed, logging warnings for any broken links instead of crashing.
