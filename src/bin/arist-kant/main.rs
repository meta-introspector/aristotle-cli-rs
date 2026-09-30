//! Aristotle Manager — Main entry point
//!
//! Commands:
//!   search <query> [--status N] [--files] [--input] [--limit N] [--shmem] [--index-dir DIR]
//!   relay          - Start the Kant relay service
//!   sops-setup     - Setup SOPS vault for credentials
//!   health         - Check service health

#[path = "../../kant_relay/mod.rs"]
mod kant_relay;
#[path = "../../search.rs"]
mod search;
#[path = "../../sops_integration/mod.rs"]
mod sops_integration;

use anyhow::{Context, Result};
use std::env;
use std::path::PathBuf;
use std::process;
use tracing::{info, error};

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize tracing
    tracing_subscriber::fmt::init();

    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} <command> [args]", args[0]);
        eprintln!("Commands:");
        eprintln!("  search         - Search Aristotle project database (tantivy)");
        eprintln!("  search-index   - Build/index the tantivy search index");
        eprintln!("  search-shmem   - Export search results to shared memory");
        eprintln!("  relay          - Start the Kant relay service");
        eprintln!("  sops-setup     - Setup SOPS vault for credentials");
        eprintln!("  health         - Check service health");
        process::exit(1);
    }

    let command = &args[1];

    match command.as_str() {
        "search" => cmd_search(&args[2..])?,
        "search-index" => cmd_search_index(&args[2..])?,
        "search-shmem" => cmd_search_shmem(&args[2..])?,
        "relay" => run_relay().await?,
        "sops-setup" => setup_sops_vault().await?,
        "health" => check_health().await?,
        _ => {
            eprintln!("Unknown command: {}", command);
            process::exit(1);
        }
    }

    Ok(())
}

// ── Search commands ──────────────────────────────────────────────────

/// Search the project database with tantivy
fn cmd_search(args: &[String]) -> Result<()> {
    let mut query = String::new();
    let mut status_filter: Option<u64> = None;
    let mut has_files_filter: Option<bool> = None;
    let mut has_input_filter: Option<bool> = None;
    let mut limit = 20usize;
    let mut index_dir: Option<PathBuf> = None;

    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "--query" | "-q" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--query requires an argument");
                }
                query = args[i + 1].clone();
                i += 2;
            }
            "--status" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--status requires an argument");
                }
                status_filter = Some(args[i + 1].parse::<u64>().context("status must be a number")?);
                i += 2;
            }
            "--files" => {
                has_files_filter = Some(true);
                i += 1;
            }
            "--no-files" => {
                has_files_filter = Some(false);
                i += 1;
            }
            "--input" => {
                has_input_filter = Some(true);
                i += 1;
            }
            "--no-input" => {
                has_input_filter = Some(false);
                i += 1;
            }
            "--limit" | "-n" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--limit requires an argument");
                }
                limit = args[i + 1].parse::<usize>().context("limit must be a number")?;
                i += 2;
            }
            "--index-dir" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--index-dir requires an argument");
                }
                index_dir = Some(PathBuf::from(&args[i + 1]));
                i += 2;
            }
            arg => {
                if arg.starts_with('-') {
                    anyhow::bail!("Unknown option: {}", arg);
                }
                if query.is_empty() {
                    query = arg.to_string();
                } else {
                    // Assume it's part of the query (for multi-word queries)
                    if !query.ends_with(' ') {
                        query.push(' ');
                    }
                    query.push_str(arg);
                }
                i += 1;
            }
        }
    }

    if query.is_empty() {
        eprintln!("Usage: search <query> [--status N] [--files|--no-files] [--input|--no-input] [--limit N] [--index-dir DIR]");
        eprintln!("Example: search \"monster group\" --status 2 --limit 10");
        process::exit(1);
    }

    // Default index dir
    let index_dir = index_dir.unwrap_or_else(|| {
        dirs::config_dir()
            .map(|p| p.join("aristotle-manager").join("search-index"))
            .unwrap_or_else(|| PathBuf::from("./search-index"))
    });

    // Load index
    info!(index_dir = %index_dir.display(), query = %query, "Searching...");
    let index = search::load_index(&index_dir)?;

    // Run search
    let results = search::search(
        &index,
        &query,
        status_filter,
        has_files_filter,
        has_input_filter,
        limit,
    )?;

    // Output results as JSON
    let json = serde_json::to_string_pretty(&results)?;
    println!("{}", json);

    info!(total = results.total, "Search complete");
    Ok(())
}

