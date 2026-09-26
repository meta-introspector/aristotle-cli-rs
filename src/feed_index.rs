//! Feed-index: build tantivy index chunks from Aristotle corpus and send them to a project.
//!
//! Reads the unified index JSON, walks actual .lean files, extracts terms,
//! builds chunks matching `aristotle-index-chunk/1` schema, and sends them
//! via the ask API.

use std::collections::HashMap;
use std::path::{Path, PathBuf};
use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use serde_json::json;
use walkdir::WalkDir;
use tracing::info;

/// A project entry in the unified index.
#[derive(Debug, Deserialize)]
pub struct UnifiedIndex {
    pub summary: Summary,
    pub projects: Vec<ProjectEntry>,
}

#[derive(Debug, Deserialize)]
pub struct Summary {
    pub total_projects_api: u64,
    pub total_local_dirs: u64,
    pub total_blocks: u64,
    pub generated_at: String,
}

#[derive(Debug, Deserialize)]
pub struct ProjectEntry {
    pub project_id: String,
    pub description: Option<String>,
    pub category: Option<String>,
    pub lean_files: Option<u64>,
    pub has_local_dir: Option<bool>,
    pub local_path: Option<String>,
}

/// A document in the index.
#[derive(Debug, Clone, Serialize)]
pub struct Doc {
    pub id: u64,
    pub path: String,
    pub title: String,
}

/// A posting (term → doc mapping).
#[derive(Debug, Clone, Serialize)]
pub struct Posting {
    pub term: String,
    pub doc: u64,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub freq: Option<u64>,
}

/// Lean declaration keywords to extract as terms.
const LEAN_KEYWORDS: &[&str] = &[
    "theorem", "lemma", "def", "axiom", "structure", "inductive",
    "class", "instance", "notation", "abbrev", "opaque", "example",
    "noncomputable", "partial", "unsafe",
];

/// Extract terms from a Lean source file.
/// Returns a list of (term, doc_id) pairs.
fn extract_terms(content: &str, doc_id: u64) -> Vec<(String, u64)> {
    let mut postings = Vec::new();
    let mut seen = std::collections::HashSet::new();

    for line in content.lines() {
        let trimmed = line.trim_start();
        // Skip comments and imports
        if trimmed.starts_with("--") || trimmed.starts_with("/-") || trimmed.starts_with("import") {
            continue;
        }

        // Check for Lean declaration keywords
        for kw in LEAN_KEYWORDS {
            if let Some(rest) = trimmed.strip_prefix(kw) {
                // Must be followed by whitespace or other non-identifier char
                if rest.starts_with(' ') || rest.starts_with('\t') {
                    // Extract the declaration name
                    let after_kw = rest.trim_start();
                    if let Some(name_end) = after_kw.find(|c: char| c.is_whitespace() || c == ':' || c == '(' || c == '[' || c == '{') {
                        let name = &after_kw[..name_end];
                        if !name.is_empty() && !name.starts_with('@') {
                            let term = name.to_lowercase();
                            if seen.insert(term.clone()) {
                                postings.push((term, doc_id));
                            }
                            // Also add the keyword itself as a term
                            let kw_term = kw.to_string();
                            if seen.insert(kw_term.clone()) {
                                postings.push((kw_term, doc_id));
                            }
                        }
                    }
                }
            }
        }

        // Extract namespace as a term
        if let Some(rest) = trimmed.strip_prefix("namespace ") {
            let ns = rest.trim();
            if !ns.is_empty() {
                let term = ns.to_lowercase();
                if seen.insert(term.clone()) {
                    postings.push((term, doc_id));
                }
            }
        }
    }

    postings
}

/// Extract a title from a file path.
fn title_from_path(path: &Path) -> String {
    path.file_stem()
        .map(|s| s.to_string_lossy().to_string())
        .unwrap_or_else(|| "unknown".to_string())
}

