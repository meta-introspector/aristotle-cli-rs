//! `aristo cache` — shared Lean/Lake dependency cache (the "lake-cache").
//!
//! Implements the shared-mathlib workflow from
//! gist.github.com/quangvdao/d41c406990c907865f584d5756c85bec:
//!
//! Projects keep their normal `lake-manifest.json`, but selected directories
//! under `.lake/packages/` are replaced by symlinks into a central store keyed
//! by `<lean-toolchain>-<dependency-rev-prefix>`. Two projects share a
//! dependency only when both the toolchain and the exact dependency revision
//! match. Everything is local-only — manifests are never modified.
//!
//! The store root defaults to `/mnt/data1/lake-cache` on this machine and can
//! be overridden with `--root` or `LEAN_SHARED_CACHE_ROOT`.

use anyhow::{Context, Result};
use serde_json::Value;
use std::path::{Path, PathBuf};

/// Default shared cache root (per goal.md: the lake-cache lives on /mnt/data1).
pub const DEFAULT_CACHE_ROOT: &str = "/mnt/data1/lake-cache";

pub fn cache_root(cli_root: Option<PathBuf>) -> PathBuf {
    cli_root
        .or_else(|| std::env::var("LEAN_SHARED_CACHE_ROOT").ok().map(PathBuf::from))
        .unwrap_or_else(|| PathBuf::from(DEFAULT_CACHE_ROOT))
}

fn mathlib_store(root: &Path) -> PathBuf {
    root.join("lean-shared").join("mathlib")
}

fn packages_store(root: &Path) -> PathBuf {
    root.join("lean-shared").join("lake-packages")
}

/// Packages managed by the shared cache besides mathlib.
fn managed_packages() -> Vec<String> {
    std::env::var("LEAN_SHARED_LAKE_PACKAGES")
        .unwrap_or_else(|_| "batteries,aesop,proofwidgets,Qq,std,importGraph".to_string())
        .split(',')
        .map(|s| s.trim().to_string())
        .filter(|s| !s.is_empty())
        .collect()
}

fn run_git(args: &[&str], cwd: &Path) -> Option<String> {
    let out = std::process::Command::new("git")
        .args(args)
        .current_dir(cwd)
        .output()
        .ok()?;
    let code = out.status.code()?;
    (code == 0)
        .then(|| String::from_utf8_lossy(&out.stdout).trim().to_string())
}

/// Read (toolchain, mathlib rev) from a project, if it is a Lean project.
fn project_info(project: &Path) -> Option<(String, String)> {
    let toolchain = std::fs::read_to_string(project.join("lean-toolchain")).ok()?;
    let toolchain = toolchain.trim().trim_start_matches("leanprover/lean4:").to_string();
    if toolchain.is_empty() {
        return None;
    }
    let manifest = std::fs::read_to_string(project.join("lake-manifest.json")).ok()?;
    let manifest: Value = serde_json::from_str(&manifest).ok()?;
    let mathlib = manifest["packages"].as_array()?.iter().find(|pkg| {
        pkg.get("name").and_then(|n| n.as_str()) == Some("mathlib")
            && pkg
                .get("url")
                .and_then(|u| u.as_str())
                .map(|u| u.contains("leanprover-community/mathlib4"))
                .unwrap_or(false)
    })?;
    let rev = mathlib.get("rev")?.as_str()?.to_string();
    Some((toolchain, rev))
}

/// The shared-store directory for a project's mathlib revision.
fn mathlib_shared_dir(root: &Path, toolchain: &str, rev: &str) -> PathBuf {
    mathlib_store(root).join(format!("{}-{}", toolchain, &rev[..12.min(rev.len())]))
}

/// The mathlib git URL pinned in the project's lake-manifest.json, if any.
fn manifest_mathlib_url(project: &Path) -> Option<String> {
    let manifest = std::fs::read_to_string(project.join("lake-manifest.json")).ok()?;
    let manifest: Value = serde_json::from_str(&manifest).ok()?;
    manifest["packages"]
        .as_array()?
        .iter()
        .find(|pkg| pkg.get("name").and_then(|n| n.as_str()) == Some("mathlib"))?
        .get("url")?
        .as_str()
        .map(|s| s.to_string())
}

fn pkg_link(project: &Path, name: &str) -> PathBuf {
    project.join(".lake").join("packages").join(name)
}

