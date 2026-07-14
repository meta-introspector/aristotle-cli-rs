/// fetch — Incremental Aristotle sync (git-fetch style).
/// Only downloads new or updated projects, then git-versions them.
use std::fs;
use std::collections::HashSet;
use crate::load_config;
use tracing::{instrument, warn};

/// Run a lightweight incremental fetch: poll API, download only new/changed, version.
#[instrument(skip(limit))]
pub async fn cmd_fetch(
    parallel: usize,
    limit: Option<usize>,
    dry_run: bool,
) -> anyhow::Result<()> {
    let config = load_config()?;
    let results_dir = &config.results_dir;
    fs::create_dir_all(results_dir)?;

    println!("=== Aristotle Fetch (incremental) ===");

    // Step 1: Discover already-downloaded project IDs + their extraction timestamps
    let mut existing: HashSet<String> = HashSet::new();
    let mut existing_time: std::collections::HashMap<String, String> = std::collections::HashMap::new();
    if results_dir.exists() {
        for entry in fs::read_dir(results_dir)? {
            let entry = entry?;
            if entry.file_type()?.is_dir() {
                let name = entry.file_name();
                let name_str = name.to_string_lossy();
                if name_str.ends_with("_aristotle") {
                    let id = name_str.trim_end_matches("_aristotle").to_string();
                    existing.insert(id.clone());
                    // Read metadata for extracted_at timestamp
                    let meta_path = entry.path().join("aristotle_metadata.json");
                    if let Ok(meta_str) = fs::read_to_string(&meta_path) {
                        if let Ok(meta) = serde_json::from_str::<serde_json::Value>(&meta_str) {
                            if let Some(ts) = meta["extracted_at"].as_str() {
                                existing_time.insert(id, ts.to_string());
                            }
                        }
                    }
                }
            }
        }
    }
    println!("  Existing projects: {}", existing.len());

    // Step 2: Poll API for latest project listing (minimal load)
    let client = reqwest::Client::new();
    let api_key = crate::get_api_key()?;
    let base_url = crate::API_BASE_URL;

    let mut new_projects: Vec<serde_json::Value> = Vec::new();
    let mut pagination_key: Option<String> = None;
    let mut page = 0u32;

    loop {
        page += 1;
        let url = if let Some(ref key) = pagination_key {
            format!("{}/project?pagination_key={}", base_url, key)
        } else {
            format!("{}/project", base_url)
        };

        let resp = client
            .get(&url)
            .header("x-api-key", &api_key)
            .header("Content-Type", "application/json")
            .send()
            .await?;

        let data: serde_json::Value = resp.json().await?;
        let items = match data.get("projects").and_then(|d| d.as_array()) {
            Some(arr) => arr.clone(),
            None => break,
        };

        if items.is_empty() {
            break;
        }

        let page_count = items.len();
        for item in &items {
            let id = item["project_id"].as_str().unwrap_or("");
            let has_files = item["has_files"].as_bool().unwrap_or(false);
            let last_updated = item["last_updated"].as_str().unwrap_or("");
            let is_new = !existing.contains(id);
            let is_updated = if let Some(extracted) = existing_time.get(id) {
                last_updated > extracted.as_str()
            } else {
                false
            };
            if has_files && (is_new || is_updated) {
                new_projects.push(item.clone());
            }
        }

        // Check for pagination
        let next_key = data["pagination_key"].as_str().map(|s| s.to_string());
        if next_key.is_none() || page_count == 0 {
            break;
        }
        if pagination_key.as_deref() == next_key.as_deref() {
            break;
        }
        pagination_key = next_key;

        // Be gentle on the API
        tokio::time::sleep(std::time::Duration::from_millis(200)).await;
    }

    println!("  New/updated projects: {}", new_projects.len());

    if dry_run {
        println!("\n  Dry run — would download:");
        for p in new_projects.iter().take(10) {
            let id = p["project_id"].as_str().unwrap_or("?");
            let desc = p["description"].as_str().unwrap_or("").lines().next().unwrap_or("");
            let updated = p["last_updated"].as_str().unwrap_or("?");
            println!("    {} — {} — {}", id, updated.chars().take(19).collect::<String>(), desc.chars().take(60).collect::<String>());
        }
        if new_projects.len() > 10 {
            println!("    ... and {} more", new_projects.len() - 10);
        }
        return Ok(());
    }

    if new_projects.is_empty() {
        println!("\n  All up to date — nothing to fetch.");
        return Ok(());
    }

    // Step 3: Download only new projects
    println!("\n  Downloading {} projects...", new_projects.len());
    let mut downloaded = 0u64;
    let mut failed = 0u64;

    for (i, project) in new_projects.iter().enumerate() {
        let id = project["project_id"].as_str().unwrap_or("?");
        let url = format!("{}/project/{}/result", base_url, id);

        match client
            .get(&url)
            .header("x-api-key", &api_key)
            .send()
            .await
        {
            Ok(resp) if resp.status().is_success() => {
                let bytes = resp.bytes().await?;
                let output_path = results_dir.join(format!("{}_aristotle.tar.gz", id));
                fs::write(&output_path, &bytes)?;

                // Extract
                let extract_dir = results_dir.join(format!("{}_aristotle", id));
                if extract_dir.exists() {
                    fs::remove_dir_all(&extract_dir)?;
                }
                fs::create_dir_all(&extract_dir)?;

                let gz = flate2::read::GzDecoder::new(&bytes[..]);
                let mut archive = tar::Archive::new(gz);
                archive.unpack(&extract_dir)?;

                // Save metadata
                let metadata = serde_json::json!({
                    "download_url": url,
                    "extracted_at": chrono::Utc::now().to_rfc3339(),
                    "project_dir": format!("{}_aristotle", id),
                    "result_id": id,
                    "tarball_size_bytes": bytes.len(),
                });
                fs::write(
                    extract_dir.join("aristotle_metadata.json"),
                    serde_json::to_string_pretty(&metadata)?,
                )?;

                // Save status/description
                let description = project["description"].as_str().unwrap_or("");
                let status = serde_json::json!({
                    "created_at": project["created_at"],
                    "description": description,
                    "has_files": true,
                    "has_input": false,
                });
                fs::write(
                    extract_dir.join("aristotle_status.json"),
                    serde_json::to_string_pretty(&status)?,
                )?;

                downloaded += 1;
                if (i + 1) % 10 == 0 {
                    println!("    [{}/{}] downloaded", i + 1, new_projects.len());
                }
            }
            Ok(resp) => {
                warn!(project = %id, status = %resp.status(), "Download failed");
                failed += 1;
            }
            Err(e) => {
                warn!(project = %id, error = %e, "Download error");
                failed += 1;
            }
        }

        // Rate limit
        tokio::time::sleep(std::time::Duration::from_millis(200)).await;
    }

    println!("\n=== Fetch Complete ===");
    println!("  Downloaded: {}", downloaded);
    println!("  Failed:     {}", failed);

    // Step 4: Git version the new results
    if downloaded > 0 {
        println!("\n  Versioning new results...");
        crate::version::cmd_version(Some(config.results_dir.clone()), Some(config.git_base.clone()))?;
    }

    Ok(())
}
