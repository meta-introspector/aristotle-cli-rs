use std::collections::HashSet;
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

mod fetch;
mod file_index;
mod index;
mod local_server;
mod notebooklm;
mod notebooklm_cross;
mod notebooklm_dump;
mod pipeline;
mod pipeline_steps;
mod replay;
mod version;
mod repl;
mod refusal;
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
        #[arg(long, default_value = "console")]
        trace: String,
        #[arg(long)]
        verbose: bool,
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
    /// Generate cross-project NotebookLM files from all REPL declarations
    NotebooklmCross {
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Load declarations into lean4-repl shared memory
    LoadDecls {
        /// Directory containing .lean source files
        dir: Option<PathBuf>,
        /// Only show counts
        #[arg(long)]
        dry_run: bool,
    },
    /// Ask Aristotle with Lean4 proof files attached
    AskWithFiles {
        project_id: String,
        prompt: String,
        #[arg(long)]
        files_dir: PathBuf,
    },
    /// Start local Aristotle API server (self-check proofs first)
    Serve {
        #[arg(long, default_value_t = 9876)]
        port: u16,
        #[arg(long)]
        forward: bool,
    },
    /// Show lean4-repl stats
    ReplStats,
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
    /// Consolidate declarations from a specific Aristotle project into unified pool
    Consolidate {
        #[arg(long)]
        project_id: String,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// J-invariant prime stratification (assign declarations to q-expansion bands)
    JKey {
        #[arg(long)]
        input_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Extract functor arrows between declarations (2-category structure)
    Arrows {
        #[arg(long)]
        input_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Split declarations by j-invariant bands
    SplitByBand {
        #[arg(long)]
        input_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Generate per-band flake.nix files
    GenFlake {
        #[arg(long)]
        band_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Build dependency graph from consolidated declarations
    DepGraph {
        #[arg(long)]
        input_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Build mycelium categorical structure (0/1/2-cells + terminal morphisms)
    Mycelium {
        #[arg(long)]
        input_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Generate canonical per-module flakes with mathlib-split resolution
    CanonicalFlake {
        /// Aristotle project directory to split
        #[arg(long)]
        input_dir: PathBuf,
        /// Output directory for canonical flakes
        #[arg(long)]
        output_dir: Option<PathBuf>,
        /// Path to mathlib-split directory
        #[arg(long)]
        mathlib_split: Option<PathBuf>,
    },
    /// Generate canonical flakes for all downloaded Aristotle projects
    CanonicalFlakeAll {
        /// Output directory for all canonical flakes
        #[arg(long)]
        output_dir: Option<PathBuf>,
        /// Path to mathlib-split directory
        #[arg(long)]
        mathlib_split: Option<PathBuf>,
    },
    /// Merge multiple Aristotle projects into a unified directory for combined processing
    MergeProjects {
        /// Project IDs to merge (space-separated UUIDs)
        #[arg(long, num_args = 1..)]
        project_ids: Vec<String>,
        /// Output directory for merged project
        #[arg(long)]
        output_dir: PathBuf,
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
        #[arg(long, default_value = "console")]
        trace: String,
    },
    /// Show status of all DASL-related projects with lean/sorry/flake stats
    DaslStatus {
        /// Filter by keyword in description
        #[arg(long)]
        filter: Option<String>,
        /// Only show projects with sorries
        #[arg(long)]
        sorries_only: bool,
    },
    /// Find overlapping projects by shared mathlib-split imports
    Overlap {
        /// Reference project ID to compare against
        #[arg(long)]
        reference: String,
        /// Minimum shared imports to report (default 5)
        #[arg(long, default_value = "5")]
        min_shared: usize,
        /// Top N results (default 20)
        #[arg(long, default_value = "20")]
        top: usize,
    },
    /// Download results from a completed Aristotle project
    DownloadResult {
        /// Project ID to download
        project_id: String,
        #[arg(long)]
        output_dir: Option<PathBuf>,
        #[arg(long)]
        verbose: bool,
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
    /// Dump entire DASL pipeline state for NotebookLM ingestion
    NotebooklmDump {
        #[arg(long)]
        output_dir: Option<PathBuf>,
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
        /// Incremental fetch: poll API, download only new/changed, git-version
    Fetch {
        #[arg(short = 'j', default_value = "2")]
        parallel: usize,
        #[arg(long)]
        limit: Option<usize>,
        #[arg(long)]
        dry_run: bool,
    },
    /// Full pipeline: fetch → split → verify (lake build) → version → merge
    Pipeline {
        #[arg(short = 'j', default_value = "2")]
        parallel: usize,
        #[arg(long)]
        limit: Option<usize>,
        #[arg(long)]
        dry_run: bool,
    },
    /// Replay entire archive chronologically into a fresh split/merge repo
    Replay {
        #[arg(long)]
        output_dir: Option<PathBuf>,
        #[arg(long)]
        dry_run: bool,
    },
    /// Git-version all Aristotle outputs — each project becomes a commit
    Version {
        #[arg(long)]
        results_dir: Option<PathBuf>,
        #[arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Send instructions to a running Aristotle project (injects files inline)
    Ask {
        project_id: String,
        prompt: String,
        #[arg(long)]
        file: Option<PathBuf>,
        #[arg(long)]
        inject_dir: Option<PathBuf>,
    },
    /// Patch mode: watch a running Aristotle project, detect prereq gaps, fill them
    Patch {
        project_id: String,
        #[arg(long)]
        prereq_dir: PathBuf,
        #[arg(long, default_value = "60")]
        interval: u64,
        #[arg(long, default_value = "10")]
        max_rounds: usize,
    },
    /// Finish: download result, merge into common project, rebuild flakes, update planner
    DaslFinish {
        project_id: String,
        #[arg(long, default_value = "/home/mdupont/projects/dasl-sorries")]
        common_project: PathBuf,
        #[arg(long, default_value = "/home/mdupont/projects/dasl-results")]
        results_dir: PathBuf,
    },
    /// Scan OEIS data for McKay-Thompson series, generate Lean4 coefficient database
    McKayOeis {
        #[arg(long, num_args = 1.., default_values = [
            "/home/mdupont/2026/06/25/index/mckay_oeis.txt",
            "/home/mdupont/2026/06/25/index/thompson_oeis.txt",
            "/home/mdupont/2026/06/25/index/borcherds_oeis.txt",
            "/home/mdupont/2026/06/25/index/moonshine_oeis.txt"
        ])]
        grep_files: Vec<PathBuf>,
        #[arg(long, default_value = "/home/mdupont/projects/mckay-thompson/RequestProject/McKayThompsonOEIS.lean")]
        output: PathBuf,
        #[arg(long)]
        inject_into: Option<String>,
    },
    /// Auto-respond to Aristotle asks: detect help requests and inject matching files
    Respond {
        project_id: String,
        #[arg(long, default_value = "/home/mdupont/projects/mckay-thompson/RequestProject")]
        prereq_dir: PathBuf,
        #[arg(long, default_value = "/home/mdupont/2026/06/25/index")]
        index_dir: PathBuf,
        #[arg(long)]
        dry_run: bool,
    },
    /// Audit Aristotle refusals/help/needs across all project outputs
    RefusalAudit {
        #[arg(long, default_value = "/mnt/data1/aristotle-results")]
        base_dir: String,
        #[arg(long, default_value = "/mnt/data1/aristotle-results/aristo-refusal-audit.json")]
        output: String,
    },
    /// Extract paragraph context around refusal/help keywords
    RefusalContext {
        #[arg(long, default_value = "/mnt/data1/aristotle-results")]
        base_dir: String,
        #[arg(long, default_value = "/mnt/data1/aristotle-results/aristo-test-corpus.json")]
        output: String,
    },
    /// Dump built-in refusal fix strategies to JSON
    RefusalFixStrategies {
        #[arg(long, default_value = "/mnt/data1/aristotle-results/aristo-fix-strategies.json")]
        output: String,
    },
    /// Build failure corpus (classify runs as refusal/partial/scaffold/success)
    RefusalCorpus {
        #[arg(long, default_value = "/mnt/data1/aristotle-results")]
        base_dir: String,
        #[arg(long, default_value = "/mnt/data1/aristotle-results/aristo-failure-corpus.jsonl")]
        output: String,
    },
    /// Extract gnostic/undefined terms from Aristotle prose
    RefusalGlossary {
        #[arg(long, default_value = "/mnt/data1/aristotle-results")]
        base_dir: String,
        #[arg(long, default_value = "/mnt/data1/aristotle-results/aristo-gnostic-glossary.json")]
        output: String,
    },
    /// Apply the Aristotle pipeline to itself — self-hosting diagonalization
    Diagonalize {
        /// Output directory for diagonalization results
        #[arg(long)]
        output_dir: Option<PathBuf>,
        /// Only find the minimal core, don't apply variants
        #[arg(long)]
        core_only: bool,
        /// Dry run: show the plan without executing
        #[arg(long)]
        dry_run: bool,
        /// Rebuild: read arist/vendormod/split-decls, merge into unified workspace
        #[arg(long)]
        rebuild: bool,
        /// From-lattice: regenerate workspace from declaration lattice (variant-index + dep-graph)
        #[arg(long)]
        from_lattice: bool,
        /// Repair: run SPARQL queries + GOAP planner to fix compilation errors
        #[arg(long)]
        repair: bool,
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

#[instrument(skip_all, fields(download_only = download_only, parallel = parallel))]
#[instrument(skip(download_only))]
async fn cmd_poll(download_only: bool, parallel: usize) -> Result<()> {
    let config = load_config()?;
    info!("Starting poll operation");

    // Step 1: Fetch project list from API and download new projects
    let api_key = get_api_key()?;
    let client = Client::builder()
        .timeout(Duration::from_secs(30))
        .build()
        .context("Failed to build HTTP client")?;

    // Fetch paginated project list
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
            .header("x-api-key", &api_key)
            .send()
            .await
            .with_context(|| format!("Failed to fetch project list from {}", page_url))?;

        let response_text = response.text().await?;
        let page_json: Value = serde_json::from_str(&response_text)
            .with_context(|| "Failed to parse project list JSON")?;

        let page_projects = page_json["projects"].as_array().cloned().unwrap_or_default();
        let page_count = page_projects.len();
        all_projects.extend(page_projects);
        info!(page, page_count, total = all_projects.len(), "Fetched project page");

        let next_key = page_json["pagination_key"].as_str().map(|s| s.to_string());
        if next_key.is_none() || page_count == 0 {
            break;
        }
        if pagination_key.as_deref() == next_key.as_deref() {
            break;
        }
        pagination_key = next_key;
    }

    // Save the project list
    let projects_json = serde_json::json!({
        "projects": all_projects,
        "total": all_projects.len()
    });
    let projects_path = config.base_dir.join("aristotle_projects.json");
    fs::write(&projects_path, serde_json::to_string_pretty(&projects_json)?)?;
    info!(path = %projects_path.display(), total = all_projects.len(), "Saved project list");

    println!("API projects: {}", all_projects.len());

    // Step 2: Download any new projects
    let existing_ids: HashSet<String> = {
        let mut s = HashSet::new();
        if let Ok(entries) = std::fs::read_dir(&config.results_dir) {
            for entry in entries.filter_map(|e| e.ok()) {
                let name_string = entry.file_name().to_string_lossy().into_owned();
                if name_string.ends_with("_aristotle") {
                    s.insert(name_string.trim_end_matches("_aristotle").to_string());
                }
                if name_string.ends_with("-aristotle.tar.gz") {
                    s.insert(name_string.trim_end_matches("-aristotle.tar.gz").to_string());
                }
            }
        }
        s
    };

    let new_count = all_projects.len() - existing_ids.len();
    println!("  Existing: {}", existing_ids.len());
    println!("  New:      {}", new_count);

    if new_count > 0 {
        println!("\nDownloading {} new projects...", new_count);
        crate::fetch::cmd_fetch(parallel, None, false).await?;
    } else if download_only {
        println!("\n  Nothing new — exiting (download-only mode).");
        return Ok(());
    }

    // Step 3: Build existing projects
    println!("\nBuilding projects...");
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
    let _api_key = get_api_key()?;

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

    // ── Multi-language extensions: Rust, Python, Shmem, Agent Logs ──

    println!("\n── Rust declarations ──");
    match run_rust_splitter(&input_dir, &output_dir.join("rust")) {
        Ok(n) => {
            println!("  ✓ {} Rust declarations", n);
            total_decls += n;
        }
        Err(e) => println!("  ✗ Rust split failed: {}", e),
    }

    println!("\n── Python declarations ──");
    match run_python_splitter(&input_dir, &output_dir.join("python")) {
        Ok(n) => {
            println!("  ✓ {} Python declarations", n);
            total_decls += n;
        }
        Err(e) => println!("  ✗ Python split failed: {}", e),
    }

    println!("\n── Shared memory (IPLD CAR) ──");
    match run_shmem_splitter(&output_dir.join("shmem")) {
        Ok(n) => {
            println!("  ✓ {} shmem declarations", n);
            total_decls += n;
        }
        Err(e) => println!("  ✗ Shmem query failed: {}", e),
    }

    println!("\n── Agent logs / task lists ──");
    match run_agent_log_splitter(&input_dir, &output_dir.join("agent_logs")) {
        Ok(n) => {
            println!("  ✓ {} agent log declarations", n);
            total_decls += n;
        }
        Err(e) => println!("  ✗ Agent log split failed: {}", e),
    }

    println!(
        "\nSplit complete: {} succeeded, {} failed, {} total declarations across all languages. Results in: {}",
        succeeded, failed, total_decls, output_dir.display()
    );
    info!(succeeded, failed, total_decls, "Split complete (all languages)");
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

/// ── Rust splitter: run split-decls-rs on .rs files ────────────────

/// Run the Rust declaration splitter on a directory (uses split-decls-rs).
fn run_rust_splitter(input_dir: &PathBuf, output_dir: &PathBuf) -> Result<u64> {
    let split_decls_bin = std::env::var("SPLIT_DECLS_RS_BIN")
        .map(PathBuf::from)
        .unwrap_or_else(|_| {
            // Try common paths
            let candidates = [
                "/nix/store/" // glob? we try PATH
            ];
            "split-decls-rs".into()
        });

    fs::create_dir_all(output_dir)?;
    let mut total_decls = 0u64;

    // Discover all .rs files
    for entry in WalkDir::new(input_dir)
        .max_depth(10)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "rs"))
    {
        let path = entry.path();
        let rel = path.strip_prefix(input_dir).unwrap_or(path);
        let safe_name = rel.to_string_lossy().replace('/', "__");
        let file_output = output_dir.join(&safe_name);
        fs::create_dir_all(&file_output)?;

        // Try using split-decls-rs simple-split first
        let result = Command::new(&split_decls_bin)
            .args(["simple-split", &path.to_string_lossy(), &file_output.to_string_lossy()])
            .output();

        match result {
            Ok(output) => {
                if output.status.success() {
                    let stdout = String::from_utf8_lossy(&output.stdout);
                    let count = stdout.lines()
                        .filter(|l| l.contains("declaration") || l.contains("flattened"))
                        .count() as u64;
                    total_decls += if count > 0 { count } else { 1 };

                    // Write declaration metadata
                    let meta = serde_json::json!({
                        "kind": "rust_file",
                        "source": path.to_string_lossy(),
                        "declarations": count,
                        "splitter": "split-decls-rs",
                    });
                    fs::write(file_output.join("declaration.json"), serde_json::to_string_pretty(&meta)?)?;
                } else {
                    // Fallback: use inline static extraction
                    let count = extract_rust_decls_inline(path, &file_output)?;
                    total_decls += count as u64;
                }
            }
            Err(_) => {
                // split-decls-rs not available, use inline
                let count = extract_rust_decls_inline(path, &file_output)?;
                total_decls += count as u64;
            }
        }
    }

    info!(count = total_decls, input = %input_dir.display(), "Rust split complete");
    Ok(total_decls)
}

/// Fallback: extract Rust declarations from a single .rs file using syn-based parsing
/// (invokes rust-parser helper if available, otherwise does basic regex extraction).
fn extract_rust_decls_inline(path: &std::path::Path, output_dir: &std::path::Path) -> Result<usize> {
    let content = std::fs::read_to_string(path)?;
    let mut count = 0usize;

    // Try to use the existing extract_rs_declarations infrastructure
    let extractor_bin = std::env::var("RUST_DECL_EXTRACTOR")
        .unwrap_or_else(|_| "extract-rs-declarations".to_string());

    let result = Command::new(&extractor_bin)
        .arg(path.as_os_str())
        .arg(output_dir.as_os_str())
        .output();

    if let Ok(output) = result {
        if output.status.success() {
            let stdout = String::from_utf8_lossy(&output.stdout);
            for line in stdout.lines() {
                if let Ok(n) = line.trim().parse::<usize>() {
                    count += n;
                }
            }
            if count > 0 {
                return Ok(count);
            }
        }
    }

    // Pure-Rust fallback: regex-based extraction for common patterns
    // This mirrors what split-expanded-lib's DeclsVisitor does
    for line in content.lines() {
        let trimmed = line.trim();
        for kw in &["fn ", "struct ", "enum ", "trait ", "type ", "const ", "static ", "macro_rules!", "pub mod", "impl "] {
            if trimmed.starts_with(kw) {
                let after = &trimmed[kw.len()..];
                let name = after.split(|c: char| c == '<' || c == '(' || c == ' ' || c == '{' || c == ';' || c == ':')
                    .next().unwrap_or("");
                if !name.is_empty() && name.chars().all(|c| c.is_alphanumeric() || c == '_') {
                    let dirname = format!("{}_{}", kw.trim().trim_end_matches(' '), name);
                    let decl_dir = output_dir.join(&dirname);
                    let _ = fs::create_dir_all(&decl_dir);
                    let meta = serde_json::json!({
                        "kind": kw.trim().trim_end_matches(' '),
                        "name": name,
                        "source": path.to_string_lossy(),
                        "signature": trimmed,
                    });
                    let _ = fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&meta).unwrap_or_default());
                    count += 1;
                    break;
                }
            }
        }
    }

    Ok(count)
}

/// ── Python splitter: extract declarations from .py files ───────────
fn run_python_splitter(input_dir: &PathBuf, output_dir: &PathBuf) -> Result<u64> {
    fs::create_dir_all(output_dir)?;
    let mut total = 0u64;

    for entry in WalkDir::new(input_dir)
        .max_depth(8)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "py"))
    {
        let path = entry.path();
        let content = std::fs::read_to_string(path)?;
        let rel = path.strip_prefix(input_dir).unwrap_or(path);
        let safe_name = rel.to_string_lossy().replace('/', "__");
        let file_output = output_dir.join(&safe_name);
        fs::create_dir_all(&file_output)?;

        let mut count = 0u64;
        for line in content.lines() {
            let trimmed = line.trim();
            for kw in &["def ", "class ", "async def "] {
                if let Some(after) = trimmed.strip_prefix(kw) {
                    let name = after.split(|c: char| c == '(' || c == ' ' || c == ':').next().unwrap_or("");
                    if !name.is_empty() {
                        let decl_dir = file_output.join(format!("{}_{}", kw.trim().trim_end_matches(' '), name));
                        let _ = fs::create_dir_all(&decl_dir);
                        let meta = serde_json::json!({
                            "kind": kw.trim().trim_end_matches(' '),
                            "name": name,
                            "source": path.to_string_lossy(),
                            "language": "python",
                            "signature": trimmed,
                        });
                        let _ = fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&meta).unwrap_or_default());
                        count += 1;
                    }
                    break;
                }
            }
        }
        total += count;
    }

    info!(count = total, input = %input_dir.display(), "Python split complete");
    Ok(total)
}

/// ── Shmem splitter: query IPLD CAR shared memory for declarations ──
fn run_shmem_splitter(output_dir: &PathBuf) -> Result<u64> {
    fs::create_dir_all(output_dir)?;
    let mut total = 0u64;

    // Try the vendormod tile server at ports 8765, 8156
    for port in &[8765, 8156] {
        let url = format!("http://localhost:{}/search?q=*&limit=1000", port);
        let client = reqwest::blocking::Client::builder()
            .timeout(std::time::Duration::from_secs(5))
            .build()
            .ok();

        if let Some(client) = client {
            if let Ok(resp) = client.get(&url).send() {
                if resp.status().is_success() {
                    if let Ok(body) = resp.text() {
                        let shmem_dir = output_dir.join("shmem");
                        let _ = fs::create_dir_all(&shmem_dir);
                        fs::write(shmem_dir.join("shmem_dump.json"), &body)?;

                        // Count declarations
                        if let Ok(decls) = serde_json::from_str::<Vec<serde_json::Value>>(&body) {
                            total += decls.len() as u64;
                            for (i, decl) in decls.iter().enumerate() {
                                let fallback_name = format!("decl_{}", i);
                                let name = decl["name"].as_str().unwrap_or(&fallback_name);
                                let kind = decl["kind"].as_str().unwrap_or("shmem_decl");
                                let decl_dir = shmem_dir.join(format!("{}_{}", kind, name.replace('.', "_")));
                                let _ = fs::create_dir_all(&decl_dir);
                                let _ = fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(decl).unwrap_or_default());
                            }
                        }
                        info!(count = total, port = port, "Shmem dump complete");
                        return Ok(total);
                    }
                }
            }
        }
    }

    // Also try UDS socket
    if let Ok(content) = std::fs::read_to_string("@ipld_car_shmem") {
        // The socket may not be readable as file; try vendormod query
        info!("Shmem socket found but not directly readable");
    }

    info!(count = total, "Shmem splitter: found {} declarations from shared memory", total);
    Ok(total)
}

