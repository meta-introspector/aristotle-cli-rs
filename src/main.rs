use std::collections::HashSet;
use std::env;
use std::fs::{self, File, OpenOptions};
use std::io::Write;
use std::path::{Path, PathBuf};
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
mod nix_build;
mod version;
mod repl;
mod refusal;
mod term_graph;
mod project_test;
pub(crate) mod api;
mod health;
mod git_utils;
mod feed_index;
mod shared_lean;

use api::{get_api_key, set_api_key, API_BASE_URL};

#[derive(Parser)]
#[command(name = "aristotle-manager")]
#[command(version = VERSION)]
#[command(about = "Tool for polling Aristotle results and managing Lean4 project compilation")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

const VERSION: &str = concat!(
    env!("CARGO_PKG_VERSION"),
    "-",
    env!("GIT_HASH"),
);
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
    /// Enrich: run task-enricher (chats, pi sessions, shmem) + GOAP pipeline (consolidate, j-key, dep-graph, mycelium, arrows)
    Enrich {
        /// DASLFINAL project ID for consolidate step
        #[arg(long, default_value = "738b2c45-72f6-43b4-8725-dfbf3fe82fcb")]
        project_id: String,
        /// Skip task-enricher phase (only run GOAP pipeline)
        #[arg(long)]
        skip_task_enricher: bool,
        /// Skip GOAP pipeline (only run task-enricher)
        #[arg(long)]
        skip_goap: bool,
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
        files_dir: Option<PathBuf>,
        /// Single .lean file to submit (alternative to --files-dir)
        #[arg(long)]
        file: Option<PathBuf>,
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
    /// Nix-build: compile Lean project using nix store binaries + oleans
    NixBuild {
        /// Project directory with .lean files
        #[arg(long)]
        input_dir: PathBuf,
        /// Output directory for built .olean files
        #[arg(long)]
        output_dir: Option<PathBuf>,
        /// Nix store path for lean toolchain (default: from config)
        #[arg(long)]
        nix_store: Option<String>,
        /// Generate flake.nix before building
        #[arg(long)]
        generate_flake: bool,
        /// Just generate flake.nix, don't build
        #[arg(long)]
        dry_run: bool,
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
        /// Print raw JSON response for debugging
        #[arg(long)]
        verbose: bool,
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
        [arg(long)]
        output_dir: Option<PathBuf>,
        [arg(long)]
        dry_run: bool,
    },
    /// Git-version all Aristotle outputs — each project becomes a commit
    Version {
        [arg(long)]
        results_dir: Option<PathBuf>,
        [arg(long)]
        output_dir: Option<PathBuf>,
    },
    /// Send instructions to a running Aristotle project (injects files inline)
    Ask {
        project_id: String,
        prompt: String,
        [arg(long)]
        file: Option<PathBuf>,
        [arg(long)]
        inject_dir: Option<PathBuf>,
    },
    /// Patch mode: watch a running Aristotle project, detect prereq gaps, fill them
    Patch {
        project_id: String,
        [arg(long)]
        prereq_dir: PathBuf,
        [arg(long, default_value = "60")]
        interval: u64,
        [arg(long, default_value = "10")]
        max_rounds: usize,
    },
    /// Finish: download result, merge into common project, rebuild flakes, update planner
    DaslFinish {
        project_id: String,
        [arg(long, default_value = "/home/mdupont/projects/dasl-sorries")]
        common_project: PathBuf,
        [arg(long, default_value = "/home/mdupont/projects/dasl-results")]
        results_dir: PathBuf,
    },
    /// Scan OEIS data for McKay-Thompson series, generate Lean4 coefficient database
    McKayOeis {
        [arg(long, num_args = 1.., default_values = [
            "/home/mdupont/2026/06/25/index/mckay_oeis.txt",
            "/home/mdupont/2026/06/25/index/thompson_oeis.txt",
            "/home/mdupont/2026/06/25/index/borcherds_oeis.txt",
            "/home/mdupont/2026/06/25/index/moonshine_oeis.txt"
        ])]
        grep_files: Vec<PathBuf>,
        [arg(long, default_value = "/home/mdupont/projects/mckay-thompson/RequestProject/McKayThompsonOEIS.lean")]
        output: PathBuf,
        [arg(long)]
        inject_into: Option<String>,
    },
    /// Auto-respond to Aristotle asks: detect help requests and inject matching files
    Respond {
        project_id: String,
        [arg(long, default_value = "/home/mdupont/projects/mckay-thompson/RequestProject")]
        prereq_dir: PathBuf,
        [arg(long, default_value = "/home/mdupont/2026/06/25/index")]
        index_dir: PathBuf,
        [arg(long)]
        dry_run: bool,
    },
    /// Audit Aristotle refusals/help/needs across all project outputs
    RefusalAudit {
        [arg(long, default_value = "/mnt/data1/aristotle-results")]
        base_dir: String,
        [arg(long, default_value = "/mnt/data1/aristotle-results/aristo-refusal-audit.json")]
        output: String,
    },
    /// Extract paragraph context around refusal/help keywords
    RefusalContext {
        [arg(long, default_value = "/mnt/data1/aristotle-results")]
        base_dir: String,
        [arg(long, default_value = "/mnt/data1/aristotle-results/aristo-test-corpus.json")]
        output: String,
    },
    /// Dump built-in refusal fix strategies to JSON
    RefusalFixStrategies {
        [arg(long, default_value = "/mnt/data1/aristotle-results/aristo-fix-strategies.json")]
        output: String,
    },
    /// Build failure corpus (classify runs as refusal/partial/scaffold/success)
    RefusalCorpus {
        [arg(long, default_value = "/mnt/data1/aristotle-results")]
        base_dir: String,
        [arg(long, default_value = "/mnt/data1/aristotle-results/aristo-failure-corpus.jsonl")]
        output: String,
    },
    /// Extract gnostic/undefined terms from Aristotle prose
    RefusalGlossary {
        [arg(long, default_value = "/mnt/data1/aristotle-results/aristo-gnostic-glossary.json")]
        base_dir: String,
        [arg(long, default_value = "/mnt/data1/aristotle-results/aristo-gnostic-glossary.json")]
        output: String,
    },
    /// Apply the Aristotle pipeline to itself — self-hosting diagonalization
    Diagonalize {
        [arg(long)]
        output_dir: Option<PathBuf>,
        [arg(long)]
        core_only: bool,
        [arg(long)]
        dry_run: bool,
        [arg(long)]
        rebuild: bool,
        [arg(long)]
        from_lattice: bool,
        [arg(long)]
        repair: bool,
    },
    /// Run project tests and report results to shmem + Aristotle
    ProjectTest {
        [arg(long)]
        project_id: Option<String>,
        [arg(long, default_value = "conformance")]
        mode: String,
        [arg(long)]
        iterations: Option<u64>,
        [arg(long, default_value = "300")]
        timeout: u64,
        [arg(long)]
        dir: Option<String>,
        [arg(long)]
        submit: bool,
        [arg(long)]
        json: bool,
    },
    /// Build term-level dependency graph across projects
    /// Each project is a page, terms are nodes, edges show usage/need relationships
    TermGraph {
        [arg(long, default_value = "/mnt/data1/time-2026/05-may/07/arist")]
        git_base: PathBuf,
        [arg(long)]
        output_dir: Option<PathBuf>,
        [arg(long)]
        quiet: bool,
    },
    /// Load term graph into IPLD CAR shmem (for cross-ref enrichment)
    LoadTermGraphToShmem {
        [arg(long)]
        dir: PathBuf,
    },
    /// Do the next smart thing: pick the highest-priority pending task and execute it
    Next,
    /// Feed tantivy index chunks from Aristotle corpus to a project
    FeedIndex {
        [arg(long)]
        project_id: String,
        [arg(long, default_value = "/mnt/data1/aristotle-results")]
        results_dir: PathBuf,
        [arg(long, default_value = "/mnt/data1/aristotle-results/aristotle-unified-index.json")]
        unified_index: PathBuf,
        [arg(long, default_value_t = 50)]
        chunk_size: usize,
        [arg(long)]
        dry_run: bool,
        [arg(long)]
        output_dir: Option<PathBuf>,
        [arg(long)]
        start_seq: Option<u64>,
    },
}

