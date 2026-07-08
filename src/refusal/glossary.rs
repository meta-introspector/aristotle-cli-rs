use super::{safe_slice, safe_truncate, GlossaryEntry, UsageContext};
use anyhow::Result;
use regex::Regex;
use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use walkdir::WalkDir;

const SKIP_TERMS: &[&str] = &[
    "lean",
    "mathlib",
    "requestproject",
    "namespace",
    "open",
    "import",
    "set_option",
    "theorem",
    "lemma",
    "def",
    "inductive",
    "structure",
    "axiom",
    "sorry",
    "propext",
    "classical",
    "quot",
    "fin",
    "nat",
    "int",
    "bool",
    "list",
    "string",
    "prop",
    "type",
    "true",
    "false",
    "and",
    "or",
    "not",
    "forall",
    "exists",
    "aristo",
    "aristotle",
    "svg",
    "html",
    "png",
    "xml",
    "lake",
    "lakefile",
    "toml",
    "also",
    "already",
    "always",
    "never",
    "sometimes",
    "often",
    "yet",
    "still",
    "really",
    "actually",
    "simply",
    "maybe",
    "probably",
    "certainly",
    "definitely",
    "clearly",
    "perhaps",
    "indeed",
    "however",
    "therefore",
    "thus",
    "hence",
    "consequently",
    "moreover",
    "furthermore",
    "nevertheless",
    "nonetheless",
    "because",
    "since",
    "although",
];

fn camel_case_regex() -> Regex {
    Regex::new(r"\b([A-Z][a-z]+[A-Z][a-zA-Z]*|[a-z]+[A-Z][a-zA-Z]*)\b").unwrap()
}
fn capitalized_regex() -> Regex {
    Regex::new(r"\b[A-Z][a-z]{3,}\b").unwrap()
}
fn compound_regex() -> Regex {
    Regex::new(r"\b[a-z]+[-–][a-z]+\b").unwrap()
}
fn backtick_regex() -> Regex {
    Regex::new(r"`([^`]+)`").unwrap()
}
fn underscore_regex() -> Regex {
    Regex::new(r"\b[a-z]+_[a-z]+\b").unwrap()
}

fn extract_terms(text: &str) -> Vec<String> {
    let mut found = Vec::new();
    let mut seen = std::collections::HashSet::new();

    for cap in camel_case_regex().find_iter(text) {
        let term = cap.as_str().to_string();
        let lower = term.to_lowercase();
        if !SKIP_TERMS.contains(&lower.as_str()) && term.len() > 3 && seen.insert(term.clone()) {
            found.push(term);
        }
    }

    for cap in backtick_regex().find_iter(text) {
        let term = cap
            .as_str()
            .trim_start_matches('`')
            .trim_end_matches('`')
            .to_string();
        let lower = term.to_lowercase();
        if !SKIP_TERMS.contains(&lower.as_str()) && term.len() > 2 && seen.insert(term.clone()) {
            found.push(term);
        }
    }

    for cap in capitalized_regex().find_iter(text) {
        let term = cap.as_str().to_string();
        let lower = term.to_lowercase();
        if !SKIP_TERMS.contains(&lower.as_str()) && seen.insert(term.clone()) {
            found.push(term);
        }
    }

    for cap in compound_regex().find_iter(text) {
        let term = cap.as_str().to_string();
        let lower = term.to_lowercase();
        if !SKIP_TERMS.contains(&lower.as_str()) && seen.insert(term.clone()) {
            found.push(term);
        }
    }

    for cap in underscore_regex().find_iter(text) {
        let term = cap.as_str().to_string();
        let lower = term.to_lowercase();
        if !SKIP_TERMS.contains(&lower.as_str()) && seen.insert(term.clone()) {
            found.push(term);
        }
    }

    found
}

fn context_for_term(text: &str, term: &str, window: usize) -> Vec<String> {
    let mut contexts = Vec::new();
    let mut idx = 0;
    while let Some(found) = text[idx..].find(term) {
        let abs_idx = idx + found;
        let start = abs_idx.saturating_sub(window);
        let end = (text.len()).min(abs_idx + term.len() + window);
        let ctx = safe_slice(text, start, end).trim().to_string();
        if !ctx.is_empty() {
            contexts.push(ctx);
        }
        idx = abs_idx + term.len();
        if idx >= text.len() {
            break;
        }
    }
    contexts.into_iter().take(5).collect()
}

