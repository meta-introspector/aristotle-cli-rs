use anyhow::{Result, Context, bail};
use tracing::info;
use std::path::Path;
use std::process::Command;
use std::fs;

/// Setup SOPS vault for credential management
pub async fn setup_vault() -> Result<()> {
    // Check if SOPS is available
    let output = std::process::Command::new("which")
        .arg("sops")
        .output()
        .context("sops command not found")?;
    
    if !output.status.success() {
        bail!("sops not found in PATH");
    }
    
    // Check for age keyring
    let age_output = std::process::Command::new("which")
        .arg("age")
        .output()
        .context("age command not found")?;
    
    if !age_output.status.success() {
        bail!("age not found in PATH - required for SOPS encryption");
    }
    
    // Check for age key
    let age_key = std::env::var("AGE_KEY")
        .map_err(|_| anyhow::anyhow!("AGE_KEY environment variable not set"))?;
    
    info!("SOPS vault initialized");
    info!("Using AGE key: {}...", &age_key[..8]);
    
    Ok(())
}

/// Load Cloudflare credentials from SOPS vault
pub async fn load_cloudflare_credentials() -> Result<(String, String)> {
    let vault_path = std::env::var("GUI2PROOF_RUNTIME_ENV")
        .unwrap_or_else(|_| "/run/gui2proof/cloudflare.env".to_string());
    
    let env_content = fs::read_to_string(&vault_path)
        .with_context(|| format!("Failed to read SOPS-encrypted file: {}", vault_path))?;
    
    // Parse Cloudflare credentials from the decrypted environment file
    let mut account_id = String::new();
    let mut api_token = String::new();
    
    for line in env_content.lines() {
        if let Some(rest) = line.strip_prefix("CLOUDFLARE_ACCOUNT_ID=") {
            account_id = rest.to_string();
        }
        if let Some(rest) = line.strip_prefix("CLOUDFLARE_API_TOKEN=") {
            api_token = rest.to_string();
        }
    }
    
    if account_id.is_empty() {
        bail!("CLOUDFLARE_ACCOUNT_ID not found in vault");
    }
    
    if api_token.is_empty() {
        bail!("CLOUDFLARE_API_TOKEN not found in vault");
    }
    
    // Validate account ID format (32-character hex)
    if !account_id.chars().all(|c| c.is_ascii_hexdigit()) || account_id.len() != 32 {
        bail!("Invalid CLOUDFLARE_ACCOUNT_ID format (expected 32 hex characters)");
    }
    
    info!("Loaded Cloudflare credentials: account {}...", &account_id[..8]);
    
    Ok((account_id, api_token))
}

/// Health check for the SOPS-integrated service
pub async fn health_check() -> Result<String> {
    // Verify that the runtime environment is set up
    let runtime_env = std::env::var("GUI2PROOF_RUNTIME_ENV")
        .map_err(|_| anyhow::anyhow!("GUI2PROOF_RUNTIME_ENV not set"))?;
    
    let _ = fs::read_to_string(&runtime_env)
        .with_context(|| format!("Failed to read: {}", runtime_env))?;
    
    Ok("healthy".to_string())
}

/// Decrypt SOPS file and return contents
pub fn decrypt_sops_file(encrypted_path: &Path) -> Result<String> {
    // Read the encrypted file
    let encrypted_data = fs::read(encrypted_path)
        .with_context(|| format!("Failed to read encrypted file: {}", encrypted_path.display()))?;
    
    // Run sops to decrypt
    let output = std::process::Command::new("sops")
        .arg("-d")
        .arg("-i").arg(encrypted_path)
        .arg("--output-type")
        .arg("yaml")
        .output()
        .map_err(|e| anyhow::anyhow!("sops decryption failed: {}", e))?;
    
    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        bail!("sops decryption error: {}", stderr);
    }
    
    Ok(String::from_utf8(output.stdout)?)
}
