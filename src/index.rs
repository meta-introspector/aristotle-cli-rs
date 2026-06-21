/// Index module — scans Aristotle run directories and produces
/// DASL-compatible blocks.json with metadata and categories.

use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use anyhow::Context;
use tracing::{debug, info, instrument, warn};

use crate::load_config;

/// Categorize an Aristotle run by its summary content
fn categorize(summary_text: &str) -> &'static str {
    let t = summary_text.to_lowercase();

    // Monster group theory
    if ["monster group", "196883", "umbral", "moonshine", "leech lattice",
        "borcherds", "griess", "baby monster", "conway group"]
        .iter().any(|kw| t.contains(kw))
    {
        return "MATH/MONSTER";
    }

    // Finite simple groups
    if ["finite simple group", "cfsg", "sporadic group",
        "janko", "mathieu", "suzuki"]
        .iter().any(|kw| t.contains(kw))
    {
        return "MATH/CFSG";
    }

    // DASL / IPLD / CBOR
    if ["dasl", "ipld", "dag-cbor", "dag_cbor", "car file",
        "cid v1", "multihash", "cbor", "ipfs"]
        .iter().any(|kw| t.contains(kw))
    {
        return "DASL/IPLD";
    }

    // FRACTRAN
    if t.contains("fractran") {
        return "MATH/FRACTRAN";
    }

    // Lean 4 proofs
    if ["theorem", "lemma", "formalized", "verified"]
        .iter().any(|kw| t.contains(kw))
    {
        return "LEAN/PROOF";
    }

    // P-adic / number theory
    if ["p-adic", "bernoulli", "modular form", "l-function",
        "galois representation", "class field"]
        .iter().any(|kw| t.contains(kw))
    {
        return "MATH/ADVANCED";
    }

    // No action taken
    if ["no actionable", "skeleton only", "conceptual", "outside the scope"]
        .iter().any(|kw| t.contains(kw))
    {
        return "NO_ACTION";
    }

    "MATH/OTHER"
}

/// Extract a title from the summary text (first heading line)
fn extract_title(summary_text: &str, fallback: &str) -> String {
    for line in summary_text.lines() {
        let ls = line.trim();
        if ls.starts_with("# ") {
            // Get the first h1 heading
            return ls.trim_start_matches("# ").trim().to_string();
        }
    }
    // Fallback: first line of summary
    for line in summary_text.lines() {
        let ls = line.trim();
        if !ls.is_empty() && !ls.starts_with('#') {
            let short: String = ls.chars().take(80).collect();
            return short;
        }
    }
    fallback.chars().take(50).collect()
}

#[instrument(skip(output))]
pub fn cmd_index(output: Option<PathBuf>) -> anyhow::Result<()> {
    let config = load_config()?;
    let output_path = output.unwrap_or_else(|| config.results_dir.join("aristotle-blocks.json"));

    // Source directories to scan
    let source_dirs: Vec<(&str, PathBuf)> = vec![
        ("aristotle_results", config.results_dir.clone()),
        ("arist", config.base_dir.clone()),
    ];

    let mut blocks: Vec<serde_json::Value> = Vec::new();
    let mut stats: HashMap<String, usize> = HashMap::new();

    for (source_name, source_dir) in &source_dirs {
        if !source_dir.exists() {
            warn!(dir = %source_dir.display(), "Source directory does not exist");
            continue;
        }

        let entries = match fs::read_dir(source_dir) {
            Ok(e) => e,
            Err(e) => {
                warn!(dir = %source_dir.display(), error = %e, "Cannot read source directory");
                continue;
            }
        };

        for entry in entries {
            let entry = match entry {
                Ok(e) => e,
                Err(_) => continue,
            };
            let path = entry.path();
            if !path.is_dir() {
                continue;
            }
            let name = match path.file_name().and_then(|n| n.to_str()) {
                Some(n) => n,
                None => continue,
            };
            if !name.ends_with("_aristotle") {
                continue;
            }

            let run_id = name.trim_end_matches("_aristotle").to_string();
            let summary_path = path.join("ARISTOTLE_SUMMARY.md");

            let summary_text = if summary_path.exists() {
                fs::read_to_string(&summary_path).unwrap_or_default()
            } else {
                String::new()
            };

            let title = extract_title(&summary_text, &run_id);
            let category = categorize(&summary_text);

            *stats.entry(category.to_string()).or_insert(0) += 1;

            let block = serde_json::json!({
                "path": format!("aristotle/{}/{}/{}", source_name, category, run_id),
                "description": title,
                "size": summary_text.len(),
                "cid": "",
                "read_only": false,
                "category": category,
            });

            blocks.push(block);
            debug!(id = %run_id, category, "Indexed aristotle run");
        }
    }

    // Sort blocks by path for deterministic output
    blocks.sort_by(|a, b| {
        a["path"].as_str().cmp(&b["path"].as_str())
    });

    // Write output
    let json_str = serde_json::to_string_pretty(&blocks)
        .context("Failed to serialize blocks to JSON")?;
    fs::write(&output_path, &json_str)?;

    // Summary
    info!(total = blocks.len(), path = %output_path.display(), "Index complete");
    println!("=== Aristotle Results Index ===");
    println!("  Total runs indexed: {}", blocks.len());
    println!("  Output: {}", output_path.display());
    println!("  Size:   {} bytes", json_str.len());
    println!();

    let mut sorted_cats: Vec<_> = stats.iter().collect();
    sorted_cats.sort_by(|a, b| b.1.cmp(a.1));
    for (cat, cnt) in &sorted_cats {
        let bar = "█".repeat(std::cmp::max(1, *cnt / 5));
        println!("  {:30} {:>4}  {}", cat, cnt, bar);
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_categorize_monster() {
        let text = "The Monster group has 194 conjugacy classes and dimension 196883.";
        assert_eq!(categorize(text), "MATH/MONSTER");
    }

    #[test]
    fn test_categorize_dasl() {
        let text = "DASL CBOR decoding with IPLD CAR file format and CID v1.";
        assert_eq!(categorize(text), "DASL/IPLD");
    }

    #[test]
    fn test_categorize_lean_proof() {
        let text = "The theorem is formalized and verified in Lean 4.";
        assert_eq!(categorize(text), "LEAN/PROOF");
    }

    #[test]
    fn test_categorize_no_action() {
        let text = "No actionable Lean formalization task. Conceptual only.";
        assert_eq!(categorize(text), "NO_ACTION");
    }

    #[test]
    fn test_categorize_other() {
        let text = "Random mathematical musings about unknown topics.";
        assert_eq!(categorize(text), "MATH/OTHER");
    }

    #[test]
    fn test_extract_title() {
        let text = "# Umbral Moonshine Conjecture — Formalization Complete\n\nSome body text.";
        assert_eq!(extract_title(text, "fallback"), "Umbral Moonshine Conjecture — Formalization Complete");
    }
}