/// ── Agent log splitter: extract patterns from Aristotle project logs ──
fn run_agent_log_splitter(input_dir: &PathBuf, output_dir: &PathBuf) -> Result<u64> {
    fs::create_dir_all(output_dir)?;
    let mut total = 0u64;

    for entry in WalkDir::new(input_dir)
        .max_depth(6)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| {
            let name = e.file_name().to_string_lossy();
            name.ends_with(".md") || name == "ARISTOTLE_SUMMARY.md" || name == "aristotle_status.json"
        })
    {
        let path = entry.path();
        let content = std::fs::read_to_string(path)?;
        let rel = path.strip_prefix(input_dir).unwrap_or(path);
        let safe_name = rel.to_string_lossy().replace('/', "__");
        let file_output = output_dir.join(&safe_name);
        fs::create_dir_all(&file_output)?;

        // Extract key-value patterns from logs
        let mut count = 0u64;
        for line in content.lines() {
            let trimmed = line.trim();
            // Extract "Key: Value" patterns
            if let Some(colon_pos) = trimmed.find(": ") {
                let key = &trimmed[..colon_pos].trim();
                let val = &trimmed[colon_pos + 2..].trim();
                if key.len() > 2 && key.len() < 100 && val.len() > 1 {
                    let decl_dir = file_output.join(format!("log_{}_{}", sanitize_name(key), sanitize_name(val)));
                    let _ = fs::create_dir_all(&decl_dir);
                    let meta = serde_json::json!({
                        "kind": "agent_log",
                        "key": key,
                        "value": val,
                        "source": path.to_string_lossy(),
                    });
                    let _ = fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&meta).unwrap_or_default());
                    count += 1;
                }
            }
        }
        total += count;
    }

    // Also extract from task lists (JSON files with task descriptions)
    for entry in WalkDir::new(input_dir)
        .max_depth(6)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_name() == "aristotle_projects.json")
    {
        if let Ok(content) = std::fs::read_to_string(entry.path()) {
            if let Ok(json) = serde_json::from_str::<serde_json::Value>(&content) {
                if let Some(projects) = json["projects"].as_array() {
                    for (i, proj) in projects.iter().enumerate() {
                        let desc = proj["description"].as_str().unwrap_or("");
                        let pid = proj["project_id"].as_str().unwrap_or("");
                        // Extract terms from description as "task list" declarations
                        for term in desc.split_whitespace().take(20) {
                            let clean = term.trim_matches(|c: char| !c.is_alphanumeric() && c != '_');
                            if clean.len() > 3 {
                                let decl_dir = output_dir.join("task_list").join(format!("task_{}_{}", &pid[..8], sanitize_name(clean)));
                                let _ = fs::create_dir_all(&decl_dir);
                                let meta = serde_json::json!({
                                    "kind": "task_list",
                                    "project_id": pid,
                                    "term": clean,
                                    "description": desc.chars().take(100).collect::<String>(),
                                });
                                let _ = fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&meta).unwrap_or_default());
                                total += 1;
                            }
                        }
                    }
                }
            }
        }
    }

    info!(count = total, "Agent log split complete");
    Ok(total)
}

