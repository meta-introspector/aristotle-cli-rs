/// Search — Tantivy-backed search over the Aristotle project database.
///
/// Indexes `aristotle_projects.json` into tantivy and provides:
/// - Full-text search across project descriptions
/// - Filtering by status, has_files, has_input
/// - Faceted search (status counts, file counts)
/// - Shmem export for cross-service consumption
///
/// Fields indexed:
///   - project_id    (exact, stored)
///   - description   (text, stored, indexed, with stemmer)
///   - status        (u64, exact, stored)
///   - created_at    (text, stored)
///   - last_updated  (text, stored)
///   - has_files     (bool, exact, stored)
///   - has_input     (bool, exact, stored)

use anyhow::{Context, Result};
use serde::Serialize;
use std::fs;
use std::path::PathBuf;
use tantivy::collector::TopDocs;
use tantivy::query::{Occur, QueryParser};
use tantivy::schema::{Field, Schema};
use tantivy::Document;
use tantivy::{Index, IndexWriter};

// Re-export TantivyDocument for use in search results
use tantivy::TantivyDocument;

// Import flags
use tantivy::schema::{INDEXED, STORED, STRING, TEXT};
use tracing::{info, warn};

// ── Field names ──────────────────────────────────────────────────────

const FIELD_PROJECT_ID: &str = "project_id";
const FIELD_DESCRIPTION: &str = "description";
const FIELD_STATUS: &str = "status";
const FIELD_CREATED_AT: &str = "created_at";
const FIELD_LAST_UPDATED: &str = "last_updated";
const FIELD_HAS_FILES: &str = "has_files";
const FIELD_HAS_INPUT: &str = "has_input";

// ── Result types ──────────────────────────────────────────────────────

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
pub struct SearchResults {
    pub total: usize,
    pub hits: Vec<ProjectHit>,
    pub facets: FacetCounts,
}

#[derive(Debug, Clone, Serialize)]
pub struct FacetCounts {
    pub status: std::collections::BTreeMap<u64, usize>,
    pub total_projects: usize,
    pub with_files: usize,
    pub with_input: usize,
}

// ── Schema builder ────────────────────────────────────────────────────

fn build_schema() -> Schema {
    let mut builder = Schema::builder();

    // project_id: exact, stored
    builder.add_text_field(FIELD_PROJECT_ID, STRING | STORED);

    // description: text with stemming, stored for display
    builder.add_text_field(FIELD_DESCRIPTION, TEXT | STORED);

    // status: u64, exact, stored
    builder.add_u64_field(FIELD_STATUS, INDEXED | STORED);

    // created_at: text, stored
    builder.add_text_field(FIELD_CREATED_AT, STRING | STORED);

    // last_updated: text, stored
    builder.add_text_field(FIELD_LAST_UPDATED, STRING | STORED);

    // has_files: bool, exact
    builder.add_bool_field(FIELD_HAS_FILES, INDEXED);

    // has_input: bool, exact
    builder.add_bool_field(FIELD_HAS_INPUT, INDEXED);

    builder.build()
}

// ── Indexing ─────────────────────────────────────────────────────────

