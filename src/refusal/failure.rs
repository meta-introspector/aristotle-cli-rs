use super::{safe_truncate, FailureEntry};
use anyhow::Result;
use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use walkdir::WalkDir;

const REFUSAL_MARKERS: &[&str] = &[
    "fabricate",
    "cannot be produced",
    "evocative poetry",
    "not a well-posed",
    "no actual constraint",
    "nothing actionable",
    "nothing concrete",
    "won't fabricate",
    "can't truthfully",
    "not well-posed",
];

const SUCCESS_MARKERS: &[&str] = &[
    "builds cleanly",
    "builds successfully",
    "no sorry",
    "0 sorry",
    "formalized",
    "proved",
    "verified",
    "machine-checked",
    "added",
    "new file",
    "new declarations",
];

const SCAFFOLD_MARKERS: &[&str] = &[
    "only boilerplate",
    "only imports",
    "just imports",
    "no definitions",
    "empty skeleton",
    "no task description",
    "nothing to add or fix",
];

const MYSTICAL_MARKERS: &[(&str, &str)] = &[
    ("dao", "Tao Te Ching / Daoist philosophy"),
    ("tao", "Tao Te Ching / Daoist philosophy"),
    ("chapter", "Chapter-structured text"),
    ("zappa", "Zappa / Moonshine Sofa"),
    ("sofa", "Moonshine Sofa"),
    ("moonshine", "Monstrous Moonshine"),
    ("transmission", "Transmission Omega"),
    ("godel", "Gödel encoding"),
    ("zownakairufication", "Zownakairufication fixed-point"),
    ("shem", "Shem HaMephorash / Kabbalah"),
    ("kabbalah", "Kabbalah mysticism"),
    ("cosmos", "Cosmological ontology"),
    ("sage", "Philosophical text"),
    ("heaven", "Religious/mystical text"),
    ("angel", "Angelic hierarchies"),
    ("exodus", "Biblical text"),
    ("betti", "Betti diagrams / math"),
    ("crt", "Chinese Remainder Theorem"),
    ("jaccard", "Jaccard similarity"),
    ("decoder", "Decoder ring"),
];

fn classify_run(text: &str) -> &'static str {
    let tl = text.to_lowercase();
    let refusal_score = REFUSAL_MARKERS.iter().filter(|m| tl.contains(*m)).count();
    let success_score = SUCCESS_MARKERS.iter().filter(|m| tl.contains(*m)).count();
    let scaffold_score = SCAFFOLD_MARKERS.iter().filter(|m| tl.contains(*m)).count();

    if scaffold_score > success_score {
        "scaffold"
    } else if refusal_score > 0 && success_score == 0 {
        "refusal"
    } else if refusal_score > 0 && success_score > 0 {
        "partial"
    } else if success_score > 0 {
        "success"
    } else {
        "unknown"
    }
}

fn extract_mystical(text: &str) -> Vec<String> {
    let tl = text.to_lowercase();
    let mut found = Vec::new();
    for (key, label) in MYSTICAL_MARKERS {
        if tl.contains(key) && !found.contains(&label.to_string()) {
            found.push(label.to_string());
        }
    }
    if found.is_empty() {
        found.push("pure-math".to_string());
    }
    found
}

fn split_runs(text: &str) -> Vec<String> {
    let mut runs = Vec::new();
    let mut current = Vec::new();
    for line in text.lines() {
        if line.starts_with("# Summary of changes for run ") {
            if !current.is_empty() {
                runs.push(current.join("\n"));
            }
            current = vec![line.to_string()];
        } else if !current.is_empty() {
            current.push(line.to_string());
        }
    }
    if !current.is_empty() {
        runs.push(current.join("\n"));
    }
    runs
}

pub fn build_failure_corpus(base_dir: &str, output_jsonl: &str) -> Result<()> {
    let base = PathBuf::from(base_dir);
    let mut entries = Vec::new();

    for entry in WalkDir::new(&base)
        .min_depth(1)
        .max_depth(5)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir())
    {
        let name = entry.file_name().to_string_lossy();
        if !name.ends_with("_aristotle") {
            continue;
        }
        let sid = name[..name.len().min(8)].to_string();

        let summary_path = entry
            .path()
            .join("output-final_aristotle")
            .join("ARISTOTLE_SUMMARY.md");
        let mut actual_summary = None;
        for item in WalkDir::new(entry.path())
            .max_depth(2)
            .into_iter()
            .filter_map(|e| e.ok())
        {
            if item.file_name() == "ARISTOTLE_SUMMARY.md" {
                actual_summary = Some(item.path().to_path_buf());
                break;
            }
        }
        let Some(summary_path) = actual_summary else {
            continue;
        };

        let text = fs::read_to_string(&summary_path)?;
        let runs = split_runs(&text);

        let status_path = entry.path().join("aristotle_status.json");
        let status: HashMap<String, String> = if status_path.exists() {
            let raw = fs::read_to_string(&status_path)?;
            serde_json::from_str(&raw).unwrap_or_default()
        } else {
            HashMap::new()
        };

        let description = status.get("description").cloned().unwrap_or_default();
        let created_at = status.get("created_at").cloned().unwrap_or_default();

        let lean_count = WalkDir::new(entry.path())
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
            .count();

        for (i, run) in runs.iter().enumerate() {
            let classification = classify_run(run);
            if classification == "success" {
                continue;
            }
            let header = run.lines().next().unwrap_or("no-header").to_string();
            let themes = extract_mystical(run);

            entries.push(FailureEntry {
                project_id: sid.clone(),
                run_index: i,
                run_header: header,
                classification: classification.to_string(),
                description: description.clone(),
                created_at: created_at.clone(),
                mystical_themes: themes,
                lean_files_count: lean_count,
                summary_excerpt: safe_truncate(run, run.len().min(1500)).to_string(),
            });
        }
    }

    entries.sort_by(|a, b| {
        a.project_id
            .cmp(&b.project_id)
            .then(a.run_index.cmp(&b.run_index))
    });

    let mut by_class: HashMap<String, usize> = HashMap::new();
    for e in &entries {
        *by_class.entry(e.classification.clone()).or_default() += 1;
    }

    let mut out = fs::File::create(output_jsonl)?;
    use std::io::Write;
    for e in &entries {
        let line = serde_json::to_string(e)?;
        writeln!(out, "{}", line)?;
    }

    eprintln!(
        "Failure corpus: {} entries (non-success runs only)",
        entries.len()
    );
    for (cls, count) in by_class {
        eprintln!("  {}: {}", cls, count);
    }
    eprintln!("Written to {}", output_jsonl);

    for e in &entries {
        if e.classification == "refusal" {
            eprintln!(
                "  [{}] run {} — {:?}",
                e.project_id, e.run_index, e.mystical_themes
            );
            let header_preview = &e.run_header[..e.run_header.len().min(120)];
            eprintln!("    {}", header_preview);
        }
    }

    Ok(())
}
