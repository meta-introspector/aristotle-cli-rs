//! Multi-account API key management.
//!
//! Accounts are stored in the shared config.toml as `[[accounts]]` entries.
//! Each account has a name and either an inline `api_key` or an
//! `api_key_file` pointing at a key file (preferred — keeps secrets out of
//! the config). Resolution order for a request:
//!
//! 1. explicitly named account (`--account` / `resolve_api_key(Some(name))`)
//! 2. `default_account` from config
//! 3. legacy single-key path (static store / env `ARISTOTLE_API_KEY`)
//!    — preserved for backward compatibility.
//!
//! The accounts table lives in the same config.toml as the main Config, but
//! is managed as raw toml::Value so the Config struct stays unchanged.

use std::collections::HashMap;
use std::env;
use std::fs;
use std::path::PathBuf;

use anyhow::{Context, Result, anyhow, bail};
use serde::{Deserialize, Serialize};
use tracing::{debug, info, warn};

use crate::api;

/// One named Aristotle API account.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Account {
    pub name: String,
    /// Inline API key. Prefer `api_key_file` so secrets stay out of config.toml.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub api_key: Option<String>,
    /// Path to a file containing the API key (one line, trimmed).
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub api_key_file: Option<PathBuf>,
    /// Optional per-account API base URL override.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub base_url: Option<String>,
}

impl Account {
    /// Read the effective key: inline value, or contents of `api_key_file`.
    pub fn effective_key(&self) -> Result<String> {
        if let Some(key) = &self.api_key {
            return Ok(key.trim().to_string());
        }
        if let Some(path) = &self.api_key_file {
            let expanded = expand_tilde(path);
            let contents = fs::read_to_string(&expanded)
                .with_context(|| format!("reading api_key_file for account '{}'", self.name))?;
            let key = contents.trim().to_string();
            if key.is_empty() {
                bail!("api_key_file for account '{}' is empty", self.name);
            }
            return Ok(key);
        }
        bail!("account '{}' has neither api_key nor api_key_file", self.name)
    }
}

fn expand_tilde(path: &PathBuf) -> PathBuf {
    let s = path.to_string_lossy();
    if let Some(rest) = s.strip_prefix("~/") {
        if let Some(home) = env::var_os("HOME") {
            return PathBuf::from(home).join(rest);
        }
    }
    path.clone()
}

/// Path of the shared config.toml (~/.config/aristotle-manager/config.toml).
fn config_path() -> Result<PathBuf> {
    let dir = dirs::config_dir()
        .context("Could not determine config directory")?
        .join("aristotle-manager");
    Ok(dir.join("config.toml"))
}

/// Load the account table from config.toml.
pub fn load_accounts() -> Result<(Vec<Account>, Option<String>)> {
    let path = config_path()?;
    let toml_str = fs::read_to_string(&path).unwrap_or_default();
    let doc: toml::Value = toml::from_str(&toml_str)
        .with_context(|| format!("parsing {}", path.display()))?;

    let accounts: Vec<Account> = doc
        .get("accounts")
        .map(|v| v.clone().try_into())
        .transpose()
        .context("parsing [[accounts]] entries")?
        .unwrap_or_default();

    let default = doc
        .get("default_account")
        .and_then(|v| v.as_str())
        .map(|s| s.to_string());

    Ok((accounts, default))
}

/// Save accounts + default back into config.toml, preserving other keys.
pub fn save_accounts(accounts: &[Account], default: &Option<String>) -> Result<()> {
    let path = config_path()?;
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)?;
    }
    let toml_str = fs::read_to_string(&path).unwrap_or_default();
    let mut doc: toml::Value = toml::from_str(&toml_str)
        .with_context(|| format!("parsing {}", path.display()))?;

    let table = doc.as_table_mut().context("config root is not a table")?;
    table.insert("accounts".into(), toml::Value::try_from(accounts.to_vec())?);
    match default {
        Some(name) => {
            table.insert("default_account".into(), toml::Value::String(name.clone()));
        }
        None => {
            table.remove("default_account");
        }
    }

    fs::write(&path, toml::to_string_pretty(&doc)?)?;
    info!(path = %path.display(), "Accounts saved");
    Ok(())
}

