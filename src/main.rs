use std::env;
use std::fs::{self, File, OpenOptions};
use std::io::Write;
use std::path::PathBuf;
use std::process::Command;
use std::sync::RwLock;
use std::time::Duration;
use anyhow::{Context, Result};
use clap::{Parser, Subcommand};
use flate2::read::GzDecoder;
use reqwest::Client;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use tar::Archive;
use tokio::sync::Semaphore;
use walkdir::WalkDir;

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
        Ok(key.clone())
    } else {
        env::var("ARISTOTLE_API_KEY")
            .map_err(|_| anyhow::anyhow!("API key not set. Set ARISTOTLE_API_KEY or use configure set"))
    }
}

fn set_api_key(api_key: &str) {
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
}

#[derive(Subcommand)]
enum ConfigureCommands {
    Set {
        #[arg(short = 'k')]
        api_key: Option<String>,
    },
    Show,
}

#[derive(Debug)]
#[derive(Serialize, Deserialize)]
struct Config {
    base_dir: PathBuf,
    results_dir: PathBuf,
    git_base: PathBuf,
    max_parallel_downloads: usize,
    retry_wait_seconds: u64,
    max_retries: usize,
}

fn load_config() -> Result<Config> {
    let config_dir = dirs::config_dir().unwrap().join("aristotle-manager");
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
        return Ok(default_config);
    }
    
    let toml = fs::read_to_string(&config_path)?;
    let config: Config = toml::from_str(&toml)?;
    Ok(config)
}

fn cmd_results() -> Result<()> {
    let config = load_config()?;
    let result_file = config.base_dir.join("result.txt");
    if result_file.exists() {
        println!("{}", fs::read_to_string(&result_file)?);
    } else {
        println!("No results found.");
    }
    Ok(())
}

fn cmd_clean() -> Result<()> {
    let config = load_config()?;
    let result_file = config.base_dir.join("result.txt");
    if result_file.exists() {
        fs::remove_file(&result_file)?;
        println!("Cleaned up result file.");
    } else {
        println!("No result file found.");
    }
    Ok(())
}

fn cmd_configure(subcommand: &ConfigureCommands) -> Result<()> {
    let config_dir = dirs::config_dir().unwrap().join("aristotle-manager");
    fs::create_dir_all(&config_dir)?;
    let config_path = config_dir.join("config.toml");
    
    match subcommand {
        ConfigureCommands::Set { api_key } => {
            if let Some(key) = api_key {
                set_api_key(key);
                println!("API key set");
            } else {
                println!("Enter API key:");
                let mut input = String::new();
                std::io::stdin().read_line(&mut input)?;
                set_api_key(input.trim());
                println!("API key set");
            }
            // Save config
            let mut config: Config = toml::from_str(&fs::read_to_string(&config_path)?)?;
            config.git_base = PathBuf::from("/home/mdupont/05/07/arist");
            config.base_dir = PathBuf::from("/home/mdupont/projects/arist");
            config.results_dir = PathBuf::from("/home/mdupont/projects/aristotle_results");
            let toml = toml::to_string(&config)?;
            fs::write(&config_path, toml)?;
            println!("Configuration saved");
        }
        ConfigureCommands::Show => {
            let config = load_config()?;
            println!("Configuration:");
            println!("  Base directory: {}", config.base_dir.display());
            println!("  Results directory: {}", config.results_dir.display());
            println!("  Git base: {}", config.git_base.display());
            println!("  Max parallel downloads: {}", config.max_parallel_downloads);
            println!("  Retry wait seconds: {}", config.retry_wait_seconds);
            println!("  Max retries: {}", config.max_retries);
        }
    }
    Ok(())
}

fn get_project_dirs(base_dir: &PathBuf) -> Result<Vec<PathBuf>> {
    let mut dirs = Vec::new();
    for entry in fs::read_dir(base_dir)? {
        let entry = entry?;
        let path = entry.path();
        if path.is_dir() {
            if let Some(name) = path.file_name() {
                if let Some(name_str) = name.to_str() {
                    if name_str.ends_with("_aristotle") {
                        dirs.push(path);
                    }
                }
            }
        }
    }
    Ok(dirs)
}