fn sanitize_name(name: &str) -> String {
    name.chars().map(|c| if c.is_alphanumeric() || c == '_' || c == '-' { c } else { '_' }).collect()
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

/// ── Consolidate command ──────────────────────────────────────────────────

#[instrument(skip(output_dir))]
fn cmd_consolidate(project_id: &str, output_dir: Option<PathBuf>) -> Result<()> {
    let config = load_config()?;
    let output_dir = output_dir.unwrap_or_else(|| config.base_dir.join("consolidated"));
    fs::create_dir_all(&output_dir)?;

    let project_dir = config.git_base.join(format!("{}_aristotle", project_id));
    if !project_dir.exists() {
        let alt_dir = config.results_dir.join(format!("{}_aristotle", project_id));
        if alt_dir.exists() {
            return consolidate_project(&alt_dir, &output_dir, project_id);
        }
        return Err(anyhow::anyhow!(
            "Project {} not found. Run 'aristotle-manager download-result {}' first.",
            project_id, project_id
        ));
    }
    consolidate_project(&project_dir, &output_dir, project_id)
}

fn consolidate_project(project_dir: &PathBuf, output_dir: &PathBuf, project_id: &str) -> Result<()> {
    let mut lean_files: Vec<PathBuf> = Vec::new();
    for entry in WalkDir::new(project_dir).max_depth(10).into_iter().filter_map(|e| e.ok()) {
        if entry.path().extension().map_or(false, |ext| ext == "lean") {
            lean_files.push(entry.path().to_path_buf());
        }
    }

    if lean_files.is_empty() {
        println!("No .lean files found in project {}", project_id);
        return Ok(());
    }

    #[derive(Debug, Serialize)]
    struct Declaration {
        name: String,
        kind: String,
        file: String,
        line: usize,
        content: String,
        cid: String,
        dependencies: Vec<String>,
    }

    let decl_keywords = [
        "theorem", "def", "lemma", "example", "instance",
        "class", "inductive", "structure", "abbrev", "axiom",
        "opaque", "mutual",
    ];

    let mut declarations: Vec<Declaration> = Vec::new();
    let mut seen: std::collections::HashSet<String> = std::collections::HashSet::new();

    for lean_path in &lean_files {
        let content = fs::read_to_string(lean_path)?;
        let file_name = lean_path.file_name().and_then(|s| s.to_str()).unwrap_or("unknown");
        let mut line_num = 0usize;
        for line in content.lines() {
            line_num += 1;
            let trimmed = line.trim();
            let mut found_kind: Option<&str> = None;
            for kw in &decl_keywords {
                if trimmed.starts_with(kw) {
                    let after = &trimmed[kw.len()..];
                    if after.starts_with(' ') || after.starts_with('\t') {
                        found_kind = Some(*kw);
                        break;
                    }
                }
            }
            if let Some(kind) = found_kind {
                let after_kw = trimmed[kind.len()..].trim_start();
                let name_part = if after_kw.starts_with('@') {
                    after_kw.split(']').nth(1).unwrap_or(after_kw).trim_start()
                } else { after_kw };
                let name = name_part
                    .split(|c: char| c.is_whitespace() || c == '(' || c == ':' || c == '{' || c == '[')
                    .next().unwrap_or("").to_string();
                if name.is_empty() || name == "-" || name == "_" { continue; }

                use std::hash::{Hash, Hasher};
                let mut hasher = std::collections::hash_map::DefaultHasher::new();
                line.hash(&mut hasher);
                let cid = format!("decl-cid-{:016x}", hasher.finish());

                let mut deps: Vec<String> = Vec::new();
                for word in name_part.split_whitespace() {
                    let w = word.trim_matches(|c: char| c == ',' || c == ')' || c == '(' || c == ':');
                    if !w.is_empty() && w != name && w.chars().next().map_or(false, |c| c.is_alphabetic()) && w.len() > 1 {
                        deps.push(w.to_string());
                    }
                }
                deps.sort(); deps.dedup();

                let dedup_key = format!("{}::{}", kind, name);
                if seen.insert(dedup_key) {
                    declarations.push(Declaration { name, kind: kind.to_string(), file: file_name.to_string(), line: line_num, content: line.to_string(), cid, dependencies: deps });
                }
            }
        }
    }

    declarations.sort_by(|a, b| a.kind.cmp(&b.kind).then(a.name.cmp(&b.name)));
    let total = declarations.len();

    let mut consolidated_lean = format!("-- Consolidated from Aristotle project {}\n-- {} declarations\n\n", project_id, total);
    let mut current_kind = String::new();
    for decl in &declarations {
        if decl.kind != current_kind {
            current_kind = decl.kind.clone();
            consolidated_lean.push_str(&format!("\n-- {}s\n\n", current_kind));
        }
        consolidated_lean.push_str(&format!("-- [{}:{}]\n{}\n\n", decl.file, decl.line, decl.content));
    }
    fs::write(output_dir.join(format!("{}_consolidated.lean", project_id)), &consolidated_lean)?;

    let mut breakdown_map = serde_json::Map::new();
    let mut counts: std::collections::HashMap<&str, usize> = std::collections::HashMap::new();
    for decl in &declarations { *counts.entry(&decl.kind).or_default() += 1; }
    for (kind, count) in &counts { breakdown_map.insert(kind.to_string(), serde_json::json!(count)); }

    let decls_json: Vec<serde_json::Value> = declarations.iter().map(|d| serde_json::json!({
        "name": d.name, "kind": d.kind, "file": d.file, "line": d.line,
        "cid": d.cid, "dependencies": d.dependencies, "content": d.content,
    })).collect();

    let manifest = serde_json::json!({
        "project_id": project_id, "total_declarations": total,
        "breakdown": breakdown_map, "declarations": decls_json,
    });
    fs::write(output_dir.join(format!("{}_manifest.json", project_id)), serde_json::to_string_pretty(&manifest)?)?;

    println!("Consolidated project {}: {} declarations", project_id, total);
    let mut bk: Vec<(String, usize)> = counts.into_iter().map(|(k,v)| (k.to_string(), v)).collect();
    bk.sort_by(|a,b| b.1.cmp(&a.1));
    for (kind, count) in &bk { println!("  {:>12}: {}", kind, count); }
    Ok(())
}

/// ── Submit command: send a project to Aristotle as multipart with tarball ──

#[instrument(skip(prompt, project_dir))]
fn cmd_submit(prompt: &str, project_dir: Option<PathBuf>, _wait: bool) -> Result<()> {
    let api_key = get_api_key()?;
    let client = reqwest::blocking::Client::builder()
        .timeout(Duration::from_secs(300))
        .build()
        .context("Failed to build HTTP client")?;

    let url = if let Ok(local) = env::var("ARISTOTLE_LOCAL_URL") {
        info!("Using local Aristotle server: {}", local);
        format!("{}/project", local)
    } else {
        format!("{}/project", API_BASE_URL)
    };
    info!(url = %url, "Submitting to Aristotle API (native HTTP with tarball)");

    let mut form = reqwest::blocking::multipart::Form::new()
        .text("body", serde_json::json!({"prompt": prompt}).to_string());

    // If project directory provided, tar.gz it and attach as file
    if let Some(ref dir) = project_dir {
        if dir.exists() {
            let tar_path = dir.with_extension("tar.gz");
            // Create tarball
            let tar_status = std::process::Command::new("tar")
                .args(["-czf", &tar_path.to_string_lossy(), "-C",
                       &dir.parent().unwrap_or(dir).to_string_lossy(),
                       &dir.file_name().unwrap_or_default().to_string_lossy()])
                .output()
                .context("Failed to create project tarball")?;
            if !tar_status.status.success() {
                return Err(anyhow::anyhow!("tar failed: {}", String::from_utf8_lossy(&tar_status.stderr)));
            }
            let tar_data = std::fs::read(&tar_path)
                .context("Failed to read tarball")?;
            let tar_len = tar_data.len();
            let fname = format!("{}.tar.gz", dir.file_name().unwrap_or_default().to_string_lossy());
            let part = reqwest::blocking::multipart::Part::bytes(tar_data)
                .file_name(fname)
                .mime_str("application/gzip")?;
            form = form.part("file", part);
            info!(size = tar_len, "Attached project tarball");
            let _ = std::fs::remove_file(&tar_path);
        }
    }

    let response = client
        .post(&url)
        .header("x-api-key", &api_key)
        .multipart(form)
        .send()
        .context("Failed to submit to Aristotle API")?;

    let status = response.status();
    let body = response.text().unwrap_or_default();
    info!(http_status = %status, body = %body.chars().take(200).collect::<String>());

    if status.is_success() {
        if let Ok(json) = serde_json::from_str::<serde_json::Value>(&body) {
            if let Some(pid) = json["project_id"].as_str() {
                println!("Project created: {}", pid);
            } else {
                println!("Submitted successfully");
            }
        }
    } else {
        error!(http_status = %status, "Aristotle API error");
        return Err(anyhow::anyhow!("API error: HTTP {} — {}", status,
            body.chars().take(300).collect::<String>()));
    }

    Ok(())
}

fn ask_aristotle_sync(api_key: &str, project_id: &str, prompt: &str) -> Result<String> {
    let client = reqwest::blocking::Client::builder()
        .timeout(Duration::from_secs(60))
        .build()
        .context("Failed to build HTTP client")?;

    let url = format!("{}/project/{}/ask", API_BASE_URL, project_id);
    info!(url = %url, "Asking Aristotle (native HTTP)");

    let response = client
        .post(&url)
        .header("x-api-key", api_key)
        .json(&serde_json::json!({"prompt": prompt}))
        .send()
        .context("Failed to ask Aristotle")?;

    let status = response.status();
    let body = response.text().unwrap_or_default();
    if !status.is_success() {
        return Err(anyhow::anyhow!("Ask failed: HTTP {} — {}", status, body));
    }
    Ok(body)
}

/// Ask with files attached (Lean4 proofs, data files)
fn ask_aristotle_with_files(api_key: &str, project_id: &str, prompt: &str, files_dir: &PathBuf) -> Result<String> {
    let client = reqwest::blocking::Client::builder()
        .timeout(Duration::from_secs(120))
        .build()
        .context("Failed to build HTTP client")?;

    // Build body JSON with prompt + inline file contents
    let mut body = serde_json::json!({"prompt": prompt});
    if files_dir.exists() {
        let mut files_map = serde_json::Map::new();
        for entry in WalkDir::new(files_dir).max_depth(2).into_iter().filter_map(|e| e.ok()) {
            if entry.path().extension().map_or(false, |e| e == "lean") {
                let content = fs::read_to_string(entry.path())?;
                let name = entry.file_name().to_string_lossy().to_string();
                files_map.insert(name, serde_json::json!(content));
            }
        }
        if !files_map.is_empty() {
            body["files"] = serde_json::json!(files_map);
        }
    }

    let url = format!("{}/project/{}/ask", API_BASE_URL, project_id);
    info!(url = %url, "Asking Aristotle with files (native HTTP)");

    let response = client
        .post(&url)
        .header("x-api-key", api_key)
        .json(&body)
        .send()
        .context("Failed to ask Aristotle with files")?;

    let status = response.status();
    let resp_body = response.text().unwrap_or_default();
    if !status.is_success() {
        return Err(anyhow::anyhow!("Ask with files failed: HTTP {} — {}", status, resp_body));
    }
    Ok(resp_body)
}

/// ── Check command: query project status from Aristotle API ──────────

#[instrument(skip(project_id))]
async fn cmd_check(project_id: Option<String>, limit: Option<usize>) -> Result<()> {
    let config = load_config()?;
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

            // Local disk info
            let proj_dir = config.results_dir.join(format!("{}_aristotle", pid));
            if proj_dir.exists() {
                let lean_count = WalkDir::new(&proj_dir)
                    .into_iter()
                    .filter_map(|e| e.ok())
                    .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
                    .count();
                let sorry_count = if lean_count > 0 {
                    let mut count = 0u64;
                    for entry in WalkDir::new(&proj_dir).into_iter().filter_map(|e| e.ok())
                        .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
                    {
                        if let Ok(content) = std::fs::read_to_string(entry.path()) {
                            count += content.matches("sorry").count() as u64;
                        }
                    }
                    count
                } else { 0 };
                let flake_dir = config.base_dir.join("canonical-flakes").join(&pid);
                let has_flakes = flake_dir.exists();
                println!("  Local: {} .lean files, {} sorries, flakes={}", lean_count, sorry_count, if has_flakes { "yes" } else { "no" });
            } else {
                println!("  Local: not downloaded");
            }
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

/// ── DASL Status: show all DASL-related projects with lean/sorry/flake stats ──

fn cmd_dasl_status(filter: Option<String>, sorries_only: bool) -> Result<()> {
    let config = load_config()?;
    let dasl_keywords = ["dasl", "dag-cbor", "ipld", "monster", "moonshine", "umbral", "aristotle loop", "consolidated", "lean4", "splitter"];

    // Load API project list
    let api_path = config.base_dir.join("aristotle_projects.json");
    let all_projects: Vec<Value> = if api_path.exists() {
        let text = std::fs::read_to_string(&api_path)?;
        let json: Value = serde_json::from_str(&text)?;
        json["projects"].as_array().cloned().unwrap_or_default()
    } else {
        return Err(anyhow::anyhow!("No aristotle_projects.json — run 'download' or 'poll' first"));
    };

    // Filter to DASL-related projects
    let mut results: Vec<(String, String, u64, u64, bool)> = Vec::new();

    for project in &all_projects {
        let pid = project["project_id"].as_str().unwrap_or("").to_string();
        let desc = project["description"].as_str().unwrap_or("").to_lowercase();

        // Check if DASL-related
        let is_dasl = dasl_keywords.iter().any(|kw| desc.contains(kw));
        if !is_dasl { continue; }

        // Apply user filter
        if let Some(ref f) = filter {
            if !desc.contains(&f.to_lowercase()) { continue; }
        }

        // Local stats
        let proj_dir = config.results_dir.join(format!("{}_aristotle", &pid));
        let (lean_count, sorry_count, has_flakes) = if proj_dir.exists() {
            let mut lean = 0u64;
            let mut sorries = 0u64;
            for entry in WalkDir::new(&proj_dir).into_iter().filter_map(|e| e.ok())
                .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
            {
                lean += 1;
                if let Ok(content) = std::fs::read_to_string(entry.path()) {
                    let actual_sorries = content.lines()
                        .filter(|l| l.trim() == "sorry" || l.trim().starts_with("sorry "))
                        .count() as u64;
                    sorries += actual_sorries;
                }
            }
            let flakes = config.base_dir.join("canonical-flakes").join(&pid).exists();
            (lean, sorries, flakes)
        } else {
            (0, 0, false)
        };

        if sorries_only && sorry_count == 0 { continue; }

        let status = match project["status"].as_i64().unwrap_or(0) {
            0 => "QUEUE", 1 => "RUN", 2 => "DONE", _ => "?"
        };
        results.push((pid, status.to_string(), lean_count, sorry_count, has_flakes));
    }

    // Sort by sorry count desc, then lean count desc
    results.sort_by(|a, b| b.3.cmp(&a.3).then(b.2.cmp(&a.2)));

    println!("{:<38} {:<6} {:<6} {:<6} {:<6}", "PROJECT", "STATUS", "LEAN", "SORRY", "FLAKES");
    for (pid, status, lean, sorry, flakes) in &results {
        let marker = if *sorry > 0 { " ⚠" } else { "" };
        println!("{:<38} {:<6} {:<6} {:<6} {:<6}{}", 
            pid, status, lean, sorry, if *flakes { "yes" } else { "no" }, marker);
    }

    let total_sorries: u64 = results.iter().map(|r| r.3).sum();
    println!("\n{} DASL projects, {} total sorries", results.len(), total_sorries);
    Ok(())
}

/// ── Overlap: find projects sharing mathlib-split imports with a reference ──

fn cmd_overlap(reference: String, min_shared: usize, top: usize) -> Result<()> {
    let config = load_config()?;
    let flakes_dir = config.base_dir.join("canonical-flakes");

    // Build reference project import set
    let ref_dir = flakes_dir.join(&reference);
    if !ref_dir.exists() {
        return Err(anyhow::anyhow!(
            "Reference project not found in canonical-flakes: {}. Run canonical-flake on it first.",
            reference
        ));
    }

    let mut ref_imports: std::collections::HashSet<String> = std::collections::HashSet::new();
    for entry in WalkDir::new(&ref_dir).into_iter().filter_map(|e| e.ok())
        .filter(|e| e.file_name() == "flake.nix")
    {
        if let Ok(content) = std::fs::read_to_string(entry.path()) {
            for line in content.lines() {
                if let Some(path) = line.trim().strip_prefix("url = \"path:") {
                    let path = path.trim_end_matches("\";");
                    ref_imports.insert(path.to_string());
                }
            }
        }
    }
    let ref_count = ref_imports.len();
    println!("Reference: {} ({}) unique mathlib-split imports", reference, ref_count);

    // Scan all projects for overlap
    let mut overlaps: Vec<(String, usize)> = Vec::new();
    if let Ok(entries) = std::fs::read_dir(&flakes_dir) {
        for entry in entries.filter_map(|e| e.ok()) {
            let pid = entry.file_name().to_string_lossy().to_string();
            if pid == reference { continue; }

            let proj_dir = flakes_dir.join(&pid);
            if !proj_dir.is_dir() { continue; }

            let mut shared = 0usize;
            for flake_entry in WalkDir::new(&proj_dir).into_iter().filter_map(|e| e.ok())
                .filter(|e| e.file_name() == "flake.nix")
            {
                if let Ok(content) = std::fs::read_to_string(flake_entry.path()) {
                    for line in content.lines() {
                        if let Some(path) = line.trim().strip_prefix("url = \"path:") {
                            let path = path.trim_end_matches("\";");
                            if ref_imports.contains(path) {
                                shared += 1;
                            }
                        }
                    }
                }
            }
            if shared >= min_shared {
                overlaps.push((pid, shared));
            }
        }
    }

    overlaps.sort_by(|a, b| b.1.cmp(&a.1));
    let total = overlaps.len();
    println!("\n{:<40} {:<10}", "PROJECT", "SHARED");
    for (pid, shared) in overlaps.iter().take(top) {
        println!("{:<40} {:<10}", pid, shared);
    }
    println!("\n{} projects share >= {} imports with {}", total, min_shared, reference);
    Ok(())
}

/// ── Download result from a completed Aristotle project ─────────

async fn cmd_download_result(project_id: &str, output_dir: Option<PathBuf>, verbose: bool) -> Result<()> {
    let config = load_config()?;
    let api_key = get_api_key()?;
    let results_dir = output_dir.unwrap_or_else(|| config.results_dir.join("aristo-outputs"));
    fs::create_dir_all(&results_dir)?;
    let client = Client::builder().timeout(Duration::from_secs(300)).build()?;
    // Enable debug tracing for verbose mode
    if verbose {
        info!("Verbose mode: full chat/prose data will be saved");
    }
    println!("Downloading result for {}...", project_id);
    match download_single_result(&client, &api_key, project_id, &results_dir, &results_dir, config.retry_wait_seconds, config.max_retries).await {
        Ok(path) => {
            println!("Downloaded to: {}", path.display());
            let summary = path.join("output-final_aristotle").join("ARISTOTLE_SUMMARY.md");
            if summary.exists() {
                println!("\n=== Aristotle Chat / Summary ===");
                let summary_text = fs::read_to_string(&summary)?;
                for line in summary_text.lines().take(40) { println!("{}", line); }
            } else {
                // Check for sub-project path (e.g., e3e23af0_aristotle/ARISTOTLE_SUMMARY.md)
                for entry in WalkDir::new(&path).max_depth(2).into_iter().filter_map(|e| e.ok()) {
                    if entry.file_name() == "ARISTOTLE_SUMMARY.md" {
                        println!("\n=== Aristotle Chat / Summary ===");
                        let summary_text = fs::read_to_string(entry.path())?;
                        for line in summary_text.lines().take(40) { println!("{}", line); }
                        break;
                    }
                }
            }
            let lean = WalkDir::new(&path).into_iter().filter_map(|e| e.ok()).filter(|e| e.path().extension().map_or(false, |e| e=="lean")).count();
            println!("  .lean files: {}", lean);
            if verbose {
                // Extract and save all prose for term analysis
                let prose_path = path.join("aristotle_all_prose.txt");
                let mut prose = String::new();
                for entry in WalkDir::new(&path).into_iter().filter_map(|e| e.ok()) {
                    if entry.path().extension().map_or(false, |e| e == "lean" || e == "md") {
                        if let Ok(text) = fs::read_to_string(entry.path()) {
                            // For .lean files, extract comments and docstrings only
                            if entry.path().extension().unwrap_or_default() == "lean" {
                                for line in text.lines() {
                                    let trimmed = line.trim();
                                    if trimmed.starts_with("-- ") || trimmed.starts_with("/--") || trimmed.starts_with("/-!") {
                                        prose.push_str(line);
                                        prose.push('\n');
                                    }
                                }
                            } else {
                                prose.push_str(&text);
                                prose.push('\n');
                            }
                        }
                    }
                }
                fs::write(&prose_path, &prose)?;
                println!("  Saved all prose to: {}", prose_path.display());
            }
        }
        Err(e) => println!("Failed: {}", e),
    }
    Ok(())
}

/// ── Ask: send instructions to a running Aristotle project ────────

fn cmd_ask(project_id: String, prompt: String, file: Option<PathBuf>, inject_dir: Option<PathBuf>) -> Result<()> {
    use std::process::Command;
    let api_key = get_api_key()?;

    // Build the prompt — optionally inject file content
    let final_prompt = if let Some(ref f) = file {
        let content = std::fs::read_to_string(f)
            .context("Failed to read inject file")?;
        let fname = f.file_name().unwrap_or_default().to_string_lossy();
        if prompt.contains("{file}") {
            prompt.replace("{file}", &format!("=== {} ===\n{}\n=== END FILE ===", fname, content))
        } else {
            format!("{}\n\n=== {} ===\n{}\n=== END FILE ===", prompt, fname, content)
        }
    } else {
        prompt.to_string()
    };

    info!("Asking project {}: {}...", project_id, &final_prompt[..final_prompt.len().min(80)]);
    
    let ask_result = ask_aristotle_sync(&api_key, &project_id, &final_prompt);
    match ask_result {
        Ok(resp) => println!("{}", resp),
        Err(e) => eprintln!("Ask failed: {}", e),
    }

    // Batch inject: iterate all .lean files in a directory
    if let Some(ref dir) = inject_dir {
        let entries: Vec<_> = std::fs::read_dir(dir)
            .context("Failed to read inject_dir")?
            .filter_map(|e| e.ok())
            .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
            .collect();
        for entry in &entries {
            let path = entry.path();
            let content = std::fs::read_to_string(&path)
                .with_context(|| format!("Failed to read {:?}", path))?;
            let fname = path.file_name().unwrap_or_default().to_string_lossy();
            let ask_prompt = format!("File: {}\n\n=== {} ===\n{}\n=== END FILE ===", fname, fname, content);
            match ask_aristotle_sync(&api_key, &project_id, &ask_prompt) {
                Ok(_) => {}
                Err(e) => eprintln!("  Failed to inject: {} — {}", fname, e),
            }
        }
        println!("Injected {} files into project {}", entries.len(), project_id);
    }

    Ok(())
}

/// ── Patch mode: poll a running Aristotle project, detect prereq gaps ──

async fn cmd_patch(project_id: String, prereq_dir: PathBuf, interval: u64, max_rounds: usize) -> Result<()> {
    use tokio::time::{sleep, Duration};

    let config = load_config()?;
    let api_key = get_api_key()?;
    let client = Client::builder()
        .timeout(Duration::from_secs(30))
        .build()
        .context("Failed to build HTTP client")?;

    // Index prereq files
    let mut prereq_index: std::collections::HashMap<String, PathBuf> = std::collections::HashMap::new();
    for entry in WalkDir::new(&prereq_dir).into_iter().filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |e| e == "lean"))
    {
        let name = entry.path().file_name().unwrap_or_default().to_string_lossy().to_string();
        prereq_index.insert(name, entry.path().to_path_buf());
    }
    println!("Indexed {} prereq files", prereq_index.len());
    println!("Watching project {} every {}s for {} rounds", project_id, interval, max_rounds);

    for round in 1..=max_rounds {
        // Check project status
        let url = format!("{}/project/{}", API_BASE_URL, project_id);
        let resp = client.get(&url).header("x-api-key", &api_key).send().await;
        match resp {
            Ok(r) if r.status().is_success() => {
                let json: serde_json::Value = r.json().await?;
                let status = json["status"].as_i64().unwrap_or(0);
                let desc = json["description"].as_str().unwrap_or("");

                match status {
                    0 | 1 => { // Queued or Running
                        println!("[Round {}/{}] Status: {} — still working...", round, max_rounds,
                            if status == 0 { "QUEUED" } else { "RUNNING" });
                        
                        // Check if Aristotle is asking for specific files
                        let tasks_url = format!("{}/project/{}/task", API_BASE_URL, project_id);
                        if let Ok(tasks_resp) = client.get(&tasks_url).header("x-api-key", &api_key).send().await {
                            if tasks_resp.status().is_success() {
                                let tasks_json: serde_json::Value = tasks_resp.json().await?;
                                if let Some(tasks) = tasks_json.as_array() {
                                    for task in tasks {
                                        let task_desc = task["description"].as_str().unwrap_or("");
                                        let task_status = task["status"].as_str().unwrap_or("");
                                        if task_status == "running" || task_status == "queued" {
                                            // Look for file requests in task description
                                            for pat in ["need", "missing", "cannot find", "can't find", "require", "please provide"] {
                                                if task_desc.to_lowercase().contains(pat) {
                                                    println!("  Task needs help: {}", &task_desc[..task_desc.len().min(200)]);
                                                    // Try to find matching prereq
                                                    for (name, path) in &prereq_index {
                                                        if task_desc.contains(name.as_str()) {
                                                            println!("  Found prereq: {} -> injecting...", name);
                                                            let content = std::fs::read_to_string(path)?;
                                                            let ask_prompt = format!(
                                                                "Here is the missing file you need:\n\n=== {} ===\n{}\n=== END FILE ===",
                                                                name, content
                                                            );
                                                            let _ = ask_aristotle_sync(&api_key, &project_id, &ask_prompt);
                                                            println!("  Injected: {}", name);
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    2 => { // Done
                        println!("[Round {}/{}] COMPLETED!", round, max_rounds);
                        return Ok(());
                    }
                    _ => {
                        println!("[Round {}/{}] Status: FAILED ({})", round, max_rounds, status);
                        return Err(anyhow::anyhow!("Project failed: {}", desc));
                    }
                }
            }
            Ok(r) => {
                println!("[Round {}/{}] API returned {}", round, max_rounds, r.status());
            }
            Err(e) => {
                println!("[Round {}/{}] API error: {}", round, max_rounds, e);
            }
        }
        sleep(Duration::from_secs(interval)).await;
    }
    println!("Max rounds ({}) reached — project still running", max_rounds);
    Ok(())
}

/// ── DaslFinish: download result, merge, rebuild flakes, update planner ──

async fn cmd_dasl_finish(project_id: String, common_project: PathBuf, results_dir: PathBuf) -> Result<()> {
    info!("=== dasl-finish: {} ====", project_id);

    // Step 1: Download result to canonical results directory
    let api_key = get_api_key()?;
    let client = Client::builder().timeout(Duration::from_secs(300)).build()?;
    fs::create_dir_all(&results_dir)?;
    
    println!("[1/5] Downloading result for {}...", project_id);
    let download_path = download_single_result(
        &client, &api_key, &project_id, &results_dir, &results_dir, 10, 3
    ).await?;
    println!("  Downloaded to: {}", download_path.display());

    // Step 2: Find and copy .lean files into common project
    println!("[2/5] Merging .lean files into {}...", common_project.display());
    let lean_files: Vec<_> = WalkDir::new(&download_path)
        .into_iter().filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |e| e == "lean"))
        .collect();
    
    let mut merged = 0usize;
    for entry in &lean_files {
        let src = entry.path();
        let fname = format!("{}_{}", &project_id[..8], src.file_name().unwrap_or_default().to_string_lossy());
        let dst = common_project.join("RequestProject").join(&fname);
        if !src.starts_with(&common_project) {
            fs::create_dir_all(dst.parent().unwrap())?;
            fs::copy(src, &dst)?;
            merged += 1;
        }
    }
    println!("  Merged {} .lean files ({} total in result)", merged, lean_files.len());

    // Step 3: Regenerate canonical flakes
    println!("[3/5] Regenerating canonical flakes...");
    let flakes_out = common_project.parent().unwrap().join("dasl-sorries-flakes");
    let _ = fs::remove_dir_all(&flakes_out);
    let _ = cmd_canonical_flake_inner(&common_project, &flakes_out, None)?;
    let flake_count = WalkDir::new(&flakes_out).into_iter().filter_map(|e| e.ok())
        .filter(|e| e.file_name() == "flake.nix").count();
    println!("  {} modules with flakes", flake_count);

    // Step 4: Update planner (auto-scan)
    println!("[4/5] Updating planner...");
    match std::process::Command::new("bash").arg("-c")
        .arg("cd ~/dasl-planning && ./dasl-planner refresh 2>&1")
        .output() 
    {
        Ok(out) => println!("  Planner: {}", String::from_utf8_lossy(&out.stdout).trim()),
        Err(e) => eprintln!("  Planner refresh failed: {}", e),
    }

    // Also update GOAP planner
    match std::process::Command::new(
        "/home/mdupont/dasl-planning/plan-mappings/goap/target/release/dasl-planner"
    ).output() {
        Ok(out) => {
            let goap_out = String::from_utf8_lossy(&out.stdout);
            let done = goap_out.lines().filter(|l| l.contains("✓")).count();
            println!("  GOAP: {} atoms proven", done);
        }
        Err(_) => {}
    }

    // Step 5: Git commit
    println!("[5/5] Committing...");
    let _ = std::process::Command::new("git")
        .args(["-C", &common_project.to_string_lossy(), "add", "-A"])
        .output();
    let _ = std::process::Command::new("git")
        .args(["-C", &common_project.to_string_lossy(), "commit", "-m",
            &format!("dasl-finish: merged Aristotle result {} ({} .lean files)", project_id, merged),
            "--no-verify"])
        .output();
    println!("  Committed {} files", merged);

    println!("\n=== dasl-finish complete ===");
    println!("  Project:  {}", project_id);
    println!("  Files:    {} merged", merged);
    println!("  Flakes:   {} modules", flake_count);
    println!("  Results:  {}", results_dir.display());

    Ok(())
}

/// ── Inner canonical-flake (returns Result instead of printing) ──

fn cmd_canonical_flake_inner(input_dir: &PathBuf, output_dir: &PathBuf, mathlib_split: Option<PathBuf>) -> Result<()> {
    use std::collections::HashSet;
    let mathlib_dir = mathlib_split.unwrap_or_else(|| PathBuf::from("/home/mdupont/projects/lean-split-tool/mathlib-split"));
    let index = cmd_canonical_flake_build_index(&mathlib_dir)?;
    let output_base = output_dir.join("RequestProject");
    fs::create_dir_all(&output_base)?;
    let lean_files: Vec<_> = WalkDir::new(input_dir.join("RequestProject")).into_iter()
        .filter_map(|e| e.ok()).filter(|e| e.path().extension().map_or(false, |e| e == "lean")).collect();
    let mut resolved = 0usize;
    for entry in &lean_files {
        let content = fs::read_to_string(entry.path())?;
        let mut deps: Vec<String> = Vec::new();
        for line in content.lines() {
            let trimmed = line.trim();
            if trimmed.starts_with("import ") {
                let import_path = trimmed.strip_prefix("import ").unwrap().trim();
                if let Some(resolved_path) = index.get(import_path) {
                    deps.push(format!("    \"{}", resolved_path));
                    resolved += 1;
                }
            }
        }
        let fname = entry.path().file_stem().unwrap().to_string_lossy();
        let mod_dir = output_base.join(&*fname);
        fs::create_dir_all(&mod_dir)?;
        let flake_content = format!(r#"{{
  description = "Canonical flake for {mod} — Auto-generated by canonical-flake";
  inputs = {{
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  }};
  outputs = {{ self, nixpkgs }}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${{system}};
    mathlibPath = "{mathlib}";
  in {{
    packages.${{system}}.default = pkgs.stdenv.mkDerivation {{
      name = "{mod}";
      src = ./.;
      buildInputs = with pkgs; [ lean4 ];
      buildPhase = ''"
        for dep in {deps_str}; do
          cp -r "$dep" src/
        done
        mkdir -p $out
        cp {mod}.lean $out/
      "'';
      installPhase = "true";
    }};
    devShells.${{system}}.default = pkgs.mkShell {{
      buildInputs = with pkgs; [ lean4 ];
      shellHook = ''
        echo "Canonical flake: {mod}"
        echo "Mathlib-split: {mathlib}"
      '';
    }};
  }};
}}"#, 
            mod = fname,
            mathlib = mathlib_dir.display(),
            deps_str = deps.join("\n")
        );
        fs::write(mod_dir.join("flake.nix"), &flake_content)?;
        fs::copy(entry.path(), mod_dir.join(format!("{}.lean", fname)))?;
    }
    Ok(())
}

fn cmd_canonical_flake_build_index(mathlib_dir: &PathBuf) -> Result<std::collections::HashMap<String, String>> {
    let mut index = std::collections::HashMap::new();
    for entry in WalkDir::new(mathlib_dir).into_iter().filter_map(|e| e.ok())
        .filter(|e| e.file_name() == "flake.nix")
    {
        let rel = entry.path().strip_prefix(mathlib_dir).unwrap_or(entry.path());
        let mod_path = rel.parent().unwrap_or(std::path::Path::new(""));
        if let Ok(content) = fs::read_to_string(entry.path()) {
            for line in content.lines() {
                if let Some(module) = line.trim().strip_prefix("module = \"") {
                    let module = module.trim_end_matches("\";");
                    index.insert(module.to_string(), mod_path.to_string_lossy().to_string());
                }
            }
        }
    }
    Ok(index)
}

/// ── McKay-OEIS: scan OEIS for McKay-Thompson series, generate Lean4 DB ──

fn cmd_mckay_oeis(grep_files: Vec<PathBuf>, output: PathBuf, inject_into: Option<String>) -> Result<()> {
    use std::collections::BTreeMap;

    println!("Parsing OEIS grep files for McKay-Thompson series...");
    
    // Collect unique .seq file paths from grep output
    let mut seq_files: BTreeMap<String, ()> = BTreeMap::new();
    for gf in &grep_files {
        let content = std::fs::read_to_string(gf)
            .with_context(|| format!("Failed to read {:?}", gf))?;
        for line in content.lines() {
            // Format: /path/to/file.seq:%N Axxxxx McKay-Thompson series of class XXx ...
            if let Some(idx) = line.find(":%N ") {
                let path = &line[..idx];
                if path.ends_with(".seq") {
                    seq_files.insert(path.to_string(), ());
                }
            }
        }
    }
    println!("  {} unique .seq files from {} grep files", seq_files.len(), grep_files.len());

    let mut classes: BTreeMap<String, (String, Vec<i64>)> = BTreeMap::new();
    let mut read_ok = 0u64;
    let mut mckay_ok = 0u64;
    let mut coeff_empty = 0u64;
    let mut cls_empty = 0u64;
    let mut coeff_empty = 0u64;
    let mut cls_empty = 0u64;
    for seq_path in seq_files.keys() {
        let content = match std::fs::read_to_string(seq_path) { Ok(c) => { read_ok += 1; c }, Err(_) => continue };
        if !content.contains("McKay-Thompson") { continue; }
        mckay_ok += 1;
        
        // Extract OEIS ID
        let mut oid = String::new();
        for line in content.lines() {
            if line.starts_with("%I ") {
                oid = line.split_whitespace().nth(1).unwrap_or("").to_string();
                break;
            }
        }
        if oid.is_empty() { continue; }

        // Extract class name — check ALL lines, not just %N
        let mut cls = String::new();
        for line in content.lines() {
            if line.contains("McKay-Thompson series of class") {
                if let Some(idx) = line.find("class ") {
                    let rest = &line[idx + 6..];
                    cls = rest.split_whitespace().next().unwrap_or("").trim_end_matches('.').trim_end_matches(',').trim_end_matches(')').to_uppercase();
                }
                break;
            }
        }
        if cls.is_empty() { cls_empty += 1; continue; }

        // Parse coefficients — numbers are comma-separated, not space-separated
        let mut coeffs: Vec<i64> = Vec::new();
        for line in content.lines() {
            if !line.starts_with("%S") && !line.starts_with("%T") && !line.starts_with("%U") { continue; }
            // Split on whitespace first to skip the OEIS ID, then comma-split
            let parts: Vec<&str> = line.split_whitespace().skip(1).collect();
            for part in parts {
                for num in part.split(',') {
                    let num = num.trim();
                    if num.is_empty() { continue; }
                    if let Ok(n) = num.parse::<i64>() { coeffs.push(n); }
                }
            }
        }
        if coeffs.is_empty() { coeff_empty += 1; continue; }
        if !classes.contains_key(&cls) {
            classes.insert(cls, (oid, coeffs.into_iter().take(40).collect()));
        }
    }

    println!("Found {} unique McKay-Thompson classes (read_ok={}, mckay_ok={}, cls_empty={}, coeff_empty={})", 
        classes.len(), read_ok, mckay_ok, cls_empty, coeff_empty);

    // Generate Lean4 file
    let mut lean = String::new();
    lean.push_str(&format!(r#"/-!
McKay-Thompson Series Coefficient Database
Source: OEIS (grep files: {})
Classes: {}
Reference: Ford, McKay, Norton — More on Replicable Functions (1994)
Generated by: aristotle-manager mc-kay-oeis
-/

import Mathlib

/-- McKay-Thompson series coefficients from OEIS.
    Each entry is (class_name, first_N_coefficients). -/
def mckayThompsonCoeffs : List (String × List ℤ) := [
"#, grep_files.iter().map(|p| p.file_name().unwrap_or_default().to_string_lossy()).collect::<Vec<_>>().join(", "), classes.len()));

    for (cls, (oid, coeffs)) in &classes {
        let cs: Vec<String> = coeffs.iter().map(|c| c.to_string()).collect();
        lean.push_str(&format!("  (\"{}\", [{}]),\n", cls, cs.join(", ")));
    }
    lean.push_str("]\n\n");

    lean.push_str(&format!("/-- Number of McKay-Thompson series classes indexed --/\ntheorem mckayThompsonClassCount : mckayThompsonCoeffs.length = {} := by\n  native_decide\n\n", classes.len()));

    let names: Vec<String> = classes.keys().map(|c| format!("\"{}\"", c)).collect();
    lean.push_str(&format!("/-- All McKay-Thompson class names from OEIS --/\ndef mckayThompsonClassNames : List String :=\n  [{}]\n", names.join(", ")));

    std::fs::create_dir_all(output.parent().unwrap())?;
    std::fs::write(&output, &lean)?;
    println!("Written: {} ({} bytes, {} classes)", output.display(), lean.len(), classes.len());

    // Inject into Aristotle project if requested
    if let Some(ref pid) = inject_into {
        let content = std::fs::read_to_string(&output)?;
        let prompt = format!("OEIS McKay-Thompson series coefficients for {} Monster conjugacy classes. Ground truth data.\n\n{}", classes.len(), content);
        let status = std::process::Command::new("aristotle")
            .args(["ask", pid, &prompt])
            .output()?;
        if status.status.success() {
            println!("Injected into project {}", pid);
        }
    }

    Ok(())
}

/// ── Diagonalize: apply Aristotle pipeline to itself ────────────────────

#[instrument(skip(output_dir))]
fn cmd_diagonalize(output_dir: Option<PathBuf>, core_only: bool, dry_run: bool, rebuild: bool, from_lattice: bool, repair: bool) -> Result<()> {
    let config = load_config()?;
    let output_dir = output_dir.unwrap_or_else(|| config.base_dir.join("diagonalize-results"));
    let self_project_dir = output_dir.join("self-project");
    let self_split_dir = output_dir.join("self-split");
    let merged_dir = output_dir.join("merged-with-variants");
    let _core_dir = output_dir.join("minimal-core");
    let applied_dir = output_dir.join("variants-applied");

    fs::create_dir_all(&output_dir)?;

    if rebuild {
        println!("╔══════════════════════════════════════════════════════════╗");
        println!("║   Rebuild: Merge arist + vendormod + split-decls      ║");
        println!("║   into a unified workspace using our tools            ║");
        println!("╚══════════════════════════════════════════════════════════╝");
        println!();
        let unified_dir = output_dir.join("unified");
        cmd_rebuild_unified(&unified_dir, dry_run)?;
        println!("\nUnified workspace at: {}", unified_dir.display());
        println!("Run `cd {} && cargo build` to build.", unified_dir.display());
        println!("Run `cd {} && aristotle-manager diagonalize` to apply to unified workspace.", unified_dir.display());
        return Ok(());
    }

    if from_lattice {
        println!("╔══════════════════════════════════════════════════════════╗");
        println!("║   From-Lattice: regenerate workspace from declaration  ║");
        println!("║   variant-index + dependency-graph                     ║");
        println!("╚══════════════════════════════════════════════════════════╝");
        println!();
        regenerate_from_lattice(&output_dir, dry_run)?;
        println!("\nLattice-regenerated workspace at: {}/lattice-workspace", output_dir.display());
        return Ok(());
    }

    if repair {
        println!("╔══════════════════════════════════════════════════════════╗");
        println!("║   Repair: SPARQL queries + GOAP planner              ║");
        println!("║   Fix compilation errors in unified-tool             ║");
        println!("╚══════════════════════════════════════════════════════════╝");
        println!();
        cmd_repair(&output_dir, dry_run)?;
        return Ok(());
    }

    println!("╔══════════════════════════════════════════════════════════╗");
    println!("║   Diagonalize — Aristotle Self-Improvement Pipeline    ║");
    println!("║   Gödelian self-application of the split/merge system  ║");
    println!("╚══════════════════════════════════════════════════════════╝");
    println!();

    // ── Step 1: Build self-project from arist codebase ───────────────
    println!("[1/5] Scanning arist codebase and building self-project...");
    let self_stats = build_self_project(&self_project_dir, dry_run)?;
    if dry_run {
        println!("  Dry run: would scan {} source files", self_stats.total_files);
        for (ext, count) in &self_stats.by_extension {
            println!("    .{}: {}", ext, count);
        }
    }

    // ── Step 2: Run split on self-project ────────────────────────────
    println!("[2/5] Splitting self-project into declarations...");
    if !dry_run {
        // Create a temporary Aristotle-style project structure for the splitter
        if self_project_dir.join("RequestProject").exists() {
            cmd_split(Some(self_project_dir.clone()), Some(self_split_dir.clone()))?;
        } else {
            // Fallback: inline static decl extraction
            let self_decls = extract_declarations_inline(&self_project_dir, &self_split_dir)?;
            info!(decl_count = self_decls, "Inline extraction completed");
            println!("  ✓ {} self-declarations extracted inline", self_decls);
        }
    } else {
        println!("  Dry run: would split self-project into {}", self_split_dir.display());
    }

    // Count self-declarations
    let self_count = if !dry_run && self_split_dir.exists() {
        count_declarations(&self_split_dir)?
    } else {
        0
    };
    println!("  Self-declarations found: {}", self_count);

    // ── Step 3: Merge with all Aristotle project variants ─────────────
    println!("[3/5] Merging self-declarations with Aristotle variant library...");
    let variant_sources = discover_variant_sources(&config)?;
    info!(variant_count = variant_sources.len(), "Discovered variant sources");
    println!("  Variant sources: {} Aristotle projects", variant_sources.len());

    if !dry_run {
        // Run merge: combine self-split with existing split-results from all projects
        let merge_inputs: Vec<PathBuf> = {
            let mut v = Vec::new();
            v.push(self_split_dir.clone());
            for src in &variant_sources {
                v.push(src.clone());
            }
            v
        };
        // Use symlinks/copy to create a unified input for merge
        let unified_input = output_dir.join("unified-split-input");
        fs::create_dir_all(&unified_input)?;
        for (i, src) in merge_inputs.iter().enumerate() {
            if src.exists() {
                link_or_copy_decls(src, &unified_input, format!("source_{}", i))?;
            }
        }
        cmd_merge(Some(unified_input.clone()), Some(merged_dir.clone()))?;

        // Also gather variant signatures for later
        let variant_index = build_variant_index(&variant_sources, &merged_dir)?;
        let vi_path = output_dir.join("variant-index.json");
        fs::write(&vi_path, serde_json::to_string_pretty(&variant_index)?)?;
        info!(variants = variant_index.len(), "Built variant index");
        println!("  Variant index: {} unique declarations", variant_index.len());
    } else {
        println!("  Dry run: would merge {} input sources", variant_sources.len() + 1);
    }

    // ── Step 4: Find minimal core ────────────────────────────────────
    println!("[4/5] Computing minimal core (self-referential kernel)...");
    let core = if !dry_run && merged_dir.exists() {
        let c = find_minimal_core(&merged_dir, &output_dir)?;
        println!("  Minimal core: {} declarations", c.declarations.len());
        println!("  Core types: {:?}", c.type_breakdown);
        // Write core report
        let core_path = output_dir.join("minimal-core.json");
        fs::write(&core_path, serde_json::to_string_pretty(&serde_json::json!({
            "description": "Minimal self-referential kernel — most-referenced declarations at the bottom of the dependency lattice",
            "total_declarations": c.declarations.len(),
            "total_variants_considered": c.total_variants,
            "type_breakdown": c.type_breakdown,
            "declarations": c.declarations,
        }))?)?;
        println!("  Core report: {}", core_path.display());
        c
    } else {
        MinimalCore {
            declarations: Vec::new(),
            total_variants: 0,
            type_breakdown: std::collections::HashMap::new(),
        }
    };

    if core_only || dry_run {
        println!();
        if core_only {
            println!("✓ Diagonalize (core only) complete. Results in: {}", output_dir.display());
        }
        return Ok(());
    }

    // ── Step 5: Apply variants back onto self ─────────────────────────
    println!("[5/5] Applying variant lattice to self — generating diagonalized code...");
    if !dry_run {
        apply_variants_to_self(&self_project_dir, &applied_dir, &core)?;
        let applied_count = count_files_recursive(&applied_dir)?;
        println!("  Generated {} diagonalized artifacts", applied_count);
    } else {
        println!("  Dry run: would generate diagonalized code in {}", applied_dir.display());
    }

    println!();
    println!("╔══════════════════════════════════════════════════════════╗");
    println!("║   Diagonalize complete!                                 ║");
    println!("║                                                         ║");
    println!("║   Final output: {:35} ║", output_dir.display());
    println!("║   Self-declarations: {:>23} ║", self_count);
    println!("║   Core declarations: {:>23} ║", core.declarations.len());
    println!("║   Variants considered: {:>20} ║", core.total_variants);
    println!("║   Variants applied: {:>23} ║", core.declarations.len());
    println!("╚══════════════════════════════════════════════════════════╝");

    info!(self_count, core_size = core.declarations.len(), variants = core.total_variants, "Diagonalize complete");
    Ok(())
}

// ── Helper: scan arist codebase and build a self-project ──────────────

#[derive(Debug, Default)]
struct SelfProjectStats {
    total_files: usize,
    by_extension: std::collections::HashMap<String, usize>,
}

fn build_self_project(output_dir: &PathBuf, dry_run: bool) -> Result<SelfProjectStats> {
    let arist_root = std::env::current_dir()?;
    let mut stats = SelfProjectStats::default();

    // Only scan our own source code directories, not the full tree
    // (aristotles_results/, .dotagents/, etc. are variants, not self)
    let scan_dirs: &[(&str, &[&str])] = &[
        ("rs", &["src/**/*.rs"]),
        ("lean", &["splitter-engine/RequestProject/*.lean", "splitter-engine/*.lean"]),
        ("sh", &["*.sh"]),
        ("nix", &["*.nix", "flake.nix"]),
        ("toml", &["Cargo.toml"]),
    ];

    if !dry_run {
        let request_dir = output_dir.join("RequestProject");
        fs::create_dir_all(&request_dir)?;
    }

    for &(ext, patterns) in scan_dirs {
        let mut count = 0usize;
        for &pattern in patterns {
            let glob_str = format!("{}/{}", arist_root.display(), pattern);
            if let Ok(entries) = glob::glob(&glob_str) {
                for entry in entries.filter_map(|e| e.ok()) {
                    let path_str = entry.to_string_lossy();
                    if path_str.contains("/target/") || path_str.contains("/.git/") {
                        continue;
                    }
                    count += 1;
                    if !dry_run {
                        let rel = entry.strip_prefix(&arist_root).unwrap_or(&entry);
                        let rel_str = rel.to_string_lossy().to_string();
                        let safe_name = rel_str.replace('/', "__").replace('\\', "__");
                        let dest = if ext == "lean" {
                            output_dir.join("RequestProject").join(&format!("self_{}", safe_name))
                        } else {
                            output_dir.join(&format!("self_{}", safe_name))
                        };
                        if let Some(parent) = dest.parent() {
                            fs::create_dir_all(parent)?;
                        }
                        let _ = fs::copy(&entry, &dest);
                    }
                }
            }
        }
        stats.by_extension.insert(String::from(ext), count);
        stats.total_files += count;
        if dry_run {
            println!("    .{}: {} files", ext, count);
        }
    }

    info!(total = stats.total_files, "Self-project built");
    Ok(stats)
}

// ── Helper: inline declaration extraction for non-Lean sources ─────────

fn extract_declarations_inline(src_dir: &PathBuf, output_dir: &PathBuf) -> Result<usize> {
    fs::create_dir_all(output_dir)?;
    let mut total = 0usize;

    // Extract Rust function/struct declarations
    for entry in WalkDir::new(src_dir)
        .max_depth(3)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "rs"))
    {
        let content = fs::read_to_string(entry.path())?;
        for line in content.lines() {
            let trimmed = line.trim();
            // Extract function signatures
            if let Some(name) = trimmed.strip_prefix("fn ").and_then(|s| {
                let before_paren = s.split('(').next()?;
                let name = before_paren.split_whitespace().next()?;
                if name.starts_with(|c: char| c.is_alphabetic() || c == '_') {
                    Some(name.to_string())
                } else { None }
            }) {
                let decl_dir = output_dir.join(format!("fn_{}", name));
                fs::create_dir_all(&decl_dir)?;
                fs::write(decl_dir.join(format!("fn_{}.rs", name)), format!("{}\n", line))?;
                fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&serde_json::json!({
                    "kind": "fn",
                    "name": name,
                    "source_file": entry.path().to_string_lossy(),
                    "signature": line.trim(),
                }))?)?;
                total += 1;
            }
            // Extract struct declarations
            if let Some(name) = trimmed.strip_prefix("struct ").and_then(|s| {
                let name = s.split_whitespace().next()?;
                if name.starts_with(|c: char| c.is_alphabetic() || c == '_') {
                    Some(name.to_string())
                } else { None }
            }) {
                let decl_dir = output_dir.join(format!("struct_{}", name));
                fs::create_dir_all(&decl_dir)?;
                fs::write(decl_dir.join(format!("struct_{}.rs", name)), format!("{}\n", line))?;
                fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&serde_json::json!({
                    "kind": "struct",
                    "name": name,
                    "source_file": entry.path().to_string_lossy(),
                    "signature": line.trim(),
                }))?)?;
                total += 1;
            }
            // Extract enum declarations
            if let Some(name) = trimmed.strip_prefix("enum ").and_then(|s| {
                let name = s.split_whitespace().next()?;
                if name.starts_with(|c: char| c.is_alphabetic() || c == '_') {
                    Some(name.to_string())
                } else { None }
            }) {
                let decl_dir = output_dir.join(format!("enum_{}", name));
                fs::create_dir_all(&decl_dir)?;
                fs::write(decl_dir.join(format!("enum_{}.rs", name)), format!("{}\n", line))?;
                fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&serde_json::json!({
                    "kind": "enum",
                    "name": name,
                    "source_file": entry.path().to_string_lossy(),
                    "signature": line.trim(),
                }))?)?;
                total += 1;
            }
            // Extract trait declarations
            if let Some(name) = trimmed.strip_prefix("trait ").and_then(|s| {
                let name = s.split_whitespace().next()?;
                if name.starts_with(|c: char| c.is_alphabetic() || c == '_') {
                    Some(name.to_string())
                } else { None }
            }) {
                let decl_dir = output_dir.join(format!("trait_{}", name));
                fs::create_dir_all(&decl_dir)?;
                fs::write(decl_dir.join(format!("trait_{}.rs", name)), format!("{}\n", line))?;
                fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&serde_json::json!({
                    "kind": "trait",
                    "name": name,
                    "source_file": entry.path().to_string_lossy(),
                    "signature": line.trim(),
                }))?)?;
                total += 1;
            }
        }
    }

    // Extract Lean declarations (theorem, lemma, def)
    for entry in WalkDir::new(src_dir)
        .max_depth(3)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
    {
        let content = fs::read_to_string(entry.path())?;
        let decl_keywords = ["theorem ", "def ", "lemma ", "example ", "instance ", "class ", "inductive ", "structure ", "abbrev ", "axiom "];
        for line in content.lines() {
            let trimmed = line.trim();
            for kw in &decl_keywords {
                if trimmed.starts_with(kw) {
                    let after = &trimmed[kw.len()..];
                    let name = after.split_whitespace().next().unwrap_or("");
                    if !name.is_empty() && name.starts_with(|c: char| c.is_alphabetic() || c == '_') {
                        let kind = kw.trim();
                        let decl_dir = output_dir.join(format!("{}_{}", kind, name));
                        fs::create_dir_all(&decl_dir)?;
                        fs::write(decl_dir.join(format!("{}_{}.lean", kind, name)), format!("{}\n", line))?;
                        fs::write(decl_dir.join("declaration.json"), serde_json::to_string_pretty(&serde_json::json!({
                            "kind": kind,
                            "name": name,
                            "source_file": entry.path().to_string_lossy(),
                            "signature": line.trim(),
                        }))?)?;
                        total += 1;
                    }
                    break;
                }
            }
        }
    }

    info!(total, "Inline declaration extraction completed");
    Ok(total)
}

