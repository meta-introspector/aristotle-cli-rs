use std::fs;

use anyhow::Result;
use tracing::{info, instrument};

use crate::config::load_config;

/// Show the contents of the `result.txt` build-results file.
#[instrument]
pub fn cmd_results() -> Result<()> {
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
