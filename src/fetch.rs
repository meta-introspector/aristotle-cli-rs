/// fetch — Incremental Aristotle sync (git-fetch style).
/// Polls the project listing for every configured API account (upstream repo),
/// downloads only new or updated results, then git-versions them.
use std::collections::{HashMap, HashSet};
use std::fs;
use std::time::Duration;

use anyhow::Context;
use tracing::{instrument, warn};

use crate::load_config;

/// Truthy value from the Aristotle API: booleans arrive as JSON bools or as
/// the strings "True"/"False"/"true"/"false"/"1"/"0".
fn json_truthy(v: &serde_json::Value) -> bool {
    match v {
        serde_json::Value::Bool(b) => *b,
        serde_json::Value::String(s) => matches!(
            s.trim().to_ascii_lowercase().as_str(),
            "true" | "1" | "yes" | "on"
        ),
        serde_json::Value::Number(n) => n.as_i64().map(|i| i != 0).unwrap_or(false),
        _ => false,
    }
}

/// Numeric value from the Aristotle API: numbers arrive as JSON numbers or as
/// decimal strings like "2".
fn json_i64(v: &serde_json::Value) -> Option<i64> {
    match v {
        serde_json::Value::Number(n) => n.as_i64(),
        serde_json::Value::String(s) => s.trim().parse::<i64>().ok(),
        _ => None,
    }
}

/// Public wrappers so other modules can parse the API's string-typed fields.
pub fn json_truthy_pub(v: &serde_json::Value) -> bool {
    json_truthy(v)
}

pub fn json_i64_pub(v: &serde_json::Value) -> Option<i64> {
    json_i64(v)
}

/// One page of the project listing for a single account.
struct ListPage {
    items: Vec<serde_json::Value>,
    next_key: Option<String>,
}

fn list_page_url(base_url: &str, pagination_key: Option<&str>) -> String {
    match pagination_key {
        Some(key) => format!("{}/project?pagination_key={}", base_url, key),
        None => format!("{}/project", base_url),
    }
}

/// GET one listing page with retry on 429 / transient errors.
async fn fetch_list_page(
    client: &reqwest::Client,
    url: &str,
    api_key: &str,
) -> anyhow::Result<ListPage> {
    let mut attempt = 0u32;
    loop {
        attempt += 1;
        let resp = client
            .get(url)
            .header("x-api-key", api_key)
            .header("Content-Type", "application/json")
            .send()
            .await
            .with_context(|| format!("Failed to request {}", url))?;

        let status = resp.status();
        if status.as_u16() == 429 || status.is_server_error() {
            if attempt >= 5 {
                anyhow::bail!("{} returned HTTP {} after {} attempts", url, status, attempt);
            }
            let wait = Duration::from_secs(2u64.saturating_pow(attempt.min(6)));
            warn!(url = %url, http_status = %status, wait_secs = wait.as_secs(), "Listing request throttled, retrying");
            tokio::time::sleep(wait).await;
            continue;
        }

        let data: serde_json::Value = resp
            .json()
            .await
            .with_context(|| format!("Failed to parse listing JSON from {}", url))?;
        let items = data
            .get("projects")
            .and_then(|d| d.as_array())
            .cloned()
            .unwrap_or_default();
        let next_key = data["pagination_key"].as_str().map(|s| s.to_string());
        return Ok(ListPage { items, next_key });
    }
}

/// Enumerate all pages of the project listing for one API key.
/// Stops when the server stops returning `pagination_key`, when the key stops
/// changing, or after `max_pages` (guard against pagination loops).
async fn list_all_pages(
    client: &reqwest::Client,
    base_url: &str,
    api_key: &str,
    max_pages: u32,
) -> anyhow::Result<Vec<serde_json::Value>> {
    let mut all: Vec<serde_json::Value> = Vec::new();
    let mut pagination_key: Option<String> = None;

    for _ in 0..max_pages {
        let url = list_page_url(base_url, pagination_key.as_deref());
        let page = fetch_list_page(client, &url, api_key).await?;
        if page.items.is_empty() {
            break;
        }
        all.extend(page.items);

        let next = page.next_key;
        match next {
            Some(k) if Some(&k) != pagination_key.as_ref() => pagination_key = Some(k),
            _ => break,
        }

        // Be gentle on the API.
        tokio::time::sleep(Duration::from_millis(200)).await;
    }

    Ok(all)
}