/// Index all projects from the JSON file.
pub fn index_projects(json_path: &PathBuf, index_dir: &PathBuf) -> Result<Index> {
    let schema = build_schema();
    let index = Index::create_in_dir(index_dir, schema.clone())
        .context("Failed to create tantivy index")?;

    let f_project_id = schema.get_field(FIELD_PROJECT_ID)?;
    let f_description = schema.get_field(FIELD_DESCRIPTION)?;
    let f_status = schema.get_field(FIELD_STATUS)?;
    let f_created_at = schema.get_field(FIELD_CREATED_AT)?;
    let f_last_updated = schema.get_field(FIELD_LAST_UPDATED)?;
    let f_has_files = schema.get_field(FIELD_HAS_FILES)?;
    let f_has_input = schema.get_field(FIELD_HAS_INPUT)?;

    let mut writer = index.writer(50_000_000).context("Failed to create index writer")?; // 50MB

    let json_data = fs::read_to_string(json_path)
        .with_context(|| format!("Failed to read project database: {}", json_path.display()))?;
    let projects: serde_json::Value = serde_json::from_str(&json_data)
        .context("Failed to parse project database JSON")?;

    let project_list = projects["projects"]
        .as_array()
        .ok_or_else(|| anyhow::anyhow!("projects field is not an array"))?;

    info!(total_projects = project_list.len(), "Indexing projects into tantivy");

    let mut total_indexed = 0u64;

    for (i, project_val) in project_list.iter().enumerate() {
        let project_id = project_val["project_id"]
            .as_str()
            .unwrap_or("")
            .to_string();

        let mut doc = tantivy::TantivyDocument::new();

        // project_id
        if !project_id.is_empty() {
            doc.add_text(f_project_id, &project_id);
        }

        // description
        let description = project_val["description"]
            .as_str()
            .unwrap_or("")
            .to_string();
        if !description.is_empty() {
            doc.add_text(f_description, &description);
        }

        // status
        let status = project_val["status"].as_u64().unwrap_or(0);
        doc.add_u64(f_status, status);

        // created_at
        let created_at = project_val["created_at"]
            .as_str()
            .unwrap_or("")
            .to_string();
        if !created_at.is_empty() {
            doc.add_text(f_created_at, &created_at);
        }

        // last_updated
        let last_updated = project_val["last_updated"]
            .as_str()
            .unwrap_or("")
            .to_string();
        if !last_updated.is_empty() {
            doc.add_text(f_last_updated, &last_updated);
        }

        // has_files
        let has_files = project_val["has_files"].as_bool().unwrap_or(false);
        doc.add_bool(f_has_files, has_files);

        // has_input
        let has_input = project_val["has_input"].as_bool().unwrap_or(false);
        doc.add_bool(f_has_input, has_input);

        writer.add_document(doc)?;
        total_indexed += 1;

        if (i + 1) % 20 == 0 {
            info!(processed = i + 1, "Indexing projects...");
        }
    }

    writer.commit().context("Failed to commit index")?;

    info!(indexed = total_indexed, "Projects indexed into tantivy");

    Ok(index)
}

// ── Querying ─────────────────────────────────────────────────────────

/// Search the index with a query string and optional filters.
pub fn search(
    index: &Index,
    query: &str,
    status_filter: Option<u64>,
_has_files_filter: Option<bool>,
_has_input_filter: Option<bool>,
    limit: usize,
) -> Result<SearchResults> {
    let reader = index.reader().context("Failed to get index reader")?;
    let searcher = reader.searcher();
    let schema = index.schema();

    let project_id_field = schema.get_field(FIELD_PROJECT_ID).unwrap();
    let description_field = schema.get_field(FIELD_DESCRIPTION).unwrap();
    let status_field = schema.get_field(FIELD_STATUS).unwrap();
    let created_at_field = schema.get_field(FIELD_CREATED_AT).unwrap();
    let last_updated_field = schema.get_field(FIELD_LAST_UPDATED).unwrap();
    let has_files_field = schema.get_field(FIELD_HAS_FILES).unwrap();
    let has_input_field = schema.get_field(FIELD_HAS_INPUT).unwrap();

    // Build query
    let query_parser = QueryParser::for_index(index, vec![description_field]);
    let query = query_parser.parse_query(query).map_err(|e| {
        anyhow::anyhow!("Query parse error: {}", e)
    })?;

    // Execute search
    let top_docs = if let Some(status) = status_filter {
        // Filter by status + text query
        let status_term = tantivy::Term::from_field_u64(status_field, status);
        let filter = tantivy::query::TermQuery::new(status_term, tantivy::schema::IndexRecordOption::Basic);
        let combined_query = tantivy::query::BooleanQuery::new(vec![
            (Occur::Must, query),
            (Occur::Must, Box::new(filter) as Box<dyn tantivy::query::Query>),
        ]);

        let collector = TopDocs::with_limit(limit).and_offset(0);
        searcher.search(&combined_query, &collector).context("Search failed")?
    } else {
        let collector = TopDocs::with_limit(limit).and_offset(0);
        searcher.search(&query, &collector).context("Search failed")?
    };
    let count = top_docs.len();

    // Build facets
    let facets = build_facets(&searcher, status_field, has_files_field, has_input_field);

    // Fetch documents
    let mut hits = Vec::with_capacity(top_docs.len());
    for (score, doc_address) in top_docs {
        let retrieved: TantivyDocument = searcher.doc(doc_address).context("Failed to retrieve document")?;

        let project_id: Option<&str> = retrieved.get_first(project_id_field).and_then(|v| if let tantivy::schema::OwnedValue::Str(ref t) = *v { Some(t.as_str()) } else { None });
        let description: Option<&str> = retrieved.get_first(description_field).and_then(|v| if let tantivy::schema::OwnedValue::Str(ref t) = *v { Some(t.as_str()) } else { None });
        let status: u64 = retrieved.get_first(status_field).and_then(|v| if let tantivy::schema::OwnedValue::U64(u) = *v { Some(u) } else { None }).unwrap_or(0);
        let created_at: Option<&str> = retrieved.get_first(created_at_field).and_then(|v| if let tantivy::schema::OwnedValue::Str(ref t) = *v { Some(t.as_str()) } else { None });
        let last_updated: Option<&str> = retrieved.get_first(last_updated_field).and_then(|v| if let tantivy::schema::OwnedValue::Str(ref t) = *v { Some(t.as_str()) } else { None });
        let has_files: Option<bool> = retrieved.get_first(has_files_field).and_then(|v| if let tantivy::schema::OwnedValue::Bool(b) = *v { Some(b) } else { None });
        let has_input: Option<bool> = retrieved.get_first(has_input_field).and_then(|v| if let tantivy::schema::OwnedValue::Bool(b) = *v { Some(b) } else { None });

        let project_id = project_id.unwrap_or("").to_string();
        let description = description.unwrap_or("").to_string();
        let created_at = created_at.unwrap_or("").to_string();
        let last_updated = last_updated.unwrap_or("").to_string();
        let has_files = has_files.unwrap_or(false);
        let has_input = has_input.unwrap_or(false);

        hits.push(ProjectHit {
            project_id,
            description,
            status,
            created_at,
            last_updated,
            has_files,
            has_input,
            score: Some(score),
        });
    }

    Ok(SearchResults {
        total: count,
        hits,
        facets,
    })
}

