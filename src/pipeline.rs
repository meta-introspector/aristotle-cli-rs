/// pipeline — Full DASL pipeline: fetch → split → verify → version → merge.
/// Each Aristotle output is split, built with lake to verify it compiles,
/// git-versioned, and merged into the unified declaration pool.
use std::fs;
use std::path::PathBuf;
use std::process::Command;
use tracing::{instrument, warn};

use crate::load_config;

/// Try to build a Lean project with lake, returning (success, stdout)
fn lake_build(project_dir: &PathBuf) -> (bool, String) {
    let lake = find_lake_binary();
    
    let output = Command::new(&lake)
        .args(["build"])
        .current_dir(project_dir)
        .output();
    
    match output {
        Ok(out) => {
            let stdout = String::from_utf8_lossy(&out.stdout).to_string();
            let stderr = String::from_utf8_lossy(&out.stderr).to_string();
            let combined = format!("{}{}", stdout, stderr);
            (out.status.success(), combined)
        }
        Err(e) => (false, format!("lake not found: {}", e)),
    }
}

fn find_lake_binary() -> String {
    // Try nix store lean first, then PATH
    for candidate in &[
        "/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin/lake",
        "/nix/store/*lean*/bin/lake",
    ] {
        if PathBuf::from(candidate).exists() {
            return candidate.to_string();
        }
    }
    // Fallback to PATH
    "lake".to_string()
}