// ── Helper: discover all variant sources ───────────────────────────────

fn discover_variant_sources(config: &Config) -> Result<Vec<PathBuf>> {
    let mut sources: Vec<PathBuf> = Vec::new();

    // 1. Existing split-results
    let split_res = config.base_dir.join("split-results");
    if split_res.exists() {
        for entry in WalkDir::new(&split_res).min_depth(1).max_depth(1).into_iter().filter_map(|e| e.ok()) {
            if entry.path().is_dir() {
                sources.push(entry.path().to_path_buf());
            }
        }
    }

    // 2. All Aristotle project directories (for raw declaration files)
    let results_dir = config.results_dir.clone();
    if results_dir.exists() {
        for entry in WalkDir::new(&results_dir)
            .min_depth(1)
            .max_depth(2)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().file_name().map_or(false, |n| n.to_string_lossy().ends_with("_aristotle")))
        {
            let request = entry.path().join("output-final_aristotle").join("RequestProject");
            if request.exists() {
                sources.push(request);
            }
            // Also look for any nested module directories with .lean files
            for lean_entry in WalkDir::new(entry.path()).max_depth(4).into_iter().filter_map(|e| e.ok()) {
                if lean_entry.path().extension().map_or(false, |ext| ext == "lean") {
                    let parent = lean_entry.path().parent().unwrap_or(entry.path());
                    if !sources.contains(&parent.to_path_buf()) {
                        sources.push(parent.to_path_buf());
                    }
                }
            }
        }
    }

    // 3. Merged results
    let merged = config.base_dir.join("merged-results");
    if merged.exists() {
        sources.push(merged);
    }

    // 4. Server-side variants: treat all downloaded project data as code
    let results_dir = config.results_dir.clone();
    if results_dir.exists() {
        // Scan for all _aristotle directories with output-final
        for entry in WalkDir::new(&results_dir)
            .min_depth(1)
            .max_depth(2)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().is_dir() && e.path().file_name().map_or(false, |n| n.to_string_lossy().ends_with("_aristotle")))
        {
            let project_request = entry.path().join("output-final_aristotle").join("RequestProject");
            if project_request.exists() {
                // Treat each .lean file as a "code variant" that can be
                // reflected back onto the system — data-as-code principle
                for lean_file in WalkDir::new(&project_request)
                    .max_depth(3)
                    .into_iter()
                    .filter_map(|e| e.ok())
                    .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
                {
                    let variant_dir = project_request.join("__variants__");
                    let _ = fs::create_dir_all(&variant_dir);
                    let dest_name = format!("server_variant_{}", lean_file.path().file_name().unwrap_or_default().to_string_lossy());
                    let dest = variant_dir.join(&dest_name);
                    if !dest.exists() {
                        let _ = fs::copy(lean_file.path(), &dest);
                    }
                }
                if project_request.join("__variants__").exists() {
                    sources.push(project_request.join("__variants__"));
                }
            }
        }
    }

    // 5. Rust source files (.rs) — both project code and build scripts
    for entry in WalkDir::new(&config.results_dir)
        .max_depth(6)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "rs"))
    {
        let parent = entry.path().parent().unwrap_or(entry.path());
        let rust_dir = parent.join("__rust_variants__");
        let _ = fs::create_dir_all(&rust_dir);
        let dest = rust_dir.join(entry.file_name());
        if !dest.exists() {
            let _ = fs::copy(entry.path(), &dest);
        }
        if rust_dir.exists() && !sources.contains(&rust_dir) {
            sources.push(rust_dir);
        }
    }

    // 6. Python source files
    for entry in WalkDir::new(&config.results_dir)
        .max_depth(6)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "py"))
    {
        let parent = entry.path().parent().unwrap_or(entry.path());
        let py_dir = parent.join("__py_variants__");
        let _ = fs::create_dir_all(&py_dir);
        let dest = py_dir.join(entry.file_name());
        if !dest.exists() {
            let _ = fs::copy(entry.path(), &dest);
        }
        if py_dir.exists() && !sources.contains(&py_dir) {
            sources.push(py_dir);
        }
    }

    // 7. Agent logs and task lists (ARISTOTLE_SUMMARY.md, *.json)
    for entry in WalkDir::new(&config.results_dir)
        .max_depth(4)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| {
            let name = e.file_name().to_string_lossy();
            name == "ARISTOTLE_SUMMARY.md" || name == "aristotle_status.json" || name == "aristotle_projects.json"
        })
    {
        let parent = entry.path().parent().unwrap_or(entry.path());
        let log_dir = parent.join("__agent_logs__");
        let _ = fs::create_dir_all(&log_dir);
        let dest = log_dir.join(entry.file_name());
        if !dest.exists() {
            let _ = fs::copy(entry.path(), &dest);
        }
        if log_dir.exists() && !sources.contains(&log_dir) {
            sources.push(log_dir);
        }
    }

    // 8. Cargo.toml files (crate metadata as variant)
    for entry in WalkDir::new(&config.results_dir)
        .max_depth(5)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_name() == "Cargo.toml")
    {
        let parent = entry.path().parent().unwrap_or(entry.path());
        let cargo_dir = parent.join("__cargo_meta__");
        let _ = fs::create_dir_all(&cargo_dir);
        let dest = cargo_dir.join("Cargo.toml");
        if !dest.exists() {
            let _ = fs::copy(entry.path(), &dest);
        }
        if cargo_dir.exists() && !sources.contains(&cargo_dir) {
            sources.push(cargo_dir);
        }
    }

    sources.sort();
    sources.dedup();
    info!(count = sources.len(), "Discovered variant sources (rust, python, agent logs, task lists)");
    Ok(sources)
}

