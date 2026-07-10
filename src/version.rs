/// version — Git-version each Aristotle project output individually.
/// Each project gets its OWN git repo under `git-versions/<project_id>/`.
/// The extracted_at date becomes the commit author date.
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use anyhow::Context;
use tracing::{debug, info, instrument, warn};

/// Create (or update) a git repo for one project, committing its current files.
fn commit_project(
    repo: &Path,
    project_dir: &Path,
) -> anyhow::Result<bool> {
    let metadata_path = project_dir.join("aristotle_metadata.json");
    if !metadata_path.exists() {
        return Ok(false);
    }

    // Read metadata for extracted_at + project_id
    let metadata: serde_json::Value = serde_json::from_str(
        &fs::read_to_string(&metadata_path)?
    )?;
    let extracted_at = metadata["extracted_at"]
        .as_str()
        .unwrap_or("unknown");

    // Derive commit message from status description
    let status_path = project_dir.join("aristotle_status.json");
    let description = if status_path.exists() {
        let status: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(&status_path)?
        )?;
        status["description"].as_str().unwrap_or("").to_string()
    } else {
        String::new()
    };

    let project_name = project_dir
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or("unknown");

    let commit_msg = if description.is_empty() {
        format!("aristotle: {}", project_name)
    } else {
        let first_line = description.lines().next().unwrap_or("");
        format!("aristotle: {}\n\n{}\n\nProject: {}", project_name, description, project_name)
    };

    // Init git repo for this project if it doesn't exist
    let git_dir = repo.join(".git");
    if !git_dir.exists() {
        let out = Command::new("git")
            .args(["init"])
            .current_dir(repo)
            .output()
            .context("git init failed")?;
        if !out.status.success() {
            warn!(project = %project_name, "git init failed: {}", String::from_utf8_lossy(&out.stderr));
            return Ok(false);
        }
        // Create an initial empty commit so that later commits can be made
        Command::new("git")
            .args([
                "-c", "user.name=aristotle-manager",
                "-c", "user.email=aristotle@harmonic.fun",
                "commit", "--allow-empty",
                "-m", "aristotle: initial commit",
            ])
            .current_dir(repo)
            .output()
            .context("first empty commit failed")?;
    }

    // Sync project files into the repo directory (only changed/new files)
    let mut changed = false;
    for entry in walkdir::WalkDir::new(project_dir)
        .max_depth(5)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let path = entry.path();
        if path.is_dir() {
            continue;
        }
        let rel = path.strip_prefix(project_dir)?;
        let target = repo.join(rel);
        if let Some(parent) = target.parent() {
            fs::create_dir_all(parent)?;
        }
        // Only copy if source is newer or target doesn't exist
        if target.exists() {
            let src_meta = fs::metadata(path)?;
            let dst_meta = fs::metadata(&target)?;
            let src_mtime = src_meta.modified()?;
            let dst_mtime = dst_meta.modified()?;
            if src_mtime <= dst_mtime {
                continue;
            }
        }
        fs::copy(path, &target)?;
        changed = true;
    }

    // If nothing was copied, check if repo is already clean
    if !changed {
        let status_out = Command::new("git")
            .args(["status", "--porcelain"])
            .current_dir(repo)
            .output()
            .context("git status failed")?;
        let status_lines = String::from_utf8_lossy(&status_out.stdout);
        if status_lines.trim().is_empty() {
            debug!(project = %project_name, "No changes, skipping commit");
            return Ok(false);
        }
    }

    // Stage all files
    let out = Command::new("git")
        .args(["add", "-A"])
        .current_dir(repo)
        .output()
        .context("git add failed")?;
    if !out.status.success() {
        warn!(project = %project_name, "git add failed: {}", String::from_utf8_lossy(&out.stderr));
        return Ok(false);
    }

    // Commit with extracted_at as author date
    let out = Command::new("git")
        .args([
            "-c", "user.name=aristotle-manager",
            "-c", "user.email=aristotle@harmonic.fun",
            "commit",
            "-m", &commit_msg,
            "--date", extracted_at,
        ])
        .current_dir(repo)
        .output()
        .context("git commit failed")?;

    if out.status.success() {
        info!(project = %project_name, "Committed");
        Ok(true)
    } else {
        let stderr = String::from_utf8_lossy(&out.stderr);
        warn!(project = %project_name, error = %stderr.trim(), "Commit failed");
        Ok(false)
    }
}

