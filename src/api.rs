use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::sync::RwLock;

use anyhow::Result;
use tracing::{debug, error};

pub const API_BASE_URL: &str = "https://aristotle.harmonic.fun/api/v3";

static API_KEY: RwLock<Option<String>> = RwLock::new(None);

const API_KEY_ENV: &str = "ARISTOTLE_API_KEY";

/// Return the Aristotle API key without executing any shell configuration.
///
/// Resolution order is: in-process configure value, exported environment,
/// ARISTOTLE_API_KEY_FILE, Aristotle config/key files, then common shell
/// startup files. Shell files are parsed as simple assignments only; command
/// substitution and other shell syntax are never evaluated.
pub fn get_api_key() -> Result<String> {
    if let Some(key) = &*API_KEY.read().unwrap() {
        debug!("API key retrieved from static store");
        Ok(key.clone())
    } else if let Some(key) = nonempty(env::var(API_KEY_ENV).ok()) {
        debug!("API key retrieved from environment");
        Ok(key)
    } else if let Some(key) = discover_api_key() {
        debug!("API key retrieved from a local configuration file");
        Ok(key)
    } else {
        error!("API key not set in supported sources");
        anyhow::bail!(
            "API key not found. Set ARISTOTLE_API_KEY, configure an API key file, or add an assignment to a supported home config"
        )
    }
}

fn nonempty(value: Option<String>) -> Option<String> {
    value.and_then(|value| {
        let value = value.trim().to_string();
        (!value.is_empty()).then_some(value)
    })
}

fn parse_assignment(line: &str, name: &str) -> Option<String> {
    let line = line.trim();
    let line = line.strip_prefix("export ").unwrap_or(line).trim();
    let (lhs, rhs) = line.split_once('=')?;
    if lhs.trim() != name {
        return None;
    }

    let mut value = rhs.trim().trim_end_matches(';').trim();
    if value.contains("$(") || value.contains('`') {
        return None;
    }
    if (value.starts_with('"') && value.ends_with('"'))
        || (value.starts_with('\'') && value.ends_with('\''))
    {
        value = &value[1..value.len() - 1];
    }
    nonempty(Some(value.to_string()))
}

fn read_key_file(path: &Path, shell_assignments: bool) -> Option<String> {
    let contents = fs::read_to_string(path).ok()?;
    if shell_assignments {
        contents
            .lines()
            .filter_map(|line| parse_assignment(line, API_KEY_ENV))
            .next()
    } else {
        nonempty(Some(contents))
    }
}

fn home_path(home: &Path, name: &str) -> PathBuf {
    home.join(name)
}

fn discover_api_key() -> Option<String> {
    if let Some(path) = env::var_os("ARISTOTLE_API_KEY_FILE") {
        if let Some(key) = read_key_file(Path::new(&path), false) {
            return Some(key);
        }
    }

    let home = PathBuf::from(env::var_os("HOME")?);
    let config_dir = home_path(&home, ".config/aristotle-manager");
    for path in [
        config_dir.join("api_key"),
        config_dir.join(".env"),
        home_path(&home, ".aristotle_api_key"),
        home_path(&home, ".config/aristotle-manager/config.toml"),
    ] {
        let shell_assignments = path.extension().is_some_and(|ext| ext == "toml" || ext == "env");
        if let Some(key) = read_key_file(&path, shell_assignments) {
            return Some(key);
        }
    }

    for name in [".bashrc", ".bash_profile", ".profile", ".zshrc"] {
        if let Some(key) = read_key_file(&home_path(&home, name), true) {
            return Some(key);
        }
    }
    None
}

pub fn set_api_key(api_key: &str) {
    debug!("Setting API key in static store");
    *API_KEY.write().unwrap() = Some(api_key.to_string());
}

#[cfg(test)]
mod tests {
    use super::parse_assignment;

    #[test]
    fn parses_exported_assignment() {
        assert_eq!(
            parse_assignment("export ARISTOTLE_API_KEY='test-key'", "ARISTOTLE_API_KEY"),
            Some("test-key".to_string())
        );
    }

    #[test]
    fn ignores_other_shell_syntax() {
        assert_eq!(
            parse_assignment("export ARISTOTLE_API_KEY=$(secret-tool lookup key)", "ARISTOTLE_API_KEY"),
            None
        );
    }
}