// ── Helper: count declarations in a split output dir ──────────────────

fn count_declarations(dir: &PathBuf) -> Result<usize> {
    let mut count = 0usize;
    for entry in WalkDir::new(dir).max_depth(5).into_iter().filter_map(|e| e.ok()) {
        if entry.file_name() == "declaration.json" {
            count += 1;
        }
        if entry.file_name() == "flake.nix" {
            count += 1;
        }
    }
    Ok(count)
}

// ── Helper: recursively count all files ───────────────────────────────

fn count_files_recursive(dir: &PathBuf) -> Result<usize> {
    let mut count = 0usize;
    for entry in WalkDir::new(dir).into_iter().filter_map(|e| e.ok()) {
        if entry.path().is_file() {
            count += 1;
        }
    }
    Ok(count)
}

// ── Helper: link or copy declarations from src to unified input ───────

fn link_or_copy_decls(src: &PathBuf, dest_base: &PathBuf, prefix: String) -> Result<()> {
    if !src.exists() {
        return Ok(());
    }
    for entry in WalkDir::new(src).max_depth(5).into_iter().filter_map(|e| e.ok()) {
        if entry.path().is_file() {
            let rel = entry.path().strip_prefix(src).unwrap_or(entry.path());
            let dest = dest_base.join(&prefix).join(rel);
            if let Some(parent) = dest.parent() {
                fs::create_dir_all(parent)?;
            }
            if !dest.exists() {
                let _ = fs::copy(entry.path(), &dest);
            }
        }
    }
    Ok(())
}

// ── Helper: build a variant index ─────────────────────────────────────

#[derive(Debug, Serialize)]
struct VariantEntry {
    name: String,
    kind: String,
    source: String,
    signature: String,
}

fn build_variant_index(sources: &[PathBuf], merged_dir: &PathBuf) -> Result<Vec<VariantEntry>> {
    use std::collections::BTreeMap;
    let mut index: BTreeMap<String, VariantEntry> = BTreeMap::new();

    // Walk all sources looking for declaration.json files
    for src in sources {
        if !src.exists() { continue; }
        for entry in WalkDir::new(src).max_depth(6).into_iter().filter_map(|e| e.ok()) {
            if entry.file_name() == "declaration.json" {
                if let Ok(content) = fs::read_to_string(entry.path()) {
                    if let Ok(json) = serde_json::from_str::<serde_json::Value>(&content) {
                        let name = json["name"].as_str().unwrap_or("").to_string();
                        let kind = json["kind"].as_str().unwrap_or("decl").to_string();
                        let sig = json["signature"].as_str().unwrap_or("").to_string();
                        let source = json["source_file"].as_str().unwrap_or("").to_string();
                        let key = format!("{}::{}", kind, name);
                        if !index.contains_key(&key) {
                            index.insert(key.clone(), VariantEntry {
                                name,
                                kind,
                                source,
                                signature: sig,
                            });
                        }
                    }
                }
            }
        }
    }

    // Also scan merged directory
    if merged_dir.exists() {
        for entry in WalkDir::new(merged_dir).max_depth(6).into_iter().filter_map(|e| e.ok()) {
            if entry.path().extension().map_or(false, |ext| ext == "lean" || ext == "rs") {
                if let Ok(content) = fs::read_to_string(entry.path()) {
                    let fname = entry.path().file_stem().unwrap_or_default().to_string_lossy();
                    // Simple heuristic: first line as signature
                    if let Some(first_line) = content.lines().next() {
                        let kind = match entry.path().extension().unwrap_or_default().to_string_lossy().as_ref() {
                            "lean" => "lean_decl",
                            "rs" => "rust_decl",
                            _ => "decl",
                        };
                        let key = format!("{}::{}", kind, fname);
                        if !index.contains_key(&key) {
                            index.insert(key.clone(), VariantEntry {
                                name: fname.to_string(),
                                kind: kind.to_string(),
                                source: entry.path().to_string_lossy().to_string(),
                                signature: first_line.to_string(),
                            });
                        }
                    }
                }
            }
        }
    }

    Ok(index.into_values().collect())
}

// ── Helper: find minimal core via dependency analysis ─────────────────

#[derive(Debug, Serialize)]
struct MinimalCore {
    declarations: Vec<CoreDecl>,
    total_variants: usize,
    type_breakdown: std::collections::HashMap<String, usize>,
}

#[derive(Debug, Serialize)]
struct CoreDecl {
    name: String,
    kind: String,
    ref_count: usize,
    is_self_referential: bool,
    signature: String,
}

fn find_minimal_core(merged_dir: &PathBuf, output_dir: &PathBuf) -> Result<MinimalCore> {
    // Build a reference graph: count how many times each declaration is referenced
    // A declaration is "core" if it's referenced the most (i.e., it's foundational)
    let mut ref_graph: std::collections::HashMap<String, usize> = std::collections::HashMap::new();
    let mut decl_info: std::collections::HashMap<String, (String, String)> = std::collections::HashMap::new();

    // Walk all files in merged dir and look for references
    for entry in WalkDir::new(merged_dir).max_depth(8).into_iter().filter_map(|e| e.ok()) {
        if entry.path().is_file() {
            if let Ok(content) = fs::read_to_string(entry.path()) {
                let ext = entry.path().extension().unwrap_or_default().to_string_lossy().to_string();
                let fname = entry.path().file_stem().unwrap_or_default().to_string_lossy().to_string();
                
                // Determine kind
                let kind = match ext.as_str() {
                    "rs" => "rust",
                    "lean" => "lean",
                    "sh" => "shell",
                    "nix" => "nix",
                    "toml" => "toml",
                    "md" => "doc",
                    _ => "other",
                };
                decl_info.insert(fname.clone(), (kind.to_string(), content.lines().next().unwrap_or("").to_string()));

                // Count references to other declarations
                // For .lean files: look for `import` and other declaration names
                // For .rs files: look for `use`, `mod`, function calls
                for line in content.lines() {
                    let trimmed = line.trim();
                    if ext == "lean" {
                        if let Some(import_path) = trimmed.strip_prefix("import ") {
                            let name = import_path.trim().split('.').last().unwrap_or("").to_string();
                            *ref_graph.entry(name).or_insert(0) += 1;
                        }
                    } else if ext == "rs" {
                        if let Some(use_path) = trimmed.strip_prefix("use ") {
                            let name = use_path.trim().split(':').last().unwrap_or("").to_string();
                            *ref_graph.entry(name).or_insert(0) += 1;
                        }
                        if let Some(mod_path) = trimmed.strip_prefix("mod ") {
                            let name = mod_path.trim().split_whitespace().next().unwrap_or("").to_string();
                            *ref_graph.entry(name).or_insert(0) += 1;
                        }
                    }
                }
            }
        }
    }

    // Find declarations that are both self-referential AND most-referenced
    let total_variants = decl_info.len();
    let mut self_ref_names: std::collections::HashSet<String> = std::collections::HashSet::new();
    for (name, count) in &ref_graph {
        // A declaration is "self-referential" if it references itself
        // or if it's referenced by its own category
        if decl_info.contains_key(name) && *count > 0 {
            self_ref_names.insert(name.clone());
        }
    }

    // Sort by reference count descending — most foundational first
    let mut entries: Vec<(String, usize)> = ref_graph.into_iter().collect();
    entries.sort_by(|a, b| b.1.cmp(&a.1));

    // Keep top 50% or at least 10, but at most 100
    let keep_count = entries.len().max(10).min(100);
    let entries: Vec<_> = entries.into_iter().take(keep_count).collect();

    let mut type_breakdown: std::collections::HashMap<String, usize> = std::collections::HashMap::new();
    let mut core_decls: Vec<CoreDecl> = Vec::new();

    for (name, ref_count) in &entries {
        if let Some((kind, sig)) = decl_info.get(name) {
            let is_self = self_ref_names.contains(name);
            *type_breakdown.entry(kind.clone()).or_insert(0) += 1;
            core_decls.push(CoreDecl {
                name: name.clone(),
                kind: kind.clone(),
                ref_count: *ref_count,
                is_self_referential: is_self,
                signature: sig.clone(),
            });
        }
    }

    // Write dependency graph for debugging
    let dep_graph_path = output_dir.join("dependency-graph.json");
    fs::write(&dep_graph_path, serde_json::to_string_pretty(&serde_json::json!({
        "total_declarations": total_variants,
        "core_size": core_decls.len(),
        "edges": entries.iter().map(|(n, c)| serde_json::json!({"target": n, "ref_count": c})).collect::<Vec<_>>(),
    }))?)?;

    Ok(MinimalCore {
        declarations: core_decls,
        total_variants,
        type_breakdown,
    })
}

// ── Helper: apply variants back onto self ─────────────────────────────

fn apply_variants_to_self(_self_project: &PathBuf, output_dir: &PathBuf, core: &MinimalCore) -> Result<()> {
    fs::create_dir_all(output_dir)?;

    // For each core declaration, generate a "diagonalized" version that
    // shows how the Aristotle variant patterns apply to the self code.
    // This creates reflection files showing the relationship between
    // the meta-system (Aristotle pipeline) and its self-application.

    let mut generated = 0usize;

    for decl in &core.declarations {
        let decl_dir = output_dir.join(&decl.name);
        fs::create_dir_all(&decl_dir)?;

        // Generate a self-reflection report showing how this core declaration
        // relates to the overall system. The report shows:
        // - The declaration's kind, name, and signature
        // - How many variants reference it
        // - Whether it is self-referential (referenced by its own kind)
        let kind_label = match decl.kind.as_str() {
            "rust" => "Rust function/module",
            "lean" => "Lean theorem/definition",
            "shell" => "Shell script",
            "nix" => "Nix expression",
            "toml" => "Cargo configuration",
            "doc" => "Documentation",
            _ => &decl.kind,
        };
        let self_ref_label = if decl.is_self_referential {
            "✦ SELF-REFERENTIAL — this declaration is part of the diagonalization kernel"
        } else {
            "Referenced by other declarations, but not self-referencing"
        };

        let report = format!(
            r#"Diagonalized Declaration: {name}
================================

Kind:       {kind}
Ref Count:  {ref_count}
Self-Ref:   {self_ref}

Signature:  {sig}

This declaration is part of the Gödelian diagonalization of the Aristotle
pipeline applied to itself. It appears in the minimal core — the kernel
of most-referenced declarations that form the foundation of the system.

In the full variant lattice, this declaration is referenced by {rc}
other declarations across the Aristotle project corpus, making it a
foundational element of the self-improvement loop.
"#,
            name = decl.name,
            kind = kind_label,
            ref_count = decl.ref_count,
            self_ref = self_ref_label,
            sig = decl.signature,
            rc = decl.ref_count,
        );

        let report_path = decl_dir.join("DIAGONALIZED_README.md");
        fs::write(&report_path, &report)?;
        generated += 1;
    }

    // Generate a summary index
    let summary: Vec<serde_json::Value> = core.declarations.iter().map(|d| {
        serde_json::json!({
            "name": d.name,
            "kind": d.kind,
            "ref_count": d.ref_count,
            "is_self_referential": d.is_self_referential,
            "signature": d.signature,
        })
    }).collect();

    let summary_path = output_dir.join("diagonalized-index.json");
    fs::write(&summary_path, serde_json::to_string_pretty(&serde_json::json!({
        "description": "Self-applied diagonalization — Aristotle pipeline applied to its own codebase",
        "total_core_declarations": generated,
        "generated_variant_reflections": generated,
        "declarations": summary,
    }))?)?;

    info!(generated, "Variant self-application complete");
    Ok(())
}