/// Top-level command: walk results dir, create individual git repo per project
#[instrument(skip(output_dir))]
pub fn cmd_version(
    results_dir: Option<PathBuf>,
    output_dir: Option<PathBuf>,
) -> anyhow::Result<()> {
    let results_dir = results_dir.unwrap_or_else(|| PathBuf::from("aristotles_results"));
    let git_base = output_dir.unwrap_or_else(|| results_dir.join("git-versions"));

    if !results_dir.exists() {
        return Err(anyhow::anyhow!(
            "Results directory not found: {}", results_dir.display()
        ));
    }

    println!("=== Aristotle Git Versioning ===");
    println!("Results: {}", results_dir.display());
    println!("Git base: {}", git_base.display());
    println!("(each project gets its own repo under git base)");
    println!();

    // Find all *_aristotle directories
    let mut projects: Vec<PathBuf> = Vec::new();
    for entry in fs::read_dir(&results_dir)? {
        let entry = entry?;
        if entry.file_type()?.is_dir() {
            let name = entry.file_name();
            if name.to_string_lossy().ends_with("_aristotle") {
                let clean = name.to_string_lossy().replace(' ', "_");
                if clean != name.to_string_lossy() {
                    // Rename directory to remove spaces
                    let src = entry.path();
                    let dst = src.with_file_name(&clean);
                    let _ = fs::rename(&src, &dst);
                    projects.push(dst);
                } else {
                    projects.push(entry.path());
                }
            }
        }
    }
    projects.sort();
    println!("Found {} Aristotle project directories", projects.len());

    // Commit each project into its own repo
    let mut committed = 0u64;
    let mut skipped = 0u64;

    for (i, project) in projects.iter().enumerate() {
        let name = project.file_name().unwrap_or_default().to_string_lossy();

        // Strip '_aristotle' suffix to get the repo dir name
        let repo_name = name.trim_end_matches("_aristotle");
        let repo_dir = git_base.join(repo_name);
        fs::create_dir_all(&repo_dir)?;

        match commit_project(&repo_dir, project) {
            Ok(true) => {
                committed += 1;
                if (i + 1) % 20 == 0 {
                    println!("  [{}/{}] committed...", i + 1, projects.len());
                }
            }
            Ok(false) => {
                skipped += 1;
                debug!(project = %name, "No changes or no metadata");
            }
            Err(e) => {
                skipped += 1;
                warn!(project = %name, error = %e, "Failed");
            }
        }
    }

    println!("\n=== Complete ===");
    println!("  Committed: {}", committed);
    println!("  Skipped:   {}", skipped);
    println!("  Git base:  {}", git_base.display());
    println!();

    // Show summary of newest repos
    println!("  Newest repos:");
    let mut entries: Vec<_> = fs::read_dir(&git_base)?
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_ok() && e.file_type().unwrap().is_dir())
        .collect();
    entries.sort_by_key(|e| e.path().join(".git").exists());
    entries.reverse();
    for e in entries.iter().take(10) {
        let name = e.file_name().to_string_lossy();
        let git_path = e.path().join(".git");
        let age = if git_path.exists() {
            let log = Command::new("git")
                .args(["-C", e.path().to_str().unwrap_or(""), "log", "--oneline", "-1"])
                .output();
            match log {
                Ok(out) => String::from_utf8_lossy(&out.stdout).trim().to_string(),
                Err(_) => "?".to_string(),
            }
        } else {
            "no repo".to_string()
        };
        println!("    {}  {}", e.file_name().to_string_lossy(), age);
    }

    Ok(())
}
