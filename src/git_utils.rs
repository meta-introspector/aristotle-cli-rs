/// git_utils — Git operations for Aristotle integration
use std::path::Path;
use std::process::Command;
use anyhow::{Result, Context};

#[derive(Debug, Clone)]
pub struct GitStatus {
    pub has_git_repo: bool,
    pub clean: bool,
    pub commits_ahead: usize,
    pub commits_behind: usize,
    pub current_commit: Option<String>,
    pub branch: Option<String>,
    pub untracked_files: Vec<String>,
    pub modified_files: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct GitDiff {
    pub added_files: Vec<String>,
    pub modified_files: Vec<String>,
    pub deleted_files: Vec<String>,
    pub total_changes: usize,
}

#[derive(Debug, Clone)]
pub struct PushResult {
    pub success: bool,
    pub commit_sha: Option<String>,
    pub aristotle_task_id: Option<String>,
    pub files_pushed: usize,
    pub message: String,
}

pub fn get_git_status(project_dir: &Path) -> Result<GitStatus> {
    let git_dir = project_dir.join(".git");
    if !git_dir.exists() {
        return Ok(GitStatus {
            has_git_repo: false,
            clean: true,
            commits_ahead: 0,
            commits_behind: 0,
            current_commit: None,
            branch: None,
            untracked_files: Vec::new(),
            modified_files: Vec::new(),
        });
    }

    let mut status = GitStatus {
        has_git_repo: true,
        clean: true,
        commits_ahead: 0,
        commits_behind: 0,
        current_commit: None,
        branch: None,
        untracked_files: Vec::new(),
        modified_files: Vec::new(),
    };

    // Check if working directory is clean
    let result = Command::new("git")
        .args(["status", "--porcelain"])
        .current_dir(project_dir)
        .output()
        .context("Failed to get git status")?;

    let stdout = String::from_utf8_lossy(&result.stdout);
    status.clean = stdout.trim().is_empty();

    // Parse status output
    for line in stdout.lines() {
        if line.len() >= 3 {
            let status_code = &line[0..2];
            let file_path = line[3..].trim();
            
            if status_code.contains("M") {
                status.modified_files.push(file_path.to_string());
            }
            if status_code.contains("?") {
                status.untracked_files.push(file_path.to_string());
            }
        }
    }

    // Get current commit
    let result = Command::new("git")
        .args(["rev-parse", "HEAD"])
        .current_dir(project_dir)
        .output()
        .context("Failed to get current commit")?;

    status.current_commit = Some(String::from_utf8_lossy(&result.stdout).trim().to_string());

    // Get current branch
    let result = Command::new("git")
        .args(["rev-parse", "--abbrev-ref", "HEAD"])
        .current_dir(project_dir)
        .output()
        .context("Failed to get current branch")?;

    status.branch = Some(String::from_utf8_lossy(&result.stdout).trim().to_string());

    // Get commits ahead/behind (requires remote tracking branch)
    if let Some(ref branch) = status.branch {
        let result = Command::new("git")
            .args(["rev-list", "--count", "--left-right", &format!("@{{u}}...{}", branch)])
            .current_dir(project_dir)
            .output();

        if let Ok(output) = result {
            let counts = String::from_utf8_lossy(&output.stdout);
            let parts: Vec<&str> = counts.trim().split('\t').collect();
            if parts.len() == 2 {
                status.commits_behind = parts[0].parse().unwrap_or(0);
                status.commits_ahead = parts[1].parse().unwrap_or(0);
            }
        }
    }

    Ok(status)
}

pub fn get_git_diff(project_dir: &Path, base_commit: Option<&str>) -> Result<GitDiff> {
    let git_dir = project_dir.join(".git");
    if !git_dir.exists() {
        return Ok(GitDiff {
            added_files: Vec::new(),
            modified_files: Vec::new(),
            deleted_files: Vec::new(),
            total_changes: 0,
        });
    }

    let mut diff = GitDiff {
        added_files: Vec::new(),
        modified_files: Vec::new(),
        deleted_files: Vec::new(),
        total_changes: 0,
    };

    let args = if let Some(base) = base_commit {
        vec!["diff", "--name-status", base, "HEAD"]
    } else {
        vec!["diff", "--name-status", "HEAD"]
    };

    let result = Command::new("git")
        .args(&args)
        .current_dir(project_dir)
        .output()
        .context("Failed to get git diff")?;

    let stdout = String::from_utf8_lossy(&result.stdout);
    for line in stdout.lines() {
        if line.len() >= 3 {
            let status_code = &line[0..1];
            let file_path = line[2..].trim();
            
            match status_code {
                "A" => diff.added_files.push(file_path.to_string()),
                "M" => diff.modified_files.push(file_path.to_string()),
                "D" => diff.deleted_files.push(file_path.to_string()),
                _ => {}
            }
            diff.total_changes += 1;
        }
    }

    Ok(diff)
}

pub fn create_commit(project_dir: &Path, message: &str) -> Result<String> {
    // Stage all changes
    let _ = Command::new("git")
        .args(["add", "-A"])
        .current_dir(project_dir)
        .output()
        .context("Failed to stage changes")?;

    // Create commit
    let result = Command::new("git")
        .args(["commit", "-m", message])
        .current_dir(project_dir)
        .output()
        .context("Failed to create commit")?;

    if !result.status.success() {
        anyhow::bail!("Git commit failed: {}", String::from_utf8_lossy(&result.stderr));
    }

    // Get commit SHA
    let result = Command::new("git")
        .args(["rev-parse", "HEAD"])
        .current_dir(project_dir)
        .output()
        .context("Failed to get commit SHA")?;

    Ok(String::from_utf8_lossy(&result.stdout).trim().to_string())
}

pub fn prepare_files_for_aristotle(project_dir: &Path) -> Result<Vec<std::path::PathBuf>> {
    let mut files = Vec::new();
    
    // Get list of tracked files
    let result = Command::new("git")
        .args(["ls-files"])
        .current_dir(project_dir)
        .output()
        .context("Failed to get tracked files")?;

    let stdout = String::from_utf8_lossy(&result.stdout);
    for line in stdout.lines() {
        let file_path = project_dir.join(line.trim());
        if file_path.exists() {
            files.push(file_path);
        }
    }

    Ok(files)
}

pub async fn push_to_aristotle(
    project_dir: &Path,
    project_id: &str,
    api_key: &str,
    commit_message: &str,
) -> Result<PushResult> {
    // Check git status
    let git_status = get_git_status(project_dir)?;
    
    if !git_status.clean {
        return Ok(PushResult {
            success: false,
            commit_sha: None,
            aristotle_task_id: None,
            files_pushed: 0,
            message: "Working directory not clean. Please commit or stash changes first.".to_string(),
        });
    }

    // Create commit if there are changes
    let commit_sha = if git_status.commits_ahead > 0 {
        git_status.current_commit.clone()
    } else {
        // No commits ahead, check if there are uncommitted changes
        if !git_status.modified_files.is_empty() || !git_status.untracked_files.is_empty() {
            Some(create_commit(project_dir, commit_message)?)
        } else {
            git_status.current_commit.clone()
        }
    };

    // Prepare files for submission
    let files = prepare_files_for_aristotle(project_dir)?;
    
    // Create tarball of the project directory
    let tarball_path = std::env::temp_dir().join(format!("{}_push.tar.gz", project_id));
    create_tarball(project_dir, &tarball_path)?;

    // Submit to Aristotle API
    let client = reqwest::Client::new();
    let url = format!("{}/project/{}/ask", crate::api::API_BASE_URL, project_id);
    
    let file_part = reqwest::multipart::Part::file(tarball_path.clone()).await?;
    
    let form = reqwest::multipart::Form::new()
        .part("file", file_part)
        .text("prompt", format!("Git commit {}: {}", commit_sha.as_deref().unwrap_or("unknown"), commit_message));

    let response = client
        .post(&url)
        .header("x-api-key", api_key)
        .multipart(form)
        .send()
        .await
        .context("Failed to submit to Aristotle")?;

    if response.status().is_success() {
        let json: serde_json::Value = response.json().await?;
        let task_id = json["agent_task_id"].as_str().map(|s| s.to_string());
        
        // Clean up tarball
        let _ = std::fs::remove_file(tarball_path);
        
        Ok(PushResult {
            success: true,
            commit_sha,
            aristotle_task_id: task_id,
            files_pushed: files.len(),
            message: "Successfully pushed to Aristotle".to_string(),
        })
    } else {
        let error_text = response.text().await.unwrap_or_else(|_| "Unknown error".to_string());
        Ok(PushResult {
            success: false,
            commit_sha,
            aristotle_task_id: None,
            files_pushed: 0,
            message: format!("Aristotle API error: {}", error_text),
        })
    }
}

fn create_tarball(source_dir: &Path, output_path: &Path) -> Result<()> {
    let file = std::fs::File::create(output_path)?;
    let gzip = flate2::write::GzEncoder::new(file, flate2::Compression::default());
    let mut tar = tar::Builder::new(gzip);
    
    tar.append_dir_all(".", source_dir)?;
    tar.finish()?;
    
    Ok(())
}
