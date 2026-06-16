use std::env;
use std::fs::{self, File, OpenOptions};
use std::io::Write;
use std::path::PathBuf;
use std::process::Command;
use std::sync::{Arc, RwLock};
use std::time::Duration;
use anyhow::{Context, Result};
use clap::{Parser, Subcommand};
use flate2::read::GzDecoder;
use reqwest::Client;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use tar::Archive;
use tracing::{debug, error, info, instrument, warn};
use tracing_subscriber::{EnvFilter, fmt};
use walkdir::WalkDir;

mod index;
mod notebooklm;
mod file_index;

#[derive(Parser)]
#[command(name = "aristotle-manager")]
#[command(version = VERSION)]
#[command(about = "Tool for polling Aristotle results and managing Lean4 project compilation")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

const VERSION: &str = env!("CARGO_PKG_VERSION");
const API_BASE_URL: &str = "https://aristotle.harmonic.fun/api/v3";

static API_KEY: RwLock<Option<String>> = RwLock::new(None);

fn get_api_key() -> Result<String> {
    if let Some(key) = &*API_KEY.read().unwrap() {
        debug!("API key retrieved from static store");
        Ok(key.clone())
    } else {
        env::var("ARISTOTLE_API_KEY")
            .map_err(|_| {
                error!("API key not set in env or static store");
                anyhow::anyhow!("API key not set. Set ARISTOTLE_API_KEY or use configure set")
            })
    }
}

fn set_api_key(api_key: &str) {
    debug!("Setting API key in static store");
    *API_KEY.write().unwrap() = Some(api_key.to_string());
}