fn update_git_repos(base_dir: &PathBuf) -> Result<()> {
    let dirs = get_project_dirs(base_dir)?;
    for dir in &dirs {
        let name = dir.file_name().unwrap().to_string_lossy();
        let log_path = base_dir.join("poll.log");
        let mut log = File::create(&log_path)?;
        writeln!(log, "[{}] Checking {} for git updates...", 
            chrono::Local::now().format("%Y-%m-%d %H:%M:%S"), name)?;
        if dir.join(".git").exists() {
            writeln!(log, "[{}] Pulling latest changes for {}", 
                chrono::Local::now().format("%Y-%m-%d %H:%M:%S"), name)?;
            let output = Command::new("git").args(&["pull"]).current_dir(dir).output()?;
            writeln!(log, "git pull output:\n{}", String::from_utf8_lossy(&output.stdout))?;
        }
    }
    Ok(())
}

fn build_project(dir: &PathBuf) -> Result<bool> {
    let name = dir.file_name().unwrap().to_string_lossy();
    if !dir.join("lakefile.toml").exists() {
        println!("? {} - no lakefile.toml", name);
        return Ok(false);
    }
    println!("Building {}...", name);
    let status = Command::new("lake").args(&["build"]).current_dir(dir).status()?;
    Ok(status.success())
}

fn cmd_poll(_download_only: bool, _parallel: usize) -> Result<()> {
    let config = load_config()?;
    update_git_repos(&config.git_base)?;
    let dirs = get_project_dirs(&config.git_base)?;
    let mut success = 0;
    let mut fail = 0;
    for dir in &dirs {
        match build_project(dir) {
            Ok(true) => { println!("✓ {} succeeded", dir.file_name().unwrap().to_string_lossy()); success += 1; }
            Ok(false) => { println!("✗ {} failed", dir.file_name().unwrap().to_string_lossy()); fail += 1; }
            Err(e) => { println!("✗ {} failed: {}", dir.file_name().unwrap().to_string_lossy(), e); fail += 1; }
        }
    }
    let result = format!("Total: {} succeeded, {} failed\n", success, fail);
    fs::write(config.base_dir.join("result.txt"), &result)?;
    println!("{}", result);
    Ok(())
}

fn cmd_build() -> Result<()> {
    let config = load_config()?;
    let dirs = get_project_dirs(&config.git_base)?;
    let mut success = 0;
    let mut fail = 0;
    for dir in &dirs {
        match build_project(dir) {
            Ok(true) => { println!("✓ {} succeeded", dir.file_name().unwrap().to_string_lossy()); success += 1; }
            Ok(false) => { println!("✗ {} failed", dir.file_name().unwrap().to_string_lossy()); fail += 1; }
            Err(e) => { println!("✗ {} failed: {}", dir.file_name().unwrap().to_string_lossy(), e); fail += 1; }
        }
    }
    let result = format!("Total: {} succeeded, {} failed\n", success, fail);
    fs::write(config.base_dir.join("result.txt"), &result)?;
    println!("{}", result);
    Ok(())
}

fn cmd_test() -> Result<()> {
    let config = load_config()?;
    let dirs = get_project_dirs(&config.git_base)?;
    let mut success = 0;
    let mut fail = 0;
    for dir in &dirs {
        match build_project(dir) {
            Ok(true) => { println!("✓ {} succeeded", dir.file_name().unwrap().to_string_lossy()); success += 1; }
            Ok(false) => { println!("✗ {} failed", dir.file_name().unwrap().to_string_lossy()); fail += 1; }
            Err(e) => { println!("✗ {} failed: {}", dir.file_name().unwrap().to_string_lossy(), e); fail += 1; }
        }
    }
    let result = format!("Total: {} succeeded, {} failed\n", success, fail);
    fs::write(config.base_dir.join("result.txt"), &result)?;
    println!("{}", result);
    Ok(())
}

