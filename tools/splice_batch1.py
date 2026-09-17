#!/usr/bin/env python3
"""Splice-out config/api infra and results/clean/configure commands from main.rs
into their own modules. Idempotent-ish: exits non-zero if a marker is missing."""
import sys

P = "/mnt/data1/time-2026/05-may/07/arist/src/main.rs"
src = open(P).read()
orig = src

def must_remove(s, label):
    global src
    if s not in src:
        print(f"MARKER NOT FOUND: {label}", file=sys.stderr)
        sys.exit(1)
    src = src.replace(s, "", 1)

def must_replace(s, r, label, count=1):
    global src
    if count == 0:
        # replace-all: no count verification needed (callers already matched)
        pass
    elif src.count(s) != count:
        print(f"EXPECTED {count} x [{label}], found {src.count(s)}", file=sys.stderr)
        sys.exit(1)
    src = src.replace(s, r)

# 1) Remove API infra block (API_BASE_URL / API_KEY / get_api_key / set_api_key)
api_block = '''const API_BASE_URL: &str = "https://aristotle.harmonic.fun/api/v3";

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

'''
must_remove(api_block, "api_block")

# 2) Remove ConfigureCommands enum + Config struct + load_config + cmd_results/cmd_clean/cmd_configure
cfg_block = '''
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
            nix_store_path: None,
            mathlib_split_path: None,
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
                    nix_store_path: None,
                    mathlib_split_path: None,
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

'''
must_remove(cfg_block, "cfg_block")

# 3) Add mod declarations for the new modules
old_mods = "mod fetch;\nmod file_index;"
new_mods = "mod api;\nmod cmd;\nmod config;\nmod fetch;\nmod file_index;"
must_replace(old_mods, new_mods, "mod declarations")

# 4) Point Commands* dispatch at the new cmd modules
must_replace("            cmd_configure(subcommand)?",
             "            crate::cmd::configure::cmd_configure(subcommand)?",
             "dispatch configure")
must_replace("            cmd_results()?",
             "            crate::cmd::results::cmd_results()?",
             "dispatch results")
must_replace("            cmd_clean()?",
             "            crate::cmd::clean::cmd_clean()?",
             "dispatch clean")

# 5) Rewire remaining call sites to the moved infra
must_replace("load_config(", "crate::config::load_config(", "load_config call", count=0)
must_replace("get_api_key(", "crate::api::get_api_key(", "get_api_key call", count=0)
must_replace("API_BASE_URL", "crate::api::API_BASE_URL", "API_BASE_URL", count=0)

open(P, "w").write(src)
print("OK: main.rs rewritten", src.count("\n"), "lines (was", orig.count("\n"), ")")