#[derive(Subcommand)]
enum ConfigureCommands {
    Set {
        [arg(short = 'k')]
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
    /// Path to nix store olean directory (e.g. /mnt/data1/nix-store/store/yy02jnq1m13zbmsahh87v5z9w91k4wwa-lean4-4.29.1/lib/lean)
    nix_store_path: Option<String>,
    /// Path to mathlib-split directory (e.g. /home/mdupont/projects/lean-split-tool/mathlib-split)
    mathlib_split_path: Option<String>,
}

#[instrument]
pub fn load_config() -> Result<Config> {
    let config_dir = dirs::config_dir()
        .context("Could not determine config directory")?
        .join("aristotle-manager");
    let config_path = config_dir.join("config.toml");
    let config = if config_path.exists() {
        let content = fs::read_to_string(&config_path)?;
        toml::from_str(&content)?
    } else {
        Config {
            base_dir: dirs::home_dir()
                .unwrap_or_else(|| PathBuf::from("."))
                .join(".aristotle-manager"),
            results_dir: dirs::home_dir()
                .unwrap_or_else(|| PathBuf::from("."))
                .join("aristotle-results"),
            git_base: dirs::home_dir()
                .unwrap_or_else(|| PathBuf::from("."))
                .join("aristotle-git-versions"),
            max_parallel_downloads: 4,
            retry_wait_seconds: 5,
            max_retries: 3,
            nix_store_path: None,
            mathlib_split_path: None,
        }
    };
    Ok(config)
}

#[instrument]
pub fn lake_binary() -> Result<PathBuf> {
    // Try nix store lake first, then PATH
    if let Some(nix_store) = load_config()?.nix_store_path {
        let lake = Path::new(&nix_store).join("bin").join("lake");
        if lake.exists() {
            return Ok(lake);
        }
    }
    // Fallback to PATH
    Ok(PathBuf::from("lake"))
}

fn ask_aristotle_sync(api_key: &str, project_id: &str, prompt: &str) -> Result<String> {
    ask_aristotle(api_key, project_id, prompt, FollowUpMode::Instruct, &[], AgentQuestions::Disabled)
}

fn ask_aristotle_with_files(
    api_key: &str,
    project_id: &str,
    prompt: &str,
    files_dir: Option<&PathBuf>,
    file: Option<&PathBuf>,
) -> Result<String> {
    let mut file_paths = Vec::new();
    // Add files from directory
    if let Some(dir) = files_dir {
        if dir.exists() {
            info!(dir = %dir.display(), "Scanning files_dir for all files");
            let mut found = 0;
            for entry in WalkDir::new(dir).max_depth(2).into_iter().filter_map(|e| e.ok()) {
                if entry.path().extension().map_or(false, |_e| true) {
                    file_paths.push(entry.path().to_path_buf());
                    debug!(file = %entry.path().display(), "Adding file from dir");
                    found += 1;
                }
            }
            info!(found = found, "Found files in dir");
        } else {
            warn!(dir = %dir.display(), "files_dir does not exist");
        }
    }
    // Add single file
    if let Some(f) = file {
        if f.exists() {
            file_paths.push(f.to_path_buf());
        }
    }
    ask_aristotle(api_key, project_id, prompt, FollowUpMode::Instruct, &file_paths, AgentQuestions::Disabled)
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

    let _file_log_guard: Option<tracing_appender::non_blocking::WorkerGuard> =
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
        Commands::Check { project_id, limit, trace, verbose } => {
            info!(?project_id, ?limit, trace, "Executing check command");
            cmd_check(project_id.clone(), *limit, *verbose).await?;
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
            cmd_results()?;
        }
        Commands::Clean => {
            info!("Executing clean command");
            cmd_clean()?;
        }
        Commands::Index { output } => {
            info!("Executing index command");
            index::cmd_index(output.clone())?;
        }
        Commands::Configure { subcommand } => {
            info!("Executing configure command");
            cmd_configure(subcommand)?;
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
        Commands::NixBuild { input_dir, output_dir, nix_store, generate_flake, dry_run } => {
            info!("Executing nix-build command");
            nix_build::cmd_nix_build(input_dir.clone(), output_dir.clone(), nix_store.clone(), *generate_flake, *dry_run)?;
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
        Commands::AskWithFiles { project_id, prompt, files_dir, file } => {
            info!("Executing ask-with-files");
            let api_key = get_api_key()?;
            let result = ask_aristotle_with_files(&api_key, project_id, prompt, files_dir.as_ref(), file.as_ref())?;
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
        Commands::ProjectTest { mode, iterations, timeout, dir, submit, json, project_id } => {
            info!("Executing project test");
            let testing_dir = dir.as_ref()
                .map(PathBuf::from)
                .or_else(|| project_test::find_project_testing_dir())
                .ok_or_else(|| anyhow::anyhow!(
                    "Testing directory not found. Specify --dir"
                ))?;
            let api_key = if *submit { get_api_key().ok() } else { None };
            let report = project_test::run_project_tests(
                &testing_dir,
                &mode,
                *iterations,
                *timeout,
                *submit,
                api_key,
                project_id.as_deref(),
            )?;
            if *json {
                println!("{}", project_test::report_to_json(&report));
            } else {
                project_test::print_report_summary(&report);
            }
        }
        Commands::TermGraph { git_base, output_dir, quiet } => {
            info!("Executing term-graph command");
            let graph = term_graph::build_term_graph(&git_base, output_dir.clone())?;
            if !quiet {
                let report = term_graph::generate_report(&graph);
                println!("{}", report);

                // Also print merge suggestions
                let merge_plan = term_graph::generate_merge_plan(&graph);
                println!("\n## Top Merge Candidates (by shared terms):");
                for (p1, p2, count) in merge_plan.iter().take(10) {
                    println!("  {} + {}: {} shared terms", p1, p2, count);
                }
            }
        }
        Commands::Enrich { project_id, skip_task_enricher, skip_goap } => {
            info!("Executing enrich command");
            cmd_enrich(&project_id, !skip_task_enricher, !skip_goap)?;
        }
        Commands::LoadTermGraphToShmem { dir } => {
            info!("Loading term graph to shmem from: {}", dir.display());
            load_shmem::load_term_graph_to_shmem(&dir)?;
        }
        Commands::Next => {
            info!("Executing next command");
            cmd_next().await?;
        }
        Commands::FeedIndex { project_id, results_dir, unified_index, chunk_size, dry_run, output_dir, start_seq } => {
            info!("Executing feed-index command");
            feed_index::cmd_feed_index(
                project_id.clone(),
                results_dir.clone(),
                unified_index.clone(),
                *chunk_size,
                *dry_run,
                output_dir.clone(),
                *start_seq,
            )?;
        }
    }

    info!("aristotle-manager finished successfully");
    Ok(())
}
