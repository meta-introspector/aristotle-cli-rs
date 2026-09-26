use std::fs;

use anyhow::Result;
use tracing::{info, instrument};

use crate::config::load_config;

/// Remove the `result.txt` build-results file.
#[instrument]
pub fn cmd_clean() -> Result<()> {
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
