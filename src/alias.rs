use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use tracing::{debug, warn};

#[derive(Debug, Serialize, Deserialize, Default)]
struct AliasFile {
    mappings: HashMap<String, String>,
    tags: HashMap<String, Vec<String>>,
}

impl AliasFile {
    fn path() -> Result<PathBuf> {
        let config_dir = dirs::config_dir()
            .context("Could not determine config directory")?
            .join("aristotle-manager");
        fs::create_dir_all(&config_dir)?;
        Ok(config_dir.join("aliases.json"))
    }

    fn load() -> Result<Self> {
        let path = Self::path()?;
        if !path.exists() {
            return Ok(Self::default());
        }
        let data = fs::read_to_string(&path)?;
        let file: AliasFile = serde_json::from_str(&data)?;
        Ok(file)
    }

    fn save(&self) -> Result<()> {
        let path = Self::path()?;
        let data = serde_json::to_string_pretty(self)?;
        fs::write(&path, data)?;
        Ok(())
    }
}

pub fn resolve(input: &str) -> Result<String> {
    let file = AliasFile::load()?;
    if let Some(uuid) = file.mappings.get(input) {
        debug!(alias = %input, uuid = %uuid, "Resolved alias");
        Ok(uuid.clone())
    } else {
        Ok(input.to_string())
    }
}

pub fn set(alias: &str, uuid: &str) -> Result<()> {
    let mut file = AliasFile::load()?;
    if let Some(existing) = file.mappings.get(alias) {
        if existing == uuid {
            println!("Alias '{}' already points to {}", alias, uuid);
            return Ok(());
        }
    }
    file.mappings.insert(alias.to_string(), uuid.to_string());
    file.save()?;
    println!("Set alias '{}' -> {}", alias, uuid);
    Ok(())
}

pub fn remove(alias: &str) -> Result<()> {
    let mut file = AliasFile::load()?;
    if file.mappings.remove(alias).is_some() {
        file.save()?;
        println!("Removed alias '{}'", alias);
    } else {
        println!("Alias '{}' not found", alias);
    }
    Ok(())
}

pub fn list() -> Result<()> {
    let file = AliasFile::load()?;
    if file.mappings.is_empty() {
        println!("No aliases defined.");
        return Ok(());
    }
    println!("{:<30} {}", "ALIAS", "UUID");
    for (alias, uuid) in &file.mappings {
        println!("{:<30} {}", alias, uuid);
    }
    println!("\nTotal: {}", file.mappings.len());
    Ok(())
}

pub fn suggest(projects_dir: &Path) -> Result<()> {
    let file = AliasFile::load()?;
    let mut used_names: HashMap<String, usize> = HashMap::new();

    for name in file.mappings.keys() {
        let base = name.rsplit_once('-').map(|(b, _)| b).unwrap_or(name);
        *used_names.entry(base.to_string()).or_default() += 1;
    }

    let mut suggestions: Vec<(String, String, String)> = Vec::new();

    if let Ok(entries) = fs::read_dir(projects_dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if !path.is_dir() {
                continue;
            }
            let dir_name = match path.file_name().and_then(|n| n.to_str()) {
                Some(n) => n,
                None => continue,
            };
            let uuid = match dir_name.strip_suffix("_aristotle") {
                Some(u) => u,
                None => continue,
            };

            if file.mappings.values().any(|v| v == uuid) {
                continue;
            }

            let status_path = path.join("aristotle_status.json");
            let description = if status_path.exists() {
                if let Ok(data) = fs::read_to_string(&status_path) {
                    if let Ok(json) = serde_json::from_str::<serde_json::Value>(&data) {
                        json["description"].as_str().unwrap_or("").to_string()
                    } else {
                        String::new()
                    }
                } else {
                    String::new()
                }
            } else {
                String::new()
            };

            let suggested = slugify(&description);
            let unique = ensure_unique(&suggested, &used_names);
            used_names.insert(unique.clone(), 0);

            suggestions.push((unique, uuid.to_string(), description));
        }
    }

    if suggestions.is_empty() {
        println!("No unaliased projects found in {}", projects_dir.display());
        return Ok(());
    }

    println!("{:<30} {:<36} {}", "SUGGESTED NAME", "UUID", "DESCRIPTION");
    for (name, uuid, desc) in suggestions {
        let short_desc = desc.chars().take(50).collect::<String>();
        println!("{:<30} {:<36} {}", name, uuid, short_desc);
    }
    println!("\nUse: alias set <name> <uuid>");
    Ok(())
}

pub fn tag(uuid: &str, tag: &str) -> Result<()> {
    let mut file = AliasFile::load()?;
    let tags = file.tags.entry(uuid.to_string()).or_default();
    if !tags.contains(&tag.to_string()) {
        tags.push(tag.to_string());
    }
    file.save()?;
    println!("Tagged {} with '{}'", uuid, tag);
    Ok(())
}

pub fn untag(uuid: &str, tag: &str) -> Result<()> {
    let mut file = AliasFile::load()?;
    if let Some(tags) = file.tags.get_mut(uuid) {
        tags.retain(|t| t != tag);
        if tags.is_empty() {
            file.tags.remove(uuid);
        }
        file.save()?;
        println!("Removed tag '{}' from {}", tag, uuid);
    } else {
        println!("No tags found for {}", uuid);
    }
    Ok(())
}

pub fn list_tags(uuid: &str) -> Result<()> {
    let file = AliasFile::load()?;
    if let Some(tags) = file.tags.get(uuid) {
        println!("Tags for {}: {}", uuid, tags.join(", "));
    } else {
        println!("No tags for {}", uuid);
    }
    Ok(())
}

pub fn list_by_tag(tag: &str) -> Result<()> {
    let file = AliasFile::load()?;
    let mut found = Vec::new();
    for (uuid, tags) in &file.tags {
        if tags.contains(&tag.to_string()) {
            found.push(uuid.clone());
        }
    }
    if found.is_empty() {
        println!("No projects tagged '{}'", tag);
        return Ok(());
    }
    println!("Projects tagged '{}':", tag);
    for uuid in found {
        if let Some(alias) = file.mappings.iter().find(|(_, v)| **v == uuid) {
            println!("  {} ({})", alias.0, uuid);
        } else {
            println!("  {} (no alias)", uuid);
        }
    }
    Ok(())
}

fn slugify(s: &str) -> String {
    let mut result = String::new();
    let mut prev_dash = false;
    for c in s.to_ascii_lowercase().chars() {
        if c.is_ascii_alphanumeric() {
            result.push(c);
            prev_dash = false;
        } else if !prev_dash && !result.is_empty() {
            result.push('-');
            prev_dash = true;
        }
    }
    result.trim_end_matches('-').to_string()
}

fn ensure_unique(base: &str, used: &HashMap<String, usize>) -> String {
    if let Some(count) = used.get(base) {
        if *count == 0 {
            return base.to_string();
        }
        format!("{}-{}", base, count + 1)
    } else {
        base.to_string()
    }
}