/// `aristo cache status [PROJECT]` — show store contents and project linkage.
pub fn cmd_status(root: Option<PathBuf>, project: Option<PathBuf>) -> Result<()> {
    let root = cache_root(root);
    println!("=== Shared Lake Cache ===");
    println!("  root: {}", root.display());

    let mstore = mathlib_store(&root);
    if mstore.exists() {
        let mut revs: Vec<String> = std::fs::read_dir(&mstore)?
            .filter_map(|e| e.ok())
            .filter(|e| e.path().is_dir())
            .map(|e| e.file_name().to_string_lossy().into_owned())
            .collect();
        revs.sort();
        println!("  mathlib versions ({}):", revs.len());
        for r in &revs {
            println!("    {}", r);
        }
    } else {
        println!("  mathlib store: empty (nothing cached yet)");
    }

    let pstore = packages_store(&root);
    if pstore.exists() {
        let mut entries: Vec<String> = std::fs::read_dir(&pstore)?
            .filter_map(|e| e.ok())
            .filter(|e| e.path().is_dir())
            .map(|e| e.file_name().to_string_lossy().into_owned())
            .collect();
        entries.sort();
        for pkg in &entries {
            let mut revs: Vec<String> = std::fs::read_dir(pstore.join(pkg))?
                .filter_map(|e| e.ok())
                .filter(|e| e.path().is_dir())
                .map(|e| e.file_name().to_string_lossy().into_owned())
                .collect();
            revs.sort();
            println!("  {} × {} revisions", pkg, revs.len());
        }
    }

    // Project linkage
    let project = match project {
        Some(p) => p,
        None => return Ok(()),
    };
    match project_info(&project) {
        Some((tc, rev)) => {
            println!("  project {}:", project.display());
            println!("    toolchain: {}", tc);
            println!("    mathlib rev: {}", &rev[..12.min(rev.len())]);
            let link = pkg_link(&project, "mathlib");
            if link.is_symlink() {
                let target = std::fs::read_link(&link)?;
                let resolved = if target.is_absolute() {
                    target
                } else {
                    link.parent().unwrap().join(target)
                };
                let expected = mathlib_shared_dir(&root, &tc, &rev);
                if resolved == expected {
                    println!("    linked: yes -> {}", resolved.display());
                } else {
                    println!("    linked: (non-standard) -> {}", resolved.display());
                }
            } else if link.exists() {
                println!("    linked: no (real directory — run `aristo cache link`)");
            } else {
                println!("    linked: no (no packages materialized — run `lake update` first)");
            }
        }
        None => println!("  {} is not a Lean project with mathlib (no lean-toolchain/mathlib rev)", project.display()),
    }
    Ok(())
}

/// `aristo cache link [PROJECT]` — link or create the shared mathlib checkout
/// for this project and symlink `.lake/packages/mathlib` to it.
pub fn cmd_link(root: Option<PathBuf>, project: Option<PathBuf>) -> Result<()> {
    let root = cache_root(root);
    let project = project.unwrap_or_else(|| PathBuf::from("."));
    let project = project.canonicalize().with_context(|| format!("project dir {}", project.display()))?;

    let (toolchain, rev) = project_info(&project)
        .context("not a mathlib project: missing lean-toolchain or mathlib in lake-manifest.json")?;
    let shared = mathlib_shared_dir(&root, &toolchain, &rev);
    let link = pkg_link(&project, "mathlib");

    // 1. Ensure the shared checkout exists.
    if !shared.exists() {
        std::fs::create_dir_all(&shared)
            .with_context(|| format!("creating {}", shared.display()))?;
        let adopted = if link.exists() && !link.is_symlink() {
            // Adopt an existing clean checkout if HEAD matches the manifest rev.
            let head = run_git(&["rev-parse", "HEAD"], &link);
            match head {
                Some(h) if h == rev => {
                    std::fs::rename(&link, &shared)
                        .with_context(|| format!("moving {} into shared store", link.display()))?;
                    true
                }
                _ => false,
            }
        } else {
            false
        };
        if !adopted && !shared.join(".git").exists() {
            // Clone with the manifest's URL so lake never sees a mismatch.
            let url = manifest_mathlib_url(&project)
                .unwrap_or_else(|| "https://github.com/leanprover-community/mathlib4".to_string());
            println!("  cloning mathlib4 into shared store (one-time, few GB)...");
            let (code, _, err) = crate::toolchain::run_cmd(
                "git",
                &["clone", &url, shared.to_str().unwrap()],
                None,
            )?;
            if code != 0 {
                let _ = std::fs::remove_dir_all(&shared);
                anyhow::bail!("git clone failed: {}", err);
            }
            let (code, _, err) =
                crate::toolchain::run_cmd("git", &["checkout", &rev], Some(&shared))?;
            if code != 0 {
                anyhow::bail!("git checkout {} failed: {}", &rev[..12.min(rev.len())], err);
            }
        }
    }

    // Verify shared HEAD matches (auto-fix drift by checking out the rev).
    let head = run_git(&["rev-parse", "HEAD"], &shared);
    match head {
        Some(h) if h == rev => {}
        Some(h) => {
            println!(
                "  shared checkout HEAD {} != manifest rev {} — checking out manifest rev",
                &h[..12.min(h.len())],
                &rev[..12.min(rev.len())]
            );
            let (code, _, err) = crate::toolchain::run_cmd("git", &["checkout", &rev], Some(&shared))?;
            if code != 0 {
                anyhow::bail!("git checkout failed: {}", err);
            }
        }
        None => {}
    }

    // Normalize the remote URL to match the manifest (lake deletes the
    // checkout when origin URL differs from the manifest URL — e.g. a clone
    // without .git suffix vs a manifest with .git).
    if let Some(url) = manifest_mathlib_url(&project) {
        let remote = run_git(&["remote", "get-url", "origin"], &shared).unwrap_or_default();
        if !remote.is_empty() && remote != url {
            println!("  normalizing shared remote: {} -> {}", remote, url);
            let _ = run_git(&["remote", "set-url", "origin", &url], &shared);
        }
    }

    // 2. Point the project at the shared checkout.
    if link.is_symlink() {
        let target = std::fs::read_link(&link)?;
        let resolved = if target.is_absolute() {
            target
        } else {
            link.parent().unwrap().join(target)
        };
        if resolved == shared {
            println!("  ok: {} -> {}", link.display(), shared.display());
            return Ok(());
        }
        std::fs::remove_file(&link)?;
    } else if link.exists() {
        let head = run_git(&["rev-parse", "HEAD"], &link);
        match head {
            Some(h) if h == rev => std::fs::remove_dir_all(&link)?,
            _ => anyhow::bail!(
                "{} is a real mathlib checkout with unexpected/dirty state; resolve it manually",
                link.display()
            ),
        }
    }
    std::fs::create_dir_all(link.parent().unwrap())?;
    #[cfg(unix)]
    std::os::unix::fs::symlink(
        pathdiff_rel(&link, &shared),
        &link,
    )
    .with_context(|| format!("symlinking {}", link.display()))?;
    #[cfg(windows)]
    std::os::windows::fs::symlink_dir(&shared, &link)
        .with_context(|| format!("symlinking {}", link.display()))?;
    println!("  linked: {} -> {}", link.display(), shared.display());
    println!("  next: lake exe cache get && lake build");
    Ok(())
}