async fn cmd_download(parallel: usize) -> Result<()> {
    let config = load_config()?;
    let api_key = get_api_key()?;
    let client = Client::new();
    let processed_file = config.base_dir.join("aristotle_processed.txt");
    let download_log = config.base_dir.join("download.log");
    
    fs::create_dir_all(&processed_file.parent().unwrap())?;
    fs::create_dir_all(&config.results_dir)?;
    File::create(&download_log)?;
    
    let mut log = File::create(&download_log)?;
    writeln!(log, "[{}] Starting download of results\n", 
        chrono::Local::now().format("%Y-%m-%d %H:%M:%S"))?;
    
    // Get list of recent projects
    let list_url = format!("{}/project", API_BASE_URL);
    let response = client
        .get(&list_url)
        .header("Authorization", format!("Bearer {}", api_key))
        .send()
        .await?;
    
    let text = response.text().await?;
    let ids: Vec<String> = text
        .lines()
        .skip(3)
        .filter(|line| {
            line.chars().take(8).all(|c| c.is_ascii_hexdigit()) 
                && line.chars().nth(8) == Some('-')
        })
        .map(|line| line.split_whitespace().next().unwrap_or("").to_string())
        .filter(|id| !id.is_empty())
        .collect();
    
    writeln!(log, "Found {} projects to download\n", ids.len())?;
    
    // Download each result
    for id in &ids {
        let tarball_name = format!("{}-aristotle.tar.gz", id);
        let tarball_path = config.results_dir.join(&tarball_name);
        
        if tarball_path.exists() {
            writeln!(log, "Tarball already exists: {}\n", tarball_name)?;
            continue;
        }
        
        writeln!(log, "Downloading: {}\n", id)?;
        let result = download_result(&client, &api_key, &id, &config).await;
        match result {
            Ok(_) => writeln!(log, "✓ Downloaded: {}\n", id)?,
            Err(e) => writeln!(log, "✗ Failed to download {}: {}\n", id, e)?,
        }
    }
    
    writeln!(log, "Download complete.")?;
    println!("Download complete. See download.log for details.");
    Ok(())
}

async fn download_result(client: &Client, api_key: &str, result_id: &str, config: &Config) -> Result<()> {
    let url = format!("{}/result/{}", API_BASE_URL, result_id);
    
    let response = client
        .get(&url)
        .header("Authorization", format!("Bearer {}", api_key))
        .send()
        .await
        .with_context(|| format!("Failed to download result {}", result_id))?;
    
    if !response.status().is_success() {
        return Err(anyhow::anyhow!("Failed to download result {}: HTTP {}", result_id, response.status()));
    }
    
    // Wait for the result to be ready
    let mut retries = 0;
    loop {
        let status_url = format!("{}/result/{}/status", API_BASE_URL, result_id);
        let status_response = client
            .get(&status_url)
            .header("Authorization", format!("Bearer {}", api_key))
            .send()
            .await?;
        
        if status_response.status().is_success() {
            let status_json: Value = status_response.json().await?;
            if status_json["ready"].as_bool().unwrap_or(false) {
                break;
            }
        }
        
        retries += 1;
        if retries >= config.max_retries {
            return Err(anyhow::anyhow!("Max retries reached for result {}", result_id));
        }
        
        tokio::time::sleep(Duration::from_secs(config.retry_wait_seconds)).await;
    }
    
    // Download the actual tarball
    let response = client
        .get(&url)
        .header("Authorization", format!("Bearer {}", api_key))
        .send()
        .await?;
    
    let tarball_name = format!("{}-aristotle.tar.gz", result_id);
    let tarball_path = config.results_dir.join(&tarball_name);
    
    let bytes = response
        .bytes()
        .await
        .with_context(|| format!("Failed to get bytes for result {}", result_id))?;
    
    fs::write(&tarball_path, &bytes)?;
    
    // Extract the tarball
    let gz_decoder = GzDecoder::new(File::open(&tarball_path)?);
    let mut archive = Archive::new(gz_decoder);
    let temp_dir = config.git_base.join(format!("extract_{}_{}", result_id, chrono::Local::now().format("%Y%m%d%H%M%S")));
    fs::create_dir_all(&temp_dir)?;
    archive.unpack(&temp_dir)?;
    
    // Find extracted directory
    let mut extracted_dir = None;
    for entry in WalkDir::new(&temp_dir) {
        let entry = entry?;
        if entry.file_type().is_dir() {
            let name = entry.file_name().to_string_lossy();
            if name.ends_with("_aristotle") {
                extracted_dir = Some(entry.path().to_path_buf());
                break;
            }
        }
    }
    let extracted_dir = extracted_dir.unwrap_or(temp_dir);
    
    println!("Extracted to: {}", extracted_dir.display());
    
    // Clean up
    fs::remove_file(&tarball_path)?;
    File::create(config.base_dir.join("aristotle_processed.txt"))?.write_all(format!("{}\n", result_id).as_bytes())?;
    
    Ok(())
}

