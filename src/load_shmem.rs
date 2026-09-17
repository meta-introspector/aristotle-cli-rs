use anyhow::{Context, Result};
use serde_json;
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use tracing::{info, warn};

/// Load a term graph into IPLD CAR shmem.
///
/// Discovers the most recent term_graph.json under `dir`, then splits it into
/// per-project blocks at `crossref/term-graph/<project>` with an index at
/// `crossref/term-graph/`.
///
/// Uses a temp file to avoid "Argument list too long" errors when the
/// project data is large.
pub fn load_term_graph_to_shmem(dir: &Path) -> Result<()> {
    let shmem_client = Path::new("/home/mdupont/bin/dasl-planner");
    if !shmem_client.exists() {
        anyhow::bail!("shmem client not found at {}", shmem_client.display());
    }

    // Discover term_graph.json — accept either a file directly or a dir to scan
    let json_path = if dir.is_file() && dir.file_name().map_or(false, |n| n == "term_graph.json") {
        dir.to_path_buf()
    } else if dir.is_dir() {
        find_term_graph_json(dir)?
    } else {
        anyhow::bail!("path is neither a file nor directory: {}", dir.display());
    };

    info!(
        "Loading term graph from {} into shmem",
        json_path.display()
    );

    let json_data = fs::read_to_string(&json_path)
        .with_context(|| format!("Failed to read {}", json_path.display()))?;
    let graph: serde_json::Value = serde_json::from_str(&json_data)
        .context("Failed to parse term graph JSON")?;

    let empty = serde_json::Map::new();
    let terms = graph["terms"].as_object().unwrap_or(&empty);
    let project_defines = graph["project_defines"].as_object().unwrap_or(&empty);

    let mut projects_written = 0u64;

    for (project, defined_terms_val) in project_defines.iter() {
        // Build cross-project reference map (owned strings to avoid borrow issues)
        let used_by_map = build_cross_refs(&graph, project);

        let cross_refs: Vec<serde_json::Value> = used_by_map
            .iter()
            .map(|(term, users)| {
                serde_json::json!({ "term": term, "used_by": users })
            })
            .collect();

        let project_data = serde_json::json!({
            "project": project,
            "defined_terms": defined_terms_val,
            "cross_references": cross_refs,
        });

        let path = format!("crossref/term-graph/{}", project);
        shmem_write(&shmem_client, &path, &project_data)?;

        projects_written += 1;
        if projects_written % 10 == 0 {
            info!("  {} project blocks written to shmem", projects_written);
        }
    }

    // Write index block
    let project_list: Vec<&str> = project_defines.keys().map(|k| k.as_str()).collect();
    let index_data = serde_json::json!({
        "type": "crossref_term_graph_index",
        "version": 1,
        "total_projects": project_list.len(),
        "total_terms": terms.len(),
        "projects": project_list,
        "paths": project_list.iter().map(|p| format!("crossref/term-graph/{}", p)).collect::<Vec<_>>(),
    });

    shmem_write(&shmem_client, "crossref/term-graph", &index_data)?;

    info!(
        "Loaded term graph into shmem: {} projects, {} terms",
        project_list.len(),
        terms.len()
    );

    Ok(())
}

/// Find the most recent term_graph.json in a directory.
fn find_term_graph_json(dir: &Path) -> Result<PathBuf> {
    let candidates: Vec<PathBuf> = glob::glob(&format!("{}/**/term_graph.json", dir.display()))
        .context("Failed to glob for term_graph.json")?
        .filter_map(|e| e.ok())
        .collect();

    if candidates.is_empty() {
        let direct = dir.join("term_graph.json");
        if direct.exists() {
            return Ok(direct);
        }
        anyhow::bail!("No term_graph.json found under {}", dir.display());
    }

    // Return the most recently modified
    let best = candidates
        .into_iter()
        .max_by_key(|p| fs::metadata(p).ok().and_then(|m| m.modified().ok()));
    Ok(best.unwrap())
}

/// Build a map of term → [projects that use it] for a given project, excluding
/// the project itself (no self-references).
fn build_cross_refs(
    graph: &serde_json::Value,
    project: &str,
) -> HashMap<String, Vec<String>> {
    let mut map: HashMap<String, Vec<String>> = HashMap::new();
    if let Some(terms_obj) = graph["terms"].as_object() {
        for (term, info) in terms_obj.iter() {
            if let Some(used_by) = info["used_by"].as_array() {
                for user in used_by {
                    if let Some(user_str) = user.as_str() {
                        if user_str != project {
                            map.entry(term.clone())
                                .or_default()
                                .push(user_str.to_string());
                        }
                    }
                }
            }
        }
    }
    map
}

/// Write a JSON value to shmem at the given path, using a temp file to avoid
/// CLI argument length limits.
fn shmem_write(client: &Path, path: &str, data: &serde_json::Value) -> Result<()> {
    // Write to a temp file first
    let tmp_dir = tempfile::tempdir().context("Failed to create temp dir")?;
    let tmp_file = tmp_dir.path().join("shmem_payload.json");
    let json_str = serde_json::to_string(data)?;
    fs::write(&tmp_file, &json_str)
        .with_context(|| format!("Failed to write temp file: {}", tmp_file.display()))?;

    // Use the atomize command: dasl-planner proofs atomize <file> --storage
    let output = Command::new(client)
        .args(["proofs", "atomize", tmp_file.to_str().unwrap()])
        .output()
        .context("Failed to run dasl-planner atomize")?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        warn!("atomize stderr: {}", stderr);
    }

    // Also try shmem write with file input
    // Some versions support: dasl-planner shmem write <path> < <file>
    let output = Command::new(client)
        .args(["shmem", "write", path])
        .stdin(std::process::Stdio::from(
            fs::File::open(&tmp_file)
                .context("Failed to open temp file for stdin")?,
        ))
        .output()
        .context("Failed to write to shmem")?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        anyhow::bail!("shmem write failed at {}: {}", path, stderr);
    }

    Ok(())
}
