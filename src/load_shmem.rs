use anyhow::{Context, Result};
use serde_json;
use std::collections::HashMap;
use std::fs;
use std::path::Path;
use std::process::Command;
use tracing::info;

/// Load a term_graph.json into IPLD CAR shmem for planner visibility.
///
/// The term graph is split into blocks:
///   crossref/term-graph/           ← index block (list of projects)
///   crossref/term-graph/<project>  ← per-project terms
///
/// Each block is JSON-serialized and written via dasl-planner shmem CLI.
pub fn load_term_graph_to_shmem(json_path: &Path) -> Result<()> {
    let shmem_client = Path::new("/home/mdupont/bin/dasl-planner");
    if !shmem_client.exists() {
        anyhow::bail!(
            "shmem client not found at {}",
            shmem_client.display()
        );
    }

    info!("Loading term graph from {} into shmem", json_path.display());

    // Read the full term graph JSON
    let json_data = fs::read_to_string(json_path)
        .with_context(|| format!("Failed to read {}", json_path.display()))?;
    let graph: serde_json::Value = serde_json::from_str(&json_data)
        .context("Failed to parse term graph JSON")?;

    let terms = graph["terms"].as_object().unwrap_or(&serde_json::Map::new());
    let project_defines = graph["project_defines"]
        .as_object()
        .unwrap_or(&serde_json::Map::new());

    // 1. Write per-project term blocks
    let mut projects_written = 0u64;
    for (project, _terms) in project_defines.iter() {
        // Build this project's term info: its definitions + which other projects use them
        let mut project_data = serde_json::json!({
            "project": project,
            "defined_terms": _terms,
        });

        // For each term this project defines, find which projects use it
        let mut used_by_map: HashMap<&str, Vec<&str>> = HashMap::new();
        if let Some(terms_obj) = graph["terms"].as_object() {
            for (term, info) in terms_obj.iter() {
                if let Some(used_by) = info["used_by"].as_array() {
                    for user in used_by {
                        if let Some(user_str) = user.as_str() {
                            if user_str != project {
                                used_by_map.entry(term.as_str()).or_default().push(user_str);
                            }
                        }
                    }
                }
            }
        }

        // Add cross-project references
        let cross_refs: Vec<serde_json::Value> = used_by_map
            .iter()
            .map(|(term, users)| {
                serde_json::json!({
                    "term": term,
                    "used_by": users,
                })
            })
            .collect();

        if !cross_refs.is_empty() {
            project_data["cross_references"] = serde_json::Value::Array(cross_refs);
        }

        let path = format!("crossref/term-graph/{}", project);
        let data = serde_json::to_string(&project_data)?;

        let output = Command::new(shmem_client)
            .args(["shmem", "write", &path, &data])
            .output()
            .context("Failed to write project block to shmem")?;

        if !output.status.success() {
            let stderr = String::from_utf8_lossy(&output.stderr);
            anyhow::bail!("shmem write failed for {}: {}", project, stderr);
        }

        projects_written += 1;
        if projects_written % 10 == 0 {
            info!("  {} project blocks written to shmem", projects_written);
        }
    }

    // 2. Write the index block
    let project_list: Vec<&str> = project_defines.keys().map(|k| k.as_str()).collect();
    let index_data = serde_json::json!({
        "type": "crossref_term_graph_index",
        "version": 1,
        "total_projects": project_list.len(),
        "total_terms": terms.len(),
        "projects": project_list,
        "paths": project_list.iter().map(|p| format!("crossref/term-graph/{}", p)).collect::<Vec<_>>(),
    });

    let index_json = serde_json::to_string(&index_data)?;
    let output = Command::new(shmem_client)
        .args(["shmem", "write", "crossref/term-graph", &index_json])
        .output()
        .context("Failed to write index block to shmem")?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        anyhow::bail!("shmem write failed for index block: {}", stderr);
    }

    info!(
        "Loaded term graph into shmem: {} projects, {} terms",
        project_list.len(),
        terms.len()
    );

    Ok(())
}
