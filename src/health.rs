/// health — Project health checking and problem detection
use std::fs;
use std::path::Path;
use std::process::Command;
use anyhow::Result;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HealthCheck {
    pub project_id: String,
    pub overall_status: HealthStatus,
    pub api_status: ApiStatus,
    pub local_status: LocalStatus,
    pub build_status: BuildStatus,
    pub git_status: GitStatus,
    pub warnings: Vec<HealthWarning>,
    pub errors: Vec<HealthError>,
    pub recommendations: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum HealthStatus {
    Healthy,
    Warning,
    Critical,
    Unknown,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ApiStatus {
    pub has_files: bool,
    pub status_code: i64,
    pub last_updated: String,
    pub metadata_consistent: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LocalStatus {
    pub lean_file_count: usize,
    pub sorry_count: usize,
    pub admit_count: usize,
    pub files_present: bool,
    pub metadata_present: bool,
    pub extracted_at: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BuildStatus {
    pub can_build: bool,
    pub build_output: String,
    pub errors: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GitStatus {
    pub has_git_repo: bool,
    pub clean: bool,
    pub commits_ahead: usize,
    pub commits_behind: usize,
    pub current_commit: Option<String>,
    pub branch: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HealthWarning {
    pub category: WarningCategory,
    pub message: String,
    pub severity: WarningSeverity,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum WarningCategory {
    StaleProject,
    BuildWarnings,
    SorriesPresent,
    MetadataInconsistency,
    GitDivergence,
    MissingDependencies,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum WarningSeverity {
    Low,
    Medium,
    High,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HealthError {
    pub category: ErrorCategory,
    pub message: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ErrorCategory {
    BuildFailure,
    FileCorruption,
    MissingFiles,
    ApiError,
    GitError,
}

pub fn check_project_health(
    project_id: &str,
    project_dir: &Path,
    api_last_updated: Option<&str>,
    _config: &crate::Config,
) -> Result<HealthCheck> {
    let mut health = HealthCheck {
        project_id: project_id.to_string(),
        overall_status: HealthStatus::Unknown,
        api_status: ApiStatus {
            has_files: false,
            status_code: 0,
            last_updated: api_last_updated.unwrap_or("").to_string(),
            metadata_consistent: true,
        },
        local_status: LocalStatus {
            lean_file_count: 0,
            sorry_count: 0,
            admit_count: 0,
            files_present: project_dir.exists(),
            metadata_present: false,
            extracted_at: None,
        },
        build_status: BuildStatus {
            can_build: false,
            build_output: String::new(),
            errors: Vec::new(),
        },
        git_status: GitStatus {
            has_git_repo: false,
            clean: true,
            commits_ahead: 0,
            commits_behind: 0,
            current_commit: None,
            branch: None,
        },
        warnings: Vec::new(),
        errors: Vec::new(),
        recommendations: Vec::new(),
    };

    if !project_dir.exists() {
        health.overall_status = HealthStatus::Critical;
        health.errors.push(HealthError {
            category: ErrorCategory::MissingFiles,
            message: format!("Project directory not found: {}", project_dir.display()),
        });
        health.recommendations.push("Download project: aristotle-manager download-result".to_string());
        return Ok(health);
    }

    // Check local status
    check_local_status(&mut health, project_dir)?;

    // Check metadata consistency
    check_metadata_consistency(&mut health, project_dir, api_last_updated)?;

    // Check build status
    check_build_status(&mut health, project_dir)?;

    // Check git status
    check_git_status(&mut health, project_dir)?;

    // Check for sorries
    if health.local_status.sorry_count > 0 {
        health.warnings.push(HealthWarning {
            category: WarningCategory::SorriesPresent,
            message: format!("{} sorries found in Lean files", health.local_status.sorry_count),
            severity: if health.local_status.sorry_count > 10 {
                WarningSeverity::High
            } else {
                WarningSeverity::Medium
            },
        });
        health.recommendations.push("Review and resolve sorries to improve proof completeness".to_string());
    }

    // Determine overall status
    health.overall_status = determine_overall_status(&health);

    Ok(health)
}

fn check_local_status(health: &mut HealthCheck, project_dir: &Path) -> Result<()> {
    // Count Lean files and sorries
    for entry in walkdir::WalkDir::new(project_dir)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
    {
        health.local_status.lean_file_count += 1;
        if let Ok(content) = fs::read_to_string(entry.path()) {
            health.local_status.sorry_count += content.matches("sorry").count();
            health.local_status.admit_count += content.matches("admit").count();
        }
    }

    // Check for metadata
    let metadata_path = project_dir.join("aristotle_metadata.json");
    health.local_status.metadata_present = metadata_path.exists();
    
    if health.local_status.metadata_present {
        if let Ok(metadata_str) = fs::read_to_string(&metadata_path) {
            if let Ok(metadata) = serde_json::from_str::<serde_json::Value>(&metadata_str) {
                health.local_status.extracted_at = metadata["extracted_at"].as_str().map(|s| s.to_string());
            }
        }
    }

    Ok(())
}

fn check_metadata_consistency(
    health: &mut HealthCheck,
    project_dir: &Path,
    api_last_updated: Option<&str>,
) -> Result<()> {
    if let (Some(local_extracted), Some(api_updated)) = (&health.local_status.extracted_at, api_last_updated) {
        // Parse timestamps and compare
        if let (Ok(local_time), Ok(api_time)) = (
            chrono::DateTime::parse_from_rfc3339(local_extracted),
            chrono::DateTime::parse_from_rfc3339(api_updated),
        ) {
            health.api_status.metadata_consistent = local_time >= api_time;
            
            if !health.api_status.metadata_consistent {
                health.warnings.push(HealthWarning {
                    category: WarningCategory::MetadataInconsistency,
                    message: format!("Local metadata ({}) is older than API ({})", local_extracted, api_updated),
                    severity: WarningSeverity::Medium,
                });
                health.recommendations.push("Run fetch to update: aristotle-manager fetch".to_string());
            }
        }
    }
    
    Ok(())
}

fn check_build_status(health: &mut HealthCheck, project_dir: &Path) -> Result<()> {
    let lakefile = project_dir.join("lakefile.lean");
    if !lakefile.exists() {
        health.build_status.can_build = true; // Not a Lean project
        return Ok(());
    }

    // Try to run lake build
    let result = Command::new("lake")
        .args(["build", "--timeout", "300"])
        .current_dir(project_dir)
        .output();

    match result {
        Ok(output) => {
            health.build_status.can_build = output.status.success();
            health.build_status.build_output = String::from_utf8_lossy(&output.stdout).to_string();
            
            if !health.build_status.can_build {
                let stderr = String::from_utf8_lossy(&output.stderr);
                health.build_status.errors.push(stderr.to_string());
                health.errors.push(HealthError {
                    category: ErrorCategory::BuildFailure,
                    message: "Lake build failed".to_string(),
                });
                health.recommendations.push("Review build errors and fix dependencies".to_string());
            }
        }
        Err(e) => {
            health.build_status.can_build = false;
            health.build_status.errors.push(e.to_string());
            health.warnings.push(HealthWarning {
                category: WarningCategory::MissingDependencies,
                message: "Lake command not found or not executable".to_string(),
                severity: WarningSeverity::High,
            });
        }
    }

    Ok(())
}

fn check_git_status(health: &mut HealthCheck, project_dir: &Path) -> Result<()> {
    let git_dir = project_dir.join(".git");
    health.git_status.has_git_repo = git_dir.exists();

    if !health.git_status.has_git_repo {
        return Ok(());
    }

    // Check if working directory is clean
    let result = Command::new("git")
        .args(["status", "--porcelain"])
        .current_dir(project_dir)
        .output();

    if let Ok(output) = result {
        let stdout = String::from_utf8_lossy(&output.stdout);
        health.git_status.clean = stdout.trim().is_empty();
    }

    // Get current commit
    let result = Command::new("git")
        .args(["rev-parse", "HEAD"])
        .current_dir(project_dir)
        .output();

    if let Ok(output) = result {
        let stdout = String::from_utf8_lossy(&output.stdout);
        health.git_status.current_commit = Some(stdout.trim().to_string());
    }

    // Get current branch
    let result = Command::new("git")
        .args(["rev-parse", "--abbrev-ref", "HEAD"])
        .current_dir(project_dir)
        .output();

    if let Ok(output) = result {
        let stdout = String::from_utf8_lossy(&output.stdout);
        health.git_status.branch = Some(stdout.trim().to_string());
    }

    // Check for commits ahead/behind (this would need remote tracking info)
    // For now, just flag if not clean
    if !health.git_status.clean {
        health.warnings.push(HealthWarning {
            category: WarningCategory::GitDivergence,
            message: "Working directory has uncommitted changes".to_string(),
            severity: WarningSeverity::Medium,
        });
        health.recommendations.push("Commit or stash changes: git commit/stash".to_string());
    }

    Ok(())
}

fn determine_overall_status(health: &HealthCheck) -> HealthStatus {
    if !health.errors.is_empty() {
        return HealthStatus::Critical;
    }
    
    if !health.warnings.is_empty() {
        let high_severity_count = health.warnings.iter()
            .filter(|w| w.severity == WarningSeverity::High)
            .count();
        
        if high_severity_count > 0 {
            return HealthStatus::Critical;
        }
        return HealthStatus::Warning;
    }
    
    HealthStatus::Healthy
}

pub fn format_health_report(health: &HealthCheck) -> String {
    let status_icon = match health.overall_status {
        HealthStatus::Healthy => "✅",
        HealthStatus::Warning => "⚠️",
        HealthStatus::Critical => "❌",
        HealthStatus::Unknown => "❓",
    };

    let mut report = format!(
        "Project: {}\n  Status: {} {}\n",
        health.project_id, status_icon, format!("{:?}", health.overall_status)
    );

    if !health.warnings.is_empty() {
        report.push_str(&format!("  Warnings: {}\n", health.warnings.len()));
        for warning in &health.warnings {
            let severity_icon = match warning.severity {
                WarningSeverity::Low => "🔵",
                WarningSeverity::Medium => "🟡", 
                WarningSeverity::High => "🔴",
            };
            report.push_str(&format!("    {} {}: {}\n", severity_icon, format!("{:?}", warning.category), warning.message));
        }
    }

    if !health.errors.is_empty() {
        report.push_str(&format!("  Errors: {}\n", health.errors.len()));
        for error in &health.errors {
            report.push_str(&format!("    ❌ {}: {}\n", format!("{:?}", error.category), error.message));
        }
    }

    if !health.recommendations.is_empty() {
        report.push_str("  Recommendations:\n");
        for rec in &health.recommendations {
            report.push_str(&format!("    → {}\n", rec));
        }
    }

    report
}