/// Build chunks from the unified index.
///
/// Walks each project's .lean files, extracts terms, and groups into chunks
/// of `chunk_size` documents each.
pub fn build_chunks(
    results_dir: &Path,
    unified_index_path: &Path,
    chunk_size: usize,
) -> Result<Vec<serde_json::Value>> {
    let index_content = std::fs::read_to_string(unified_index_path)
        .with_context(|| format!("Failed to read unified index: {}", unified_index_path.display()))?;
    let index: UnifiedIndex = serde_json::from_str(&index_content)
        .context("Failed to parse unified index JSON")?;

    info!(projects = index.projects.len(), "Building chunks from unified index");

    let mut all_docs: Vec<Doc> = Vec::new();
    let mut all_postings: Vec<Posting> = Vec::new();
    let mut doc_id: u64 = 0;

    for proj in &index.projects {
        let lean_count = proj.lean_files.unwrap_or(0);
        if lean_count == 0 {
            continue;
        }

        // Build the project directory path
        let proj_dir = results_dir.join(format!("{}_aristotle", proj.project_id));
        let output_dir = proj_dir.join("output-final_aristotle").join("RequestProject");

        if !output_dir.exists() {
            // Try alternate path
            if let Some(ref lp) = proj.local_path {
                let alt = PathBuf::from(lp);
                if alt.exists() {
                    // Walk .lean files from there
                    for entry in WalkDir::new(&alt).into_iter().filter_map(|e| e.ok()) {
                        if entry.path().extension().map_or(false, |e| e == "lean") {
                            let path = entry.path();
                            let rel_path = path.strip_prefix(results_dir)
                                .unwrap_or(path)
                                .to_string_lossy()
                                .to_string();
                            let title = title_from_path(path);
                            let content = std::fs::read_to_string(path).unwrap_or_default();
                            let terms = extract_terms(&content, doc_id);
                            all_docs.push(Doc { id: doc_id, path: rel_path, title });
                            for (term, did) in terms {
                                all_postings.push(Posting { term, doc: did, freq: None });
                            }
                            doc_id += 1;
                        }
                    }
                    continue;
                }
            }
            continue;
        }

        // Walk .lean files in the RequestProject directory
        for entry in WalkDir::new(&output_dir)
            .max_depth(5)
            .into_iter()
            .filter_map(|e| e.ok())
        {
            if entry.path().extension().map_or(false, |e| e == "lean") {
                let path = entry.path();
                // Skip __variants__ directories — they are generated duplicates
                if path.to_string_lossy().contains("__variants__") {
                    continue;
                }
                let rel_path = path.strip_prefix(results_dir)
                    .unwrap_or(path)
                    .to_string_lossy()
                    .to_string();
                let title = title_from_path(path);
                let content = std::fs::read_to_string(path).unwrap_or_default();
                let terms = extract_terms(&content, doc_id);
                all_docs.push(Doc { id: doc_id, path: rel_path, title });
                for (term, did) in terms {
                    all_postings.push(Posting { term, doc: did, freq: None });
                }
                doc_id += 1;
            }
        }
    }

    info!(total_docs = all_docs.len(), total_postings = all_postings.len(), "Extracted documents and postings");

    // Group docs into chunks
    let total_chunks = (all_docs.len() + chunk_size - 1) / chunk_size;
    if total_chunks == 0 {
        return Ok(vec![]);
    }

    let mut chunks = Vec::with_capacity(total_chunks);

    // Group postings by doc, then split into chunks
    let mut doc_to_postings: HashMap<u64, Vec<&Posting>> = HashMap::new();
    for p in &all_postings {
        doc_to_postings.entry(p.doc).or_default().push(p);
    }

    for (chunk_idx, doc_chunk) in all_docs.chunks(chunk_size).enumerate() {
        let seq = (chunk_idx + 1) as u64; // 1-indexed

        // Collect postings for docs in this chunk
        let chunk_postings: Vec<&Posting> = doc_chunk
            .iter()
            .flat_map(|d| {
                doc_to_postings.get(&d.id)
                    .map(|v| v.iter().map(|p| *p))
                    .into_iter()
                    .flatten()
            })
            .collect();

        let chunk = json!({
            "protocol": "aristotle-index-chunk/1",
            "index": "tantivy",
            "task": "upper-ontology-merge",
            "seq": seq,
            "total": total_chunks as u64,
            "docs": doc_chunk.iter().map(|d| json!({
                "id": d.id,
                "path": d.path,
                "title": d.title,
            })).collect::<Vec<_>>(),
            "postings": chunk_postings.iter().map(|p| json!({
                "term": p.term,
                "doc": p.doc,
            })).collect::<Vec<_>>(),
        });

        chunks.push(chunk);
    }

    info!(total_chunks = chunks.len(), "Built chunks");
    Ok(chunks)
}