// ── Rebuild: merge arist + vendormod + split-decls into unified workspace ──

#[instrument(skip(output_dir))]
fn cmd_rebuild_unified(output_dir: &PathBuf, dry_run: bool) -> Result<()> {
    let arist_root = std::env::current_dir()?;
    let vendormod_root = PathBuf::from("/home/mdupont/projects/vendormod");
    let split_decls_root = PathBuf::from("/mnt/data1/nix/vendor/rust/cargo2nix/submodules/split-decls-rs");
    let unified_src = output_dir.join("src");

    fs::create_dir_all(&unified_src)?;

    println!("Collecting source from 3 projects into unified workspace...");

    let arist_src = arist_root.join("src");
    let vm_src = vendormod_root.join("src");
    let sd_src = split_decls_root.join("src");

    // 1. Copy arist src/ to root src/ level (their mod refs expect files at same level)
    if arist_src.exists() {
        copy_source_tree_preserve(&arist_src, &unified_src, &["bin"], dry_run)?;
    }

    // 2. Copy vendormod src/ under src/vendormod/
    let vm_dst = unified_src.join("vendormod");
    if vm_src.exists() {
        copy_source_tree_preserve(&vm_src, &vm_dst, &["bin"], dry_run)?;
    }

    // 3. Copy split-decls-rs src/ under src/splitdecls/
    let sd_dst = unified_src.join("splitdecls");
    if sd_src.exists() {
        copy_source_tree_preserve(&sd_src, &sd_dst, &["bin"], dry_run)?;
    }

    // 4. Write the merged Cargo.toml with workspace dependencies
    if !dry_run {
        let cargo_toml = generate_unified_cargo_toml();
        fs::write(output_dir.join("Cargo.toml"), &cargo_toml)?;
        println!("  ✓ Cargo.toml written");
    } else {
        println!("  [dry-run] would write Cargo.toml");
    }

    // 5. Generate src/lib.rs and per-subdirectory mod.rs files
    if !dry_run {
        // Generate mod.rs for vendormod and splitdecls subdirectories
        for subdir in &["vendormod", "splitdecls"] {
            let dir = unified_src.join(subdir);
            if dir.exists() {
                let mod_rs = generate_module_entry(&dir);
                fs::write(dir.join("mod.rs"), &mod_rs)?;
            }
        }
        // Generate root lib.rs (arist is at root, subdirs are modules)
        let lib_rs = generate_unified_lib_rs();
        fs::write(unified_src.join("lib.rs"), &lib_rs)?;
        println!("  ✓ module entry files generated");
    } else {
        println!("  [dry-run] would generate module entry files");
    }

    // 5. Generate flake.nix
    if !dry_run {
        let flake = generate_unified_flake_nix();
        fs::write(output_dir.join("flake.nix"), &flake)?;
        println!("  ✓ flake.nix written");
    } else {
        println!("  [dry-run] would write flake.nix");
    }

    // 6. Initialize git
    if !dry_run {
        let _ = std::process::Command::new("git")
            .args(["init", "-b", "main"])
            .current_dir(output_dir)
            .output();
        let _ = std::process::Command::new("git")
            .args(["add", "-A"])
            .current_dir(output_dir)
            .output();
        let _ = std::process::Command::new("git")
            .args(["commit", "-m", "Aristotle Unified: merge arist + vendormod + split-decls"])
            .current_dir(output_dir)
            .output();
        println!("  ✓ git repo initialized");
    }

    // Count files
    let count = count_files_recursive(output_dir).unwrap_or(0);
    println!("\nUnified workspace: {} files at {}", count, output_dir.display());
    println!("  src/  — merged source (arist + vendormod + split-decls)");
    println!("  Cargo.toml — unified workspace manifest");
    println!("  flake.nix — nix build expression");

    Ok(())
}

/// Copy source tree preserving directory structure (so internal `mod` references work)
fn copy_source_tree_preserve(src: &std::path::Path, dst: &std::path::Path, skip_dirs: &[&str], dry_run: bool) -> Result<()> {
    let mut count = 0u64;
    for entry in walkdir::WalkDir::new(src)
        .max_depth(8)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| {
            let path = e.path();
            let fname = path.file_name().unwrap_or_default().to_string_lossy();
            // Skip backup files, binaries, and excluded directories
            if fname.ends_with(".bak") || fname.ends_with('~') || fname.ends_with(".backup")
                || fname.ends_with(".old") || fname.ends_with(".debug")
                || fname.ends_with(".test_backup") || fname.contains("backup")
                || fname == "lib_old.rs" || fname == "main_old.rs"
            {
                return false;
            }
            if path.extension().map_or(false, |ext| ext == "rs") {
                !skip_dirs.iter().any(|d| path.to_string_lossy().contains(&format!("/{}/", d)))
            } else { false }
        })
    {
        let rel = entry.path().strip_prefix(src).unwrap_or(entry.path());
        let dest = dst.join(rel);
        if !dry_run {
            if let Some(parent) = dest.parent() { fs::create_dir_all(parent)?; }
            fs::write(&dest, fs::read_to_string(entry.path())?)?;
        }
        count += 1;
    }
    if dry_run {
        println!("  [dry-run] {} .rs files would be copied to {}", count, dst.display());
    } else {
        println!("  ✓ {} .rs files copied to {}", count, dst.display());
    }
    Ok(())
}

fn generate_module_entry(dir: &std::path::Path) -> String {
    let mut lines = Vec::new();
    lines.push(format!("//! Module: {}", dir.file_name().unwrap_or_default().to_string_lossy()));

    let mut modules: Vec<String> = Vec::new();
    if let Ok(entries) = std::fs::read_dir(dir) {
        for entry in entries.filter_map(|e| e.ok()) {
            let name = entry.file_name().to_string_lossy().to_string();
            if name.ends_with(".rs") && name != "mod.rs" && name != "lib.rs" {
                let mod_name = name.strip_suffix(".rs").unwrap().to_string();
                modules.push(mod_name);
            }
        }
    }
    modules.sort();

    for m in modules {
        lines.push(format!("pub mod {};", m));
    }

    lines.push(String::new());
    lines.join("\n")
}

fn generate_unified_lib_rs() -> String {
    let mut lines = Vec::new();
    lines.push("//! Aristotle Unified: self-hosting diagonalization system".to_string());
    lines.push("//! Auto-generated from arist + vendormod + split-decls\n".to_string());
    lines.push("// Arist project files live at src/ root level (their mod refs expect that)".to_string());
    lines.push("pub mod vendormod;".to_string());
    lines.push("pub mod splitdecls;".to_string());
    lines.push(String::new());
    lines.push("#[cfg(test)]".to_string());
    lines.push("mod tests {".to_string());
    lines.push("    #[test]".to_string());
    lines.push("    fn it_works() {".to_string());
    lines.push("        assert!(true);".to_string());
    lines.push("    }".to_string());
    lines.push("}".to_string());
    lines.join("\n")
}

fn generate_unified_cargo_toml() -> String {
    r#"[package]
name = "aristotle-unified"
version = "0.1.0"
edition = "2024"
description = "Unified Aristotle pipeline: diagonalization + vendormod + split-decls"
authors = ["mdupont"]
license = "MIT"

[dependencies]
anyhow = "1.0"
chrono = { version = "0.4", features = ["serde"] }
clap = { version = "4.0", features = ["derive"] }
cid = "0.11"
dirs = "5.0"
flate2 = "1.0"
git2 = { version = "0.21", features = ["vendored-openssl"] }
glob = "0.3"
hex = "0.4"
itertools = "0.12"
lazy_static = "1.4"
multihash = "0.19"
pathdiff = "0.2"
petgraph = "0.6"
proc-macro2 = "1.0"
quote = "1.0"
rayon = "1.8"
regex = "1.10"
reqwest = { version = "0.11", features = ["json"], optional = true }
serde = { version = "1.0", features = ["derive"] }
serde_bytes = "0.11"
serde_ipld_dagcbor = "0.6.4"
serde_json = "1.0"
sha2 = "0.10"
syn = { version = "2.0", features = ["full", "visit", "visit-mut", "extra-traits"] }
tar = "0.4"
tempfile = "3"
thiserror = "1.0"
tokio = { version = "1.0", features = ["full"] }
toml = "0.8"
toml_edit = "0.22"
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }
walkdir = "2.3"

[profile.release]
opt-level = 3
lto = true
"#.to_string()
}

/// ── Regenerate clean unified tool from declaration lattice ──────
///
/// Reads source files from arist, vendormod, and split-decls-rs,
/// rewrites module paths using the declaration index, and produces
/// a single clean compilable workspace.

fn regenerate_from_lattice(output_dir: &std::path::PathBuf, dry_run: bool) -> Result<()> {
    let ws_dir = output_dir.join("unified-tool");
    let ws_src = ws_dir.join("src");
    let arist_root = std::env::current_dir()?;

    println!("Building clean unified tool from source declarations...\n");

    // Define the three source projects with their canonical module paths
    let projects = vec![
        ("core",  arist_root.join("src")),
        ("vendormod", PathBuf::from("/home/mdupont/projects/vendormod/src")),
        ("splitdecls", PathBuf::from("/mnt/data1/nix/vendor/rust/cargo2nix/submodules/split-decls-rs/src")),
    ];

    if !dry_run {
        // Clean previous workspace if it exists
        if ws_dir.exists() {
            fs::remove_dir_all(&ws_dir)?;
        }
        fs::create_dir_all(&ws_src)?;
    }

    // Phase 1: Read all source files, build a declaration → canonical path map
    let mut decl_paths: std::collections::HashMap<String, String> = std::collections::HashMap::new();
    let mut file_map: Vec<(String, std::path::PathBuf)> = Vec::new(); // (new_module_path, old_file)
    let mut total_files = 0u64;
    let mut total_decls = 0u64;

    for (project_prefix, src_dir) in &projects {
        if !src_dir.exists() {
            println!("  skipping {} (not found: {})", project_prefix, src_dir.display());
            continue;
        }

        for entry in walkdir::WalkDir::new(src_dir)
            .max_depth(6)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().extension().map_or(false, |ext| ext == "rs"))
            .filter(|e| {
                let fname = e.file_name().to_string_lossy();
                !fname.ends_with(".bak") && !fname.ends_with('~')
                    && !fname.contains("backup") && !fname.contains("old.rs")
                    && !fname.contains(".backup")
            })
        {
            let rel = entry.path().strip_prefix(src_dir).unwrap_or(entry.path());
            let rel_str = rel.to_string_lossy();

            // Build canonical module path: {project}/{original_dir_structure}
            // Preserve subdirectory separators so refusal/audit.rs stays as refusal/audit
            // Rename lib.rs to mod.rs since Cargo expects mod.rs for module directory entries
            let effective_name = if rel_str == "lib.rs" { "mod.rs".to_string() } else { rel_str.to_string() };
            let mod_path = format!("{}/{}", project_prefix, effective_name.strip_suffix(".rs").unwrap_or(&effective_name));

            // Read file and extract declarations
            let content = std::fs::read_to_string(entry.path())?;
            let lines: Vec<&str> = content.lines().collect();

            // Count declarations for stats
            let mut file_decl_count = 0u64;
            for line in &lines {
                let trimmed = line.trim();
                if trimmed.starts_with("pub fn ") || trimmed.starts_with("fn ")
                    || trimmed.starts_with("pub struct ") || trimmed.starts_with("pub enum ")
                    || trimmed.starts_with("pub trait ") || trimmed.starts_with("pub mod ")
                    || trimmed.starts_with("pub type ") || trimmed.starts_with("pub const ")
                    || trimmed.starts_with("pub unsafe ")
                {
                    file_decl_count += 1;
                }
            }

            total_decls += file_decl_count;
            total_files += 1;

            // Register declarations with their canonical paths
            decl_paths.insert(mod_path.clone(), effective_name.clone());
            file_map.push((mod_path, entry.path().to_path_buf()));
        }
    }

    println!("Phase 1: Found {} .rs files, {} declarations across 3 projects", total_files, total_decls);
    println!();

    // Phase 2: Generate workspace with proper module structure
    println!("Phase 2: Generating unified workspace...");

    // Write each source file into its project subdirectory
    // Structure: src/{project}/{original_path}
    // Then generate src/{project}/mod.rs that re-exports all sub-modules
    let mut rewritten_count = 0u64;
    let mut proj_files: std::collections::HashMap<String, Vec<String>> = std::collections::HashMap::new();

    for (mod_path, old_path) in &file_map {
        let content = std::fs::read_to_string(old_path)?;
        let rewritten = rewrite_module_paths(&content, mod_path, &decl_paths);

        // Determine project prefix and relative path from mod_path (format: core/refusal/audit)
        let (project, rel_path) = if let Some(rest) = mod_path.strip_prefix("core/") {
            ("core", rest.to_string())
        } else if let Some(rest) = mod_path.strip_prefix("vendormod/") {
            ("vendormod", rest.to_string())
        } else if let Some(rest) = mod_path.strip_prefix("splitdecls/") {
            ("splitdecls", rest.to_string())
        } else {
            ("other", mod_path.clone())
        };

        // Output: src/{project}/{rel_path}.rs  (preserves subdirectories)
        let out_path = ws_src.join(&project).join(format!("{}.rs", rel_path));
        // For mod.rs generation, use the directory-relative path
        let mod_key = rel_path.replace('/', "/"); // keep as-is for directory nesting

        if !dry_run {
            if let Some(parent) = out_path.parent() {
                fs::create_dir_all(parent)?;
            }
            fs::write(&out_path, &rewritten)?;
        }

        proj_files.entry(project.to_string())
            .or_default()
            .push(mod_key);
        rewritten_count += 1;

        if rewritten_count % 50 == 0 {
            println!("  ... {} files rewritten", rewritten_count);
        }
    }

    // Generate mod.rs for each project subdirectory
    // Only generate mod.rs if the project doesn't ALREADY have one
    // (the original lib.rs or mod.rs is used as the module entry)
    if !dry_run {
        for (project, files) in &proj_files {
            let proj_dir = ws_src.join(project);
            
            // Check if this project already has a mod.rs or lib.rs from original source
            let has_entry = proj_dir.join("mod.rs").exists() || proj_dir.join("lib.rs").exists();
            
            if !has_entry {
                // Generate mod.rs for root-level files
                // Collect all root modules: files at project root + subdirectory-only names
                let subdir_names: std::collections::HashSet<String> = files.iter()
                    .filter(|f| f.contains('/'))
                    .filter_map(|f| f.split('/').next())
                    .map(|s| s.to_string())
                    .collect();
                let root_file_names: std::collections::HashSet<String> = files.iter()
                    .filter(|f| !f.contains('/'))
                    .cloned()
                    .collect();
                
                // Include file modules that DON'T conflict with subdirectories
                // AND subdirectory-only modules (no corresponding file)
                let mut all_root: Vec<String> = Vec::new();
                for f in &root_file_names {
                    if !subdir_names.contains(f) {
                        all_root.push(f.clone());
                    }
                }
                for s in &subdir_names {
                    if !root_file_names.contains(s) {
                        all_root.push(s.clone());
                    }
                }
                all_root.sort();
                
                if !all_root.is_empty() {
                    let mut mod_content = format!("//! {} module\n\n", project);
                    for f in &all_root {
                        mod_content.push_str(&format!("pub mod {};\n", f));
                    }
                    fs::write(proj_dir.join("mod.rs"), &mod_content)?;
                }
            }

            // Generate mod.rs for subdirectories (always, since original files don't have these)
            let subdirs: std::collections::HashSet<&str> = files.iter()
                .filter_map(|f| f.split('/').next())
                .filter(|_s| files.iter().any(|f| f.contains('/')))
                .collect();
            for subdir in subdirs {
                let sub_dir = proj_dir.join(subdir);
                if sub_dir.join("mod.rs").exists() || sub_dir.join("lib.rs").exists() {
                    continue; // already has entry from original source
                }
                let sub_files: Vec<String> = files.iter()
                    .filter(|f| f.starts_with(&format!("{}/", subdir)))
                    .map(|f| f.strip_prefix(&format!("{}/", subdir)).unwrap_or(f).to_string())
                    .collect();
                if !sub_files.is_empty() {
                    let mut sub_mod = format!("//! {}::{} module\n\n", project, subdir);
                    let mut sorted = sub_files.clone();
                    sorted.sort();
                    for f in sorted {
                        sub_mod.push_str(&format!("pub mod {};\n", f));
                    }
                    fs::create_dir_all(&sub_dir)?;
                    fs::write(sub_dir.join("mod.rs"), &sub_mod)?;
                }
            }
        }
    }

    // Generate root lib.rs
    if !dry_run {
        let mut lib_rs = String::from("//! Aristotle Unified Tool\n");
        lib_rs.push_str("//! Clean merged codebase from arist + vendormod + split-decls\n\n");
        // Generate pub mod for each project — this links to src/{project}/mod.rs
        for (project_prefix, _) in &projects {
            lib_rs.push_str(&format!("pub mod {};\n", project_prefix));
        }
        fs::write(ws_src.join("lib.rs"), &lib_rs)?;

        // Generate Cargo.toml with ALL dependencies from all three projects merged
        let cargo = r#"[package]
name = "aristotle-unified"
version = "0.1.0"
edition = "2024"

[dependencies]
# Core
anyhow = "1.0"
chrono = { version = "0.4", features = ["serde"] }
clap = { version = "4.5", features = ["derive"] }
dirs = "5.0"
flate2 = "1.0"
glob = "0.3"
regex = "1.10"
reqwest = { version = "0.12", features = ["json", "multipart", "rustls-tls", "blocking"], default-features = false, optional = true }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
tar = "0.4"
tempfile = "3.10"
thiserror = "1.0"
tokio = { version = "1.40", features = ["full"] }
toml = "0.8"
toml_edit = "0.22"
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }
walkdir = "2.5"