/// Relative symlink target from the link's parent to the shared dir.
fn pathdiff_rel(link: &Path, target: &Path) -> String {
    let base = link.parent().unwrap();
    target
        .strip_prefix(base)
        .map(|p| p.to_string_lossy().into_owned())
        .unwrap_or_else(|_| target.to_string_lossy().into_owned())
}

/// `aristo cache link-all [ROOT_DIR]` — link every Lean project under a tree
/// (e.g. all downloaded Aristotle results).
pub fn cmd_link_all(root: Option<PathBuf>, scan_root: PathBuf) -> Result<()> {
    let _ = root;
    let mut linked = 0usize;
    let mut skipped = 0usize;
    let mut stack = vec![scan_root.clone()];
    while let Some(dir) = stack.pop() {
        let entries = match std::fs::read_dir(&dir) {
            Ok(e) => e,
            Err(_) => continue,
        };
        for entry in entries.flatten() {
            let path = entry.path();
            if !path.is_dir() {
                continue;
            }
            let name = entry.file_name();
            let name = name.to_string_lossy();
            if name == ".lake" || name == ".git" || name.starts_with('.') {
                continue;
            }
            if path.join("lean-toolchain").exists() && path.join("lake-manifest.json").exists() {
                match cmd_link(None, Some(path.clone())) {
                    Ok(()) => linked += 1,
                    Err(_) => skipped += 1,
                }
            } else {
                stack.push(path);
            }
        }
    }
    println!();
    println!("  linked: {} projects, skipped: {}", linked, skipped);
    Ok(())
}

/// `aristo cache gc [PROJECT...]` — remove shared checkouts nothing links to.
pub fn cmd_gc(root: Option<PathBuf>) -> Result<()> {
    let root = cache_root(root);
    let mstore = mathlib_store(&root);
    if !mstore.exists() {
        println!("  nothing to collect");
        return Ok(());
    }
    // Collect all active symlink targets across common project locations.
    let mut active: Vec<PathBuf> = Vec::new();
    for base in ["/mnt/data1/aristotle-results", "/home/mdupont/projects"] {
        let out = std::process::Command::new("find")
            .args([base, "-maxdepth", "6", "-type", "l", "-path", "*/.lake/packages/mathlib"])
            .output();
        if let Ok(out) = out {
            for line in String::from_utf8_lossy(&out.stdout).lines() {
                if let Ok(resolved) = std::fs::canonicalize(line) {
                    active.push(resolved);
                }
            }
        }
    }
    let mut removed = 0usize;
    for entry in std::fs::read_dir(&mstore)?.flatten() {
        let path = entry.path();
        if !path.is_dir() {
            continue;
        }
        if !active.iter().any(|a| a == &path) {
            println!("  removing unused {}", path.display());
            std::fs::remove_dir_all(&path)?;
            removed += 1;
        }
    }
    println!("  removed {} unused shared checkouts", removed);
    Ok(())
}