/// Build/index the tantivy search index from aristotle_projects.json
fn cmd_search_index(args: &[String]) -> Result<()> {
    let mut json_path: Option<PathBuf> = None;
    let mut index_dir: Option<PathBuf> = None;

    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "--json" | "-j" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--json requires a path to aristotle_projects.json");
                }
                json_path = Some(PathBuf::from(&args[i + 1]));
                i += 2;
            }
            "--index-dir" | "-o" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--index-dir requires a directory path");
                }
                index_dir = Some(PathBuf::from(&args[i + 1]));
                i += 2;
            }
            arg => {
                if arg.starts_with('-') {
                    anyhow::bail!("Unknown option: {}", arg);
                }
                json_path = Some(PathBuf::from(arg));
                i += 1;
            }
        }
    }

    let json_path = json_path.unwrap_or_else(|| PathBuf::from("aristotle_projects.json"));
    let index_dir = index_dir.unwrap_or_else(|| {
        PathBuf::from("./search-index")
    });

    if !json_path.exists() {
        anyhow::bail!("Project database not found: {}", json_path.display());
    }

    info!(json = %json_path.display(), index = %index_dir.display(), "Indexing projects...");
    let index = search::index_projects(&json_path, &index_dir)?;

    // Count documents
    let count = search::count(&index)?;
    println!("Indexed {} projects at {}", count, index_dir.display());

    info!(count, "Index built successfully");
    Ok(())
}

/// Export search results to shared memory for cross-service consumption
fn cmd_search_shmem(args: &[String]) -> Result<()> {
    let mut query = String::from("*");
    let mut index_dir: Option<PathBuf> = None;
    let mut shmem_client: Option<PathBuf> = None;
    let mut limit = 50usize;

    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "--query" | "-q" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--query requires an argument");
                }
                query = args[i + 1].clone();
                i += 2;
            }
            "--index-dir" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--index-dir requires an argument");
                }
                index_dir = Some(PathBuf::from(&args[i + 1]));
                i += 2;
            }
            "--shmem-client" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--shmem-client requires a path");
                }
                shmem_client = Some(PathBuf::from(&args[i + 1]));
                i += 2;
            }
            "--limit" | "-n" => {
                if i + 1 >= args.len() {
                    anyhow::bail!("--limit requires an argument");
                }
                limit = args[i + 1].parse::<usize>().context("limit must be a number")?;
                i += 2;
            }
            arg => {
                if arg.starts_with('-') && !arg.starts_with("--") {
                    anyhow::bail!("Unknown option: {}", arg);
                }
                if query == "*" {
                    query = arg.to_string();
                } else {
                    if !query.ends_with(' ') {
                        query.push(' ');
                    }
                    query.push_str(arg);
                }
                i += 1;
            }
        }
    }

    let index_dir = index_dir.unwrap_or_else(|| {
        dirs::config_dir()
            .map(|p| p.join("aristotle-manager").join("search-index"))
            .unwrap_or_else(|| PathBuf::from("./search-index"))
    });

    let shmem_client = shmem_client.unwrap_or_else(|| PathBuf::from("/home/mdupont/bin/dasl-planner"));

    info!(
        query = %query,
        index_dir = %index_dir.display(),
        "Exporting search results to shmem"
    );

    search::export_to_shmem(&PathBuf::from("aristotle_projects.json"), &index_dir, &shmem_client, &query, limit)?;

    info!("Search results exported to shmem");
    Ok(())
}

// ── Kant relay ───────────────────────────────────────────────────────

/// Run the Kant relay service
async fn run_relay() -> Result<()> {
    let relay = kant_relay::service::KantRelay::new(kant_relay::models::RelayConfig {
        kant_base_url: env::var("KANT_BASE_URL")
            .unwrap_or_else(|_| "https://kant-zk-pastebin.pages.dev".to_string()),
        relay_url: env::var("KANT_RELAY_URL")
            .unwrap_or_else(|_| "https://kant-zk-relay.jmikedupont2.workers.dev".to_string()),
        pass_limit: env::var("KANT_PASS_LIMIT")
            .unwrap_or_else(|_| "100".to_string())
            .parse()
            .unwrap_or(100),
    });

    relay.start().await?;
    Ok(())
}

/// Setup SOPS vault for credentials
async fn setup_sops_vault() -> Result<()> {
    sops_integration::setup_vault().await?;
    Ok(())
}

/// Check service health
async fn check_health() -> Result<()> {
    let health = sops_integration::health_check().await?;
    println!("Service health: {}", health);
    Ok(())
}
