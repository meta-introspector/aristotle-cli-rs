use anyhow::{Context, Result};
use std::fs;
use std::path::PathBuf;
use serde::{Deserialize, Serialize};
use tracing::{debug, info, instrument, warn};
use walkdir::WalkDir;

#[derive(Debug, Serialize, Deserialize)]
struct AristotleMetadata {
    extracted_at: chrono::DateTime<chrono::Utc>,
    project_dir: PathBuf,
}

fn is_text_file(path: &PathBuf) -> bool {
    let extension = match path.extension().and_then(|s| s.to_str()) {
        Some(ext) => ext.to_lowercase(),
        None => return false,
    };

    let text_extensions = [
        "txt", "md", "lean", "rs", "toml", "json", "yaml", "yml", "sh", 
        "py", "js", "ts", "html", "css", "xml", "log", "ini", "cfg", "conf"
    ];
    let binary_extensions = [
        "png", "jpg", "jpeg", "gif", "bmp", "ico", "pdf", "zip", "gz", 
        "tar", "rar", "7z", "exe", "dll", "so", "a", "o", "class", "jar",
        "mp3", "wav", "mp4", "mkv", "avi", "mov", "webm", "flac"
    ];

    if binary_extensions.contains(&extension.as_str()) {
        return false;
    }
    if text_extensions.contains(&extension.as_str()) {
        return true;
    }
    
    false
}

#[instrument(skip(project_dir))]
pub fn cmd_notebooklm(project_dir: &PathBuf) -> Result<()> {
    const WORD_LIMIT: usize = 500_000;
    
    info!(project = %project_dir.display(), "Starting notebooklm command");

    let metadata_path = project_dir.join("aristotle_metadata.json");
    if !metadata_path.exists() {
        return Err(anyhow::anyhow!("aristotle_metadata.json not found in project directory"));
    }
    let metadata_content = fs::read_to_string(&metadata_path)?;
    let metadata: AristotleMetadata = serde_json::from_str(&metadata_content)?;

    let home_dir = dirs::home_dir().context("Could not determine home directory")?;
    let project_name = metadata.project_dir.file_name()
        .and_then(|s| s.to_str())
        .unwrap_or("unknown_project");
    let output_dir = home_dir
        .join("notebooklm")
        .join("2026")
        .join(metadata.extracted_at.format("%Y-%m-%d").to_string())
        .join(project_name);
    
    fs::create_dir_all(&output_dir)?;
    info!(output_dir = %output_dir.display(), "Created output directory");

    let mut buffer = String::new();
    let mut word_count = 0;
    let mut part_number = 1;

    for entry in WalkDir::new(project_dir).into_iter().filter_map(|e| e.ok()) {
        let path = entry.into_path();
        if path.is_file() && is_text_file(&path) {
            debug!(file = %path.display(), "Processing text file");
            
            let content = match fs::read_to_string(&path) {
                Ok(c) => c,
                Err(e) => {
                    warn!(file = %path.display(), error = %e, "Failed to read file, skipping");
                    continue;
                }
            };
            
            let words: Vec<&str> = content.split_whitespace().collect();
            let new_word_count = words.len();

            if word_count + new_word_count > WORD_LIMIT && !buffer.is_empty() {
                let output_file_path = output_dir.join(format!("part_{}.txt", part_number));
                fs::write(&output_file_path, &buffer)?;
                info!(path = %output_file_path.display(), words = word_count, "Wrote part file");
                
                part_number += 1;
                buffer.clear();
                word_count = 0;
            }

            buffer.push_str(&format!("

--- Content from: {} ---

", path.display()));
            buffer.push_str(&content);
            word_count += new_word_count;
        }
    }

    if !buffer.is_empty() {
        let output_file_path = output_dir.join(format!("part_{}.txt", part_number));
        fs::write(&output_file_path, &buffer)?;
        info!(path = %output_file_path.display(), words = word_count, "Wrote final part file");
    }
    
    println!("NotebookLM export complete. Files are in: {}", output_dir.display());
    Ok(())
}