#[derive(Subcommand)]
enum Commands {
    /// Poll for new projects
    Poll {
        #[arg(long)]
        download_only: bool,
        #[arg(short = 'j', default_value = "4")]
        parallel: usize,
    },
    /// Build all projects
    Build {
        #[arg(long)]
        input_dir: Option<PathBuf>,
        #[arg(long)]
        no_fail_fast: bool,
        #[arg(short = 'v')]
        verbose: bool,
    },
    /// Download results from Aristotle
    Download {
        #[arg(short = 'j', default_value = "4")]
        parallel: usize,
        #[arg(long, default_value = "console")]
        trace: String,
        #[arg(long, default_value = "false")]
        verbose: bool,
        #[arg(long)]
        limit: Option<usize>,
    },
    /// Split Lean4 modules (de-duplicate)
    Split {
        #[arg(long)]
        input_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Refresh: pull latest from Aristotle, download new, split all, build decl table
    Refresh {
        #[arg(short = 'j', default_value = "4")]
        parallel: usize,
        #[arg(long)]
        limit: Option<usize>,
    },
    /// Build canonical declaration table from split results
    DeclTable {
        #[arg(long)]
        split_dir: Option<PathBuf>,
        #[arg(long)]
        output: Option<PathBuf>,
    },
    /// Merge split results
    Merge {
        #[arg(long)]
        input_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Submit a project to the Aristotle API
    Submit {
        /// Prompt text or file containing the prompt
        prompt: String,
        #[arg(long)]
        project_dir: Option<PathBuf>,
        #[arg(long)]
        wait: bool,
    },
    /// Check status of a submitted Aristotle project
    Check {
        /// Project ID to check (omit to list recent)
        project_id: Option<String>,
        #[arg(long)]
        limit: Option<usize>,
    },
    /// Download results from a completed Aristotle project
    DownloadResult {
        /// Project ID to download
        project_id: String,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Test Lean4 projects
    Test {
        #[arg(long)]
        no_fail_fast: bool,
        #[arg(short = 'v')]
        verbose: bool,
    },
    /// Show results
    Results,
    /// Configure settings
    Configure {
        #[command(subcommand)]
        subcommand: ConfigureCommands,
    },
    /// Clean build artifacts
    Clean,
    /// Index all Aristotle runs into DASL-compatible blocks.json
    Index {
        #[arg(long)]
        output: Option<PathBuf>,
    },
    /// Generate text files for NotebookLM
    Notebooklm {
        /// The path to the Aristotle project directory
        #[arg(long)]
        project_dir: PathBuf,
    },
    /// Run SplitDecls on all Lean projects and produce per-declaration flake.nix lattice
    SplitAll {
        #[arg(long)]
        output_dir: Option<PathBuf>,
        #[arg(short = 'j', default_value = "4")]
        parallel: usize,
        #[arg(long)]
        dry_run: bool,
    },
    /// Scan index files (lists of file paths), find Lean4 proofs, ingest
    ScanIndex {
        #[arg(long)]
        index_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
        #[arg(long)]
        prefix_filter: Option<String>,
    },
}

#[derive(Subcommand)]
enum ConfigureCommands {
    Set {
        #[arg(short = 'k')]
        api_key: Option<String>,
    },
    Show,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Config {
    base_dir: PathBuf,
    results_dir: PathBuf,
    git_base: PathBuf,
    max_parallel_downloads: usize,
    retry_wait_seconds: u64,
    max_retries: usize,
}

#[instrument]
pub fn load_config() -> Result<Config> {
    let config_dir = dirs::config_dir()
        .context("Could not determine config directory")?
        .join("aristotle-manager");
    fs::create_dir_all(&config_dir)?;
    let config_path = config_dir.join("config.toml");

    if !config_path.exists() {
        let default_config = Config {
            base_dir: PathBuf::from("aristotles_results"),
            results_dir: PathBuf::from("aristotles_results"),
            git_base: PathBuf::from("aristotles_results"),
            max_parallel_downloads: 4,
            retry_wait_seconds: 10,
            max_retries: 3,
        };
        let toml = toml::to_string(&default_config)?;
        fs::write(&config_path, toml)?;
        info!(
            config_path = %config_path.display(),
            "Created default configuration"
        );
        return Ok(default_config);
    }

    let toml = fs::read_to_string(&config_path)?;
    let mut config: Config = toml::from_str(&toml)
        .with_context(|| format!("Failed to parse config at {}", config_path.display()))?;
    
    let current_dir = env::current_dir()?;
    if current_dir.to_string_lossy() == "/mnt/data1/time-2026/05-may/07/arist" {
        config.git_base = current_dir;
    }

    debug!(
        base_dir = %config.base_dir.display(),
        results_dir = %config.results_dir.display(),
        git_base = %config.git_base.display(),
        max_parallel = config.max_parallel_downloads,
        "Loaded configuration"
    );
    Ok(config)
}

#[instrument]
fn cmd_results() -> Result<()> {
    let config = load_config()?;
    let result_file = config.base_dir.join("result.txt");
    if result_file.exists() {
        let contents = fs::read_to_string(&result_file)?;
        info!(path = %result_file.display(), "Displaying results");
        println!("{}", contents);
    } else {
        info!("No results found");
        println!("No results found.");
    }
    Ok(())
}

#[instrument]
fn cmd_clean() -> Result<()> {
    let config = load_config()?;
    let result_file = config.base_dir.join("result.txt");
    if result_file.exists() {
        fs::remove_file(&result_file)?;
        info!(path = %result_file.display(), "Cleaned up result file");
        println!("Cleaned up result file.");
    } else {
        info!("No result file found to clean");
        println!("No result file found.");
    }
    Ok(())
}

#[instrument(skip(subcommand))]
fn cmd_configure(subcommand: &ConfigureCommands) -> Result<()> {
    let config_dir = dirs::config_dir()
        .context("Could not determine config directory")?
        .join("aristotle-manager");
    fs::create_dir_all(&config_dir)?;
    let config_path = config_dir.join("config.toml");

    match subcommand {
        ConfigureCommands::Set { api_key } => {
            if let Some(key) = api_key {
                set_api_key(key);
                info!("API key set from CLI argument");
                println!("API key set");
            } else {
                println!("Enter API key:");
                let mut input = String::new();
                std::io::stdin().read_line(&mut input)?;
                set_api_key(input.trim());
                info!("API key set from stdin");
                println!("API key set");
            }
            // Save config
            let config_str = fs::read_to_string(&config_path).unwrap_or_default();
            let mut config: Config = if config_str.is_empty() {
                Config {
                    base_dir: PathBuf::from("aristotles_results"),
                    results_dir: PathBuf::from("aristotles_results"),
                    git_base: PathBuf::from("aristotles_results"),
                    max_parallel_downloads: 4,
                    retry_wait_seconds: 10,
                    max_retries: 3,
                }
            } else {
                toml::from_str(&config_str)?
            };
            config.git_base = PathBuf::from("aristotles_results");
            config.base_dir = PathBuf::from("aristotles_results");
            config.results_dir = PathBuf::from("aristotles_results");
            let toml = toml::to_string(&config)?;
            fs::write(&config_path, toml)?;
            info!(path = %config_path.display(), "Configuration saved");
            println!("Configuration saved");
        }
        ConfigureCommands::Show => {
            let config = load_config()?;
            info!("Displaying configuration");
            println!("Configuration:");
            println!("  Base directory:       {}", config.base_dir.display());
            println!("  Results directory:    {}", config.results_dir.display());
            println!("  Git base:             {}", config.git_base.display());
            println!("  Max parallel downloads: {}", config.max_parallel_downloads);
            println!("  Retry wait seconds:   {}", config.retry_wait_seconds);
            println!("  Max retries:          {}", config.max_retries);
        }
    }
    Ok(())
}

#[instrument(skip(base_dir))]
fn get_project_dirs(base_dir: &PathBuf) -> Result<Vec<PathBuf>> {
    let mut dirs = Vec::new();
    let readdir = match fs::read_dir(base_dir) {
        Ok(rd) => rd,
        Err(e) => {
            warn!(base_dir = %base_dir.display(), error = %e, "Cannot read project directory");
            return Ok(dirs);
        }
    };
    for entry in readdir {
        let entry = match entry {
            Ok(e) => e,
            Err(e) => {
                warn!(error = %e, "Failed to read directory entry");
                continue;
            }
        };
        let path = entry.path();
        if path.is_dir() {
            let is_git_repo = path.join(".git").is_dir();
            if let Some(name) = path.file_name() {
                if let Some(name_str) = name.to_str() {
                    if name_str.ends_with("_aristotle") || is_git_repo {
                        debug!(project = name_str, is_git = is_git_repo, "Found project directory");
                        dirs.push(path);
                    }
                }
            }
        }
    }
    info!(count = dirs.len(), base = %base_dir.display(), "Found project directories");
    Ok(dirs)
}

#[instrument(skip(base_dir))]
fn update_git_repos(base_dir: &PathBuf) -> Result<()> {
    let dirs = get_project_dirs(base_dir)?;

    for dir in &dirs {
        let name = dir.file_name().unwrap().to_string_lossy();
        info!(project = %name, "Checking for git updates");

        if dir.join(".git").exists() {
            debug!(project = %name, "Pulling latest changes");
            let output = Command::new("git")
                .args(["pull"])
                .current_dir(dir)
                .output()
                .with_context(|| format!("Failed to run git pull in {}", dir.display()))?;

            let stdout = String::from_utf8_lossy(&output.stdout);
            if !output.status.success() {
                let stderr = String::from_utf8_lossy(&output.stderr);
                warn!(project = %name, stdout = %stdout.trim(), stderr = %stderr.trim(), "git pull had issues");
            } else {
                debug!(project = %name, output = %stdout.trim(), "git pull succeeded");
            }
        } else {
            debug!(project = %name, "Not a git repository");
        }
    }

    let log_path = base_dir.join("poll.log");
    let mut log = File::create(&log_path)?;
    writeln!(
        log,
        "[{}] Updated {} repositories",
        chrono::Local::now().format("%Y-%m-%d %H:%M:%S"),
        dirs.len()
    )?;

    info!("Git update complete");
    Ok(())
}

#[instrument(skip(dir))]
fn build_project(dir: &PathBuf) -> Result<bool> {
    let name = dir.file_name().unwrap().to_string_lossy();
    if !dir.join("lakefile.toml").exists() {
        info!(project = %name, "No lakefile.toml, skipping");
        println!("? {} - no lakefile.toml", name);
        return Ok(false);
    }

    info!(project = %name, "Building");
    println!("Building {}...", name);

    let output = Command::new("lake")
        .args(["build"])
        .current_dir(dir)
        .output()
        .with_context(|| format!("Failed to run lake build in {}", dir.display()))?;

    let success = output.status.success();
    if success {
        info!(project = %name, "Build succeeded");
    } else {
        let stderr = String::from_utf8_lossy(&output.stderr);
        error!(project = %name, stderr = %stderr.trim(), "Build failed");
    }
    Ok(success)
}

#[instrument(skip_all, fields(download_only = _download_only, parallel = _parallel))]
fn cmd_poll(_download_only: bool, _parallel: usize) -> Result<()> {
    let config = load_config()?;
    info!("Starting poll operation");

    update_git_repos(&config.git_base)?;

    let dirs = get_project_dirs(&config.git_base)?;
    info!(project_count = dirs.len(), "Building projects");

    let mut success = 0;
    let mut fail = 0;
    for dir in &dirs {
        match build_project(dir) {
            Ok(true) => {
                println!("✓ {} succeeded", dir.file_name().unwrap().to_string_lossy());
                success += 1;
            }
            Ok(false) => {
                println!("✗ {} failed", dir.file_name().unwrap().to_string_lossy());
                fail += 1;
            }
            Err(e) => {
                error!(project = %dir.display(), error = %e, "Build error");
                println!("✗ {} failed: {}", dir.file_name().unwrap().to_string_lossy(), e);
                fail += 1;
            }
        }
    }

    let result = format!("Total: {} succeeded, {} failed\n", success, fail);
    fs::write(config.base_dir.join("result.txt"), &result)?;
    println!("{}", result);
    info!(success, fail, "Poll complete");
    Ok(())
}

#[instrument]
fn cmd_build(input_dir: Option<PathBuf>) -> Result<()> {
    let config = load_config()?;
    let build_dir = input_dir.unwrap_or(config.git_base);
    let dirs = get_project_dirs(&build_dir)?;
    info!(project_count = dirs.len(), "Starting build");

    let mut success = 0;
    let mut fail = 0;
    for dir in &dirs {
        match build_project(dir) {
            Ok(true) => {
                println!("✓ {} succeeded", dir.file_name().unwrap().to_string_lossy());
                success += 1;
            }
            Ok(false) => {
                println!("✗ {} failed", dir.file_name().unwrap().to_string_lossy());
                fail += 1;
            }
            Err(e) => {
                error!(project = %dir.display(), error = %e, "Build error");
                println!("✗ {} failed: {}", dir.file_name().unwrap().to_string_lossy(), e);
                fail += 1;
            }
        }
    }

    let result = format!("Total: {} succeeded, {} failed\n", success, fail);
    fs::write(config.base_dir.join("result.txt"), &result)?;
    println!("{}", result);
    info!(success, fail, "Build complete");
    Ok(())
}

#[instrument]
fn cmd_test() -> Result<()> {
    let config = load_config()?;
    let dirs = get_project_dirs(&config.git_base)?;
    info!(project_count = dirs.len(), "Starting test");

    let mut success = 0;
    let mut fail = 0;
    for dir in &dirs {
        match build_project(dir) {
            Ok(true) => {
                println!("✓ {} succeeded", dir.file_name().unwrap().to_string_lossy());
                success += 1;
            }
            Ok(false) => {
                println!("✗ {} failed", dir.file_name().unwrap().to_string_lossy());
                fail += 1;
            }
            Err(e) => {
                error!(project = %dir.display(), error = %e, "Test error");
                println!("✗ {} failed: {}", dir.file_name().unwrap().to_string_lossy(), e);
                fail += 1;
            }
        }
    }

    let result = format!("Total: {} succeeded, {} failed\n", success, fail);
    fs::write(config.base_dir.join("result.txt"), &result)?;
    println!("{}", result);
    info!(success, fail, "Test complete");
    Ok(())
}

/// ── Download command with parallel downloads and telemetry ────────────────

#[instrument(skip_all)]
async fn cmd_download(parallel: usize, _trace: &str, verbose: bool, limit: Option<usize>) -> Result<()> {
    let config = load_config()?;
    let api_key = get_api_key()?;
    let client = Client::builder()
        .timeout(Duration::from_secs(300))
        .build()
        .context("Failed to build HTTP client")?;

    // ── Verbose mode ───────────────────────────────────────────────────
    if verbose {
        info!("Verbose mode enabled for download");
        println!("Verbose mode: enabled");
    }

    // ── Limit mode ─────────────────────────────────────────────────────
    if let Some(lim) = limit {
        info!(limit = lim, "Download limit set");
        println!("Download limit: {} results", lim);
    }

    let processed_file = config.base_dir.join("aristotle_processed.txt");
    let download_log = config.base_dir.join("download.log");

    fs::create_dir_all(
        processed_file
            .parent()
            .context("Invalid processed file path")?,
    )?;
    fs::create_dir_all(&config.results_dir)?;

    // Load already-processed IDs
    let processed_ids: std::collections::HashSet<String> = if processed_file.exists() {
        let contents = fs::read_to_string(&processed_file)?;
        contents.lines().map(|l| l.trim().to_string()).collect()
    } else {
        std::collections::HashSet::new()
    };
    debug!(processed_count = processed_ids.len(), "Loaded processed IDs");

    let mut log = OpenOptions::new().create(true).append(true).open(&download_log)?;
    writeln!(
        log,
        "[{}] Starting download of results",
        chrono::Local::now().format("%Y-%m-%d %H:%M:%S")
    )?;

    // ── Fetch project list (paginated) ────────────────────────────────
    let api_key_for_list = api_key.clone();
    let mut all_projects: Vec<Value> = Vec::new();
    let mut pagination_key: Option<String> = None;
    let mut page = 0u32;

    loop {
        page += 1;
        let page_url = if let Some(ref key) = pagination_key {
            format!("{}/project?pagination_key={}", API_BASE_URL, key)
        } else {
            format!("{}/project", API_BASE_URL)
        };
        info!(url = %page_url, page, "Fetching project list page");

        let response = client
            .get(&page_url)
            .header("x-api-key", &api_key_for_list)
            .send()
            .await
            .with_context(|| format!("Failed to fetch project list from {}", page_url))?;

        let status = response.status();
        let response_text = response
            .text()
            .await
            .with_context(|| "Failed to read project list response body")?;

        if !status.is_success() {
            error!(http_status = %status, body = %response_text, "Project list request failed");
            writeln!(
                log,
                "[{}] ERROR: Project list request failed with HTTP {}: {}",
                chrono::Local::now().format("%Y-%m-%d %H:%M:%S"),
                status,
                response_text
            )?;
            return Err(anyhow::anyhow!(
                "Project list request failed: HTTP {}",
                status
            ));
        }

        let page_json: Value = serde_json::from_str(&response_text)
            .with_context(|| format!("Failed to parse project list JSON: {}", &response_text[..response_text.len().min(200)]))?;

        // Extract projects from this page
        let page_projects = page_json["projects"]
            .as_array()
            .cloned()
            .unwrap_or_default();
        let page_count = page_projects.len();
        all_projects.extend(page_projects);

        info!(page, page_count, total = all_projects.len(), "Fetched project page");

        // Check for pagination key to continue
        let next_key = page_json["pagination_key"].as_str().map(|s| s.to_string());
        if next_key.is_none() || page_count == 0 {
            break;
        }
        // Stop if the key hasn't changed (prevents infinite loop)
        if pagination_key.as_deref() == next_key.as_deref() {
            info!("Pagination key unchanged, stopping");
            break;
        }
        pagination_key = next_key;
    }

    // Save the aggregated project list as raw JSON
    let projects_json_path = config.base_dir.join("aristotle_projects.json");
    let all_json = serde_json::json!({
        "projects": all_projects,
        "total": all_projects.len()
    });
    let all_json_str = serde_json::to_string_pretty(&all_json)?;
    fs::write(&projects_json_path, &all_json_str)?;
    info!(path = %projects_json_path.display(), total = all_projects.len(), size = all_json_str.len(), "Saved aggregated project list JSON");

    // Build a synthetic JSON Value for extract_project_ids
    let json = serde_json::json!({ "projects": all_projects });
    let ids: Vec<String> = extract_project_ids(&json);
    info!(project_count = ids.len(), "Extracted project IDs from all pages");
    writeln!(log, "Found {} projects to download ({} pages)", ids.len(), page)?;

    if ids.is_empty() {
        warn!("No project IDs found in API response");
        writeln!(log, "WARNING: No project IDs found in API response")?;
    }

    // ── Download projects in parallel ───────────────────────────────────
    // Apply limit: truncate IDs if --limit is set
    let ids = if let Some(lim) = limit {
        ids.into_iter().take(lim).collect::<Vec<_>>()
    } else {
        ids
    };

    let semaphore = Arc::new(tokio::sync::Semaphore::new(parallel));
    let mut handles = Vec::new();
    let mut skipped = 0u64;
    let download_counter = Arc::new(std::sync::atomic::AtomicU64::new(0));
    let fail_counter = Arc::new(std::sync::atomic::AtomicU64::new(0));

    for id in &ids {
        if processed_ids.contains(id.as_str()) {
            debug!(id = %id, "Already processed, skipping");
            writeln!(log, "SKIP: {} (already processed)", id)?;
            skipped += 1;
            continue;
        }

        let permit = semaphore.clone();
        let client = client.clone();
        let api_key = api_key.clone();
        let config_git_base = config.git_base.clone();
        let config_results_dir = config.results_dir.clone();
        let retry_wait = config.retry_wait_seconds;
        let max_retries = config.max_retries;
        let handle_id = id.clone();
        let counter = download_counter.clone();
        let fcounter = fail_counter.clone();

        let handle = tokio::spawn(async move {
            let _permit = permit.acquire().await.unwrap();
            info!(id = %handle_id, "Starting download");
            match download_single_result(
                &client,
                &api_key,
                &handle_id,
                &config_git_base,
                &config_results_dir,
                retry_wait,
                max_retries,
            )
            .await
            {
                Ok(extracted_path) => {
                    info!(id = %handle_id, path = %extracted_path.display(), "Downloaded and extracted successfully");
                    counter.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
                    Ok::<_, anyhow::Error>(extracted_path)
                }
                Err(e) => {
                    error!(id = %handle_id, error = %e, "Download failed");
                    fcounter.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
                    Err(e)
                }
            }
        });
        handles.push((id.clone(), handle));
    }

    // Wait for all downloads
    let mut downloaded = 0u64;
    let mut failed = 0u64;
    for (id, handle) in handles {
        match handle.await {
            Ok(Ok(path)) => {
                writeln!(log, "✓ Downloaded and extracted: {} -> {}", id, path.display())?;
                downloaded += 1;
                // Mark as processed
                let mut proc = OpenOptions::new()
                    .create(true)
                    .append(true)
                    .open(&processed_file)?;
                writeln!(proc, "{}", id)?;
            }
            Ok(Err(e)) => {
                writeln!(log, "✗ Failed {}: {}", id, e)?;
                failed += 1;
            }
            Err(join_err) => {
                error!(id = %id, error = %join_err, "Task panicked");
                writeln!(log, "✗ Task panicked for {}: {}", id, join_err)?;
                failed += 1;
            }
        }
    }

    writeln!(
        log,
        "[{}] Download complete: {} downloaded, {} skipped, {} failed",
        chrono::Local::now().format("%Y-%m-%d %H:%M:%S"),
        downloaded,
        skipped,
        failed
    )?;

    info!(downloaded, skipped, failed, "Download operation complete");
    println!(
        "Download complete: {} downloaded, {} skipped, {} failed. See download.log for details.",
        downloaded, skipped, failed
    );
    Ok(())
}

/// ── Refresh: pull newest, download, split, build decl table ────────────

#[instrument(skip_all)]
async fn cmd_refresh(parallel: usize, limit: Option<usize>) -> Result<()> {
    let config = load_config()?;
    let api_key = get_api_key()?;

    println!("╔══════════════════════════════════════════════╗");
    println!("║   Aristotle Refresh Pipeline                 ║");
    println!("╚══════════════════════════════════════════════╝");

    // Step 1: Download (handles pagination, saves JSON, extracts)
    println!("\n[1/3] Downloading latest projects...");
    cmd_download(parallel, "console", true, limit).await?;

    // Step 2: Split all projects (including nested archives)
    println!("\n[2/3] Splitting declarations...");
    let split_input = config.git_base.clone();
    let split_output = config.base_dir.join("split-results");
    cmd_split(Some(split_input), Some(split_output.clone()))?;

    // Step 3: Build canonical declaration table
    println!("\n[3/3] Building canonical declaration table...");
    let table_output = config.base_dir.join("decl-table.json");
    cmd_decl_table(Some(split_output), Some(table_output.clone()))?;

    println!("\n✓ Refresh complete!");
    println!("  Decl table: {}", table_output.display());
    Ok(())
}

/// ── Build canonical declaration table ──────────────────────────────────

#[instrument(skip(split_dir, output))]
fn cmd_decl_table(split_dir: Option<PathBuf>, output: Option<PathBuf>) -> Result<()> {
    let config = load_config()?;
    let split_dir = split_dir
        .unwrap_or_else(|| config.git_base.join("split-results"));
    let output = output
        .unwrap_or_else(|| config.git_base.join("decl-table.json"));

    info!(
        split_dir = %split_dir.display(),
        output = %output.display(),
        "Building canonical declaration table"
    );

    // Walk all split output directories for flake.nix files
    // Each flake.nix directory = one declaration
    let mut decls: std::collections::BTreeMap<String, Vec<String>> = std::collections::BTreeMap::new();
    let mut total = 0u64;

    for entry in WalkDir::new(&split_dir)
        .min_depth(2)
        .max_depth(5)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        if entry.file_name() == "flake.nix" {
            let decl_dir = entry.path().parent().unwrap_or(entry.path());
            let decl_name = decl_dir
                .file_name()
                .and_then(|s| s.to_str())
                .unwrap_or("unknown")
                .to_string();

            // Find which project(s) this decl comes from
            let project = decl_dir
                .ancestors()
                .find(|a| {
                    a.file_name()
                        .map_or(false, |n| n.to_string_lossy().ends_with("_aristotle"))
                })
                .map(|p| p.file_name().unwrap_or_default().to_string_lossy().to_string())
                .unwrap_or_default();

            decls.entry(decl_name.clone())
                .or_default()
                .push(project);
            total += 1;
        }
    }

    // Deduplicate: each unique declaration name → canonical path + source projects
    let mut table: Vec<serde_json::Value> = Vec::new();
    for (name, projects) in &decls {
        // Canonical path: use first project's path as canonical
        let canonical = projects.first().map(|p| format!("{}/{}", p, name)).unwrap_or_default();
        let unique_projects: Vec<&String> = {
            let mut seen = std::collections::HashSet::new();
            projects.iter().filter(|p| seen.insert(*p)).collect()
        };
        table.push(serde_json::json!({
            "declaration": name,
            "canonical_path": canonical,
            "source_projects": unique_projects,
            "occurrences": projects.len(),
        }));
    }

    // Write table
    let json = serde_json::to_string_pretty(&serde_json::json!({
        "total_declarations": table.len(),
        "total_occurrences": total,
        "table": table,
    }))?;
    fs::write(&output, &json)?;

    info!(declarations = table.len(), occurrences = total, "Declaration table built");
    println!(
        "Canonical decl table: {} unique declarations ({} total occurrences) -> {}",
        table.len(),
        total,
        output.display()
    );
    Ok(())
}

/// Extract project IDs from the JSON response, handling various possible structures.
fn extract_project_ids(json: &Value) -> Vec<String> {
    // Helper: try "project_id" first, then "id"
    fn get_id(obj: &serde_json::Map<String, Value>) -> Option<String> {
        obj.get("project_id")
            .or_else(|| obj.get("id"))
            .and_then(Value::as_str)
            .filter(|s| is_uuid_like(s))
            .map(|s| s.to_string())
    }

    // Case 1: { "projects": ["uuid1", "uuid2", ...] }
    if let Some(arr) = json["projects"].as_array() {
        let ids: Vec<String> = arr
            .iter()
            .filter_map(|v| match v {
                Value::String(s) if is_uuid_like(s) => Some(s.clone()),
                Value::Array(a) => {
                    a.first()
                        .and_then(Value::as_str)
                        .filter(|s| is_uuid_like(s))
                        .map(|s| s.to_string())
                }
                Value::Object(o) => get_id(o),
                _ => None,
            })
            .filter(|id| !id.is_empty())
            .collect();
        if !ids.is_empty() {
            debug!(count = ids.len(), "Found project IDs in 'projects' key");
            return ids;
        }
    }

    // Case 2: { "data": [...], "results": [...], "items": [...] }
    for key in &["data", "results", "items"] {
        if let Some(arr) = json[*key].as_array() {
            let ids: Vec<String> = arr
                .iter()
                .filter_map(|v| match v {
                    Value::String(s) if is_uuid_like(s) => Some(s.clone()),
                    Value::Object(o) => get_id(o),
                    _ => None,
                })
                .filter(|id| !id.is_empty())
                .collect();
            if !ids.is_empty() {
                debug!(count = ids.len(), key = key, "Found project IDs");
                return ids;
            }
        }
    }

    // Case 3: Top-level array
    if let Some(arr) = json.as_array() {
        let ids: Vec<String> = arr
            .iter()
            .filter_map(|v| match v {
                Value::String(s) if is_uuid_like(s) => Some(s.clone()),
                Value::Object(o) => get_id(o),
                _ => None,
            })
            .filter(|id| !id.is_empty())
            .collect();
        if !ids.is_empty() {
            debug!(count = ids.len(), "Found project IDs at top-level array");
            return ids;
        }
    }

    debug!("Could not extract IDs from API response; response: {}", serde_json::to_string_pretty(json).unwrap_or_default());
    warn!("Could not extract project IDs from API response");
    Vec::new()
}

fn is_uuid_like(s: &str) -> bool {
    let chars: Vec<char> = s.chars().collect();
    if chars.len() < 36 {
        return false;
    }
    chars.iter().take(8).all(|c| c.is_ascii_hexdigit()) && chars.get(8) == Some(&'-')
}

#[instrument(skip(client, api_key, git_base, results_dir))]
async fn download_single_result(
    client: &Client,
    api_key: &str,
    result_id: &str,
    git_base: &PathBuf,
    results_dir: &PathBuf,
    retry_wait_seconds: u64,
    max_retries: usize,
) -> Result<PathBuf> {
    let url = format!("{}/project/{}/result", API_BASE_URL, result_id);
    debug!(url = %url, "Downloading result");

    // ── Wait for the result to be ready ──────────────────────────────────
    let mut retries = 0;
    let mut last_status_json: Option<String> = None;
    loop {
        let status_url = format!("{}/project/{}", API_BASE_URL, result_id);
        debug!(url = %status_url, retry = retries, "Checking result status");

        let status_response = client
            .get(&status_url)
            .header("x-api-key", api_key)
            .send()
            .await
            .with_context(|| format!("Failed to check status for result {}", result_id))?;

        let status_code = status_response.status();
        if status_code.is_success() {
            let status_text = status_response
                .text()
                .await
                .unwrap_or_else(|_| "unreadable".to_string());
            debug!(id = %result_id, body = %status_text, "Status response");

            if let Ok(status_json) = serde_json::from_str::<Value>(&status_text) {
                last_status_json = Some(status_text);
                // has_files=true means results are available
                if status_json["has_files"].as_bool().unwrap_or(false) {
                    info!(id = %result_id, "Result files available (has_files=true)");
                    break;
                }
                // status=2 seems to mean completed
                if status_json["status"].as_i64().unwrap_or(0) >= 2 {
                    info!(id = %result_id, "Result is ready (status >= 2)");
                    break;
                }
                // Legacy checks
                if status_json["ready"].as_bool().unwrap_or(false) {
                    info!(id = %result_id, "Result is ready (ready=true)");
                    break;
                }
                if let Some(state) = status_json["state"].as_str() {
                    if state == "completed" || state == "ready" || state == "done" {
                        info!(id = %result_id, state, "Result is ready (state)");
                        break;
                    }
                }
                debug!(id = %result_id, retry = retries, status = ?status_json, "Result not ready yet");
            } else {
                // Non-JSON success response — treat as ready
                info!(id = %result_id, "Status returned success (non-JSON), treating as ready");
                break;
            }
        } else if status_code == reqwest::StatusCode::NOT_FOUND {
            debug!(id = %result_id, "Status endpoint not found, will try main endpoint");
            break;
        }

        retries += 1;
        if retries >= max_retries {
            return Err(anyhow::anyhow!(
                "Max retries ({}) reached waiting for result {}",
                max_retries,
                result_id
            ));
        }

        debug!(
            id = %result_id,
            retry = retries,
            max = max_retries,
            wait_secs = retry_wait_seconds,
            "Waiting before retry"
        );
        tokio::time::sleep(Duration::from_secs(retry_wait_seconds)).await;
    }

    // ── Download the tarball ─────────────────────────────────────────────
    info!(id = %result_id, "Fetching result tarball");
    let response = client
        .get(&url)
        .header("x-api-key", api_key)
        .send()
        .await
        .with_context(|| format!("Failed to download result {}", result_id))?;

    let http_status = response.status();
    if !http_status.is_success() {
        let body = response
            .text()
            .await
            .unwrap_or_else(|_| "unreadable".to_string());
        error!(id = %result_id, http_status = %http_status, body = %body, "Download request failed");
        return Err(anyhow::anyhow!(
            "Download failed for {}: HTTP {} - {}",
            result_id,
            http_status,
            body
        ));
    }

    let bytes = response
        .bytes()
        .await
        .with_context(|| format!("Failed to read response bytes for result {}", result_id))?;

    if bytes.is_empty() {
        return Err(anyhow::anyhow!("Empty response body for result {}", result_id));
    }

    debug!(id = %result_id, size_bytes = bytes.len(), "Downloaded bytes");

    // Save tarball
    let tarball_name = format!("{}-aristotle.tar.gz", result_id);
    let tarball_path = results_dir.join(&tarball_name);
    fs::write(&tarball_path, &bytes)?;
    info!(id = %result_id, path = %tarball_path.display(), "Saved tarball");

    // ── Extract tarball ──────────────────────────────────────────────────
    let archive_file = File::open(&tarball_path)
        .with_context(|| format!("Failed to open tarball {}", tarball_path.display()))?;

    let gz_decoder = GzDecoder::new(archive_file);
    let mut archive = Archive::new(gz_decoder);

    // Extract into project directory: <git_base>/<id>_aristotle/
    let project_dir = git_base.join(format!("{}_aristotle", result_id));
    if project_dir.exists() {
        debug!(id = %result_id, "Removing existing project directory");
        fs::remove_dir_all(&project_dir)?;
    }
    fs::create_dir_all(&project_dir)?;

    archive
        .unpack(&project_dir)
        .with_context(|| format!("Failed to extract tarball to {}", project_dir.display()))?;

    info!(id = %result_id, path = %project_dir.display(), "Extracted tarball");

    // ── Save metadata JSON ───────────────────────────────────────────
    let metadata = serde_json::json!({
        "result_id": result_id,
        "extracted_at": chrono::Utc::now().to_rfc3339(),
        "project_dir": project_dir.to_string_lossy(),
        "tarball_size_bytes": bytes.len(),
        "download_url": url,
    });
    let metadata_path = project_dir.join("aristotle_metadata.json");
    fs::write(&metadata_path, serde_json::to_string_pretty(&metadata)?)?;
    debug!(id = %result_id, path = %metadata_path.display(), "Saved metadata JSON");

    // Save status JSON if we got one
    if let Some(status_text) = last_status_json {
        let status_path = project_dir.join("aristotle_status.json");
        // Pretty-print if it's valid JSON
        let pretty = serde_json::from_str::<Value>(&status_text)
            .ok()
            .and_then(|v| serde_json::to_string_pretty(&v).ok())
            .unwrap_or(status_text);
        fs::write(&status_path, pretty)?;
        debug!(id = %result_id, path = %status_path.display(), "Saved status JSON");
    }

    // Clean up tarball
    fs::remove_file(&tarball_path)?;
    debug!(id = %result_id, "Removed tarball after extraction");

    Ok(project_dir)
}

/// ── Split-All command: run SplitDecls on every Lean project ─────────

#[instrument(skip(output_dir))]
fn cmd_split_all(output_dir: Option<PathBuf>, parallel: usize, dry_run: bool) -> Result<()> {
    let config = load_config()?;
    let output_dir = output_dir.unwrap_or_else(|| config.base_dir.join("split-results"));

    let splitter_script = PathBuf::from("split-aristotle-project.sh");
    if !splitter_script.exists() {
        return Err(anyhow::anyhow!(
            "split-aristotle-project.sh not found. Run from aristotle-manager root."
        ));
    }

    // Find all *_aristotle/ project directories
    let dirs = get_project_dirs(&config.git_base)?;
    info!(count = dirs.len(), "Found project directories");

    if dirs.is_empty() {
        println!("No project directories found in {}", config.git_base.display());
        return Ok(());
    }

    if dry_run {
        println!("Dry run — would split {} projects into {}", dirs.len(), output_dir.display());
        for dir in &dirs {
            let name = dir.file_name().unwrap_or_default().to_string_lossy();
            let project_output = output_dir.join(&*name);
            println!("  {} -> {}", name, project_output.display());
        }
        return Ok(());
    }

    fs::create_dir_all(&output_dir)?;

    println!("Splitting {} Lean projects...", dirs.len());
    let mut succeeded = 0u64;
    let mut failed = 0u64;
    let mut total_decls = 0u64;

    // Process sequentially (the splitter itself is parallelized internally)
    for (i, dir) in dirs.iter().enumerate() {
        let name = dir.file_name().unwrap_or_default().to_string_lossy();
        let project_output = output_dir.join(&*name);

        // Look for .lean files inside the project
        let lean_files: Vec<_> = WalkDir::new(dir)
            .max_depth(5)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
            .collect();

        if lean_files.is_empty() {
            debug!(project = %name, "No .lean files, skipping");
            continue;
        }

        // Check for RequestProject directory
        let rp_dir = dir.join("output-final_aristotle").join("RequestProject");
        if !rp_dir.exists() {
            debug!(project = %name, "No RequestProject, skipping");
            continue;
        }

        println!(
            "[{}/{}] Splitting {}...",
            i + 1,
            dirs.len(),
            name
        );

        let abs_splitter = std::env::current_dir()?.join("split-aristotle-project.sh");
        let result = Command::new(&abs_splitter)
            .args([
                dir.to_string_lossy().as_ref(),
                project_output.to_string_lossy().as_ref(),
            ])
            .output();

        match result {
            Ok(output) => {
                let stdout = String::from_utf8_lossy(&output.stdout);
                let stderr = String::from_utf8_lossy(&output.stderr);
                if output.status.success() {
                    // Parse declaration count from output
                    let decls = stdout
                        .lines()
                        .rev()
                        .find_map(|line| {
                            line.split_whitespace()
                                .next()
                                .and_then(|s| s.parse::<u64>().ok())
                        })
                        .unwrap_or(0);
                    println!("  ✓ {} declarations -> {}", decls, project_output.display());
                    succeeded += 1;
                    total_decls += decls;
                } else {
                    warn!(project = %name, stderr = %stderr.trim(), "Split failed");
                    println!("  ✗ Failed: {}", stderr.lines().last().unwrap_or("unknown"));
                    failed += 1;
                }
            }
            Err(e) => {
                error!(project = %name, error = %e, "Failed to run splitter");
                println!("  ✗ Error: {}", e);
                failed += 1;
            }
        }
    }

    println!(
        "Split-all complete: {} succeeded, {} failed, {} total declarations. Results in: {}",
        succeeded, failed, total_decls, output_dir.display()
    );
    info!(succeeded, failed, total_decls, "Split-all complete");
    Ok(())
}

/// ── Split command (Lean declaration-level splitter) ──────────────────

#[instrument(skip(input_dir, output_dir))]
fn cmd_split(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let config = load_config()?;
    let input_dir =
        input_dir.unwrap_or_else(|| config.git_base.clone());
    let output_dir =
        output_dir.unwrap_or_else(|| config.git_base.join("split-results"));
    fs::create_dir_all(&output_dir)?;

    // Path to the Lean splitter tool
    let splitter_path = std::env::var("LEAN_SPLITTER")
        .map(PathBuf::from)
        .unwrap_or_else(|_| {
            let cwd = std::env::current_dir().unwrap_or_default();
            cwd.join("..").join("lean-split-decls").join("SplitDecls.lean")
        });

    info!(
        input = %input_dir.display(),
        output = %output_dir.display(),
        splitter = %splitter_path.display(),
        "Starting Lean declaration split"
    );

    // Find lake binary (same dir as lean)
    let lake_bin = find_lake()?;
    info!(lake = %lake_bin.display(), "Found lake binary");

    // Discover all project directories with RequestProject
    let mut projects: Vec<(PathBuf, String)> = Vec::new();
    for entry in WalkDir::new(&input_dir).min_depth(2).max_depth(5) {
        let entry = match entry {
            Ok(e) => e,
            Err(e) => {
                warn!(error = %e, "Failed to walk directory entry");
                continue;
            }
        };
        if !entry.file_type().is_dir() {
            continue;
        }
        if entry.file_name() != "RequestProject" {
            continue;
        }
        let request_dir = entry.path().to_path_buf();
        let project_dir = request_dir
            .parent()
            .map(|p| p.to_path_buf())
            .unwrap_or_else(|| request_dir.clone());

        // Find module name from .lean files in RequestProject
        let first_lean = WalkDir::new(&request_dir)
            .max_depth(3)
            .into_iter()
            .filter_map(|e| e.ok())
            .find(|e| e.path().extension().map_or(false, |x| x == "lean"));

        let module_name = match first_lean {
            Some(f) => {
                let stem = f.path().file_stem()
                    .and_then(|s| s.to_str())
                    .unwrap_or("Main");
                format!("RequestProject.{}", stem)
            }
            None => continue,
        };

        let proj_name = project_dir
            .file_name()
            .and_then(|s| s.to_str())
            .unwrap_or("unknown")
            .to_string();

        debug!(project = %proj_name, module = %module_name, "Found project");
        projects.push((project_dir, module_name));
    }

    info!(count = projects.len(), "Discovered projects with RequestProject");

    if projects.is_empty() {
        println!("No projects with RequestProject found — nothing to split.");
        return Ok(());
    }

    let mut succeeded = 0u64;
    let mut failed = 0u64;
    let mut total_decls = 0u64;

    for (i, (project_dir, module_name)) in projects.iter().enumerate() {
        let proj_name = project_dir
            .file_name()
            .and_then(|s| s.to_str())
            .unwrap_or("unknown");
        let proj_output = output_dir.join(proj_name);

        println!(
            "[{}/{}] Splitting {} (module: {})...",
            i + 1,
            projects.len(),
            proj_name,
            module_name
        );

        match run_lean_splitter(&lake_bin, &splitter_path, project_dir, module_name, &proj_output) {
            Ok(decl_count) => {
                println!("  ✓ {} declarations split -> {}", decl_count, proj_output.display());
                succeeded += 1;
                total_decls += decl_count;
            }
            Err(e) => {
                warn!(project = %proj_name, error = %e, "Split failed");
                println!("  ✗ Failed: {}", e);
                failed += 1;
            }
        }
    }

    println!(
        "Split complete: {} succeeded, {} failed, {} total declarations. Results in: {}",
        succeeded, failed, total_decls, output_dir.display()
    );
    info!(succeeded, failed, total_decls, "Split complete");
    Ok(())
}

/// Find the `lake` binary (Lean build tool)
fn find_lake() -> Result<PathBuf> {
    // Try LEAN_BIN env
    if let Ok(lean_path) = std::env::var("LEAN_BIN") {
        let lake = PathBuf::from(&lean_path).parent().map(|p| p.join("lake"));
        if let Some(p) = lake {
            if p.exists() {
                return Ok(p);
            }
        }
    }
    // Check common paths
    for candidate in &[
        "/nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin/lake",
    ] {
        let p = PathBuf::from(candidate);
        if p.exists() {
            return Ok(p);
        }
    }
    // Search PATH
    std::env::var("PATH")
        .ok()
        .and_then(|path| {
            path.split(':')
                .map(PathBuf::from)
                .map(|d| d.join("lake"))
                .find(|p| p.exists())
        })
        .ok_or_else(|| anyhow::anyhow!("lake not found. Install Lean 4 or set LEAN_BIN"))
}

/// Run the Lean split-decls tool on a single project
fn run_lean_splitter(
    lake_bin: &PathBuf,
    splitter_path: &PathBuf,
    project_dir: &PathBuf,
    module_name: &str,
    output_dir: &PathBuf,
) -> Result<u64> {
    fs::create_dir_all(output_dir)?;

    let output = Command::new(lake_bin)
        .args(["env", "lean", "--run"])
        .arg(splitter_path)
        .arg(module_name)
        .arg(output_dir)
        .current_dir(project_dir)
        .output()
        .with_context(|| {
            format!(
                "Failed to run lake env lean --run {} {} {} in {}",
                splitter_path.display(),
                module_name,
                output_dir.display(),
                project_dir.display()
            )
        })?;

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    if !output.status.success() {
        warn!(
            project = %project_dir.display(),
            "Lean splitter returned non-zero"
        );
        return Err(anyhow::anyhow!(
            "Splitter failed: {}",
            stderr.lines().last().unwrap_or("unknown error")
        ));
    }

    // Parse declaration count from stdout (format: "N declaration files written to ...")
    let decl_count = stdout
        .lines()
        .rev()
        .find_map(|line| {
            line.split_whitespace()
                .next()
                .and_then(|s| s.parse::<u64>().ok())
        })
        .unwrap_or(0);

    debug!(
        project = %project_dir.display(),
        decl_count,
        "Splitter completed"
    );

    Ok(decl_count)
}

/// ── Merge command ────────────────────────────────────────────────────────

#[instrument(skip(input_dir, output_dir))]
fn cmd_merge(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let config = load_config()?;
    let input_dir =
        input_dir.unwrap_or_else(|| config.git_base.join("split-results"));
    let output_dir =
        output_dir.unwrap_or_else(|| config.git_base.join("merged-results"));
    fs::create_dir_all(&output_dir)?;

    info!(
        input = %input_dir.display(),
        output = %output_dir.display(),
        "Starting merge operation"
    );

    let mut merged = 0u64;
    let mut copied = 0u64;
    for entry_res in WalkDir::new(&input_dir) {
        let entry = match entry_res {
            Ok(e) => e,
            Err(e) => {
                warn!(error = %e, "Failed to walk directory entry");
                continue;
            }
        };
        let path = entry.path();
        if path.is_file() && path.extension().map_or(false, |ext| ext == "lean") {
            let relative = path.strip_prefix(&input_dir)?;
            let output = output_dir.join(relative);
            if let Some(parent) = output.parent() {
                fs::create_dir_all(parent)?;
            }
            let content = fs::read_to_string(path)?;
            if output.exists() {
                let existing = fs::read_to_string(&output)?;
                if !existing.contains(&content) {
                    fs::write(&output, format!("{}\n{}", existing, content))?;
                    debug!(file = %path.display(), "Merged content");
                    merged += 1;
                }
            } else {
                fs::copy(path, &output)?;
                debug!(file = %path.display(), "Copied");
                copied += 1;
            }
        }
    }

    info!(merged, copied, "Merge complete");
    println!(
        "Merge complete. {} merged, {} copied. Results in: {}",
        merged,
        copied,
        output_dir.display()
    );
    Ok(())
}

/// ── Submit command: send a project to Aristotle via the CLI ────────

#[instrument(skip(prompt, project_dir))]
fn cmd_submit(prompt: &str, project_dir: Option<PathBuf>, wait: bool) -> Result<()> {
    let api_key = get_api_key()?;
    let mut args: Vec<String> = vec!["submit".into(), "--api-key".into(), api_key];
    
    if let Some(ref dir) = project_dir {
        args.push("--project-dir".into());
        args.push(dir.to_string_lossy().to_string());
    }
    if wait {
        args.push("--wait".into());
    }
    args.push(prompt.to_string());

    info!("Running: aristotle {}", args.join(" "));
    
    let output = Command::new("aristotle")
        .args(&args)
        .output()
        .context("Failed to run aristotle CLI")?;

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    if output.status.success() {
        for line in stdout.lines() {
            if line.contains("Project created") || line.contains("WARNING") || line.contains("Error") {
                println!("{}", line);
            }
        }
        if !stderr.is_empty() {
            eprintln!("{}", stderr);
        }
    } else {
        error!(stdout = %stdout, stderr = %stderr, "aristotle CLI failed");
        eprintln!("stdout: {}", stdout);
        eprintln!("stderr: {}", stderr);
        return Err(anyhow::anyhow!("aristotle CLI failed"));
    }

    Ok(())
}

/// ── Check command: query project status from Aristotle API ──────────

#[instrument(skip(project_id))]
async fn cmd_check(project_id: Option<String>, limit: Option<usize>) -> Result<()> {
    let api_key = get_api_key()?;
    let client = Client::builder()
        .timeout(Duration::from_secs(30))
        .build()
        .context("Failed to build HTTP client")?;

    if let Some(pid) = project_id {
        let url = format!("{}/project/{}", API_BASE_URL, pid);
        let response = client
            .get(&url)
            .header("x-api-key", &api_key)
            .send()
            .await
            .context("Failed to query project")?;

        let body = response.text().await?;
        if let Ok(json) = serde_json::from_str::<Value>(&body) {
            println!("Project: {}", pid);
            println!("  Description: {}", json["description"].as_str().unwrap_or(""));
            println!("  Status: {} (has_files={})", 
                json["status"].as_i64().unwrap_or(0),
                json["has_files"].as_bool().unwrap_or(false));
            println!("  Created: {}", json["created_at"].as_str().unwrap_or(""));
            println!("  Updated: {}", json["last_updated"].as_str().unwrap_or(""));
        }
    } else {
        let url = format!("{}/project", API_BASE_URL);
        let limit = limit.unwrap_or(20);
        let response = client.get(&url).header("x-api-key", &api_key).send().await?;
        let body = response.text().await?;
        if let Ok(json) = serde_json::from_str::<Value>(&body) {
            if let Some(projects) = json["projects"].as_array() {
                println!("{:<36} {:<20} {:<6} {:<30}", "ID", "CREATED", "STATUS", "DESCRIPTION");
                for p in projects.iter().take(limit) {
                    let st = match p["status"].as_i64().unwrap_or(0) {
                        0 => "QUEUE", 1 => "RUN", 2 => "DONE", _ => "?"
                    };
                    println!("{:<36} {:<20} {:<6} {:<30}",
                        p["project_id"].as_str().unwrap_or(""),
                        p["created_at"].as_str().unwrap_or("").get(..20).unwrap_or(""),
                        st,
                        p["description"].as_str().unwrap_or("").get(..30).unwrap_or(""));
                }
            }
        }
    }

    Ok(())
}

/// ── Download result from a completed Aristotle project ─────────

async fn cmd_download_result(project_id: &str, output_dir: Option<PathBuf>) -> Result<()> {
    let config = load_config()?;
    let api_key = get_api_key()?;
    let results_dir = output_dir.unwrap_or_else(|| config.results_dir.join("aristo-outputs"));
    fs::create_dir_all(&results_dir)?;
    let client = Client::builder().timeout(Duration::from_secs(300)).build()?;
    println!("Downloading result for {}...", project_id);
    match download_single_result(&client, &api_key, project_id, &results_dir, &results_dir, config.retry_wait_seconds, config.max_retries).await {
        Ok(path) => {
            println!("Downloaded to: {}", path.display());
            let summary = path.join("output-final_aristotle").join("ARISTOTLE_SUMMARY.md");
            if summary.exists() {
                println!("\n=== Output ===");
                for line in fs::read_to_string(&summary)?.lines().take(40) { println!("{}", line); }
            }
            let lean = WalkDir::new(&path).into_iter().filter_map(|e| e.ok()).filter(|e| e.path().extension().map_or(false, |e| e=="lean")).count();
            println!("  .lean files: {}", lean);
        }
        Err(e) => println!("Failed: {}", e),
    }
    Ok(())
}

/// ── Main ─────────────────────────────────────────────────────────────────

#[tokio::main]
async fn main() -> Result<()> {
    // Parse CLI first so we can configure tracing based on command options
    let cli = Cli::parse();

    // Determine log level: use RUST_LOG env, or debug if --verbose on download
    let env_filter = EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| EnvFilter::new("info"));

    let file_log_guard: Option<tracing_appender::non_blocking::WorkerGuard> =
        match &cli.command {
            Commands::Download { trace, .. } if trace == "file" || trace == "both" => {
                let config = load_config()?;
                let trace_path = config.base_dir.join("trace.log");
                let file_appender =
                    tracing_appender::rolling::never(&config.base_dir, "trace.log");
                let (non_blocking, guard) = tracing_appender::non_blocking(file_appender);
                let file_layer = fmt::layer()
                    .with_writer(non_blocking)
                    .with_ansi(false)
                    .with_target(true)
                    .with_thread_ids(false)
                    .with_thread_names(false)
                    .with_file(false)
                    .with_line_number(false);
                let console_layer = fmt::layer()
                    .with_writer(std::io::stdout)
                    .with_target(true)
                    .with_thread_ids(false)
                    .with_thread_names(false)
                    .with_file(false)
                    .with_line_number(false);

                use tracing_subscriber::layer::SubscriberExt;
                let subscriber = tracing_subscriber::Registry::default()
                    .with(env_filter)
                    .with(console_layer)
                    .with(file_layer);
                tracing::subscriber::set_global_default(subscriber)
                    .context("Failed to set tracing subscriber")?;
                println!("Trace file: {}", trace_path.display());
                Some(guard)
            }
            _ => {
                // Default: console-only subscriber
                fmt()
                    .with_env_filter(env_filter)
                    .with_target(true)
                    .with_thread_ids(false)
                    .with_thread_names(false)
                    .with_file(false)
                    .with_line_number(false)
                    .init();
                None
            }
        };

    info!(version = VERSION, "aristotle-manager starting");

    load_config()?;

    match &cli.command {
        Commands::Poll {
            download_only,
            parallel,
        } => {
            info!("Executing poll command");
            cmd_poll(*download_only, *parallel)?;
        }
        Commands::Build { input_dir, .. } => {
            info!("Executing build command");
            cmd_build(input_dir.clone())?;
        }
        Commands::Download {
            parallel,
            trace,
            verbose,
            limit,
        } => {
            info!(parallel, trace, verbose, ?limit, "Executing download command");
            cmd_download(*parallel, trace, *verbose, *limit).await?;
        }
        Commands::Test { .. } => {
            info!("Executing test command");
            cmd_test()?;
        }
        Commands::Split {
            input_dir,
            output_dir,
        } => {
            info!("Executing split command");
            cmd_split(input_dir.clone(), output_dir.clone())?;
        }
        Commands::Refresh { parallel, limit } => {
            info!(parallel, ?limit, "Executing refresh command");
            cmd_refresh(*parallel, *limit).await?;
        }
        Commands::DeclTable { split_dir, output } => {
            info!("Executing decl-table command");
            cmd_decl_table(split_dir.clone(), output.clone())?;
        }
        Commands::Merge {
            input_dir,
            output_dir,
        } => {
            info!("Executing merge command");
            cmd_merge(input_dir.clone(), output_dir.clone())?;
        }
        Commands::Submit { prompt, project_dir, wait } => {
            info!("Executing submit command");
            cmd_submit(prompt, project_dir.clone(), *wait)?;
        }
        Commands::Check { project_id, limit } => {
            info!("Executing check command");
            cmd_check(project_id.clone(), *limit).await?;
        }
        Commands::DownloadResult { project_id, output_dir } => {
            info!("Executing download-result command");
            cmd_download_result(project_id, output_dir.clone()).await?;
        }
        Commands::Results => {
            info!("Executing results command");
            cmd_results()?
        }
        Commands::Clean => {
            info!("Executing clean command");
            cmd_clean()?
        }
        Commands::Index { output } => {
            info!("Executing index command");
            index::cmd_index(output.clone())?;
        }
        Commands::Configure { subcommand } => {
            info!("Executing configure command");
            cmd_configure(subcommand)?
        }
        Commands::Notebooklm { project_dir } => {
            info!("Executing notebooklm command");
            notebooklm::cmd_notebooklm(project_dir)?;
        }
        Commands::SplitAll { output_dir, parallel, dry_run } => {
            info!("Executing split-all command");
            cmd_split_all(output_dir.clone(), *parallel, *dry_run)?;
        }
        Commands::ScanIndex { index_dir, output_dir, prefix_filter } => {
            info!("Executing scan-index command");
            file_index::cmd_scan_index(index_dir.clone(), output_dir.clone(), prefix_filter.clone())?;
        }
    }

    // Keep the file appender guard alive until program exit
    drop(file_log_guard);

    info!("aristotle-manager finished successfully");
    Ok(())
}
