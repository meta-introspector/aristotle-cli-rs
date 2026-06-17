/// replay — Replay entire Aristotle archive into a fresh split/merge repo.
/// Processes all projects in chronological order (by extracted_at date),
/// splitting each and committing incrementally. Reconstructs history from scratch.
use std::collections::BTreeMap;
use std::fs;
use std::path::PathBuf;
use std::process::Command;
use serde::{Deserialize, Serialize};
use tracing::{info, instrument, warn};

use crate::load_config;

#[derive(Debug, Deserialize, Serialize)]
struct ProjectMeta {
    extracted_at: Option<String>,
    project_dir: Option<String>,
}

/// Replay all projects chronologically into a fresh repo
#[instrument]
pub async fn cmd_replay(
    output_dir: Option<PathBuf>,
    dry_run: bool,
) -> anyhow::Result<()> {
    let config = load_config()?;
    let results_dir = &config.results_dir;
    let output = output_dir.unwrap_or_else(|| PathBuf::from("replay-output"));

    println!("=== Aristotle Replay ===");
    println!("Source: {}", results_dir.display());
    println!("Output: {}", output.display());
    println!();

    // ── Step 1: Discover all projects with their dates ─────────────
    println!("[1/6] Discovering projects...");
    let mut projects: BTreeMap<String, (PathBuf, String)> = BTreeMap::new();

    for entry in fs::read_dir(results_dir)? {
        let entry = entry?;
        if !entry.file_type()?.is_dir() {
            continue;
        }
        let name = entry.file_name().to_string_lossy().to_string();
        if !name.ends_with("_aristotle") {
            continue;
        }

        let meta_path = entry.path().join("aristotle_metadata.json");
        let date = if meta_path.exists() {
            if let Ok(content) = fs::read_to_string(&meta_path) {
                if let Ok(meta) = serde_json::from_str::<serde_json::Value>(&content) {
                    meta["extracted_at"].as_str().unwrap_or("1970-01-01").to_string()
                } else {
                    "1970-01-01".to_string()
                }
            } else {
                "1970-01-01".to_string()
            }
        } else {
            "1970-01-01".to_string()
        };

        let rp_exists = entry.path()
            .join("output-final_aristotle")
            .join("RequestProject")
            .exists();

        if rp_exists {
            projects.insert(format!("{}|{}", date, name), (entry.path(), name));
        }
    }

    println!("  Found {} splittable projects (chronological order)", projects.len());

    if dry_run {
        println!("\n  Dry run — would process:");
        for (i, (key, (_, name))) in projects.iter().enumerate() {
            let date = key.split('|').next().unwrap_or("?");
            if i < 10 || i > projects.len() - 3 {
                println!("    {}  {}", date, name);
            } else if i == 10 {
                println!("    ... {} more ...", projects.len() - 20);
            }
        }
        return Ok(());
    }

    // ── Step 2: Init fresh repo ────────────────────────────────────
    println!("\n[2/6] Initializing fresh repo...");
    if output.exists() {
        fs::remove_dir_all(&output)?;
    }
    fs::create_dir_all(&output)?;

    let mut git = |args: &[&str]| -> anyhow::Result<()> {
        let out = Command::new("git")
            .args(args)
            .current_dir(&output)
            .output()?;
        if !out.status.success() {
            warn!("git {}: {}", args.join(" "), String::from_utf8_lossy(&out.stderr));
        }
        Ok(())
    };

    git(&["init"])?;
    git(&["-c", "user.name=aristotle-replay", "-c", "user.email=replay@harmonic.fun",
          "commit", "--allow-empty", "-m", "initial: empty replay repo", "--date=1970-01-01T00:00:00Z"])?;

    let split_dir = output.join("split-decls");
    fs::create_dir_all(&split_dir)?;

    // ── Step 3: Split each project chronologically ─────────────────
    println!("\n[3/6] Splitting {} projects...", projects.len());
    let mut ok = 0u64;
    let mut failed = 0u64;
    let mut total_decls = 0u64;

    let splitter = std::env::current_dir()?.join("split-aristotle-project.sh");

    for (i, (key, (proj_dir, name))) in projects.iter().enumerate() {
        let date = key.split('|').next().unwrap_or("?");

        let proj_out = output.join("work").join(name);
        fs::create_dir_all(proj_out.parent().unwrap())?;

        if proj_out.exists() {
            fs::remove_dir_all(&proj_out)?;
        }

        let proj_str = proj_dir.to_string_lossy().to_string();
        let out_str = proj_out.to_string_lossy().to_string();

        match Command::new(&splitter)
            .args([&proj_str, &out_str])
            .output()
        {
            Ok(result) if result.status.success() => {
                // Copy split results into the unified pool
                let src = proj_out.join("split-decls");
                let mut new_decls = 0u64;
                if src.exists() {
                    for file in walkdir::WalkDir::new(&src)
                        .into_iter()
                        .filter_map(|e| e.ok())
                        .filter(|e| e.path().is_file())
                    {
                        let rel = file.path().strip_prefix(&src).unwrap_or(file.path());
                        let dest = split_dir.join(rel);
                        if let Some(parent) = dest.parent() {
                            fs::create_dir_all(parent)?;
                        }
                        fs::copy(file.path(), &dest)?;
                        new_decls += 1;
                    }
                }

                total_decls += new_decls;
                ok += 1;

                // Git commit this project's contribution
                git(&["add", "split-decls/"])?;

                // Get summary for commit message
                let summary_path = proj_dir.join("ARISTOTLE_SUMMARY.md");
                let summary = if summary_path.exists() {
                    fs::read_to_string(&summary_path).unwrap_or_default()
                        .lines().take(3).collect::<Vec<_>>().join("\n")
                } else {
                    format!("{} — {} declarations", name, new_decls)
                };

                let msg = format!("[{}/{}] {}\n\n{} new declarations", i + 1, projects.len(), name, new_decls);
                git(&["-c", "user.name=aristotle-replay",
                      "-c", "user.email=replay@harmonic.fun",
                      "commit", "-m", &msg, "--date", &format!("{}T00:00:00Z", date)])?;

                if (i + 1) % 20 == 0 {
                    println!("  [{}/{}] {} decls — {}", i + 1, projects.len(), total_decls, name);
                }
            }
            _ => {
                warn!(project = %name, "Split failed");
                failed += 1;
            }
        }

        // Cleanup work dir
        let _ = fs::remove_dir_all(&output.join("work"));
    }

    println!("  Split: {} ok, {} failed, {} total declarations", ok, failed, total_decls);

    // ── Step 4: Generate lakefile + build ───────────────────────────
    println!("\n[4/6] Generating lakefile...");
    let lakefile = output.join("lakefile.toml");
    fs::write(&lakefile, format!(r#"
name = "replay-pool"
defaultTargets = ["ReplayPool"]
[[lean_lib]]
name = "ReplayPool"
globs = ["ReplayPool.+"]
"#))?;

    // Reorganize: split-decls/ → ReplayPool/
    let pool = output.join("ReplayPool");
    if split_dir.exists() {
        fs::rename(&split_dir, &pool)?;
    }
    git(&["add", "-A"])?;
    git(&["-c", "user.name=aristotle-replay",
          "commit", "-m", "pool: unified declaration pool from split results",
          "--date", chrono::Utc::now().to_rfc3339().as_str()])?;

    // ── Step 5: Verify with lake build ─────────────────────────────
    println!("\n[5/6] Verifying with lake build...");
    let lake_bin = if PathBuf::from("/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin/lake").exists() {
        "/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin/lake"
    } else {
        "lake"
    };

    match Command::new(lake_bin)
        .args(["build"])
        .current_dir(&output)
        .output()
    {
        Ok(result) => {
            let stderr = String::from_utf8_lossy(&result.stderr);
            if result.status.success() {
                println!("  ✓ lake build succeeded — all declarations compile");
                git(&["-c", "user.name=aristotle-replay",
                      "commit", "-m", "verify: lake build passed — all declarations are valid Lean",
                      "--allow-empty",
                      "--date", chrono::Utc::now().to_rfc3339().as_str()])?;
            } else {
                let last_lines: Vec<&str> = stderr.lines().rev().take(10).collect();
                println!("  ✗ lake build failed:");
                for line in last_lines.iter().rev() {
                    println!("    {}", line);
                }
                git(&["-c", "user.name=aristotle-replay",
                      "commit", "-m", "verify: lake build had errors (see log)",
                      "--allow-empty",
                      "--date", chrono::Utc::now().to_rfc3339().as_str()])?;
            }
        }
        Err(e) => {
            println!("  ✗ lake not found: {}", e);
        }
    }

    // ── Step 6: Generate dag.json (dependency graph) ────────────────
    println!("\n[6/6] Generating dependency DAG...");
    let dag_path = output.join("dag.json");
    let mut dag: serde_json::Map<String, serde_json::Value> = serde_json::Map::new();
    let pool_dir = output.join("ReplayPool");
    if pool_dir.exists() {
        for file in walkdir::WalkDir::new(&pool_dir)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().extension().map_or(false, |e| e == "lean"))
        {
            if let Ok(content) = fs::read_to_string(file.path()) {
                let name = file.path().file_stem()
                    .and_then(|s| s.to_str())
                    .unwrap_or("?")
                    .to_string();
                let imports: Vec<String> = content.lines()
                    .filter(|l| l.trim().starts_with("import "))
                    .filter_map(|l| {
                        let imp = l.trim().strip_prefix("import ")?;
                        Some(imp.to_string())
                    })
                    .collect();
                dag.insert(name, serde_json::json!(imports));
            }
        }
    }
    fs::write(&dag_path, serde_json::to_string_pretty(&dag)?)?;
    git(&["add", "dag.json"])?;
    git(&["-c", "user.name=aristotle-replay",
          "commit", "-m", "dag: dependency graph for all declarations",
          "--date", chrono::Utc::now().to_rfc3339().as_str()])?;

    // ── Summary ────────────────────────────────────────────────────
    println!("\n═══ Replay Complete ═══");
    println!("  Projects:    {} ok, {} failed", ok, failed);
    println!("  Declarations: {}", total_decls);
    println!("  Output:      {}", output.display());
    println!("  Commits:     $(git -C {} rev-list --count HEAD)", output.display());
    println!("\n  View:  git -C {} log --oneline --graph", output.display());
    println!("  Build: cd {} && lake build", output.display());

    Ok(())
}
