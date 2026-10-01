//! Search command — Tantivy-backed search over the Aristotle project database.
//!
//! Indexes `aristotle_projects.json` into tantivy and provides:
//! - Full-text search across project descriptions
//! - Filtering by status, has_files, has_input
//! - Faceted search (status counts, file counts)
//! - Shmem export for cross-service consumption

use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use serde::Serialize;
use tracing::info;

/// Search results
#[derive(Debug, Clone, Serialize)]
pub struct SearchResults {
    pub total: usize,
    pub hits: Vec<ProjectHit>,
    pub facets: FacetCounts,
}

#[derive(Debug, Clone, Serialize)]
pub struct ProjectHit {
    pub project_id: String,
    pub description: String,
    pub status: u64,
    pub created_at: String,
    pub last_updated: String,
    pub has_files: bool,
    pub has_input: bool,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub score: Option<f32>,
}

#[derive(Debug, Clone, Serialize)]
pub struct FacetCounts {
    pub status: std::collections::BTreeMap<u64, usize>,
    pub total_projects: usize,
    pub with_files: usize,
    pub with_input: usize,
}

/// Search the project database.
pub fn cmd_search(
    query: &str,
    status_filter: Option<u64>,
    has_files_filter: Option<bool>,
    has_input_filter: Option<bool>,
    limit: usize,
    index_dir: Option<&Path>,
    shmem: bool,
) -> Result<SearchResults> {
    let index_dir = index_dir
        .map(|p| p.to_path_buf())
        .unwrap_or_else(|| {
            dirs::config_dir()
                .map(|d| d.join("aristotle-manager").join("search-index"))
                .unwrap_or_else(|| PathBuf::from("./search-index"))
        });

    let index = crate::search::load_index(&index_dir)?;

    let results = crate::search::search(
        &index,
        query,
        status_filter,
        has_files_filter,
        has_input_filter,
        limit,
    )?;

    if shmem {
        let shmem_client = PathBuf::from("/home/mdupont/bin/dasl-planner");
        crate::search::export_results_to_shmem(&shmem_client, &index_dir, &results, query)?;
    }

    Ok(SearchResults {
        total: results.total,
        hits: results.hits.into_iter().map(|h| ProjectHit {
            project_id: h.project_id,
            description: h.description,
            status: h.status,
            created_at: h.created_at,
            last_updated: h.last_updated,
            has_files: h.has_files,
            has_input: h.has_input,
            score: h.score,
        }).collect(),
        facets: FacetCounts {
            status: results.facets.status,
            total_projects: results.facets.total_projects,
            with_files: results.facets.with_files,
            with_input: results.facets.with_input,
        },
    })
}

/// Build/index the search index from aristotle_projects.json.
pub fn cmd_search_index(json_path: &Path, index_dir: &Path) -> Result<()> {
    info!(json = %json_path.display(), index = %index_dir.display(), "Indexing projects...");
    let index = crate::search::index_projects(&json_path.to_path_buf(), &index_dir.to_path_buf())?;
    let count = crate::search::count(&index)?;
    println!("Indexed {} projects at {}", count, index_dir.display());
    info!(count, "Index built successfully");
    Ok(())
}