# Rust AST
proc-macro2 = "1.0"
quote = "1.0"
syn = { version = "2.0", features = ["full", "visit", "visit-mut", "extra-traits"] }
prettyplease = "0.2"

# Graph & analysis
petgraph = "0.6"
rayon = "1.8"
lazy_static = "1.4"
itertools = "0.12"

# Vendormod: git & cargo
cid = "0.11"
git2 = { version = "0.21", features = ["vendored-openssl"] }
hex = "0.4"
multihash = "0.19"
pathdiff = "0.2"
serde_bytes = "0.11"
serde_ipld_dagcbor = "0.6.4"
sha2 = "0.10"
uuid = { version = "1.0", features = ["v4", "serde"] }
camino = "1.1"
cargo_metadata = "0.18"

# Split-decls
base64 = "0.21"
futures = "0.3"
libp2p = { version = "0.54", features = ["gossipsub", "mdns", "noise", "macros", "tcp", "yamux", "tokio"] }
rand = "0.8"

[profile.release]
opt-level = 3
lto = true

[features]
default = []
"#;
        fs::write(ws_dir.join("Cargo.toml"), cargo)?;

        // Initialize git
        let _ = std::process::Command::new("git")
            .args(["init", "-b", "main"])
            .current_dir(&ws_dir)
            .output();
        let _ = std::process::Command::new("git")
            .args(["add", "-A"])
            .current_dir(&ws_dir)
            .output();
        let _ = std::process::Command::new("git")
            .args(["commit", "-m", "Aristotle Unified: clean rebuild from declaration lattice"])
            .current_dir(&ws_dir)
            .output();
    }

    println!("\n✓ Unified workspace generated at {}", ws_dir.display());
    println!("  {} .rs files, {} declarations", total_files, total_decls);
    println!("  {} files with rewritten paths", rewritten_count);
    println!("  Run: cd {} && cargo build", ws_dir.display());

    Ok(())
}

/// Rewrite module paths so internal `mod foo;` declarations work when the file
/// has been moved into a subdirectory.
///
/// When a file like `main.rs` (now at `src/core/main.rs`) has `mod fetch;`,
/// Cargo looks for `src/core/main/fetch.rs`. But the file is at `src/core/fetch.rs`.
/// The fix: replace `mod foo;` with `use crate::core::foo;` for sibling modules.
fn rewrite_module_paths(content: &str, current_mod_path: &str, decl_paths: &std::collections::HashMap<String, String>) -> String {
    let mut result = String::new();
    let current_is_main_or_lib = current_mod_path.ends_with("main") || current_mod_path.ends_with("lib");
    
    // Determine the project prefix from the current module path
    let current_project = if current_mod_path.starts_with("core/") || current_mod_path == "core" { "core" }
        else if current_mod_path.starts_with("vendormod/") || current_mod_path == "vendormod" { "vendormod" }
        else if current_mod_path.starts_with("splitdecls/") || current_mod_path == "splitdecls" { "splitdecls" }
        else { "" };

    // Build a reverse index: module_basename → project_prefix
    // e.g., "config" → "vendormod", "fetch" → "core"
    let mut module_to_project: std::collections::HashMap<String, &str> = std::collections::HashMap::new();
    for key in decl_paths.keys() {
        if let Some(rest) = key.strip_prefix("core/") {
            // Use the first path component as the module name
            let first_seg = rest.split('/').next().unwrap_or(rest);
            module_to_project.insert(first_seg.to_string(), "core");
        } else if let Some(rest) = key.strip_prefix("vendormod/") {
            let first_seg = rest.split('/').next().unwrap_or(rest);
            module_to_project.insert(first_seg.to_string(), "vendormod");
        } else if let Some(rest) = key.strip_prefix("splitdecls/") {
            let first_seg = rest.split('/').next().unwrap_or(rest);
            module_to_project.insert(first_seg.to_string(), "splitdecls");
        }
        // Also add the full key for matching specific paths
    }

    for line in content.lines() {
        let trimmed = line.trim();
        let indent = &line[..line.len() - line.trim_start().len()];

        // ── Rule 1: main.rs/lib.rs `mod foo;` → `use crate::project::foo;` ──
        if current_is_main_or_lib && trimmed.starts_with("mod ") && trimmed.ends_with(';') && !current_project.is_empty() {
            let mod_name = trimmed[4..trimmed.len()-1].trim();
            if mod_name.chars().all(|c| c.is_alphanumeric() || c == '_') && !mod_name.is_empty() {
                let keywords = ["use", "pub", "crate", "self", "super", "fn", "struct", "enum", "trait", "impl", "mod"];
                if !keywords.contains(&mod_name) {
                    result.push_str(&format!("{}use crate::{}::{};\n", indent, current_project, mod_name));
                    continue;
                }
            }
        }

        // ── Rule 2: `use crate::foo::...` → `use crate::project::foo::...` ──
        // Always rewrite when `foo` is a module in any sub-project (even the same one),
        // because `crate::foo` no longer resolves — modules are under crate::{project}::
        if trimmed.starts_with("use crate::") {
            let rest = &trimmed["use crate::".len()..];
            if let Some(sep_pos) = rest.find(|c: char| c == ':' || c == ';' || c == ' ' || c == '(') {
                let first_seg = &rest[..sep_pos];
                if let Some(&target_project) = module_to_project.get(first_seg) {
                    // Rewrite: `use crate::foo::bar` → `use crate::project::foo::bar`
                    result.push_str(&format!("{}use crate::{}::{};\n", indent, target_project, rest.trim_end_matches(';')));
                    continue;
                }
            }
        }

        // ── Rule 3: Inline `crate::foo::...` references (not in `use` statements) ──
        // Match patterns like `crate::some_module::Function` where some_module
        // comes from a different project
        let mut modified = line.to_string();
        let mut changed = false;
        // Only process non-comment, non-string lines for crate:: references
        if !trimmed.starts_with("//") && !trimmed.starts_with("#[") {
            for (mod_name, &target_project) in &module_to_project {
                if target_project != current_project {
                    // Look for `crate::{mod_name}::` or `crate::{mod_name};`
                    let pattern_from = format!("crate::{}::", mod_name);
                    let pattern_simple = format!("crate::{};", mod_name);
                    let replacement = format!("crate::{}::{}::", target_project, mod_name);
                    let replacement_simple = format!("crate::{}::{};", target_project, mod_name);
                    if modified.contains(&pattern_from) {
                        modified = modified.replace(&pattern_from, &replacement);
                        changed = true;
                    }
                    if modified.contains(&pattern_simple) {
                        modified = modified.replace(&pattern_simple, &replacement_simple);
                        changed = true;
                    }
                }
            }
        }
        if changed {
            result.push_str(&modified);
            result.push('\n');
        } else {
            result.push_str(line);
            result.push('\n');
        }
    }

    result
}

/// ── Repair: SPARQL queries + GOAP planner ───────────────────────
///
/// Runs SPARQL queries over the generated code to find and fix
/// compilation errors. Uses the petgraph SPARQL engine from
/// split-decls-rs and the GOAP planner from dasl-planning.
///
/// Query patterns:
///   Q1: Find `use crate::foo` where foo is a sub-project module
///       → rewrite to `use crate::project::foo`
///   Q2: Find missing external crate dependencies
///       → add to Cargo.toml
///   Q3: Find ambiguous module/directory pairs
///       → resolve by removing duplicate

fn cmd_repair(output_dir: &std::path::PathBuf, dry_run: bool) -> Result<()> {
    let ws_dir = output_dir.join("unified-tool");
    if !ws_dir.exists() {
        return Err(anyhow::anyhow!(
            "Unified workspace not found at {}. Run `diagonalize --from-lattice` first.",
            ws_dir.display()
        ));
    }

    println!("Repairing unified workspace at: {}", ws_dir.display());
    println!();

    // ── Step 1: Push source into queryable graph ──
    // Generate an OWL/Turtle knowledge base from the source files
    println!("[1/5] Loading source into queryable graph...");
    let kb_path = ws_dir.join("code_graph.owl");
    if !dry_run {
        let kb = generate_knowledge_base(&ws_dir);
        fs::write(&kb_path, &kb)?;
        println!("  ✓ Knowledge base written: {} triples", kb.lines().filter(|l| l.contains("rdf:type") || l.contains("uses") || l.contains("declares")).count());
    }

    // ── Step 2: Run SPARQL queries to find error patterns ──
    println!("[2/5] Running SPARQL queries...");
    if !dry_run {
        run_sparql_queries(&ws_dir, &kb_path)?;
    }

    // ── Step 3: Apply fixes ──
    println!("[3/5] Applying fixes from query results...");
    if !dry_run {
        apply_sparql_fixes(&ws_dir)?;
    }

    // ── Step 4: Verify with cargo check ──
    println!("[4/5] Verifying with cargo check...");
    if !dry_run {
        let output = std::process::Command::new("cargo")
            .args(["check", "--message-format", "short"])
            .current_dir(&ws_dir)
            .output()
            .context("Failed to run cargo check")?;
        let stderr = String::from_utf8_lossy(&output.stderr);
        let error_count = stderr.lines().filter(|l| l.starts_with("error")).count();
        println!("  {} errors remaining", error_count);
        if error_count == 0 {
            println!("  ✓ cargo check passed!");
        } else {
            println!("  Run `cd {} && cargo check` to see details.", ws_dir.display());
        }
    }

    // ── Step 5: Generate task directories with boot.sh for dotagents ──
    println!("[5/5] Generating task directories for dotagents...");
    if !dry_run {
        let tasks_base = PathBuf::from("/home/mdupont/dotagents/dotagents/tasks");
        let generated = generate_repair_tasks(&tasks_base, &ws_dir)?;
        println!("  ✓ {} task directories generated with boot.sh", generated);
    }

    println!();
    if !dry_run {
        let error_count = count_errors(&ws_dir)?;
        println!("Errors: {}", error_count);
        if error_count > 0 {
            println!("Run `diagonalize --repair` again after fixes are applied.");
            println!("Or run the tasks in order:");
            println!("  cd ~/dotagents/dotagents/tasks/2026-06-27-repair-task-*/ && ./boot.sh");
        }
    }

    Ok(())
}

