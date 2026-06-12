use std::env;
use std::fs;
use std::path::PathBuf;
use std::sync::RwLock;
use anyhow::Result;
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "aristotle-manager")]
#[command(version = VERSION)]
#[command(about = "Tool for polling Aristotle results and managing Lean4 project compilation")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

const VERSION: &str = env!("CARGO_PKG_VERSION");
const API_VERSION: &str = "3";

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

fn load_config() -> Result<()> {
    let config_dir = dirs::config_dir().unwrap().join("aristotle-manager");
    fs::create_dir_all(&config_dir)?;
    let config_path = config_dir.join("config.toml");
    
    if !config_path.exists() {
        let config = r#"base_dir = "/home/mdupont/projects/arist"
results_dir = "/home/mdupont/projects/aristotle_results"
git_base = "/home/mdupont/05/07/arist"
max_parallel_downloads = 4
retry_wait_seconds = 10
max_retries = 3
notification_email = ""
slack_webhook = ""
"#;
        fs::write(&config_path, config)?;
    }
    Ok(())
}

fn cmd_results() -> Result<()> {
    let result_file = PathBuf::from("/home/mdupont/projects/arist/result.txt");
    if result_file.exists() {
        println!("{}", fs::read_to_string(&result_file)?);
    } else {
        println!("No results found.");
    }
    Ok(())
}

fn cmd_clean() -> Result<()> {
    println!("Clean command (placeholder - implement with walkdir)");
    Ok(())
}

fn cmd_configure(subcommand: &ConfigureCommands) -> Result<()> {
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
        }
        ConfigureCommands::Show => {
            println!("Configuration: (todo)");
        }
    }
    Ok(())
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    load_config()?;
    
    match &cli.command {
        Commands::Poll { download_only, parallel } => {
            println!("Poll: download_only={}, parallel={}", download_only, parallel);
            println!("Set ARISTOTLE_API_KEY to authenticate with Aristotle API");
        }
        Commands::Build { no_fail_fast, verbose } => {
            println!("Build: no_fail_fast={}, verbose={}", no_fail_fast, verbose);
        }
        Commands::Results => cmd_results()?,
        Commands::Clean => cmd_clean()?,
        Commands::Configure { subcommand } => cmd_configure(subcommand)?,
    }
    Ok(())
}
