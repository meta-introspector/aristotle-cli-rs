use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use anyhow::Context;
use std::time::Instant;
use tracing::{debug, info, instrument, warn};

/// Keyword index structure for Aristotle projects
#[derive(Debug, Clone)]
pub struct KeywordIndex {
    pub index: HashMap<String, Vec<String>>, // term -> list of file paths
    pub files: HashMap<String, Vec<String>>, // file path -> list of terms
}

impl KeywordIndex {
    pub fn new() -> Self {
        KeywordIndex {
            index: HashMap::new(),
            files: HashMap::new(),
        }
    }
    
    pub fn add_file(&mut self, file_path: &str, content: &str) {
        // Add to files map
        self.files.insert(file_path.to_string(), Vec::new());
        
        // Tokenize content (simple word extraction)
        let words: Vec<String> = content
            .split(|c: char| !c.is_alphanumeric() && !c.is_whitespace())
            .map(|s| s.to_lowercase())
            .filter(|s| !s.is_empty())
            .collect();
            
        for word in words {
            self.index.entry(word).or_insert_with(Vec::new).push(file_path.to_string());
            if let Some(terms) = self.files.get_mut(file_path) {
                terms.push(word);
            }
        }
    }
    
    pub fn query(&self, term: &str) -> Option<Vec<String>> {
        self.index.get(term).cloned()
    }
}

#[derive(Debug)]
pub struct SearchResult {
    pub path: String,
    pub snippet: String,
    pub score: f64,
}

#[instrument]
pub fn build_keyword_index(root_dir: &str) -> anyhow::Result<KeywordIndex> {
    info!(dir = root_dir, "Building keyword index");
    let start = Instant::now();
    
    let mut index = KeywordIndex::new();
    let root_path = PathBuf::from(root_dir);
    
    // Walk the directory tree
    let walker = walkdir::WalkDir::new(root_path)
        .into_iter()
        .filter_map(Result::ok)
        .filter(|e| e.path().is_file());
    
    let mut file_count = 0;
    for entry in walker {
        let path = entry.path();
        if path.is_file() {
            // Only process text files
            if let Ok(contents) = fs::read_to_string(path) {
                let file_path = path.to_string_lossy().to_string();
                index.add_file(&file_path, &contents);
                file_count += 1;
                if file_count % 100 == 0 {
                    debug!(processed = file_count, "Indexing files");
                }
            }
        }
    }
    
    info!(files = file_count, time = %start.elapsed().as_secs_f32(), "Keyword index complete");
    Ok(index)
}

pub fn search_keyword_index(
    index: &KeywordIndex,
    query: &str,
    max_results: usize,
) -> anyhow::Result<Vec<SearchResult>> {
    let matches = match index.query(query) {
        Some(m) => m,
        None => return Ok(vec![]),
    };
    
    let mut results = Vec::new();
    for file_path in matches {
        if let Ok(content) = fs::read_to_string(&file_path) {
            let snippet = extract_snippet(&content, query);
            results.push(SearchResult {
                path: file_path.clone(),
                snippet,
                score: 1.0,
            });
        }
    }
    
    // Sort by length (shorter paths first)
    results.sort_by(|a, b| a.path.len().cmp(&b.path.len()));
    
    Ok(results)
}

fn extract_snippet(content: &str, query: &str) -> String {
    let query_lower = query.to_lowercase();
    let content_lower = content.to_lowercase();
    
    if let Some(start_idx) = content_lower.find(&query_lower) {
        let context = 50;
        let snippet_start = if start_idx > context {
            start_idx - context
        } else {
            0
        };
        let snippet_end = if (start_idx + query_lower.len() + context) < content_lower.len() {
            start_idx + query_lower.len() + context
        } else {
            content.len()
        };
        
        let snippet = &content[snippet_start..snippet_end];
        return snippet.to_string();
    }
    
    // Fallback: first 200 chars
    content.chars().take(200).collect()
}

pub fn build_aristotle_keyword_index() -> anyhow::Result<KeywordIndex> {
    let config = load_config()?;
    let aristo_root = config.aristo_dir.join("aristotle_results");
    if !aristo_root.exists() {
        return Err(anyhow::anyhow!("Aristotle results directory not found: {}", aristo_root.display()));
    }
    build_keyword_index(aristo_root.to_string_lossy().as_ref())
}

pub fn build_mathlib_keyword_index() -> anyhow::Result<KeywordIndex> {
    let mathlib_root = PathBuf::from("/mnt/data1/lean/mathlib");
    if !mathlib_root.exists() {
        return Err(anyhow::anyhow!("Mathlib directory not found: {}", mathlib_root.display()));
    }
    build_keyword_index(mathlib_root.to_string_lossy().as_ref())
}

#[derive(Debug)]
pub struct IndexStats {
    pub total_files: usize,
    pub total_terms: usize,
    pub unique_terms: usize,
}

pub fn index_stats(index: &KeywordIndex) -> IndexStats {
    let mut total_terms = 0;
    let mut file_count = index.files.len();
    
    for terms in index.index.values() {
        total_terms += terms.len();
    }
    
    IndexStats {
        total_files: file_count,
        total_terms,
        unique_terms: index.index.len(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_keyword_index_basic() {
        let mut index = KeywordIndex::new();
        index.add_file("test1.txt", "hello world hello");
        index.add_file("test2.txt", "hello world");
        
        let matches = index.query("hello").unwrap();
        assert_eq!(matches.len(), 2);
        assert!(matches.contains(&"test1.txt".to_string()));
        assert!(matches.contains(&"test2.txt".to_string()));
    }
}