/// Resolve the API key for a request.
///
/// `account` overrides the configured default. Falls back to the legacy
/// single-key resolution (static store / env / key files) when no accounts
/// are configured.
pub fn resolve_api_key(account: Option<&str>) -> Result<String> {
    let (accounts, default) = load_accounts()?;

    if accounts.is_empty() {
        debug!("No accounts configured; using legacy single-key resolution");
        return api::get_api_key();
    }

    let name = account.or(default.as_deref());

    let selected = match name {
        Some(name) => accounts
            .iter()
            .find(|a| a.name == name)
            .ok_or_else(|| anyhow!("account '{}' not found (have: {})", name,
                accounts.iter().map(|a| a.name.as_str()).collect::<Vec<_>>().join(", ")))?,
        None => bail!(
            "multiple accounts configured but no default set; \
             use `configure account use <name>` or pass --account"
        ),
    };

    let key = selected.effective_key()?;
    // Store in the static cache so legacy call sites pick it up.
    api::set_api_key(&key);
    debug!(account = %selected.name, "Resolved API key");
    Ok(key)
}

/// List accounts with masked keys (for display).
pub fn describe_accounts() -> Result<Vec<String>> {
    let (accounts, default) = load_accounts()?;
    let mut lines = Vec::new();
    for a in &accounts {
        let is_default = default.as_deref() == Some(a.name.as_str());
        let key_desc = if a.api_key.is_some() {
            "inline key".to_string()
        } else if let Some(p) = &a.api_key_file {
            format!("file: {}", p.display())
        } else {
            "MISSING KEY".to_string()
        };
        let key_status = match a.effective_key() {
            Ok(k) => {
                let prefix: String = k.chars().take(4).collect();
                format!("ok ({}…)", prefix)
            }
            Err(_) => "unreadable".to_string(),
        };
        lines.push(format!(
            "{}{}  {}  [{}]",
            if is_default { "* " } else { "  " },
            a.name,
            key_desc,
            key_status
        ));
    }
    if accounts.is_empty() {
        lines.push("(no accounts configured — legacy single-key mode)".to_string());
    }
    Ok(lines)
}

/// Add or update an account.
pub fn upsert_account(
    name: &str,
    api_key: Option<&str>,
    api_key_file: Option<&PathBuf>,
    base_url: Option<&str>,
) -> Result<()> {
    let (mut accounts, default) = load_accounts()?;

    let existing = accounts.iter_mut().find(|a| a.name == name);
    match existing {
        Some(a) => {
            warn!(account = name, "Updating existing account");
            if let Some(k) = api_key {
                a.api_key = Some(k.to_string());
            }
            if let Some(f) = api_key_file {
                a.api_key_file = Some(f.clone());
                a.api_key = None; // file takes precedence on update
            }
            if let Some(u) = base_url {
                a.base_url = Some(u.to_string());
            }
        }
        None => {
            accounts.push(Account {
                name: name.to_string(),
                api_key: api_key.map(|k| k.to_string()),
                api_key_file: api_key_file.cloned(),
                base_url: base_url.map(|u| u.to_string()),
            });
        }
    }

    let default = if default.is_none() { Some(accounts[0].name.clone()) } else { default };
    save_accounts(&accounts, &default)?;
    println!(
        "Account '{}' saved{}",
        name,
        if default.as_deref() == Some(name) { " (default)" } else { "" }
    );
    Ok(())
}

/// Remove an account by name.
pub fn remove_account(name: &str) -> Result<()> {
    let (mut accounts, default) = load_accounts()?;
    let before = accounts.len();
    accounts.retain(|a| a.name != name);
    if accounts.len() == before {
        bail!("account '{}' not found", name);
    }
    let default = if default.as_deref() == Some(name) {
        accounts.first().map(|a| a.name.clone())
    } else {
        default
    };
    save_accounts(&accounts, &default)?;
    println!("Account '{}' removed", name);
    Ok(())
}

/// Set the default account.
pub fn use_account(name: &str) -> Result<()> {
    let (accounts, _) = load_accounts()?;
    if !accounts.iter().any(|a| a.name == name) {
        bail!("account '{}' not found (have: {})", name,
            accounts.iter().map(|a| a.name.as_str()).collect::<Vec<_>>().join(", "));
    }
    save_accounts(&accounts, &Some(name.to_string()))?;
    println!("Default account set to '{}'", name);
    Ok(())
}

/// Map of account name -> key, for callers that rotate across accounts.
pub fn all_keys() -> Result<HashMap<String, String>> {
    let (accounts, _) = load_accounts()?;
    let mut keys = HashMap::new();
    for a in &accounts {
        if let Ok(k) = a.effective_key() {
            keys.insert(a.name.clone(), k);
        }
    }
    Ok(keys)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn account_inline_key() {
        let a = Account {
            name: "t".into(),
            api_key: Some("  k  ".into()),
            api_key_file: None,
            base_url: None,
        };
        assert_eq!(a.effective_key().unwrap(), "k");
    }

    #[test]
    fn account_missing_key_errs() {
        let a = Account {
            name: "t".into(),
            api_key: None,
            api_key_file: None,
            base_url: None,
        };
        assert!(a.effective_key().is_err());
    }
}