fn cmd_split(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let input_dir = input_dir.unwrap_or_else(|| PathBuf::from("/home/mdupont/05/07/arist"));
    let output_dir = output_dir.unwrap_or_else(|| PathBuf::from("/home/mdupont/05/07/arist/split-results"));
    fs::create_dir_all(&output_dir)?;
    
    for entry in WalkDir::new(&input_dir) {
        let entry = entry?;
        let path = entry.path();
        if path.is_dir() && path.file_name().unwrap() == "RequestProject" {
            for lean_entry in WalkDir::new(path) {
                let lean_entry = lean_entry?;
                if lean_entry.path().extension().map_or(false, |ext| ext == "lean") {
                    let relative = lean_entry.path().strip_prefix(&input_dir)?;
                    let output = output_dir.join(relative);
                    if let Some(parent) = output.parent() {
                        fs::create_dir_all(parent)?;
                    }
                    if !output.exists() {
                        fs::copy(lean_entry.path(), &output)?;
                        println!("Copied: {}", lean_entry.path().display());
                    }
                }
            }
        }
    }
    
    println!("Split complete. Results in: {}", output_dir.display());
    Ok(())
}

fn cmd_merge(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let input_dir = input_dir.unwrap_or_else(|| PathBuf::from("/home/mdupont/05/07/arist/split-results"));
    let output_dir = output_dir.unwrap_or_else(|| PathBuf::from("/home/mdupont/05/07/arist/merged-results"));
    fs::create_dir_all(&output_dir)?;
    
    for entry in WalkDir::new(&input_dir) {
        let entry = entry?;
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
                    println!("Merged: {}", path.display());
                }
            } else {
                fs::copy(path, &output)?;
            }
        }
    }
    
    println!("Merge complete. Results in: {}", output_dir.display());
    Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
    let cli = Cli::parse();
    load_config()?;
    
    match &cli.command {
        Commands::Poll { download_only, parallel } => {
            println!("Poll command");
            cmd_poll(*download_only, *parallel)?;
        }
        Commands::Build { no_fail_fast, verbose } => {
            cmd_build()?;
        }
        Commands::Download { parallel } => {
            cmd_download(*parallel).await?;
        }
        Commands::Test { no_fail_fast, verbose } => {
            cmd_test()?;
        }
        Commands::Split { input_dir, output_dir } => {
            cmd_split(input_dir.clone(), output_dir.clone())?;
        }
        Commands::Merge { input_dir, output_dir } => {
            cmd_merge(input_dir.clone(), output_dir.clone())?;
        }
        Commands::Results => cmd_results()?,
        Commands::Clean => cmd_clean()?,
        Commands::Configure { subcommand } => cmd_configure(subcommand)?,
    }
    
    Ok(())
}
