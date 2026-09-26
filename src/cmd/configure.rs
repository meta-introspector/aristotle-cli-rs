use std::fs;

use anyhow::Result;
use clap::Subcommand;
use tracing::{info, instrument};

use crate::api::set_api_key;
use crate::config::{config_path, load_config, Config};

/// Subcommands for managing the local configuration.
#[derive(Subcommand)]
pub enum ConfigureCommands {
    /// Set the API key (from `--api-key` or interactive stdin).
    Set {
        #[arg(short = 'k')]
        api_key: Option<String>,
    },
    /// Display the current configuration.
    Show,
}

/// Configure the aristotle-manager settings (API key, paths).
#[instrument(skip(subcommand))]
pub fn cmd_configure(subcommand: &ConfigureCommands) -> Result<()> {
    let config_path = config_path()?;

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
                Config::default()
            } else {
                toml::from_str(&config_str)?
            };
            config.git_base = "aristotles_results".into();
            config.base_dir = "aristotles_results".into();
            config.results_dir = "aristotles_results".into();
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