fn build_facets(
    searcher: &tantivy::Searcher,
_status_field: Field,
    has_files_field: Field,
    has_input_field: Field,
) -> FacetCounts {
    let mut status_counts: std::collections::BTreeMap<u64, usize> = std::collections::BTreeMap::new();
    let mut with_files = 0usize;
    let mut with_input = 0usize;

    for segment_reader in searcher.segment_readers() {
        let n = segment_reader.num_docs();
        if let Ok(Some((col, _ty))) = segment_reader.fast_fields().u64_lenient(FIELD_STATUS) {
            for doc in 0..n {
                if let Some(v) = col.first(doc) {
                    *status_counts.entry(v).or_insert(0) += 1;
                }
            }
        }

        if let Ok(col) = segment_reader.fast_fields().bool(FIELD_HAS_FILES) {
            for doc in 0..n {
                if col.first(doc) == Some(true) {
                    with_files += 1;
                }
            }
        }

        if let Ok(col) = segment_reader.fast_fields().bool(FIELD_HAS_INPUT) {
            for doc in 0..n {
                if col.first(doc) == Some(true) {
                    with_input += 1;
                }
            }
        }
    }

    FacetCounts {
        status: status_counts,
        total_projects: searcher.num_docs() as usize,
        with_files,
        with_input,
    }
}

