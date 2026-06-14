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

mod notebooklm;


#[cfg(test)]
mod tests;

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
    /// Merge split results
    Merge {
        #[arg(long)]
        input_dir: Option<PathBuf>,
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
    /// Generate text files for NotebookLM
    Notebooklm {
        /// The path to the Aristotle project directory
        #[arg(long)]
        project_dir: PathBuf,
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
struct Config {
    base_dir: PathBuf,
    results_dir: PathBuf,
    git_base: PathBuf,
    max_parallel_downloads: usize,
    retry_wait_seconds: u64,
    max_retries: usize,
}

#[instrument]
fn load_config() -> Result<Config> {
    let config_dir = dirs::config_dir()
        .context("Could not determine config directory")?
        .join("aristotle-manager");
    fs::create_dir_all(&config_dir)?;
    let config_path = config_dir.join("config.toml");

    if !config_path.exists() {
        let default_config = Config {
            base_dir: PathBuf::from("/home/mdupont/projects/arist"),
            results_dir: PathBuf::from("/home/mdupont/projects/aristotle_results"),
            git_base: PathBuf::from("/home/mdupont/05/07/arist"),
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
    let config: Config = toml::from_str(&toml)
        .with_context(|| format!("Failed to parse config at {}", config_path.display()))?;
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
                    base_dir: PathBuf::from("/home/mdupont/projects/arist"),
                    results_dir: PathBuf::from("/home/mdupont/projects/aristotle_results"),
                    git_base: PathBuf::from("/home/mdupont/05/07/arist"),
                    max_parallel_downloads: 4,
                    retry_wait_seconds: 10,
                    max_retries: 3,
                }
            } else {
                toml::from_str(&config_str)?
            };
            config.git_base = PathBuf::from("/home/mdupont/05/07/arist");
            config.base_dir = PathBuf::from("/home/mdupont/projects/arist");
            config.results_dir = PathBuf::from("/home/mdupont/projects/aristotle_results");
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
            if let Some(name) = path.file_name() {
                if let Some(name_str) = name.to_str() {
                    if name_str.ends_with("_aristotle") {
                        debug!(project = name_str, "Found aristotle project directory");
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
fn cmd_build() -> Result<()> {
    let config = load_config()?;
    let dirs = get_project_dirs(&config.git_base)?;
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

/// ── Split command ────────────────────────────────────────────────────────

#[instrument(skip(input_dir, output_dir))]
fn cmd_split(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let input_dir = input_dir.unwrap_or_else(|| PathBuf::from("/home/mdupont/05/07/arist"));
    let output_dir =
        output_dir.unwrap_or_else(|| PathBuf::from("/home/mdupont/05/07/arist/split-results"));
    fs::create_dir_all(&output_dir)?;

    info!(
        input = %input_dir.display(),
        output = %output_dir.display(),
        "Starting split operation"
    );

    let mut copied = 0u64;
    for entry in WalkDir::new(&input_dir) {
        let entry = match entry {
            Ok(e) => e,
            Err(e) => {
                warn!(error = %e, "Failed to walk directory entry");
                continue;
            }
        };
        let path = entry.path();
        if path.is_dir()
            && path.file_name().map_or(false, |n| n == "RequestProject")
        {
            debug!(dir = %path.display(), "Found RequestProject directory");
            for lean_entry_res in WalkDir::new(path) {
                let lean_entry = match lean_entry_res {
                    Ok(e) => e,
                    Err(e) => {
                        warn!(error = %e, "Failed to walk Lean entry");
                        continue;
                    }
                };
                if lean_entry
                    .path()
                    .extension()
                    .map_or(false, |ext| ext == "lean")
                {
                    let relative = lean_entry.path().strip_prefix(&input_dir)?;
                    let output = output_dir.join(relative);
                    if let Some(parent) = output.parent() {
                        fs::create_dir_all(parent)?;
                    }
                    if !output.exists() {
                        fs::copy(lean_entry.path(), &output)?;
                        debug!(file = %lean_entry.path().display(), "Copied");
                        copied += 1;
                    }
                }
            }
        }
    }

    info!(copied, "Split complete");
    println!(
        "Split complete. {} files copied to: {}",
        copied,
        output_dir.display()
    );
    Ok(())
}

/// ── Merge command ────────────────────────────────────────────────────────

#[instrument(skip(input_dir, output_dir))]
fn cmd_merge(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let input_dir =
        input_dir.unwrap_or_else(|| PathBuf::from("/home/mdupont/05/07/arist/split-results"));
    let output_dir =
        output_dir.unwrap_or_else(|| PathBuf::from("/home/mdupont/05/07/arist/merged-results"));
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
        Commands::Build { .. } => {
            info!("Executing build command");
            cmd_build()?;
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
        Commands::Merge {
            input_dir,
            output_dir,
        } => {
            info!("Executing merge command");
            cmd_merge(input_dir.clone(), output_dir.clone())?;
        }
        Commands::Results => {
            info!("Executing results command");
            cmd_results()?
        }
        Commands::Clean => {
            info!("Executing clean command");
            cmd_clean()?
        }
        Commands::Configure { subcommand } => {
            info!("Executing configure command");
            cmd_configure(subcommand)?
        }
        Commands::Notebooklm { project_dir } => {
            info!("Executing notebooklm command");
            notebooklm::cmd_notebooklm(project_dir)?;
        }
    }

    // Keep the file appender guard alive until program exit
    drop(file_log_guard);

    info!("aristotle-manager finished successfully");
    Ok(())
}