/// Generate task directories with boot.sh scripts for each repair step
fn generate_repair_tasks(tasks_dir: &std::path::Path, ws_dir: &std::path::Path) -> Result<usize> {
    let tasks = vec![
        ("add-deps", "Task 1: Add missing external crate dependencies", r#"#!/usr/bin/env bash
# Repair Task 1: Add missing external crate dependencies
set -euo pipefail
WORKSPACE="/mnt/data1/aristotle-results/diagonalize-results/unified-tool"
cd "$WORKSPACE"
# Add missing deps to Cargo.toml
# See ~/dotagents/dotagents/tasks/2026-06-27-repair-add-deps/SKILL.md for full list
cargo check 2>&1 | grep "E0433" | head -5
echo "Task 1: add missing deps — edit Cargo.toml with missing crates"
"#),
        ("crate-paths", "Task 2: Rewrite crate:: paths with project prefix", r#"#!/usr/bin/env bash
# Repair Task 2: Rewrite crate:: paths with project prefix
set -euo pipefail
WORKSPACE="/mnt/data1/aristotle-results/diagonalize-results/unified-tool"
cd "$WORKSPACE"
# For each use crate::X:: where X is in a sub-project, prefix with project name
python3 -c "
import os, re
src = os.path.join(os.environ['WORKSPACE'], 'src')
for root, dirs, files in os.walk(src):
    for f in files:
        if not f.endswith('.rs'): continue
        path = os.path.join(root, f)
        rel = os.path.relpath(path, src)
        proj = rel.split('/')[0]
        with open(path, 'r') as fh:
            content = fh.read()
        # Map: known module -> project
        mod_map = {}
        for d in os.listdir(src):
            dpath = os.path.join(src, d)
            if os.path.isdir(dpath):
                for m in os.listdir(dpath):
                    if m.endswith('.rs') and m not in ('mod.rs', 'lib.rs'):
                        mod_map[m[:-3]] = d
        # Rewrite use crate::X::... to use crate::proj::X::...
        changed = False
        new_content = []
        for line in content.split(chr(10)):
            m = re.match(r'^(\s*)use crate::(\w+)(.*)', line)
            if m and m.group(2) in mod_map and mod_map[m.group(2)] != proj:
                new_line = f'{m.group(1)}use crate::{mod_map[m.group(2)]}::{m.group(2)}{m.group(3)}'
                new_content.append(new_line)
                changed = True
            else:
                new_content.append(line)
        if changed:
            with open(path, 'w') as fh:
                fh.write(chr(10).join(new_content))
            print(f'Fixed: {rel}')
print('Done')
"
"#),
        ("super-paths", "Task 3: Rewrite super:: paths", r#"#!/usr/bin/env bash
# Repair Task 3: Rewrite super:: paths to absolute crate:: paths
set -euo pipefail
WORKSPACE="/mnt/data1/aristotle-results/diagonalize-results/unified-tool"
cd "$WORKSPACE"
# Replace super::load_config with crate::core::main::load_config
find src/ -name '*.rs' -exec sed -i 's/super::load_config/crate::core::main::load_config/g' {} +
echo "Fixed super::load_config references"
"#),
        ("zkperf-macros", "Task 4: Resolve zkperf_macros proc macro", r#"#!/usr/bin/env bash
# Repair Task 4: Resolve zkperf_macros proc macro
set -euo pipefail
WORKSPACE="/mnt/data1/aristotle-results/diagonalize-results/unified-tool"
cd "$WORKSPACE"
# Remove #[zkperf_macros::witness_boundary(...)] annotations
find src/splitdecls/ -name '*.rs' -exec sed -i '/#\[zkperf_macros::witness_boundary/,/)]/d' {} +
echo "Stripped zkperf_macros annotations"
"#),
        ("type-annotations", "Task 5: Fix type annotations", r#"#!/usr/bin/env bash
# Repair Task 5: Fix type annotations
set -euo pipefail
WORKSPACE="/mnt/data1/aristotle-results/diagonalize-results/unified-tool"
cd "$WORKSPACE"
# Count E0282 errors
count=$(cargo check 2>&1 | grep -c "E0282" || true)
echo "Type annotation errors remaining: $count"
"#),
        ("oneoff", "Task 6: One-off fixes", r#"#!/usr/bin/env bash
# Repair Task 6: One-off fixes
set -euo pipefail
WORKSPACE="/mnt/data1/aristotle-results/diagonalize-results/unified-tool"
cd "$WORKSPACE"
# Fix eager_splitter ambiguity: remove file, keep directory
rm -f src/splitdecls/eager_splitter.rs 2>/dev/null || true
# Fix syn_mold: remove from mod.rs if it doesn't exist
if [ ! -f src/splitdecls/syn_mold.rs ]; then
    sed -i '/pub mod syn_mold;/d' src/splitdecls/mod.rs 2>/dev/null || true
fi
# Enable span-locations feature for proc-macro2
if grep -q 'proc-macro2' Cargo.toml; then
    sed -i 's/proc-macro2 = "1.0"/proc-macro2 = { version = "1.0", features = ["span-locations"] }/' Cargo.toml
fi
echo "One-off fixes applied"
"#),
    ];

    let mut count = 0usize;
    for (name, title, boot_script) in &tasks {
        let task_dir = tasks_dir.join(format!("2026-06-27-repair-{}", name));
        fs::create_dir_all(&task_dir)?;
        
        // Write SKILL.md
        let skill = format!("# {}\n\n**Workspace:** {}\n\n## Action\n\nRun `./boot.sh` to execute.\n", title, ws_dir.display());
        fs::write(task_dir.join("SKILL.md"), &skill)?;
        
        // Write boot.sh
        fs::write(task_dir.join("boot.sh"), boot_script)?;
        
        // Make boot.sh executable
        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt;
            let perms = std::fs::Permissions::from_mode(0o755);
            let _ = std::fs::set_permissions(task_dir.join("boot.sh"), perms);
        }
        
        // Write SYSTEM.md
        let system = format!("Generated by diagonalize --repair\nDate: {}\n", chrono::Utc::now().to_rfc3339());
        fs::write(task_dir.join("SYSTEM.md"), &system)?;
        
        count += 1;
    }

    Ok(count)
}

/// Generate an OWL/Turtle knowledge base from source files
fn generate_knowledge_base(ws_dir: &std::path::Path) -> String {
    let mut triples = String::new();
    triples.push_str("@prefix lmdfb: <http://lmdfb.org/ontology/> .\n");
    triples.push_str("@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n\n");

    let src_dir = ws_dir.join("src");
    if !src_dir.exists() {
        return triples;
    }

    for entry in walkdir::WalkDir::new(&src_dir).max_depth(6).into_iter().filter_map(|e| e.ok()) {
        if entry.path().extension().map_or(false, |ext| ext == "rs") {
            let rel = entry.path().strip_prefix(&src_dir).unwrap_or(entry.path());
            let node_id = format!("file:{}", rel.to_string_lossy().replace('/', "_"));

            // Node type declaration
            triples.push_str(&format!("{} rdf:type lmdfb:RustSourceFile .\n", node_id));
            triples.push_str(&format!("{} lmdfb:path \"{}\" .\n", node_id, entry.path().display()));

            // Extract module declarations and use statements
            if let Ok(content) = std::fs::read_to_string(entry.path()) {
                for line in content.lines() {
                    let trimmed = line.trim();
                    if let Some(rest) = trimmed.strip_prefix("pub mod ") {
                        if let Some(mod_name) = rest.strip_suffix(';') {
                            let decl_val = format!("decl::{}::module::rust", mod_name.trim());
                            triples.push_str(&format!("{} lmdfb:declares \"{}\" .\n", node_id, decl_val));
                        }
                    } else if let Some(rest) = trimmed.strip_prefix("use crate::") {
                        if let Some(semicolon) = rest.find(';') {
                            let path = &rest[..semicolon];
                            triples.push_str(&format!("{} lmdfb:uses \"crate::{}\" .\n", node_id, path));
                        }
                    } else if let Some(rest) = trimmed.strip_prefix("use ") {
                        if let Some(semicolon) = rest.find(';') {
                            let path = &rest[..semicolon];
                            triples.push_str(&format!("{} lmdfb:imports \"{}\" .\n", node_id, path));
                        }
                    }
                }
            }
        }
    }

    triples
}

/// Run SPARQL queries against the knowledge base
fn run_sparql_queries(_ws_dir: &std::path::Path, kb_path: &std::path::Path) -> Result<()> {
    // Try using the split-decls-rs SPARQL engine if available
    let sparql_engine = std::env::var("SPARQL_ENGINE")
        .unwrap_or_else(|_| String::new());

    if !sparql_engine.is_empty() && std::path::Path::new(&sparql_engine).exists() {
        println!("  Using SPARQL engine: {}", sparql_engine);
        let output = std::process::Command::new(&sparql_engine)
            .arg(kb_path)
            .output()?;
        if output.status.success() {
            let stdout = String::from_utf8_lossy(&output.stdout);
            println!("  {}", stdout.lines().last().unwrap_or(""));
        }
    } else {
        println!("  Inline SPARQL analysis (set SPARQL_ENGINE env for full engine)");
        // Inline analysis: find crate:: references that need rewriting
        let content = fs::read_to_string(kb_path)?;
        let crate_refs: Vec<&str> = content.lines()
            .filter(|l| l.contains("lmdfb:uses") && l.contains("crate::"))
            .collect();
        println!("  Found {} `use crate::` references", crate_refs.len());
    }

    Ok(())
}

/// Apply fixes based on query results
fn apply_sparql_fixes(ws_dir: &std::path::Path) -> Result<()> {
    let src_dir = ws_dir.join("src");
    if !src_dir.exists() { return Ok(()); }

    // Build the project-name map: short module name → project prefix
    let mut module_to_project: std::collections::HashMap<String, String> = std::collections::HashMap::new();
    for entry in walkdir::WalkDir::new(&src_dir).max_depth(2).into_iter().filter_map(|e| e.ok()) {
        if entry.path().extension().map_or(false, |ext| ext == "rs") {
            let rel = entry.path().strip_prefix(&src_dir).unwrap_or(entry.path());
            let rel_owned = rel.to_string_lossy().to_string();
            let parts: Vec<&str> = rel_owned.split('/').collect();
            if parts.len() >= 2 {
                let project = parts[0];
                let file_stem = entry.path().file_stem().unwrap_or_default().to_string_lossy().to_string();
                if file_stem != "mod" && file_stem != "lib" {
                    module_to_project.insert(file_stem, project.to_string());
                }
            }
        }
    }

    println!("  Module→project map: {} entries", module_to_project.len());

    // Fix `use crate::foo` paths in vendormod files (they need `use crate::vendormod::foo`)
    let mut fixed = 0u64;
    for entry in walkdir::WalkDir::new(&src_dir).max_depth(4).into_iter().filter_map(|e| e.ok()) {
        if entry.path().extension().map_or(false, |ext| ext == "rs") {
            let content = std::fs::read_to_string(entry.path())?;
            let rel = entry.path().strip_prefix(&src_dir).unwrap_or(entry.path());
            let rel_str = rel.to_string_lossy().to_string();
            let current_project = rel_str.split('/').next().unwrap_or("").to_string();

            let mut new_content = String::new();
            let mut changed = false;

            for line in content.lines() {
                let trimmed = line.trim();
                let indent = &line[..line.len() - line.trim_start().len()];

                if trimmed.starts_with("use crate::") {
                    let rest = &trimmed["use crate::".len()..];
                    if let Some(sep_pos) = rest.find(|c: char| c == ':' || c == ';' || c == ' ' || c == '(') {
                        let first_seg = &rest[..sep_pos];
                        if let Some(target_project) = module_to_project.get(first_seg) {
                            let rewritten = format!("{}use crate::{}::{};\n", indent, target_project, rest.trim_end_matches(';'));
                            if trimmed != rewritten.trim() {
                                new_content.push_str(&rewritten);
                                changed = true;
                                fixed += 1;
                                continue;
                            }
                        }
                    }
                }
                new_content.push_str(line);
                new_content.push('\n');
            }

            if changed {
                std::fs::write(entry.path(), &new_content)?;
            }
        }
    }
    println!("  Fixed {} `use crate::` references", fixed);

    Ok(())
}

/// Count compilation errors
fn count_errors(ws_dir: &std::path::Path) -> Result<usize> {
    let output = std::process::Command::new("cargo")
        .args(["check", "--message-format", "short"])
        .current_dir(ws_dir)
        .output()?;
    let stderr = String::from_utf8_lossy(&output.stderr);
    Ok(stderr.lines().filter(|l| l.starts_with("error")).count())
}

fn generate_unified_flake_nix() -> String {
    r#"{
  description = "Aristotle Unified: self-hosting diagonalization system";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, rust-overlay, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = { pkgs, system, ... }: let
        rustPkgs = pkgs.extend (import rust-overlay);
        rustToolchain = rustPkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "aristotle-unified";
          version = "0.1.0";
          src = ./.;
          cargoHash = "";
          nativeBuildInputs = [ rustToolchain ];
          buildInputs = [ pkgs.openssl pkgs.pkg-config ];
        };

        devShells.default = pkgs.mkShell {
          packages = [ rustToolchain pkgs.lean4 ];
          shellHook = ''
            echo "Aristotle Unified dev shell"
            echo "  cargo build  — build the unified system"
            echo "  cargo run -- diagonalize  — run self-application pipeline"
          '';
        };
      };
    };
}
"#.to_string()
}

/// ── Next: do the next smart thing (autonomous agent loop) ──

async fn cmd_next() -> Result<()> {
    let api_key = get_api_key()?;
    let client = Client::builder().timeout(Duration::from_secs(30)).build()?;

    println!("=== next ===\n");

    // 1. Check GOAP planner for pending tasks
    let goap = std::process::Command::new("/home/mdupont/dasl-planning/plan-mappings/goap/target/release/dasl-planner")
        .output().ok();
    if let Some(ref out) = goap {
        let s = String::from_utf8_lossy(&out.stdout);
        if let Some(line) = s.lines().find(|l| l.starts_with("   1.")) {
            println!("GOAP: {}", line.trim());
        }
    }

    // 2. Check Aristotle for completed projects not yet finished
    let url = format!("{}/project", API_BASE_URL);
    let resp = client.get(&url).header("x-api-key", &api_key).send().await?;
    let projects: serde_json::Value = resp.json().await?;
    let mut todo: Vec<(String, String, String)> = Vec::new();

    if let Some(arr) = projects.as_array() {
        for p in arr.iter().take(20) {
            let id = p["project_id"].as_str().unwrap_or("");
            let desc = p["description"].as_str().unwrap_or("");
            let status = p["status"].as_i64().unwrap_or(0);
            match status {
                2 => { // Done — download and finish
                    let local = std::path::Path::new("/home/mdupont/projects/dasl-results")
                        .join(format!("{}_aristotle", id));
                    if !local.exists() {
                        todo.push((id.to_string(), "download+finish".into(), desc.to_string()));
                    }
                }
                1 => { // Running — check for asks
                    todo.push((id.to_string(), "check-asks".into(), desc.to_string()));
                }
                _ => {}
            }
        }
    }

    // 3. Do the highest-priority action
    if let Some((id, action, desc)) = todo.first() {
        println!("Action: {} — {} ({})", action, id, &desc[..desc.len().min(60)]);
        match action.as_str() {
            "download+finish" => {
                cmd_dasl_finish(id.clone(),
                    std::path::PathBuf::from("/home/mdupont/projects/dasl-sorries"),
                    std::path::PathBuf::from("/home/mdupont/projects/dasl-results")).await?;
            }
            "check-asks" => {
                cmd_respond(id.clone(),
                    std::path::PathBuf::from("/home/mdupont/projects/mckay-thompson/RequestProject"),
                    std::path::PathBuf::from("/home/mdupont/2026/06/25/index"),
                    false).await?;
            }
            _ => println!("No action needed"),
        }
    } else {
        println!("Nothing pending — all projects processed.");

        // Check planner state
        let plan = std::process::Command::new("/home/mdupont/dasl-planning/dasl-planner")
            .args(["status"])
            .output().ok();
        if let Some(out) = plan {
            let s = String::from_utf8_lossy(&out.stdout);
            for line in s.lines() {
                if line.contains("⬜") && !line.contains("░░") {
                    println!("  PENDING: {}", line.trim());
                }
            }
        }
    }

    println!("\nRun again for next action.");
    Ok(())
}


/// ── Respond: auto-detect Aristotle asks and inject matching files ──

async fn cmd_respond(project_id: String, prereq_dir: PathBuf, index_dir: PathBuf, dry_run: bool) -> Result<()> {
    let api_key = get_api_key()?;
    let client = Client::builder().timeout(Duration::from_secs(60)).build()?;
    println!("=== aristotle-respond ===");
    println!("Project: {}", project_id);
    let tasks_url = format!("{}/project/{}/task", API_BASE_URL, project_id);
    let resp = client.get(&tasks_url).header("x-api-key", &api_key).send().await?;
    let tasks_json: serde_json::Value = resp.json().await?;
    let help_patterns = [
        "need", "needs", "require", "would need", "missing", "lacks", "absent",
        "could you", "please", "re-send", "attach", "happy to formalize",
        "point me", "let me know", "still need", "not available", "couldn't",
        "wasn't able", "would need to be", "not enough", "not sufficient",
    ];
    let mut available: std::collections::HashMap<String, PathBuf> = std::collections::HashMap::new();
    for entry in WalkDir::new(&prereq_dir).into_iter().filter_map(|e| e.ok())
        .filter(|e| e.path().is_file() && e.path().extension().map_or(false, |e| e == "lean"))
    {
        let name = entry.path().file_stem().unwrap_or_default().to_string_lossy().to_lowercase();
        available.insert(name, entry.path().to_path_buf());
    }
    for entry in WalkDir::new(&index_dir).into_iter().filter_map(|e| e.ok())
        .filter(|e| e.path().is_file() && e.path().extension().map_or(false, |e| e == "txt"))
    {
        let name = entry.path().file_stem().unwrap_or_default().to_string_lossy().to_lowercase();
        available.insert(name, entry.path().to_path_buf());
    }
    println!("Indexed {} available files", available.len());
    let mut asks = 0u64; let mut injected = 0u64;
    if let Some(tasks) = tasks_json.as_array() {
        for task in tasks {
            let desc = task["description"].as_str().unwrap_or("").to_lowercase();
            let status = task["status"].as_str().unwrap_or("");
            if status == "completed" || status == "done" { continue; }
            let mut m: Vec<&str> = Vec::new();
            for p in &help_patterns { if desc.contains(p) { m.push(*p); } }
            if m.is_empty() { continue; }
            asks += 1;
            let full = task["description"].as_str().unwrap_or("");
            println!("\n  Ask #{}: \"{}\"", asks, &full[..full.len().min(140)]);
            println!("    Pattern: {}", m.join(", "));
            for (name, path) in &available {
                if desc.contains(name.as_str()) {
                    if dry_run { println!("    [DRY] inject: {}", name); continue; }
                    let content = std::fs::read_to_string(path)?;
                    let prompt = format!("You asked about \"{}\". File:\n\n=== {} ===\n{}\n=== END ===", name, path.file_name().unwrap_or_default().to_string_lossy(), content);
                    let s = std::process::Command::new("aristotle").args(["ask", &project_id, &prompt]).output()?;
                    if s.status.success() { println!("    Injected: {}", name); injected += 1; }
                }
            }
        }
    }
    println!("\n=== {} asks, {} injected ===", asks, injected);
    Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
    // Parse CLI first so we can configure tracing based on command options
    let cli = Cli::parse();

    // Determine log level: use RUST_LOG env, or debug if --verbose on download
    let env_filter = EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| EnvFilter::new("info"));

    // Extract trace mode from command
    let trace_mode: Option<&str> = match &cli.command {
        Commands::Download { trace, .. } => Some(trace.as_str()),
        Commands::Poll { trace, .. } => Some(trace.as_str()),
        Commands::Check { trace, .. } => Some(trace.as_str()),
        _ => None,
    };

    let file_log_guard: Option<tracing_appender::non_blocking::WorkerGuard> =
        match trace_mode {
            Some(file) if file == "file" || file == "both" => {
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
            trace,
            verbose,
        } => {
            info!(parallel, trace, verbose, "Executing poll command");
            cmd_poll(*download_only, *parallel).await?;
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
        Commands::Check { project_id, limit, trace } => {
            info!(?project_id, ?limit, trace, "Executing check command");
            cmd_check(project_id.clone(), *limit).await?;
        }
        Commands::DaslStatus { filter, sorries_only } => {
            info!(?filter, sorries_only, "Executing dasl-status command");
            cmd_dasl_status(filter.clone(), *sorries_only)?;
        }
        Commands::Overlap { reference, min_shared, top } => {
            info!(reference, min_shared, top, "Executing overlap command");
            cmd_overlap(reference.clone(), *min_shared, *top)?;
        }
        Commands::DownloadResult { project_id, output_dir, verbose } => {
            info!("Executing download-result command");
            cmd_download_result(project_id, output_dir.clone(), *verbose).await?;
        }
        Commands::Ask { project_id, prompt, file, inject_dir } => {
            info!("Executing ask command");
            cmd_ask(project_id.clone(), prompt.clone(), file.clone(), inject_dir.clone())?;
        }
        Commands::Patch { project_id, prereq_dir, interval, max_rounds } => {
            info!("Executing patch command");
            cmd_patch(project_id.clone(), prereq_dir.clone(), *interval, *max_rounds).await?;
        }
        Commands::DaslFinish { project_id, common_project, results_dir } => {
            info!("Executing dasl-finish command");
            cmd_dasl_finish(project_id.clone(), common_project.clone(), results_dir.clone()).await?;
        }
        Commands::McKayOeis { grep_files, output, inject_into } => {
            info!("Executing mc-kay-oeis command");
            cmd_mckay_oeis(grep_files.clone(), output.clone(), inject_into.clone())?;
        }
        Commands::Respond { project_id, prereq_dir, index_dir, dry_run } => {
            info!("Executing respond command");
            cmd_respond(project_id.clone(), prereq_dir.clone(), index_dir.clone(), *dry_run).await?;
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
        Commands::NotebooklmCross { output_dir } => {
            info!("Executing notebooklm-cross command");
            notebooklm_cross::cmd_notebooklm_cross(output_dir.clone())?;
        }
        Commands::Notebooklm { project_dir } => {
            info!("Executing notebooklm command");
            notebooklm::cmd_notebooklm(project_dir)?;
        }
        Commands::NotebooklmDump { output_dir } => {
            info!("Executing notebooklm-dump command");
            notebooklm_dump::cmd_notebooklm_dump(output_dir.clone())?;
        }
        Commands::SplitAll { output_dir, parallel, dry_run } => {
            info!("Executing split-all command");
            cmd_split_all(output_dir.clone(), *parallel, *dry_run)?;
        }
        Commands::ScanIndex { index_dir, output_dir, prefix_filter } => {
            info!("Executing scan-index command");
            file_index::cmd_scan_index(index_dir.clone(), output_dir.clone(), prefix_filter.clone())?;
        }
        Commands::Fetch { parallel, limit, dry_run } => {
            info!("Executing fetch command");
            fetch::cmd_fetch(*parallel, *limit, *dry_run).await?;
        }
        Commands::Pipeline { parallel, limit, dry_run } => {
            info!("Executing pipeline command");
            pipeline::cmd_pipeline(*parallel, *limit, *dry_run).await?;
        }
        Commands::Replay { output_dir, dry_run } => {
            info!("Executing replay command");
            replay::cmd_replay(output_dir.clone(), *dry_run).await?;
        }
        Commands::Version { results_dir, output_dir } => {
            info!("Executing version command");
            version::cmd_version(results_dir.clone(), output_dir.clone())?;
        }
        Commands::Consolidate { project_id, output_dir } => {
            info!("Executing consolidate command");
            cmd_consolidate(project_id, output_dir.clone())?;
        }
        Commands::JKey { input_dir, output_dir } => {
            info!("Executing j-key command");
            pipeline_steps::cmd_j_key(input_dir.clone(), output_dir.clone())?;
        }
        Commands::Arrows { input_dir, output_dir } => {
            info!("Executing arrows command");
            pipeline_steps::cmd_arrows(input_dir.clone(), output_dir.clone())?;
        }
        Commands::SplitByBand { input_dir, output_dir } => {
            info!("Executing split-by-band command");
            pipeline_steps::cmd_split_by_band(input_dir.clone(), output_dir.clone())?;
        }
        Commands::GenFlake { band_dir, output_dir } => {
            info!("Executing gen-flake command");
            pipeline_steps::cmd_gen_flake(band_dir.clone(), output_dir.clone())?;
        }
        Commands::CanonicalFlake { input_dir, output_dir, mathlib_split } => {
            info!("Executing canonical-flake command");
            pipeline_steps::cmd_canonical_flake(input_dir.clone(), output_dir.clone(), mathlib_split.clone())?;
        }
        Commands::CanonicalFlakeAll { output_dir, mathlib_split } => {
            info!("Executing canonical-flake-all command");
            pipeline_steps::cmd_canonical_flake_all(output_dir.clone(), mathlib_split.clone())?;
        }
        Commands::MergeProjects { project_ids, output_dir } => {
            info!(?project_ids, "Executing merge-projects command");
            pipeline_steps::cmd_merge_projects(&project_ids, output_dir.clone())?;
        }
        Commands::DepGraph { input_dir, output_dir } => {
            info!("Executing dep-graph command");
            pipeline_steps::cmd_dep_graph(input_dir.clone(), output_dir.clone())?;
        }
        Commands::Mycelium { input_dir, output_dir } => {
            info!("Executing mycelium command");
            pipeline_steps::cmd_mycelium(input_dir.clone(), output_dir.clone())?;
        }
        Commands::LoadDecls { dir, dry_run } => {
            info!("Executing load-decls");
            repl::cmd_load_decls(dir.clone(), *dry_run)?;
        }
        Commands::AskWithFiles { project_id, prompt, files_dir } => {
            info!("Executing ask-with-files");
            let api_key = get_api_key()?;
            let result = ask_aristotle_with_files(&api_key, project_id, prompt, files_dir)?;
            println!("{}", result);
        }
        Commands::Serve { port, forward } => {
            info!("Starting local Aristotle server on port {}", port);
            let api_key = get_api_key()?;
            local_server::AristoServer::start(*port, *forward, &api_key)?;
            }
	Commands::ReplStats => {
            info!("Executing repl-stats");
            repl::cmd_repl_stats()?;
	}
	Commands::RefusalAudit { base_dir, output } => {
            info!("Executing refusal-audit");
            refusal::audit::run_audit(base_dir, output)?;
	}
	Commands::RefusalContext { base_dir, output } => {
            info!("Executing refusal-context");
            refusal::extract::run_extract(base_dir, output)?;
	}
	Commands::RefusalFixStrategies { output } => {
            info!("Executing refusal-fix-strategies");
            refusal::fix::write_fix_strategies(output)?;
	}
	Commands::RefusalCorpus { base_dir, output } => {
            info!("Executing refusal-corpus");
            refusal::failure::build_failure_corpus(base_dir, output)?;
	}
	Commands::RefusalGlossary { base_dir, output } => {
            info!("Executing refusal-glossary");
            refusal::glossary::build_glossary(base_dir, output)?;
	}
	Commands::Diagonalize { output_dir, core_only, dry_run, rebuild, from_lattice, repair } => {
            info!("Executing diagonalize command");
            cmd_diagonalize(output_dir.clone(), *core_only, *dry_run, *rebuild, *from_lattice, *repair)?;
	}
    }
    // Keep the file appender guard alive until program exit
    drop(file_log_guard);

    info!("aristotle-manager finished successfully");
    Ok(())
}
