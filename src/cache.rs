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
//!
//! Managed packages beyond mathlib (batteries, aesop, proofwidgets, ...) are
//! deduplicated the same way: a real checkout whose git HEAD matches the
//! manifest rev is *adopted* — moved into the shared store and replaced by a
//! symlink — so repeated builds never re-download or re-copy packages.
//! `cache dedup` scans existing trees (dry-run by default, `--execute` to
//! commit) and `cache prune` removes stale build workspaces.

use anyhow::{Context, Result};
use serde_json::Value;
use std::collections::BTreeSet;
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
pub fn managed_packages() -> Vec<String> {
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

/// The git URL pinned in the project's lake-manifest.json for `name`.
fn manifest_pkg_url(project: &Path, name: &str) -> Option<String> {
    let manifest = std::fs::read_to_string(project.join("lake-manifest.json")).ok()?;
    let manifest: Value = serde_json::from_str(&manifest).ok()?;
    manifest["packages"]
        .as_array()?
        .iter()
        .find(|pkg| pkg.get("name").and_then(|n| n.as_str()) == Some(name))?
        .get("url")?
        .as_str()
        .map(|s| s.to_string())
}

fn pkg_link(project: &Path, name: &str) -> PathBuf {
    project.join(".lake").join("packages").join(name)
}

/// A dependency pinned in lake-manifest.json.
#[derive(Debug, Clone)]
pub struct ManifestPkg {
    pub name: String,
    pub rev: String,
}

/// All named+rev'd packages in a project's lake-manifest.json.
fn manifest_packages(project: &Path) -> Vec<ManifestPkg> {
    let Ok(manifest) = std::fs::read_to_string(project.join("lake-manifest.json")) else {
        return Vec::new();
    };
    let Ok(v) = serde_json::from_str::<Value>(&manifest) else {
        return Vec::new();
    };
    v["packages"]
        .as_array()
        .map(|pkgs| {
            pkgs.iter()
                .filter_map(|pkg| {
                    let name = pkg.get("name")?.as_str()?.to_string();
                    let rev = pkg.get("rev")?.as_str()?.to_string();
                    (!name.is_empty() && !rev.is_empty()).then_some(ManifestPkg { name, rev })
                })
                .collect()
        })
        .unwrap_or_default()
}

/// The packages this project should share, intersected with the managed set.
/// mathlib is always managed.
fn shared_packages(project: &Path) -> Vec<ManifestPkg> {
    let managed: BTreeSet<String> = managed_packages().into_iter().chain(["mathlib".into()]).collect();
    manifest_packages(project)
        .into_iter()
        .filter(|p| managed.contains(&p.name))
        .collect()
}

fn rev12(rev: &str) -> String {
    rev[..12.min(rev.len())].to_string()
}

fn resolve_link(link: &Path) -> Option<PathBuf> {
    let target = std::fs::read_link(link).ok()?;
    if target.is_absolute() {
        Some(target)
    } else {
        link.parent().map(|p| p.join(target))
    }
}

/// Summary of one `link_project` pass.
#[derive(Debug, Default)]
pub struct LinkStats {
    pub linked: usize,
    pub adopted: usize,
    pub skipped: Vec<(String, String)>,
}

/// Link every managed package of `project` into the shared store.
///
/// For each managed package pinned in the manifest:
///   - already a symlink to the shared checkout → nothing to do;
///   - a real checkout whose git HEAD matches the manifest rev → *adopt*:
///     move it into the shared store (or drop it if the store already has
///     that revision) and symlink back — this is the dedup path;
///   - nothing materialized and (for mathlib) no shared checkout yet →
///     clone once into the store.
///
/// With `dry_run` nothing is moved or created; actions are only printed.
/// With `clone_missing` a mathlib checkout missing from the store is cloned
/// once (guarded by a free-space check); otherwise missing revs are skipped
/// and lake will fetch them per-project — never silently cloning multi-GB
/// trees from a bulk dedup pass.
pub fn link_project(
    root: Option<PathBuf>,
    project: &Path,
    dry_run: bool,
    clone_missing: bool,
) -> Result<LinkStats> {
    let root = cache_root(root);
    let project = if project.is_absolute() && project.exists() {
        project.to_path_buf()
    } else {
        project
            .canonicalize()
            .with_context(|| format!("project dir {}", project.display()))?
    };
    let toolchain = std::fs::read_to_string(project.join("lean-toolchain"))
        .ok()
        .map(|s| s.trim().trim_start_matches("leanprover/lean4:").to_string())
        .filter(|s| !s.is_empty());
    let mut stats = LinkStats::default();

    for pkg in shared_packages(&project) {
        let link = pkg_link(&project, &pkg.name);
        let Some(toolchain) = &toolchain else {
            stats.skipped.push((pkg.name.clone(), "no lean-toolchain".into()));
            continue;
        };
        let store = if pkg.name == "mathlib" {
            mathlib_shared_dir(&root, toolchain, &pkg.rev)
        } else {
            packages_store(&root)
                .join(&pkg.name)
                .join(format!("{}-{}", toolchain, rev12(&pkg.rev)))
        };

        // Already shared?
        if link.is_symlink() {
            match resolve_link(&link).map(|p| std::fs::canonicalize(&p).unwrap_or(p)) {
                Some(resolved) if resolved == std::fs::canonicalize(&store).unwrap_or(store.clone()) => {
                    stats.linked += 1;
                    continue;
                }
                Some(resolved) => {
                    stats.skipped.push((
                        pkg.name.clone(),
                        format!("non-standard link -> {}", resolved.display()),
                    ));
                    continue;
                }
                None => {
                    // Dangling symlink — fall through to relink.
                    if !dry_run {
                        let _ = std::fs::remove_file(&link);
                    }
                }
            }
        }

        // Real checkout present? Adopt it when HEAD matches the manifest rev.
        if link.exists() && !link.is_symlink() {
            let head = run_git(&["rev-parse", "HEAD"], &link);
            match head {
                Some(h) if h == pkg.rev => {
                    if store.exists() {
                        println!(
                            "  dedup {}: remove {} (shared {} already has {})",
                            pkg.name,
                            link.display(),
                            root.display(),
                            rev12(&pkg.rev)
                        );
                        if !dry_run {
                            std::fs::remove_dir_all(&link).with_context(|| {
                                format!("removing duplicate {}", link.display())
                            })?;
                        }
                    } else {
                        println!(
                            "  adopt {}: move {} into shared store",
                            pkg.name,
                            link.display()
                        );
                        if !dry_run {
                            std::fs::create_dir_all(store.parent().unwrap())?;
                            std::fs::rename(&link, &store).with_context(|| {
                                format!("moving {} into shared store", link.display())
                            })?;
                        }
                        stats.adopted += 1;
                    }
                }
                _ => {
                    stats.skipped.push((
                        pkg.name.clone(),
                        "real checkout with unexpected/dirty HEAD".into(),
                    ));
                    continue;
                }
            }
        }

        // Nothing materialized locally: mathlib can be cloned into the store
        // once (opt-in + free-space guarded); other packages are left for
        // lake to fetch (the next dedup pass adopts them).
        if !store.exists() {
            if pkg.name == "mathlib" {
                if dry_run || !clone_missing {
                    println!(
                        "  [skip] mathlib {} not in shared store{}",
                        rev12(&pkg.rev),
                        if dry_run { " (would clone)" } else { " — use `aristo cache link` to clone it" }
                    );
                    stats
                        .skipped
                        .push((pkg.name.clone(), "rev not in shared store".into()));
                    continue;
                }
                if let Some(free) = free_bytes(&store) {
                    if free < 20 * (1 << 30) {
                        println!(
                            "  [skip] mathlib {}: only {} free — refusing to clone (need ~20G)",
                            rev12(&pkg.rev),
                            human(free)
                        );
                        stats
                            .skipped
                            .push((pkg.name.clone(), "insufficient disk for clone".into()));
                        continue;
                    }
                }
                std::fs::create_dir_all(&store)
                    .with_context(|| format!("creating {}", store.display()))?;
                let url = manifest_pkg_url(&project, "mathlib")
                    .unwrap_or_else(|| "https://github.com/leanprover-community/mathlib4".to_string());
                println!("  cloning mathlib4 into shared store (one-time, few GB)...");
                let (code, _, err) = crate::toolchain::run_cmd(
                    "git",
                    ["clone", &url, store.to_str().unwrap()].as_slice(),
                    None,
                )?;
                if code != 0 {
                    let _ = std::fs::remove_dir_all(&store);
                    anyhow::bail!("git clone failed: {}", err);
                }
                let (code, _, err) =
                    crate::toolchain::run_cmd("git", &["checkout", &pkg.rev], Some(&store))?;
                if code != 0 {
                    anyhow::bail!("git checkout {} failed: {}", rev12(&pkg.rev), err);
                }
            } else {
                stats.skipped.push((
                    pkg.name.clone(),
                    "not materialized yet (lake will fetch; re-run dedup after build)".into(),
                ));
                continue;
            }
        }

        // Verify/fix HEAD drift and remote URL on the shared checkout so
        // lake never deletes or re-clones it (lake drops a checkout whose
        // origin URL differs from the manifest URL).
        if !dry_run {
            let head = run_git(&["rev-parse", "HEAD"], &store);
            if let Some(h) = head {
                if h != pkg.rev {
                    println!(
                        "  shared {} HEAD {} != manifest rev {} — checking out manifest rev",
                        pkg.name,
                        rev12(&h),
                        rev12(&pkg.rev)
                    );
                    let (code, _, err) =
                        crate::toolchain::run_cmd("git", &["checkout", &pkg.rev], Some(&store))?;
                    if code != 0 {
                        anyhow::bail!("git checkout failed: {}", err);
                    }
                }
            }
            if let Some(url) = manifest_pkg_url(&project, &pkg.name) {
                let remote = run_git(&["remote", "get-url", "origin"], &store).unwrap_or_default();
                if !remote.is_empty() && remote != url {
                    println!(
                        "  normalizing shared {}/{} remote: {} -> {}",
                        pkg.name,
                        rev12(&pkg.rev),
                        remote,
                        url
                    );
                    let _ = run_git(&["remote", "set-url", "origin", &url], &store);
                }
            }
        }

        // Symlink the project at the shared checkout.
        if dry_run {
            println!(
                "  would link {} -> {}",
                link.display(),
                store.display()
            );
            stats.linked += 1;
        } else {
            std::fs::create_dir_all(link.parent().unwrap())?;
            #[cfg(unix)]
            std::os::unix::fs::symlink(&store, &link)
                .with_context(|| format!("symlinking {}", link.display()))?;
            #[cfg(windows)]
            std::os::windows::fs::symlink_dir(&store, &link)
                .with_context(|| format!("symlinking {}", link.display()))?;
            println!("  linked: {} -> {}", link.display(), store.display());
            stats.linked += 1;
        }
    }
    Ok(stats)
}

/// `aristo cache init` — configure package managers on this OS for the
/// shared-cache workflow.
///
/// Creates the cache root, ensures a package manager exists (elan > nix),
/// writes a `lake` env shim (env.sh) exporting LEAN_SHARED_CACHE_ROOT, and
/// records the setup in `<root>/README.md`. Idempotent; never installs
/// anything when the managers are already present.
pub fn cmd_init(root: Option<PathBuf>, toolchain: Option<String>) -> Result<()> {
    let root = cache_root(root);
    std::fs::create_dir_all(root.join("lean-shared/mathlib"))
        .with_context(|| format!("creating {}", root.join("lean-shared/mathlib").display()))?;
    std::fs::create_dir_all(root.join("lean-shared/lake-packages"))?;
    println!("=== Shared Lake Cache Init ===");
    println!("  root: {}", root.display());

    // 1. Package managers present? (elan covers Linux/macOS/Windows-WSL;
    //    nix covers Linux/macOS; the gokujo binary + bundled toolchain is the
    //    zero-package-manager fallback for everything else.)
    let has_elan = std::process::Command::new("elan")
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false);
    let has_nix = std::process::Command::new("nix")
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false);
    println!("  elan: {}", if has_elan { "present" } else { "missing" });
    println!("  nix:  {}", if has_nix { "present" } else { "missing" });

    if !has_elan && !has_nix {
        println!("  no package manager — the tiny signed gokujo binary is the fallback:");
        println!("    aristotle-manager toolchain bootstrap    # compile the lean-worker");
        println!("    aristotle-manager toolchain bundle ...    # ship a toolchain beside it");
        if !cfg!(windows) {
            println!("  or install elan: curl https://elan.lean-lang.org/elan-init.sh -sSf | sh");
        }
    } else if has_elan {
        // Make sure the requested (or default) toolchain is installed.
        let want = toolchain.clone().unwrap_or_default();
        if !want.is_empty() && want != "stable" {
            println!("  installing toolchain {} (elan)...", want);
            let out = std::process::Command::new("elan")
                .args(["toolchain", "install", &want])
                .output()
                .context("elan toolchain install failed")?;
            if !out.status.success() {
                anyhow::bail!("elan toolchain install {}: {}", want, String::from_utf8_lossy(&out.stderr));
            }
        }
    }

    // 2. Write env.sh — source this before building so every lake shares
    //    the same lakedir/cache root.
    let env_sh = root.join("env.sh");
    std::fs::write(
        &env_sh,
        format!(
            "# written by `aristotle-manager cache init`\nexport LEAN_SHARED_CACHE_ROOT={}\n",
            root.display()
        ),
    )?;
    println!("  wrote {} (source it before building)", env_sh.display());

    // 3. README with the workflow.
    let readme = root.join("README.md");
    if !readme.exists() {
        std::fs::write(
            &readme,
            format!(
                "# Shared lake-cache\n\n\
                Root: `{}`\n\n\
                - `lean-shared/mathlib/<toolchain>-<rev>` — shared mathlib checkouts\n\
                - `lean-shared/lake-packages/<name>/<toolchain>-<rev>` — shared deps\n\
                - `env.sh` — source before building (sets LEAN_SHARED_CACHE_ROOT)\n\n\
                Workflow:\n\
                ```\n\
                aristo cache init                  # once per machine\n\
                aristo cache link <project>        # link shared mathlib + packages\n\
                lake exe cache get!                # fetch prebuilt oleans (never rebuild mathlib)\n\
                aristo publish <project>           # build + signed report tile\n\
                aristo cache dedup --execute       # dedup existing .lake/packages copies\n\
                aristo cache prune --execute       # remove stale build workspaces\n\
                ```\n",
                root.display()
            ),
        )?;
        println!("  wrote {}", readme.display());
    }
    println!("  done — never rebuild mathlib again");
    Ok(())
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
                match resolve_link(&link) {
                    Some(resolved) => {
                        let expected = mathlib_shared_dir(&root, &tc, &rev);
                        if resolved == expected {
                            println!("    linked: yes -> {}", resolved.display());
                        } else {
                            println!("    linked: (non-standard) -> {}", resolved.display());
                        }
                    }
                    None => println!("    linked: DANGLING symlink"),
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

/// `aristo cache link [PROJECT]` — link or create the shared checkouts for
/// every managed package of this project (mathlib + batteries/aesop/...).
pub fn cmd_link(root: Option<PathBuf>, project: Option<PathBuf>) -> Result<()> {
    let project = project.unwrap_or_else(|| PathBuf::from("."));
    let stats = link_project(root, &project, false, true)?;
    println!(
        "  done: {} linked, {} adopted, {} skipped",
        stats.linked,
        stats.adopted,
        stats.skipped.len()
    );
    println!("  next: lake exe cache get && lake build");
    Ok(())
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
                match link_project(None, &path, false, true) {
                    Ok(_) => linked += 1,
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

/// `aristo cache dedup [ROOTS...] --execute` — deduplicate real
/// `.lake/packages/<managed>` checkouts found under the given trees into the
/// shared store. Dry-run by default: pass `--execute` to move/remove.
pub fn cmd_dedup(root: Option<PathBuf>, scan_roots: Vec<PathBuf>, execute: bool) -> Result<()> {
    let roots: Vec<PathBuf> = if scan_roots.is_empty() {
        let mut v = vec![crate::deploy::builds_root()];
        if let Ok(config) = crate::load_config() {
            v.push(PathBuf::from(config.results_dir));
        }
        v
    } else {
        scan_roots
    };

    let mode = if execute { "EXECUTE" } else { "DRY-RUN (pass --execute to commit)" };
    println!("=== Shared Lake Cache Dedup — {} ===", mode);
    println!("  store: {}", cache_root(root.clone()).display());

    // Find every project dir (anything containing lean-toolchain +
    // lake-manifest.json) under the scan roots.
    let mut projects: BTreeSet<PathBuf> = BTreeSet::new();
    for scan_root in &roots {
        let scan_root = scan_root.canonicalize().unwrap_or_else(|_| scan_root.clone());
        println!("  scanning: {}", scan_root.display());
        // Bounded walk: project trees live within a few levels (e.g.
        // <uuid>_aristotle/output-final_aristotle, or the flat build
        // workspaces) — do not descend into the multi-GB git/version trees.
        let mut stack: Vec<(PathBuf, usize)> = vec![(scan_root, 0usize)];
        while let Some((dir, depth)) = stack.pop() {
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
                if path.join("lean-toolchain").exists() && path.join("lake-manifest.json").exists()
                {
                    projects.insert(path);
                } else if depth < 3 {
                    stack.push((path, depth + 1));
                }
            }
        }
    }

    let mut total_adopted = 0usize;
    let mut total_linked = 0usize;
    let mut total_skipped = 0usize;
    for project in &projects {
        match link_project(root.clone(), project, !execute, false) {
            Ok(stats) => {
                if stats.adopted > 0 || stats.skipped.is_empty() {
                    println!(
                        "  project {}: {} linked, {} adopted, {} skipped",
                        project.display(),
                        stats.linked,
                        stats.adopted,
                        stats.skipped.len()
                    );
                }
                for (pkg, why) in &stats.skipped {
                    if !why.contains("non-standard") && !why.contains("not materialized") {
                        println!("    [skip] {}: {}", pkg, why);
                    }
                }
                total_adopted += stats.adopted;
                total_linked += stats.linked;
                total_skipped += stats.skipped.len();
            }
            Err(e) => println!("  project {}: FAILED: {}", project.display(), e),
        }
    }
    println!(
        "\n  {} projects: {} linked, {} adopted (deduped), {} skipped",
        projects.len(),
        total_linked,
        total_adopted,
        total_skipped
    );
    if !execute {
        println!("  nothing moved — re-run with --execute to commit");
    }
    Ok(())
}

/// Rough size of a directory tree, bounded by depth.
fn dir_size(path: &Path, max_depth: usize) -> u64 {
    let mut total = 0u64;
    let mut stack = vec![(path.to_path_buf(), 0usize)];
    while let Some((dir, depth)) = stack.pop() {
        let entries = match std::fs::read_dir(&dir) {
            Ok(e) => e,
            Err(_) => continue,
        };
        for entry in entries.flatten() {
            let p = entry.path();
            match entry.file_type() {
                Ok(ft) if ft.is_dir() => {
                    if depth < max_depth {
                        // Don't follow symlinks into the shared store.
                        if !p.is_symlink() {
                            stack.push((p, depth + 1));
                        }
                    }
                }
                Ok(ft) if ft.is_file() => {
                    if let Ok(md) = entry.metadata() {
                        total += md.len();
                    }
                }
                _ => {}
            }
        }
    }
    total
}

fn human(bytes: u64) -> String {
    if bytes >= 1 << 30 {
        format!("{:.1}G", bytes as f64 / (1 << 30) as f64)
    } else if bytes >= 1 << 20 {
        format!("{:.1}M", bytes as f64 / (1 << 20) as f64)
    } else if bytes >= 1 << 10 {
        format!("{:.1}K", bytes as f64 / (1 << 10) as f64)
    } else {
        format!("{}B", bytes)
    }
}

/// Free bytes on the filesystem that holds `path` (None when unavailable).
fn free_bytes(path: &Path) -> Option<u64> {
    // `df -B1 <path>` prints the fs stats; parse the "available" column from
    // the data line (portable across Unix variants, no extra crate).
    let out = std::process::Command::new("df")
        .args(["-B1", path.to_str()?])
        .output()
        .ok()?;
    if !out.status.success() {
        return None;
    }
    let text = String::from_utf8_lossy(&out.stdout);
    text.lines().nth(1)?.split_whitespace().nth(3)?.parse().ok()
}

/// A dir is a build workspace when its name is 8 hex chars (short id) or a
/// full UUID (8 hex + '-'). Other names (logs, output-final,
/// dasl-corpus-merged, ...) are never pruned.
fn is_uuidish(name: &str) -> bool {
    if name.len() == 8 && name.bytes().all(|b| b.is_ascii_hexdigit()) {
        return true;
    }
    name.len() >= 9
        && name.as_bytes()[..8].iter().all(|b| b.is_ascii_hexdigit())
        && name.as_bytes().get(8) == Some(&b'-')
}

/// `aristo cache prune --execute` — remove stale build workspaces under the
/// builds root (default `/mnt/data1/aristotle-builds`). Dry-run by default.
pub fn cmd_prune(older_than_days: u64, execute: bool) -> Result<()> {
    let builds_root = crate::deploy::builds_root();
    let cutoff = std::time::SystemTime::now() - std::time::Duration::from_secs(older_than_days * 86_400);
    let mode = if execute { "EXECUTE" } else { "DRY-RUN (pass --execute to delete)" };
    println!("=== Build Workspace Prune — {} ===", mode);
    println!("  root: {}", builds_root.display());
    println!("  removing UUID workspaces untouched for >{} days", older_than_days);

    let mut candidates: Vec<(PathBuf, u64, std::time::SystemTime)> = Vec::new();
    for entry in std::fs::read_dir(&builds_root)?.flatten() {
        let name = entry.file_name().to_string_lossy().into_owned();
        if !is_uuidish(&name) {
            continue;
        }
        let path = entry.path();
        let md = entry.metadata()?;
        // Use the LATER of mtime and (ext4) creation time — but ignore a
        // bogus epoch crtime (platforms without birthtime support). A bulk
        // chmod/rename can touch mtimes without real activity, so a
        // fresh-looking mtime must not resurrect a workspace that was never
        // rebuilt; the .build-done markers are themselves evidence of age.
        let mtime = md.modified().unwrap_or(std::time::SystemTime::UNIX_EPOCH);
        let crtime = md.created().unwrap_or(std::time::SystemTime::UNIX_EPOCH);
        let last_activity = if crtime > std::time::SystemTime::UNIX_EPOCH {
            mtime.max(crtime)
        } else {
            mtime
        };
        if last_activity < cutoff {
            let size = dir_size(&path, 4);
            candidates.push((path, size, last_activity));
        }
    }
    candidates.sort_by_key(|(_, size, _)| std::cmp::Reverse(*size));

    let mut total: u64 = 0;
    let now = std::time::SystemTime::now();
    for (path, size, last) in &candidates {
        let age_days = now
            .duration_since(*last)
            .map(|d| d.as_secs() / 86_400)
            .unwrap_or(0);
        println!("  {} {} ({}d old)", path.display(), human(*size), age_days);
        total += size;
    }
    println!(
        "\n  {} workspaces, {} reclaimable",
        candidates.len(),
        human(total)
    );
    if execute {
        let mut removed = 0usize;
        for (path, _, _) in &candidates {
            if std::fs::remove_dir_all(path).is_ok() {
                removed += 1;
            }
        }
        println!("  removed {} workspaces", removed);
    } else if !candidates.is_empty() {
        println!("  nothing deleted — re-run with --execute to delete");
    }
    Ok(())
}

/// Collect the leaf revision dirs of a store subtree.
///
/// For `mathlib_store` (root/<toolchain>-<rev>) the leaves are the entries of
/// the store dir itself (`sub = 0`). For `packages_store`
/// (root/<name>/<toolchain>-<rev>) it descends one level (`sub = 1`). Every
/// returned path is a revision checkout — i.e. the exact path a project's
/// `.lake/packages/<name>` symlink resolves to — as stored on disk, so gc
/// compares like with like. `sub` is a safety bound only; deeper unexpected
/// nesting is not descended into.
fn collect_store_leaves(store: &Path, sub: usize) -> Result<Vec<PathBuf>> {
    if !store.exists() {
        return Ok(Vec::new());
    }
    let mut leaves: Vec<PathBuf> = Vec::new();
    let mut stack = vec![(store.to_path_buf(), 0usize)];
    while let Some((dir, depth)) = stack.pop() {
        for entry in std::fs::read_dir(&dir)?.flatten() {
            let p = entry.path();
            if !p.is_dir() {
                continue;
            }
            if depth < sub {
                stack.push((p, depth + 1));
            } else {
                // depth == sub: this IS a revision dir. (The old code pushed
                // the rev dir's children as leaves — never the rev dir itself
                // — so no active link ever matched and gc deleted the
                // contents of live shared checkouts.)
                leaves.push(p);
            }
        }
    }
    Ok(leaves)
}

/// `aristo cache gc [PROJECT...]` — remove shared checkouts nothing links to.
/// Every shared-store path a project's `.lake/packages/*` symlink points at,
/// across the given trees.
///
/// Same walk discipline as `cmd_dedup`/`cmd_link_all`: skip dot-dirs (so
/// `.lake`/`.git` interiors are never entered), only descend real directories
/// (symlinks are not followed, so cycles are impossible), no artificial depth
/// limit — nested results like
/// `results/git-versions/<uuid>/<x>_aristotle/output-final` are covered,
/// unlike the old `find -maxdepth` version which both missed them and crawled
/// every project's multi-GB `.lake/build` tree.
fn collect_active_link_targets(bases: &[&str]) -> Vec<PathBuf> {
    let mut active: Vec<PathBuf> = Vec::new();
    let mut stack: Vec<PathBuf> = bases.iter().map(PathBuf::from).collect();
    while let Some(dir) = stack.pop() {
        let entries = match std::fs::read_dir(&dir) {
            Ok(e) => e,
            Err(_) => continue,
        };
        // Package links of a project rooted at this dir.
        let pkg_dir = dir.join(".lake").join("packages");
        if pkg_dir.is_dir() {
            if let Ok(pkgs) = std::fs::read_dir(&pkg_dir) {
                for p in pkgs.flatten() {
                    let path = p.path();
                    if path.is_symlink() {
                        if let Ok(resolved) = std::fs::canonicalize(&path) {
                            active.push(resolved);
                        }
                    }
                }
            }
        }
        for entry in entries.flatten() {
            let path = entry.path();
            let Ok(ft) = entry.file_type() else { continue };
            // Real dirs only: is_dir() would follow symlinks (cycle risk).
            if !ft.is_dir() || ft.is_symlink() {
                continue;
            }
            if entry.file_name().to_string_lossy().starts_with('.') {
                continue;
            }
            stack.push(path);
        }
    }
    active
}

pub fn cmd_gc(root: Option<PathBuf>) -> Result<()> {
    let root = cache_root(root);
    // Collect all active symlink targets across common project locations.
    let active = collect_active_link_targets(&[
        "/mnt/data1/aristotle-results",
        "/mnt/data1/aristotle-builds",
        "/home/mdupont/projects",
    ]);
    let mut removed = 0usize;
    for (store, sub) in [
        // mathlib_store: rev dirs are direct children (leaf depth 0).
        (mathlib_store(&root), 0usize),
        // packages_store: rev dirs sit one level below <name> (leaf depth 1).
        (packages_store(&root), 1usize),
    ] {
        if !store.exists() {
            continue;
        }
        let leaves = collect_store_leaves(&store, sub)?;
        for leaf in leaves {
            // Compare canonical paths: the active targets were canonicalized,
            // so a leaf reached through a symlinked parent must be too.
            let leaf_canon = std::fs::canonicalize(&leaf).unwrap_or_else(|_| leaf.clone());
            if !active.iter().any(|a| a == &leaf_canon) {
                println!("  removing unused {}", leaf.display());
                std::fs::remove_dir_all(&leaf)?;
                removed += 1;
            }
        }
    }
    println!("  removed {} unused shared checkouts", removed);
    Ok(())
}
