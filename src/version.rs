/// version — Git-version each Aristotle project output.
/// Each Aristotle result becomes a git commit with the user's description
/// as the commit message and the extracted_at date as the commit date.
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use anyhow::Context;
use tracing::{debug, info, instrument, warn};

/// Create a git commit from a single Aristotle project directory
fn commit_project(
    repo: &Path,
    project_dir: &Path,
) -> anyhow::Result<bool> {
    let metadata_path = project_dir.join("aristotle_metadata.json");
    let status_path = project_dir.join("aristotle_status.json");

    if !metadata_path.exists() {
        return Ok(false);
    }

    // Read metadata for extracted_at timestamp
    let metadata: serde_json::Value = serde_json::from_str(
        &fs::read_to_string(&metadata_path)?
    )?;
    let extracted_at = metadata["extracted_at"]
        .as_str()
        .unwrap_or("unknown");

    // Read description for commit message
    let description = if status_path.exists() {
        let status: serde_json::Value = serde_json::from_str(
            &fs::read_to_string(&status_path)?
        )?;
        status["description"]
            .as_str()
            .unwrap_or("")
            .to_string()
    } else {
        String::new()
    };

    let project_name = project_dir
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or("unknown");

    // Use first line of description as commit subject, rest as body
    let commit_msg = if description.is_empty() {
        format!("aristotle: {}", project_name)
    } else {
        let first_line = description.lines().next().unwrap_or("");
        let _subject = if first_line.len() > 72 {
            format!("{}...", &first_line[..69])
        } else {
            first_line.to_string()
        };
        format!("aristotle: {}\n\n{}\n\nProject: {}", project_name, description, project_name)
    };

    // Copy project files into a temp staging area within the repo
    let dest = repo.join(project_name);
    if dest.exists() {
        fs::remove_dir_all(&dest)?;
    }
    fs::create_dir_all(&dest)?;

    // Copy all files from project_dir into dest (skip nested _aristotle dirs?)
    for entry in walkdir::WalkDir::new(project_dir)
        .max_depth(3)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let path = entry.path();
        if path.is_dir() {
            continue;
        }
        let rel = path.strip_prefix(project_dir)?;
        let target = dest.join(rel);
        if let Some(parent) = target.parent() {
            fs::create_dir_all(parent)?;
        }
        fs::copy(path, &target)?;
    }

    // Git add and commit
    let git = |args: &[&str]| -> anyhow::Result<String> {
        let output = Command::new("git")
            .args(args)
            .current_dir(repo)
            .output()
            .context("git command failed")?;
        Ok(String::from_utf8_lossy(&output.stdout).to_string())
    };

    // Stage files
    git(&["add", project_name])?;

    // Commit with extracted_at as author date
    let output = Command::new("git")
        .args([
            "-c", &format!("user.name=aristotle-manager"),
            "-c", &format!("user.email=aristotle@harmonic.fun"),
            "commit",
            "-m", &commit_msg,
            "--date", extracted_at,
        ])
        .current_dir(repo)
        .output()
        .context("git commit failed")?;

    if output.status.success() {
        info!(project = %project_name, "Committed");
        Ok(true)
    } else {
        let stderr = String::from_utf8_lossy(&output.stderr);
        warn!(project = %project_name, error = %stderr.trim(), "Commit failed");
        Ok(false)
    }
}

/// Top-level command: walk aristotles_results, create git repo, commit each project
#[instrument(skip(output_dir))]
pub fn cmd_version(
    results_dir: Option<PathBuf>,
    output_dir: Option<PathBuf>,
) -> anyhow::Result<()> {
    let results_dir = results_dir.unwrap_or_else(|| PathBuf::from("aristotles_results"));
    let repo_dir = output_dir.unwrap_or_else(|| results_dir.join("git-versions"));

    if !results_dir.exists() {
        return Err(anyhow::anyhow!(
            "Results directory not found: {}", results_dir.display()
        ));
    }

    println!("=== Aristotle Git Versioning ===");
    println!("Results:  {}", results_dir.display());
    println!("Git repo: {}", repo_dir.display());
    println!();

    // Init git repo
    fs::create_dir_all(&repo_dir)?;
    let git_dir = repo_dir.join(".git");
    if !git_dir.exists() {
        let output = Command::new("git")
            .args(["init"])
            .current_dir(&repo_dir)
            .output()
            .context("git init failed")?;
        if !output.status.success() {
            return Err(anyhow::anyhow!("git init failed: {}", String::from_utf8_lossy(&output.stderr)));
        }
        println!("Initialized git repo");
    }

    // Find all *_aristotle directories
    let mut projects: Vec<PathBuf> = Vec::new();
    for entry in fs::read_dir(&results_dir)? {
        let entry = entry?;
        if entry.file_type()?.is_dir() {
            let name = entry.file_name();
            if name.to_string_lossy().ends_with("_aristotle") {
                projects.push(entry.path());
            }
        }
    }
    projects.sort();
    println!("Found {} Aristotle project directories", projects.len());

    // Commit each
    let mut committed = 0u64;
    let mut skipped = 0u64;
    for (i, project) in projects.iter().enumerate() {
        let name = project.file_name().unwrap_or_default().to_string_lossy();
        match commit_project(&repo_dir, project) {
            Ok(true) => {
                committed += 1;
                if (i + 1) % 20 == 0 {
                    println!("  [{}/{}] committed...", i + 1, projects.len());
                }
            }
            Ok(false) => {
                skipped += 1;
                debug!(project = %name, "Skipped (no metadata)");
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
    println!("  Repo:      {}", repo_dir.display());
    println!();
    println!("  View log:  git -C {} log --oneline", repo_dir.display());

    Ok(())
}
