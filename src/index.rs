/// Index module — scans Aristotle run directories and produces
/// DASL-compatible blocks.json with metadata and categories.

use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
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

/// Read the run's summary: prefer top-level ARISTOTLE_SUMMARY.md, fall back to
/// output-final_aristotle/ARISTOTLE_SUMMARY.md where the real summaries live.
fn read_summary(run_dir: &Path) -> String {
    let top = run_dir.join("ARISTOTLE_SUMMARY.md");
    if top.exists() {
        if let Ok(t) = fs::read_to_string(&top) {
            if !t.trim().is_empty() {
                return t;
            }
        }
    }
    let nested = run_dir.join("output-final_aristotle").join("ARISTOTLE_SUMMARY.md");
    if nested.exists() {
        if let Ok(t) = fs::read_to_string(&nested) {
            return t;
        }
    }
    String::new()
}

/// Collect RequestProject *.lean basenames (both top-level and output-final layouts).
fn collect_lean_names(run_dir: &Path) -> Vec<String> {
    let mut names = Vec::new();
    let mut roots = vec![run_dir.join("RequestProject")];
    let of = run_dir.join("output-final_aristotle");
    if of.exists() {
        roots.push(of.join("RequestProject"));
    }
    for root in roots {
        if let Ok(entries) = fs::read_dir(&root) {
            for e in entries.flatten() {
                let p = e.path();
                if p.extension().map(|x| x == "lean").unwrap_or(false) {
                    if let Some(n) = p.file_stem().and_then(|s| s.to_str()) {
                        names.push(n.to_string());
                    }
                }
            }
        }
    }
    names
}

/// DASL/IPLD signal from lean file names (DagCbor*, DASL*, CID*, CBOR*, CAR*, DRISL*).
fn lean_names_hint_dasl(names: &[String]) -> bool {
    names.iter().any(|n| {
        let l = n.to_lowercase();
        l.contains("dasl") || l.contains("dagcbor") || l.contains("cbor")
            || l.contains("ipld") || l.contains("drisl") || l.contains("carheader")
            || l.contains("cid") || l.contains("multihash") || l.contains("shmem")
            || l.contains("fuzz") || l.contains("dag_")
    })
}

/// Load aristo-projects.json track->main_project-id map for authoritative seeding.
fn load_track_main_ids() -> HashMap<String, String> {
    let mut map = HashMap::new();
    let candidates = vec![
        PathBuf::from("/mnt/data1/dasl-planning2/aristo-projects.json"),
        PathBuf::from("aristo-projects.json"),
    ];
    for cand in candidates {
        if !cand.exists() {
            continue;
        }
        if let Ok(text) = fs::read_to_string(&cand) {
            if let Ok(v) = serde_json::from_str::<serde_json::Value>(&text) {
                if let Some(tracks) = v["tracks"].as_array() {
                    for t in tracks {
                        let track = t["track"].as_str().unwrap_or("");
                        let id = t["main_project"]["id"].as_str().unwrap_or("");
                        if !track.is_empty() && !id.is_empty() {
                            map.insert(id.to_string(), track.to_string());
                        }
                    }
                }
            }
        }
        break;
    }
    map
}

/// Category for a known track from the manifest (seeded regardless of content).
fn track_category(track: &str) -> &'static str {
    match track {
        "dasl" => "DASL/IPLD",
        "drisl" => "DASL/IPLD",
        "solfunmeme" => "MATH/MONSTER",
        _ => "MATH/OTHER",
    }
}

#[instrument(skip(output))]
pub fn cmd_index(output: Option<PathBuf>) -> anyhow::Result<()> {
    let config = load_config()?;
    let output_path = output.unwrap_or_else(|| config.results_dir.join("aristotle-blocks.json"));
    let track_map = load_track_main_ids();

    // Source directories to scan
    let source_dirs: Vec<(&str, PathBuf)> = vec![
        ("aristotle_results", config.results_dir.clone()),
        ("arist", config.base_dir.clone()),
    ];

    // Deduplicate identical dirs (results_dir may equal base_dir) so each
    // unique run is indexed exactly once.
    let mut seen_dirs: std::collections::HashSet<PathBuf> = std::collections::HashSet::new();
    let mut unique_sources: Vec<(&str, PathBuf)> = Vec::new();
    for (name, dir) in &source_dirs {
        let canon = std::fs::canonicalize(dir).unwrap_or_else(|_| dir.clone());
        if seen_dirs.insert(canon) {
            unique_sources.push((name, dir.clone()));
        }
    }

    let mut blocks: Vec<serde_json::Value> = Vec::new();
    let mut stats: HashMap<String, usize> = HashMap::new();

    for (source_name, source_dir) in &unique_sources {
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
            let summary_text = read_summary(&path);
            let lean_names = collect_lean_names(&path);

            let title = extract_title(&summary_text, &run_id);
            let track = track_map.get(&run_id).map(|s| s.as_str()).unwrap_or("");
            let category = if !track.is_empty() {
                track_category(track)
            } else if lean_names_hint_dasl(&lean_names) {
                "DASL/IPLD"
            } else {
                categorize(&summary_text)
            };

            *stats.entry(category.to_string()).or_insert(0) += 1;

            let block = serde_json::json!({
                "path": format!("aristotle/{}/{}/{}", source_name, category, run_id),
                "description": title,
                "size": summary_text.len(),
                "lean_files": lean_names.len(),
                "cid": "",
                "read_only": false,
                "category": category,
                "track": track,
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

    #[test]
    fn test_lean_names_hint_dasl() {
        assert!(lean_names_hint_dasl(&["DagCborBranchCoverage".to_string()]));
        assert!(lean_names_hint_dasl(&["DaslStateRefresh".to_string(), "Main".to_string()]));
        assert!(!lean_names_hint_dasl(&["Main".to_string(), "GroupTheory".to_string()]));
        assert!(!lean_names_hint_dasl(&["Ring".to_string(), "Topology".to_string()]));
    }

    #[test]
    fn test_track_category() {
        assert_eq!(track_category("dasl"), "DASL/IPLD");
        assert_eq!(track_category("drisl"), "DASL/IPLD");
        assert_eq!(track_category("solfunmeme"), "MATH/MONSTER");
        assert_eq!(track_category("unknown"), "MATH/OTHER");
    }
}