/// The accounts (upstream repos) whose project listings should be polled.
/// With multiple accounts configured, each sees a disjoint set of projects.
fn upstream_accounts() -> anyhow::Result<Vec<(String, String)>> {
    let (accounts, default) = crate::accounts::load_accounts()?;
    if accounts.is_empty() {
        // Legacy single-key mode.
        return Ok(vec![("default".to_string(), crate::get_api_key()?)]);
    }
    let mut out = Vec::new();
    for a in &accounts {
        let key = a.effective_key().unwrap_or_else(|e| {
            warn!(account = %a.name, error = %e, "Skipping account with unreadable key");
            String::new()
        });
        if key.is_empty() {
            continue;
        }
        out.push((a.name.clone(), key));
    }
    if out.is_empty() {
        anyhow::bail!("no usable API accounts configured");
    }
    let _ = default;
    Ok(out)
}

/// Run a lightweight incremental fetch: poll API, download only new/changed, version.
///
/// `all_history`: ignore the recency window and page through the complete
/// listing of every account, so nothing upstream is ever skipped.
#[instrument(skip(parallel, limit, recent_days, project_id))]
pub async fn cmd_fetch(
    parallel: usize,
    limit: Option<usize>,
    dry_run: bool,
    recent_days: u64,
    project_id: Option<String>,
    all_history: bool,
) -> anyhow::Result<()> {
    let _ = parallel; // downloads are serialized with a polite rate limit
    let config = load_config()?;
    let results_dir = config.results_dir.clone();
    fs::create_dir_all(&results_dir)?;

    let base_url = crate::API_BASE_URL;
    let client = reqwest::Client::builder()
        .timeout(Duration::from_secs(300))
        .build()
        .context("Failed to build HTTP client")?;
    let api_key = crate::get_api_key()?;

    // ── Single-project fetch ────────────────────────────────────────────
    if let Some(pid) = project_id {
        println!("Fetching single project: {}", pid);
        let project_dir = results_dir.join(format!("{}_aristotle", pid));
        if project_dir.exists() && !all_history {
            println!("Project already downloaded: {}", project_dir.display());
        } else {
            println!("Downloading project {}...", pid);
            // Try the default key first; on Forbidden, retry with each other
            // account until one can read the project.
            let mut last_err: Option<anyhow::Error> = None;
            for (name, key) in upstream_accounts()? {
                match crate::download_single_result(
                    &client,
                    &key,
                    &pid,
                    &results_dir,
                    &results_dir,
                    config.retry_wait_seconds,
                    config.max_retries,
                )
                .await
                {
                    Ok(_) => {
                        println!(
                            "Downloaded to: {} (account {})",
                            results_dir.join(format!("{}_aristotle", pid)).display(),
                            name
                        );
                        return Ok(());
                    }
                    Err(e) => {
                        let msg = format!("{}", e);
                        if msg.contains("403") || msg.to_lowercase().contains("forbidden") {
                            last_err = Some(e);
                            continue;
                        }
                        return Err(e);
                    }
                }
            }
            return Err(last_err.unwrap_or_else(|| anyhow::anyhow!(
                "no account could download project {}",
                pid
            )));
        }
        return Ok(());
    }

    println!("=== Aristotle Fetch (incremental) ===");

    let cutoff = chrono::Utc::now() - chrono::Duration::days(recent_days as i64);
    let cutoff_str = cutoff.to_rfc3339();
    if all_history {
        println!("  Mode: ALL history (recency window disabled)");
    } else {
        println!("  Recent cutoff: {} ({} days back)", cutoff_str, recent_days);
    }

    // ── Step 1: Discover already-downloaded project IDs + timestamps ────
    // Both layouts exist on disk: `<id>_aristotle/` (canonical) and bare
    // `<id>/` extraction dirs. Either counts as "already downloaded".
    let mut existing: HashSet<String> = HashSet::new();
    let mut existing_time: HashMap<String, String> = HashMap::new();
    if results_dir.exists() {
        for entry in fs::read_dir(&results_dir)? {
            let entry = entry?;
            if !entry.file_type()?.is_dir() {
                continue;
            }
            let name_str = entry.file_name().to_string_lossy().into_owned();
            let id = if let Some(id) = name_str.strip_suffix("_aristotle") {
                id.to_string()
            } else if is_uuid_like(&name_str) {
                name_str.clone()
            }
            else {
                continue;
            };
            if existing.insert(id.clone()) {
                // Prefer the canonical dir's metadata when both layouts exist.
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
    println!("  Existing projects: {}", existing.len());

    // ── Step 2: Poll the project listing of every upstream account ──────
    let accounts = upstream_accounts()?;
    println!(
        "  Upstream accounts: {} ({})",
        accounts.len(),
        accounts
            .iter()
            .map(|(n, _)| n.as_str())
            .collect::<Vec<_>>()
            .join(", ")
    );

    let mut all_projects: Vec<serde_json::Value> = Vec::new();
    let mut seen_ids: HashSet<String> = HashSet::new();
    // Remember which upstream account owns each project — results can only be
    // downloaded with the owning account's key (cross-account is Forbidden).
    let mut account_of: HashMap<String, String> = HashMap::new();
    let mut key_of_account: HashMap<String, String> = HashMap::new();
    for (account_name, account_key) in &accounts {
        key_of_account.insert(account_name.clone(), account_key.clone());
        let pages = if all_history { 1000 } else { 1000 };
        match list_all_pages(&client, base_url, account_key, pages).await {
            Ok(items) => {
                let mut fresh = 0usize;
                for it in &items {
                    if let Some(id) = it["project_id"].as_str() {
                        if seen_ids.insert(id.to_string()) {
                            account_of.insert(id.to_string(), account_name.clone());
                            fresh += 1;
                        }
                    }
                }
                println!(
                    "    [{}] {} projects ({} new vs other accounts)",
                    account_name,
                    items.len(),
                    fresh
                );
                all_projects.extend(items);
            }
            Err(e) => {
                warn!(account = %account_name, error = %e, "Failed to list projects; continuing with other accounts");
                eprintln!("  WARNING: account '{}' listing failed: {}", account_name, e);
            }
        }
        tokio::time::sleep(Duration::from_millis(300)).await;
    }

    // Save the aggregated project list like poll/download do.
    let projects_path = crate::config::config_path()
        .ok()
        .and_then(|p| p.parent().map(|d| d.to_path_buf()));
    let list_path = match projects_path {
        Some(dir) => dir.join("aristotle_projects.json"),
        None => results_dir.join("aristotle_projects.json"),
    };
    // The historical location is the repo results dir; keep writing there too.
    let list_json = serde_json::json!({
        "projects": all_projects,
        "total": all_projects.len()
    });
    fs::write(&list_path, serde_json::to_string_pretty(&list_json)?)?;
    println!(
        "  Saved project list ({} projects) to {}",
        all_projects.len(),
        list_path.display()
    );

    // ── Step 3: Select new/updated projects ─────────────────────────────
    let mut new_projects: Vec<serde_json::Value> = Vec::new();
    for item in &all_projects {
        let id = item["project_id"].as_str().unwrap_or("");
        if id.is_empty() {
            continue;
        }
        // has_files arrives as JSON bool or string "True" — accept both.
        if !json_truthy(&item["has_files"]) {
            continue;
        }
        let last_updated = item["last_updated"].as_str().unwrap_or("");
        if !all_history && last_updated < cutoff_str.as_str() {
            continue;
        }
        let is_new = !existing.contains(id);
        let is_updated = match existing_time.get(id) {
            Some(extracted) => last_updated > extracted.as_str(),
            None => existing.contains(id),
        };
        if is_new || is_updated {
            new_projects.push(item.clone());
        }
    }
    // Dedup by project id (accounts can overlap).
    {
        let mut seen = HashSet::new();
        new_projects.retain(|p| seen.insert(p["project_id"].as_str().unwrap_or("").to_string()));
    }
    if let Some(max) = limit {
        new_projects.truncate(max);
    }
    println!("  New/updated projects: {}", new_projects.len());

    if dry_run {
        println!("\n  Dry run — would download:");
        for p in new_projects.iter().take(10) {
            let id = p["project_id"].as_str().unwrap_or("?");
            let desc = p["description"].as_str().unwrap_or("").lines().next().unwrap_or("");
            let updated = p["last_updated"].as_str().unwrap_or("?");
            println!(
                "    {} — {} — {}",
                id,
                updated.chars().take(19).collect::<String>(),
                desc.chars().take(60).collect::<String>()
            );
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

    // ── Step 4: Download new projects ───────────────────────────────────
    // delegate to download_single_result so behavior matches `download-result`
    // (status wait, retry, canonical extraction + metadata).
    println!("\n  Downloading {} projects...", new_projects.len());
    let mut downloaded = 0u64;
    let mut failed = 0u64;
    for (i, project) in new_projects.iter().enumerate() {
        let id = project["project_id"].as_str().unwrap_or("?");
        // Use the owning account's key; fall back to the default key.
        let owner = account_of.get(id).cloned().unwrap_or_default();
        let dl_key = key_of_account
            .get(&owner)
            .cloned()
            .unwrap_or_else(|| api_key.clone());
        match crate::download_single_result(
            &client,
            &dl_key,
            id,
            &results_dir,
            &results_dir,
            config.retry_wait_seconds,
            config.max_retries,
        )
        .await
        {
            Ok(_) => {
                downloaded += 1;
                if (i + 1) % 10 == 0 {
                    println!("    [{}/{}] downloaded", i + 1, new_projects.len());
                }
            }
            Err(e) => {
                warn!(project = %id, error = %e, "Download failed");
                eprintln!("    FAILED {}: {}", id, e);
                failed += 1;
            }
        }

        // Rate limit.
        tokio::time::sleep(Duration::from_millis(200)).await;
    }

    println!("\n=== Fetch Complete ===");
    println!("  Downloaded: {}", downloaded);
    println!("  Failed:     {}", failed);

    // ── Step 5: Git version the new results ─────────────────────────────
    if downloaded > 0 {
        println!("\n  Versioning new results...");
        crate::version::cmd_version(Some(config.results_dir.clone()), Some(config.git_base.clone()))?;
    }

    Ok(())
}

/// Loose UUID check: 8+ hex chars with a dash at position 8 (36-char UUIDs and
/// some prefixed variants). Matches the heuristic in main.rs `is_uuid_like`.
fn is_uuid_like(s: &str) -> bool {
    let chars: Vec<char> = s.chars().collect();
    if chars.len() < 36 {
        return false;
    }
    chars.iter().take(8).all(|c| c.is_ascii_hexdigit()) && chars.get(8) == Some(&'-')
}

#[cfg(test)]
mod tests {
    use super::{json_i64, json_truthy};
    use serde_json::json;

    #[test]
    fn truthy_accepts_json_bools_and_string_booleans() {
        assert!(json_truthy(&json!(true)));
        assert!(!json_truthy(&json!(false)));
        assert!(json_truthy(&json!("True")));
        assert!(json_truthy(&json!("true")));
        assert!(json_truthy(&json!(" 1 ")));
        assert!(!json_truthy(&json!("False")));
        assert!(!json_truthy(&json!("false")));
        assert!(!json_truthy(&json!("0")));
        assert!(!json_truthy(&json!("")));
        assert!(!json_truthy(&serde_json::Value::Null));
    }

    #[test]
    fn i64_accepts_numbers_and_numeric_strings() {
        assert_eq!(json_i64(&json!(2)), Some(2));
        assert_eq!(json_i64(&json!("2")), Some(2));
        assert_eq!(json_i64(&json!(1)), Some(1));
        assert_eq!(json_i64(&json!("abc")), None);
        assert_eq!(json_i64(&serde_json::Value::Null), None);
    }
}