/// Run the feed-index command.
pub fn cmd_feed_index(
    project_id: String,
    results_dir: PathBuf,
    unified_index: PathBuf,
    chunk_size: usize,
    dry_run: bool,
    output_dir: Option<PathBuf>,
    start_seq: Option<u64>,
) -> Result<()> {
    use std::io::Write;

    info!(
        project_id = %project_id,
        results_dir = %results_dir.display(),
        unified_index = %unified_index.display(),
        chunk_size,
        dry_run,
        start_seq = ?start_seq,
        "Building index chunks"
    );

    let chunks = build_chunks(&results_dir, &unified_index, chunk_size)?;

    info!(chunk_count = chunks.len(), "Built chunks, ready to feed");

    // Filter by start_seq if provided (resume from specific chunk)
    let chunks: Vec<_> = match start_seq {
        Some(ss) => {
            let filtered: Vec<_> = chunks.into_iter().filter(|c| {
                c["seq"].as_u64().unwrap_or(0) >= ss
            }).collect();
            info!(start_seq = ss, remaining = filtered.len(), "Resuming from seq");
            filtered
        }
        None => chunks,
    };

    // Optionally write chunks to disk
    if let Some(ref out_dir) = output_dir {
        std::fs::create_dir_all(out_dir)
            .with_context(|| format!("Failed to create output dir: {}", out_dir.display()))?;
        for chunk in &chunks {
            let seq = chunk["seq"].as_u64().unwrap_or(0);
            let filename = format!("chunk-{:04}.json", seq);
            let path = out_dir.join(&filename);
            let json = serde_json::to_string_pretty(chunk)?;
            std::fs::write(&path, json)
                .with_context(|| format!("Failed to write chunk file: {}", path.display()))?;
            info!(seq, path = %path.display(), "Wrote chunk file");
        }
        println!("Wrote {} chunk files to {}", chunks.len(), out_dir.display());
        let _ = std::io::stdout().flush();
    }

    if dry_run {
        println!("Dry run: {} chunks would be sent to project {}", chunks.len(), project_id);
        for chunk in chunks.iter().take(3) {
            println!("  chunk {} ({} docs, {} postings)",
                chunk["seq"], chunk["docs"].as_array().map(|a| a.len()).unwrap_or(0),
                chunk["postings"].as_array().map(|a| a.len()).unwrap_or(0));
        }
        if chunks.len() > 3 {
            println!("  ... and {} more", chunks.len() - 3);
        }
        let _ = std::io::stdout().flush();
        return Ok(());
    }

    // Send chunks via curl subprocess — avoids reqwest::blocking timeout bugs
    let api_key = crate::api::get_api_key()?;
    let total = chunks.len();

    let url = format!("{}/project/{}/ask", crate::api::API_BASE_URL, project_id);

    let mut sent_count = 0u64;
    let mut fail_count = 0u64;

    for (i, chunk) in chunks.iter().enumerate() {
        let seq = chunk["seq"].as_u64().unwrap_or(0);
        let doc_count = chunk["docs"].as_array().map(|a| a.len()).unwrap_or(0);
        let posting_count = chunk["postings"].as_array().map(|a| a.len()).unwrap_or(0);

        info!(seq, doc_count, posting_count, progress = i + 1, total, "Sending chunk");
        let _ = std::io::stdout().flush();

        let chunk_json = match serde_json::to_string_pretty(chunk) {
            Ok(s) => s,
            Err(e) => {
                eprintln!("[{}/{}] chunk {} serialize FAILED: {}", i + 1, total, seq, e);
                let _ = std::io::stderr().flush();
                continue;
            }
        };
        let prompt = format!(
            "Feeding tantivy index chunk {} of {}\n\n```json\n{}\n```",
            seq, total, chunk_json
        );

        info!(seq, prompt_len = prompt.len(), "Serialized chunk, sending to API");
        let _ = std::io::stdout().flush();

        // Write prompt to temp file to avoid shell escaping issues
        let tmp_prompt = std::env::temp_dir().join(format!("arist-chunk-{}.txt", seq));
        if let Err(e) = std::fs::write(&tmp_prompt, &prompt) {
            eprintln!("[{}/{}] chunk {} FAILED: write tmp: {}", i + 1, total, seq, e);
            let _ = std::io::stderr().flush();
            fail_count += 1;
            continue;
        }

        // Retry with exponential backoff: 3 attempts
        let mut success = false;
        for attempt in 1..=3u32 {
            if attempt > 1 {
                let backoff = 1u64 << attempt;
                info!(seq, attempt, backoff_secs = backoff, "Retrying after backoff");
                std::thread::sleep(std::time::Duration::from_secs(backoff));
            }

            // Use curl with --max-time for reliable timeout
            let output = std::process::Command::new("curl")
                .arg("-s")
                .arg("-S")
                .arg("-w")
                .arg("\n%{http_code}")
                .arg("--max-time")
                .arg("45")
                .arg("--connect-timeout")
                .arg("10")
                .arg("-X")
                .arg("POST")
                .arg(&url)
                .arg("-H")
                .arg(format!("x-api-key: {}", api_key))
                .arg("-F")
                .arg("mode=2")
                .arg("-F")
                .arg("agent_questions_setting=1")
                .arg("-F")
                .arg("_=")
                .arg("-F")
                .arg(format!("prompt=<{}", tmp_prompt.display()))
                .output();

            match output {
                Ok(out) => {
                    let stdout = String::from_utf8_lossy(&out.stdout);
                    let stderr = String::from_utf8_lossy(&out.stderr);
                    // Last line of stdout is the http_code from -w
                    let lines: Vec<&str> = stdout.lines().collect();
                    let http_code = lines.last().unwrap_or(&"000");
                    let body = if lines.len() > 1 {
                        lines[..lines.len()-1].join("\n")
                    } else {
                        String::new()
                    };

                    if *http_code == "200" {
                        info!(seq, attempt, status = %http_code, body_len = body.len(), "Chunk sent");
                        println!("[{}/{}] chunk {} sent ({} docs, {} postings){}",
                            i + 1, total, seq, doc_count, posting_count,
                            if attempt > 1 { format!(" (retry {})", attempt) } else { String::new() });
                        let _ = std::io::stdout().flush();
                        success = true;
                        sent_count += 1;
                        break;
                    } else {
                        eprintln!("[{}/{}] chunk {} FAILED (attempt {}): HTTP {} — {}",
                            i + 1, total, seq, attempt, http_code,
                            if stderr.is_empty() { &body[..body.len().min(200)] } else { &stderr[..stderr.len().min(200)] });
                        let _ = std::io::stderr().flush();
                    }
                }
                Err(e) => {
                    eprintln!("[{}/{}] chunk {} FAILED (attempt {}): curl: {}",
                        i + 1, total, seq, attempt, e);
                    let _ = std::io::stderr().flush();
                }
            }
        }

        // Clean up temp file
        let _ = std::fs::remove_file(&tmp_prompt);

        if !success {
            fail_count += 1;
        }

        // Delay between chunks to avoid rate limiting
        std::thread::sleep(std::time::Duration::from_millis(800));
    }

    println!("Fed {} chunks to project {} ({} sent, {} failed)",
        chunks.len(), project_id, sent_count, fail_count);
    let _ = std::io::stdout().flush();
    Ok(())
}
