use std::env;
use std::fs;
use std::path::PathBuf;

use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use tracing::{debug, info, instrument};

/// Global runtime configuration for aristotle-manager.
#[derive(Debug, Serialize, Deserialize)]
pub struct Config {
    pub base_dir: PathBuf,
    pub results_dir: PathBuf,
    pub git_base: PathBuf,
    pub max_parallel_downloads: usize,
    pub retry_wait_seconds: u64,
    pub max_retries: usize,
    /// Path to nix store olean directory (e.g. /mnt/data1/nix-store/store/yy02jnq1m13zbmsahh87v5z9w91k4wwa-lean4-4.29.1/lib/lean)
    pub nix_store_path: Option<String>,
    /// Path to mathlib-split directory (e.g. /home/mdupont/projects/lean-split-tool/mathlib-split)
    pub mathlib_split_path: Option<String>,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            base_dir: PathBuf::from("aristotles_results"),
            results_dir: PathBuf::from("aristotles_results"),
            git_base: PathBuf::from("aristotles_results"),
            max_parallel_downloads: 4,
            retry_wait_seconds: 10,
            max_retries: 3,
            nix_store_path: None,
            mathlib_split_path: None,
        }
    }
}

/// Return the on-disk path of the config file, creating its parent dir.
pub fn config_path() -> Result<PathBuf> {
    let config_dir = dirs::config_dir()
        .context("Could not determine config directory")?
        .join("aristotle-manager");
    fs::create_dir_all(&config_dir)?;
    Ok(config_dir.join("config.toml"))
}

#[instrument]
pub fn load_config() -> Result<Config> {
    let config_path = config_path()?;

    if !config_path.exists() {
        let default_config = Config::default();
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