fn categorize_term(term: &str) -> Vec<String> {
    let mut cats = Vec::new();
    let lower = term.to_lowercase();

    if [
        "godel", "hash", "crt", "prime", "factor", "mod", "residue", "cipher", "encrypt", "decode",
        "decoder", "crypto", "ring", "key", "shard",
    ]
    .iter()
    .any(|kw| lower.contains(kw))
    {
        cats.push("cryptographic".to_string());
    }
    if [
        "spoke",
        "transmission",
        "omega",
        "zownakairufication",
        "kryptoeffnung",
        "moonshine",
        "sofa",
        "bott",
        "periodicity",
        "hecke",
        "griess",
        "monster",
    ]
    .iter()
    .any(|kw| lower.contains(kw))
    {
        cats.push("gnostic/mystical".to_string());
    }
    if [
        "sheaf",
        "section",
        "lattice",
        "betti",
        "matrix",
        "vector",
        "graph",
        "representation",
        "irrep",
        "functor",
        "category",
        "skeleton",
    ]
    .iter()
    .any(|kw| lower.contains(kw))
    {
        cats.push("mathematical".to_string());
    }
    if [
        "statute",
        "law",
        "nj",
        "rullca",
        "bill",
        "federal",
        "legal",
        "citation",
        "solfunmeme",
    ]
    .iter()
    .any(|kw| lower.contains(kw))
    {
        cats.push("legal".to_string());
    }
    if [
        "dao", "tao", "cosmos", "sage", "heaven", "virtue", "shem", "kabbalah", "exodus", "angel",
    ]
    .iter()
    .any(|kw| lower.contains(kw))
    {
        cats.push("philosophical/religious".to_string());
    }
    if [
        "ipld", "car", "shmem", "cid", "http", "rest", "api", "json", "rust", "python", "nix",
    ]
    .iter()
    .any(|kw| lower.contains(kw))
    {
        cats.push("engineering".to_string());
    }

    if cats.is_empty() {
        cats.push("uncategorized".to_string());
    }
    cats
}

pub fn build_glossary(base_dir: &str, output_json: &str) -> Result<()> {
    let base = PathBuf::from(base_dir);
    let mut term_counter: HashMap<String, usize> = HashMap::new();
    let mut term_contexts: HashMap<String, Vec<UsageContext>> = HashMap::new();

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

        for item in WalkDir::new(entry.path())
            .into_iter()
            .filter_map(|e| e.ok())
        {
            let path = item.path();
            if !path.is_file() {
                continue;
            }
            let ext = path.extension().and_then(|e| e.to_str());
            let text = match ext {
                Some("lean") => {
                    let raw = fs::read_to_string(path).unwrap_or_default();
                    raw.lines()
                        .filter(|l| l.trim().starts_with("-- ") || l.trim().starts_with("/-"))
                        .collect::<Vec<_>>()
                        .join("\n")
                }
                Some("md") => fs::read_to_string(path).unwrap_or_default(),
                _ => continue,
            };

            if text.is_empty() {
                continue;
            }

            let terms = extract_terms(&text);
            for term in terms {
                *term_counter.entry(term.clone()).or_default() += 1;
                let ctxs = context_for_term(&text, &term, 150);
                for ctx in ctxs {
                    term_contexts
                        .entry(term.clone())
                        .or_default()
                        .push(UsageContext {
                            project: sid.clone(),
                            file: path.to_string_lossy().to_string(),
                            context: ctx,
                        });
                }
            }
        }
    }

    let mut glossary = Vec::new();
    let mut undefined = Vec::new();

    for (term, freq) in term_counter.iter() {
        if *freq < 2 {
            continue;
        }
        let categories = categorize_term(term);
        let contexts = term_contexts.get(term).cloned().unwrap_or_default();

        let entry = GlossaryEntry {
            term: term.clone(),
            frequency: *freq,
            categories,
            wordnet: serde_json::json!({"found": false}),
            usage_contexts: contexts.into_iter().take(3).collect(),
        };

        glossary.push(entry.clone());
        undefined.push(entry);
    }

    glossary.sort_by(|a, b| b.frequency.cmp(&a.frequency));
    undefined.sort_by(|a, b| b.frequency.cmp(&a.frequency));

    let output = serde_json::json!({
        "total_terms": term_counter.len(),
        "defined_count": 0,
        "undefined_count": undefined.len(),
        "glossary": glossary,
    });

    fs::write(output_json, serde_json::to_string_pretty(&output)?)?;

    for entry in &undefined {
        eprintln!(
            "{} (x{}) [{:?}]",
            entry.term, entry.frequency, entry.categories
        );
        for ctx in &entry.usage_contexts {
            let preview = if ctx.context.len() > 200 {
                format!("{}...", safe_truncate(&ctx.context, 200))
            } else {
                ctx.context.clone()
            };
            eprintln!("  [{}] ...{}...", ctx.project, preview);
        }
    }

    eprintln!("\nTotal terms: {}", term_counter.len());
    eprintln!("undefined: {}", undefined.len());
    eprintln!("Saved to {}", output_json);

    Ok(())
}
