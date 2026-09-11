//! Canonical Lean 4.28 and shared-package setup for downloaded projects.

use anyhow::{Context, Result};
use std::fs;
use std::path::{Path, PathBuf};

pub const SHARED_PACKAGES: &str = "/mnt/data1/lean/dot_lake/packages";
pub const SHARED_MATHLIB: &str = "/mnt/data1/lean/mathlib";
pub const LEAN_STORE: &str =
    "/mnt/data1/nix-store/store/181szlvcvvjg9yr14849gmv253zyhlfl-lean";

/// Make a downloaded Lean project use the shared precompiled dependencies.
///
/// Existing local package directories are renamed rather than overwritten so
/// this operation is reversible and never destroys a project cache.
pub fn configure_project(project_root: &Path) -> Result<()> {
    let lakefile = project_root.join("lakefile.toml");
    if lakefile.exists() {
        let source = fs::read_to_string(&lakefile)
            .with_context(|| format!("reading {}", lakefile.display()))?;
        let canonical = canonicalize_mathlib_path(&source);
        if canonical != source {
            fs::write(&lakefile, canonical)
                .with_context(|| format!("writing {}", lakefile.display()))?;
        }
    }

    let lake_dir = project_root.join(".lake");
    fs::create_dir_all(&lake_dir)
        .with_context(|| format!("creating {}", lake_dir.display()))?;
    let packages = lake_dir.join("packages");
    if packages.is_symlink() {
        if fs::read_link(&packages).ok().as_deref() == Some(Path::new(SHARED_PACKAGES)) {
            return Ok(());
        }
        anyhow::bail!("{} points to the wrong package cache", packages.display());
    }
    if packages.exists() {
        let backup = lake_dir.join("packages.before-shared");
        if backup.exists() {
            anyhow::bail!(
                "{} exists; refusing to overwrite local package cache {}",
                backup.display(),
                packages.display()
            );
        }
        fs::rename(&packages, &backup).with_context(|| {
            format!("preserving {} as {}", packages.display(), backup.display())
        })?;
    }
    std::os::unix::fs::symlink(SHARED_PACKAGES, &packages)
        .with_context(|| format!("linking shared packages at {}", packages.display()))?;
    Ok(())
}

/// Configure either a project root or an extracted Aristotle result wrapper.
pub fn configure_downloaded_tree(download_dir: &Path) -> Result<()> {
    let nested = download_dir.join("output-final_aristotle");
    if nested.is_dir() {
        configure_project(&nested)
    } else {
        configure_project(download_dir)
    }
}

/// Replace a git Mathlib requirement while preserving the rest of lakefile.toml.
fn canonicalize_mathlib_path(source: &str) -> String {
    let mut output = Vec::new();
    let mut in_require = false;
    let mut is_mathlib = false;
    for line in source.lines() {
        let trimmed = line.trim();
        if trimmed.starts_with("[[") {
            in_require = trimmed == "[[require]]";
            is_mathlib = false;
        }
        if in_require && trimmed == "name = \"mathlib\"" {
            is_mathlib = true;
        }
        if is_mathlib && trimmed.starts_with("git = ") {
            output.push(format!("path = \"{}\"", SHARED_MATHLIB));
            continue;
        }
        if is_mathlib && trimmed.starts_with("rev = ") {
            continue;
        }
        output.push(line.to_string());
    }
    let mut result = output.join("\n");
    if source.ends_with('\n') {
        result.push('\n');
    }
    result
}

/// Return the canonical shared `lake` executable.
pub fn lake_binary() -> PathBuf {
    Path::new(LEAN_STORE).join("bin/lake")
}

#[cfg(test)]
mod tests {
    use super::{canonicalize_mathlib_path, SHARED_MATHLIB};

    #[test]
    fn replaces_git_mathlib_and_revision() {
        let source = "[[require]]\nname = \"mathlib\"\ngit = \"url\"\nrev = \"v4.28.0\"\n";
        let result = canonicalize_mathlib_path(source);
        assert!(result.contains(&format!("path = \"{}\"", SHARED_MATHLIB)));
        assert!(!result.contains("git ="));
        assert!(!result.contains("rev ="));
    }
}