/// Run the full pipeline on new/changed Aristotle outputs
#[instrument(skip(limit))]
pub async fn cmd_pipeline(
    parallel: usize,
    limit: Option<usize>,
    dry_run: bool,
) -> anyhow::Result<()> {
    let config = load_config()?;

    println!("=== Aristotle Pipeline ===\n");
    println!("  1. fetch    — download new/changed projects");
    println!("  2. split    — run SplitDecls on each project");
    println!("  3. verify   — lake build to check Lean validity");
    println!("  4. version  — git-commit each result");
    println!("  5. merge    — merge into unified pool\n");

    // ── Step 1: Fetch ──────────────────────────────────────────────
    println!("═══ [1/5] Fetch ═══");
    if !dry_run {
        crate::fetch::cmd_fetch(parallel, limit, false).await?;
    } else {
        crate::fetch::cmd_fetch(parallel, limit, true).await?;
        println!("  (dry run — skipping remaining steps)");
        return Ok(());
    }

    // ── Step 2: Split ──────────────────────────────────────────────
    println!("\n═══ [2/5] Split ═══");
    let results_dir = &config.results_dir;
    let split_dir = results_dir.join("split-results");
    fs::create_dir_all(&split_dir)?;

    let mut projects_to_split: Vec<(PathBuf, String)> = Vec::new();
    for entry in fs::read_dir(results_dir)? {
        let entry = entry?;
        if entry.file_type()?.is_dir() {
            let name = entry.file_name().to_string_lossy().to_string();
            if name.ends_with("_aristotle") {
                let rp_dir = entry.path().join("output-final_aristotle").join("RequestProject");
                if rp_dir.exists() {
                    projects_to_split.push((entry.path(), name));
                }
            }
        }
    }

    println!("  Projects to split: {}", projects_to_split.len());
    let mut split_succeeded = 0u64;
    let mut split_failed = 0u64;
    let mut total_split_decls = 0u64;

    for (i, (proj_dir, name)) in projects_to_split.iter().enumerate() {
        let out = split_dir.join(name);
        if out.exists() {
            // Already split — count existing decls
            let existing = walkdir::WalkDir::new(&out)
                .into_iter()
                .filter_map(|e| e.ok())
                .filter(|e| e.path().extension().map_or(false, |e| e == "lean"))
                .count();
            total_split_decls += existing as u64;
            split_succeeded += 1;
            continue;
        }

        let splitter = std::env::current_dir()?.join("split-aristotle-project.sh");
        let proj_str = proj_dir.to_string_lossy().to_string();
        let out_str = out.to_string_lossy().to_string();
        match Command::new(&splitter)
            .args([&proj_str, &out_str])
            .output()
        {
            Ok(output) if output.status.success() => {
                let decls = walkdir::WalkDir::new(&out)
                    .into_iter()
                    .filter_map(|e| e.ok())
                    .filter(|e| e.path().extension().map_or(false, |e| e == "lean"))
                    .count();
                println!("  [{}/{}] ✓ {} → {} decls", i + 1, projects_to_split.len(), name, decls);
                total_split_decls += decls as u64;
                split_succeeded += 1;
            }
            _ => {
                warn!(project = %name, "Split failed");
                split_failed += 1;
            }
        }
    }

    // ── Step 3: Verify (lake build) ────────────────────────────────
    println!("\n═══ [3/5] Verify ═══");
    let mut verified = 0u64;
    let mut failed_verify = 0u64;

    // Try lake build on the main mathlib-split pool
    let mathlib_split = results_dir.join("mathlib-split");
    let has_lakefile = mathlib_split.join("lakefile.toml").exists();

    if has_lakefile {
        println!("  Building mathlib-split with lake...");
        let (ok, output) = lake_build(&mathlib_split);
        if ok {
            println!("  ✓ mathlib-split builds");
            verified += 1;
        } else {
            let last_lines: Vec<&str> = output.lines().rev().take(5).collect();
            println!("  ✗ lake build failed:");
            for line in last_lines.iter().rev() {
                println!("    {}", line);
            }
            failed_verify += 1;
        }
    }

    // Verify individual split projects
    for entry in fs::read_dir(&split_dir)? {
        let entry = entry?;
        if entry.file_type()?.is_dir() {
            let path = entry.path();
            let lakefile = path.join("lakefile.toml");
            if lakefile.exists() {
                let name = entry.file_name().to_string_lossy().to_string();
                let (ok, _) = lake_build(&path);
                if ok {
                    println!("  ✓ {}", name);
                    verified += 1;
                } else {
                    println!("  ✗ {} (build failed)", name);
                    failed_verify += 1;
                }
            }
        }
    }

    println!("  Verified: {}, Failed: {}", verified, failed_verify);

    // ── Step 4: Version ────────────────────────────────────────────
    println!("\n═══ [4/5] Version ═══");
    crate::version::cmd_version(None, None)?;

    // ── Step 5: Merge ──────────────────────────────────────────────
    println!("\n═══ [5/5] Merge ═══");
    let merge_dir = results_dir.join("mathlib-split");
    fs::create_dir_all(&merge_dir)?;

    // Create lakefile if missing
    let lakefile = merge_dir.join("lakefile.toml");
    if !lakefile.exists() {
        fs::write(&lakefile, format!(r#"
name = "unified-pool"
defaultTargets = ["UnifiedPool"]
[[lean_lib]]
name = "UnifiedPool"
globs = ["UnifiedPool.+"]
"#))?;
    }

    let mut merged = 0u64;
    for entry in fs::read_dir(&split_dir)? {
        let entry = entry?;
        if !entry.file_type()?.is_dir() {
            continue;
        }
        let src = entry.path();
        let name = entry.file_name().to_string_lossy().to_string();
        let dest = merge_dir.join(&name);

        if !dest.exists() {
            // Copy split results into unified pool
            let decls_dir = src.join("split-decls");
            if decls_dir.exists() {
                fs::create_dir_all(&dest)?;
                for file in walkdir::WalkDir::new(&decls_dir)
                    .into_iter()
                    .filter_map(|e| e.ok())
                    .filter(|e| e.path().is_file())
                {
                    let rel = file.path().strip_prefix(&decls_dir).unwrap_or(file.path());
                    let target = dest.join("split-decls").join(rel);
                    if let Some(parent) = target.parent() {
                        fs::create_dir_all(parent)?;
                    }
                    if !target.exists() {
                        fs::copy(file.path(), &target)?;
                    }
                }
                merged += 1;
            }
        }
    }

    println!("  Merged {} projects into {}", merged, merge_dir.display());

    println!("\n═══ Pipeline Complete ═══");
    println!("  Split:   {} succeeded, {} failed, {} total decls",
        split_succeeded, split_failed, total_split_decls);
    println!("  Verify:  {} passed, {} failed", verified, failed_verify);
    println!("  Merged:  {} into unified pool", merged);
    println!("  Git log: git -C {} log --oneline",
        results_dir.join("git-versions").display());

    Ok(())
}