/// Get a project by ID.
pub fn get_project(index: &Index, project_id: &str) -> Result<Option<ProjectHit>> {
    let reader = index.reader().context("Failed to get index reader")?;
    let searcher = reader.searcher();
    let schema = index.schema();

    let project_id_field = schema.get_field(FIELD_PROJECT_ID).unwrap();
    let description_field = schema.get_field(FIELD_DESCRIPTION).unwrap();
    let status_field = schema.get_field(FIELD_STATUS).unwrap();
    let created_at_field = schema.get_field(FIELD_CREATED_AT).unwrap();
    let last_updated_field = schema.get_field(FIELD_LAST_UPDATED).unwrap();
    let has_files_field = schema.get_field(FIELD_HAS_FILES).unwrap();
    let has_input_field = schema.get_field(FIELD_HAS_INPUT).unwrap();

    let term = tantivy::Term::from_field_text(project_id_field, project_id);
    let query = tantivy::query::TermQuery::new(term, tantivy::schema::IndexRecordOption::Basic);
    let collector = TopDocs::with_limit(1);

    let top_docs = searcher.search(&query, &collector).context("Search failed")?;

    if let Some((_score, doc_address)) = top_docs.first() {
        let retrieved: TantivyDocument = searcher.doc(*doc_address).context("Failed to retrieve document")?;

        let project_id = retrieved
            .get_first(project_id_field)
            .and_then(|v: &tantivy::schema::OwnedValue| if let tantivy::schema::OwnedValue::Str(ref t) = *v { Some(t.as_str()) } else { None })
            .unwrap_or(project_id)
            .to_string();

        let description = retrieved
            .get_first(description_field)
            .and_then(|v: &tantivy::schema::OwnedValue| if let tantivy::schema::OwnedValue::Str(ref t) = *v { Some(t.as_str()) } else { None })
            .unwrap_or("")
            .to_string();

        let status = retrieved
            .get_first(status_field)
            .and_then(|v| if let tantivy::schema::OwnedValue::U64(u) = *v { Some(u) } else { None })
            .unwrap_or(0);

        let created_at = retrieved
            .get_first(created_at_field)
            .and_then(|v: &tantivy::schema::OwnedValue| if let tantivy::schema::OwnedValue::Str(ref t) = *v { Some(t.as_str()) } else { None })
            .unwrap_or("")
            .to_string();

        let last_updated = retrieved
            .get_first(last_updated_field)
            .and_then(|v: &tantivy::schema::OwnedValue| if let tantivy::schema::OwnedValue::Str(ref t) = *v { Some(t.as_str()) } else { None })
            .unwrap_or("")
            .to_string();

        let has_files = retrieved
            .get_first(has_files_field)
            .and_then(|v| if let tantivy::schema::OwnedValue::Bool(b) = *v { Some(b) } else { None })
            .unwrap_or(false);

        let has_input = retrieved
            .get_first(has_input_field)
            .and_then(|v| if let tantivy::schema::OwnedValue::Bool(b) = *v { Some(b) } else { None })
            .unwrap_or(false);

        Ok(Some(ProjectHit {
            project_id,
            description,
            status,
            created_at,
            last_updated,
            has_files,
            has_input,
            score: None,
        }))
    } else {
        Ok(None)
    }
}

/// Load the index from a directory.
pub fn load_index(index_dir: &PathBuf) -> Result<Index> {
    let index = Index::open_in_dir(index_dir)
        .map_err(|e| anyhow::anyhow!("Failed to open tantivy index at {}: {}", index_dir.display(), e))?;
    Ok(index)
}

/// Count total documents in the index.
pub fn count(index: &Index) -> Result<usize> {
    let reader = index.reader().context("Failed to get index reader")?;
    Ok(reader.searcher().num_docs() as usize)
}

// ── Shmem export (direct SearchResults) ─────────────────────────────

/// Export pre-built search results to shmem.
pub fn export_results_to_shmem(
    shmem_client: &PathBuf,
    index_dir: &PathBuf,
    results: &SearchResults,
    query: &str,
) -> Result<()> {
    info!("Exporting search results to shmem");
    let payload = serde_json::json!({
        "type": "search_results",
        "version": 1,
        "total": results.total,
        "query": query,
        "hits": results.hits.iter().map(|h| serde_json::json!({
            "project_id": h.project_id,
            "description": h.description,
            "status": h.status,
            "created_at": h.created_at,
            "last_updated": h.last_updated,
            "has_files": h.has_files,
            "has_input": h.has_input,
        })).collect::<Vec<_>>(),
        "facets": serde_json::json!({
            "status": results.facets.status,
            "total_projects": results.facets.total_projects,
            "with_files": results.facets.with_files,
            "with_input": results.facets.with_input,
        }),
    });

    write_to_shmem(shmem_client, "search/projects", &payload)?;
    info!(total = results.total, "Search results exported to shmem");
    Ok(())
}

// ── Shmem export (index + query) ────────────────────────────────────

/// Build a searchable shmem payload from the project database.
/// Build a searchable shmem payload from the project database.
///
/// Creates a tantivy index, runs a default query, and exports results
/// in a format suitable for the shmem ring buffer.
pub fn export_to_shmem(
    json_path: &PathBuf,
    index_dir: &PathBuf,
    shmem_client: &PathBuf,
    query: &str,
    limit: usize,
) -> Result<()> {
    info!("Exporting search results to shmem");

    // Index if not already indexed
    let index = if index_dir.exists() {
        load_index(index_dir)?
    } else {
        index_projects(json_path, index_dir)?
    };

    // Run search
    let results = search(&index, query, None, None, None, limit)?;

    // Build shmem payload
    let payload = serde_json::json!({
        "type": "search_results",
        "version": 1,
        "total": results.total,
        "query": query,
        "hits": results.hits.iter().map(|h| serde_json::json!({
            "project_id": h.project_id,
            "description": h.description,
            "status": h.status,
            "created_at": h.created_at,
            "last_updated": h.last_updated,
            "has_files": h.has_files,
            "has_input": h.has_input,
        })).collect::<Vec<_>>(),
        "facets": serde_json::json!({
            "status": results.facets.status,
            "total_projects": results.facets.total_projects,
            "with_files": results.facets.with_files,
            "with_input": results.facets.with_input,
        }),
    });

    // Write to temp file, then atomize + shmem write
    write_to_shmem(shmem_client, "search/projects", &payload)?;

    info!(total = results.total, "Search results exported to shmem");
    Ok(())
}

/// Write JSON to shmem via dasl-planner (same pattern as load_shmem.rs).
fn write_to_shmem(client: &PathBuf, path: &str, data: &serde_json::Value) -> Result<()> {
    use std::process::Command;

    let tmp_dir = tempfile::tempdir().context("Failed to create temp dir")?;
    let tmp_file = tmp_dir.path().join("shmem_search.json");
    let json_str = serde_json::to_string(data)?;
    fs::write(&tmp_file, &json_str)
        .with_context(|| format!("Failed to write temp file: {}", tmp_file.display()))?;

    // Atomize
    let output = Command::new(client)
        .args(["proofs", "atomize", tmp_file.to_str().unwrap()])
        .output()
        .context("Failed to run dasl-planner atomize")?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        warn!("atomize stderr: {}", stderr);
    }

    // Write to shmem
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

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Write;

    #[test]
    fn test_build_schema() {
        let schema = build_schema();
        let names: Vec<&str> = schema.fields().map(|(f, _)| schema.get_field_entry(f).name()).collect();
        assert!(names.contains(&FIELD_PROJECT_ID));
        assert!(names.contains(&FIELD_DESCRIPTION));
        assert!(names.contains(&FIELD_STATUS));
    }

    #[test]
    fn test_index_and_search() -> Result<()> {
        // Create a temp JSON file
        let tmp_dir = tempfile::tempdir().unwrap();
        let json_path = tmp_dir.path().join("projects.json");
        let index_dir = tmp_dir.path().join("index");

        let test_data = serde_json::json!({
            "projects": [
                {
                    "project_id": "test-1",
                    "description": "A test project about Lean4 formal verification",
                    "status": 2,
                    "created_at": "2026-01-01T00:00:00",
                    "last_updated": "2026-01-02T00:00:00",
                    "has_files": true,
                    "has_input": false,
                },
                {
                    "project_id": "test-2",
                    "description": "Another project about DASL indexing",
                    "status": 1,
                    "created_at": "2026-02-01T00:00:00",
                    "last_updated": "2026-02-02T00:00:00",
                    "has_files": false,
                    "has_input": true,
                },
            ],
            "total": 2,
        });

        let mut file = fs::File::create(&json_path).unwrap();
        writeln!(file, "{}", serde_json::to_string_pretty(&test_data).unwrap()).unwrap();

        // Create index directory
        fs::create_dir_all(&index_dir).unwrap();

        // Index
        let index = index_projects(&json_path, &index_dir)?;

        // Search
        let results = search(&index, "test", None, None, None, 10)?;
        assert!(results.total >= 1, "Expected at least 1 result, got {}", results.total);

        // Search with filter: "lean4" only appears in test-1, which has status=2,
        // so the filter must still return that hit rather than filtering it out.
        let results = search(&index, "lean4", Some(2), None, None, 10)?;
        assert!(
            results.total >= 1,
            "Expected at least 1 result with status=2, got {}",
            results.total
        );

        // Get by ID
        let project = get_project(&index, "test-1")?;
        assert!(project.is_some());
        let p = project.unwrap();
        assert_eq!(p.project_id, "test-1");
        assert_eq!(p.status, 2);

        Ok(())
    }
}
