//! Numerics extraction and analysis for Aristotle projects.
//!
//! This module provides functionality to:
//! 1. Extract numerical constants from Lean files in git-versions repos
//! 2. Compute prime factorizations
//! 3. Match constants with OEIS sequences
//! 4. Create a graph of projects connected by shared numerical values

use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};
use std::fs;
use std::path::{Path, PathBuf};
use regex::Regex;
use serde::{Deserialize, Serialize};
use tracing::{debug, info, instrument, warn};

/// A numerical constant extracted from a Lean file
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq, PartialOrd, Ord)]
pub struct NumericalConstant {
    /// The numeric value
    pub value: u64,
    /// The project ID where this constant was found
    pub project_id: String,
    /// The file path where it was found
    pub file_path: String,
    /// The line number where it was found
    pub line_number: usize,
    /// The context/snippet around the constant
    pub context: String,
}

/// Prime factorization of a number
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub struct PrimeFactorization {
    /// The original number
    pub number: u64,
    /// Prime factors with their exponents: p -> exponent
    pub factors: BTreeMap<u64, u32>,
}

impl PrimeFactorization {
    /// Compute prime factorization of a number
    pub fn compute(number: u64) -> Self {
        let mut n = number;
        let mut factors = BTreeMap::new();
        
        // Handle 2 separately
        while n % 2 == 0 {
            *factors.entry(2).or_insert(0) += 1;
            n /= 2;
        }
        
        // Check odd divisors up to sqrt(n)
        let mut i = 3;
        while i * i <= n {
            while n % i == 0 {
                *factors.entry(i).or_insert(0) += 1;
                n /= i;
            }
            i += 2;
        }
        
        // If n is still > 1, it's a prime
        if n > 1 {
            factors.insert(n, 1);
        }
        
        PrimeFactorization { number, factors }
    }
    
    /// Get the prime factors as a sorted set
    pub fn prime_factors(&self) -> Vec<u64> {
        self.factors.keys().cloned().collect()
    }
    
    /// Get the exponents for a specific prime factor
    pub fn exponent(&self, prime: u64) -> u32 {
        *self.factors.get(&prime).unwrap_or(&0)
    }
    
    /// Check if this number is prime
    pub fn is_prime(&self) -> bool {
        self.factors.len() == 1 && self.factors.values().next().unwrap_or(&0) == &1
    }
    
    /// Get the radical (product of distinct prime factors)
    pub fn radical(&self) -> u64 {
        self.factors.keys().product()
    }
}

/// Information about an OEIS sequence
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OeisSequence {
    /// OEIS sequence ID (e.g., "A000040")
    pub id: String,
    /// Sequence name/title
    pub name: String,
    /// Sequence data (first terms)
    pub data: Vec<u64>,
    /// Comments about the sequence
    pub comments: Vec<String>,
    /// References
    pub references: Vec<String>,
    /// Links
    pub links: Vec<String>,
}

/// A project with its extracted numerical constants
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectNumerics {
    /// Project ID
    pub project_id: String,
    /// List of numerical constants found
    pub constants: Vec<NumericalConstant>,
    /// Prime factorizations for each constant
    pub factorizations: HashMap<u64, PrimeFactorization>,
    /// Set of all prime factors across all constants
    pub all_prime_factors: BTreeSet<u64>,
}

/// The complete numerics graph connecting projects
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NumericsGraph {
    /// All projects with their numerics
    pub projects: HashMap<String, ProjectNumerics>,
    /// Map from constant value to projects that contain it
    pub constant_to_projects: HashMap<u64, HashSet<String>>,
    /// Map from prime factor to projects that contain it
    pub prime_to_projects: HashMap<u64, HashSet<String>>,
    /// Map from radical to projects
    pub radical_to_projects: HashMap<u64, HashSet<String>>,
    /// OEIS sequences that match our constants
    pub oeis_matches: HashMap<String, Vec<OeisMatch>>,
}

/// A match between a constant and an OEIS sequence
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OeisMatch {
    /// The OEIS sequence
    pub sequence: OeisSequence,
    /// The index in the sequence where the match occurs
    pub index: usize,
    /// The matching constant value
    pub value: u64,
    /// Projects that contain this value
    pub projects: HashSet<String>,
}

/// Similarity score between a project and an OEIS sequence
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectOeisSimilarity {
    /// Project ID
    pub project_id: String,
    /// OEIS sequence ID
    pub oeis_id: String,
    /// Jaccard similarity (intersection/union of constants)
    pub jaccard_similarity: f64,
    /// Cosine similarity (dot product / magnitudes)
    pub cosine_similarity: f64,
    /// Number of matching constants
    pub match_count: usize,
    /// Number of matching prime factors
    pub prime_match_count: usize,
    /// Matching constant values
    pub matching_values: Vec<u64>,
    /// Weighted score (combines multiple similarity metrics)
    pub weighted_score: f64,
}

/// Ranked OEIS sequences for a project
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectOeisRanking {
    /// Project ID
    pub project_id: String,
    /// All similarity scores for this project
    pub similarities: Vec<ProjectOeisSimilarity>,
    /// Top N OEIS sequences sorted by weighted score
    pub top_sequences: Vec<ProjectOeisSimilarity>,
}

/// Configuration for numerics extraction
#[derive(Debug, Clone)]
pub struct ExtractionConfig {
    /// Base directory containing git-versions
    pub git_base: PathBuf,
    /// File extensions to search
    pub extensions: Vec<String>,
    /// Minimum value to extract (to avoid tiny common numbers)
    pub min_value: u64,
    /// Maximum value to extract
    pub max_value: u64,
    /// Whether to extract from comments
    pub extract_comments: bool,
    /// Whether to extract from code
    pub extract_code: bool,
}

impl Default for ExtractionConfig {
    fn default() -> Self {
        ExtractionConfig {
            git_base: PathBuf::from("./git-versions"),
            extensions: vec!["lean".to_string()],
            min_value: 2,
            max_value: u64::MAX,
            extract_comments: true,
            extract_code: true,
        }
    }
}

impl NumericsGraph {
    pub fn new() -> Self {
        NumericsGraph {
            projects: HashMap::new(),
            constant_to_projects: HashMap::new(),
            prime_to_projects: HashMap::new(),
            radical_to_projects: HashMap::new(),
            oeis_matches: HashMap::new(),
        }
    }
    
    /// Add a project to the graph
    pub fn add_project(&mut self, project: ProjectNumerics) {
        // Store the project
        self.projects.insert(project.project_id.clone(), project.clone());
        
        // Index constants
        for constant in &project.constants {
            self.constant_to_projects
                .entry(constant.value)
                .or_default()
                .insert(constant.project_id.clone());
        }
        
        // Index prime factors
        for prime in &project.all_prime_factors {
            self.prime_to_projects
                .entry(*prime)
                .or_default()
                .insert(project.project_id.clone());
        }
        
        // Index radicals
        for constant in &project.constants {
            if let Some(factorization) = project.factorizations.get(&constant.value) {
                let radical = factorization.radical();
                self.radical_to_projects
                    .entry(radical)
                    .or_default()
                    .insert(project.project_id.clone());
            }
        }
    }
    
    /// Get projects that share a constant
    pub fn projects_sharing_constant(&self, value: u64) -> HashSet<String> {
        self.constant_to_projects.get(&value).cloned().unwrap_or_default()
    }
    
    /// Get projects that share a prime factor
    pub fn projects_sharing_prime(&self, prime: u64) -> HashSet<String> {
        self.prime_to_projects.get(&prime).cloned().unwrap_or_default()
    }
    
    /// Get all connections between projects
    pub fn get_connections(&self) -> Vec<(String, String, Vec<String>)> {
        let mut connections = Vec::new();
        
        // For each constant, if it appears in multiple projects, create connections
        for (value, projects) in &self.constant_to_projects {
            if projects.len() > 1 {
                let projects_list: Vec<String> = projects.iter().cloned().collect();
                for i in 0..projects_list.len() {
                    for j in (i + 1)..projects_list.len() {
                        connections.push((
                            projects_list[i].clone(),
                            projects_list[j].clone(),
                            vec![format!("constant: {}", value)],
                        ));
                    }
                }
            }
        }
        
        // For each prime, if it appears in multiple projects, create connections
        for (prime, projects) in &self.prime_to_projects {
            if projects.len() > 1 {
                let projects_list: Vec<String> = projects.iter().cloned().collect();
                for i in 0..projects_list.len() {
                    for j in (i + 1)..projects_list.len() {
                        connections.push((
                            projects_list[i].clone(),
                            projects_list[j].clone(),
                            vec![format!("prime factor: {}", prime)],
                        ));
                    }
                }
            }
        }
        
        connections
    }
}

/// Extract numerical constants from a string
#[instrument(skip(text, project_id, file_path, line_number))]
fn extract_numerics_from_text(
    text: &str,
    project_id: &str,
    file_path: &str,
    line_number: usize,
    config: &ExtractionConfig,
) -> Vec<NumericalConstant> {
    let mut constants = Vec::new();
    
    // Regex to match integers in various formats
    // This matches:
    // - Regular integers: 123, 4567
    // - Hex: 0x123, 0xABC
    // - Binary: 0b1010
    // - Octal: 0o755
    // - Negative numbers (we'll take absolute value): -123
    // - Numbers with underscores: 1_000_000
    let re = Regex::new(r"(?<![a-zA-Z0-9_])(?:0[xX][0-9a-fA-F_]+|0[bB][01_]+|0[oO][0-7_]+|-?\d[\d_]*|\d+)(?![a-zA-Z0-9_])").unwrap_or_else(|_| {
        // Fallback simpler regex
        Regex::new(r"\b\d+\b").unwrap()
    });
    
    // Also match numbers in scientific notation in comments
    let sci_re = Regex::new(r"\b\d+\.?\d*(?:[eE][-+]?\d+)?\b").unwrap();
    
    // Extract from comments (lines starting with -- or between /- and -/)
    if config.extract_comments {
        // Find all comments
        // Single-line comments: -- comment
        let single_line_re = Regex::new(r"--.*$(?m)").unwrap();
        // Multi-line comments: /- ... -/
        
        for cap in re.captures_iter(text) {
            if let Ok(num) = cap[0].parse::<u64>() {
                if num >= config.min_value && num <= config.max_value {
                    // Get context around the match
                    let start = cap.get(0).unwrap().start();
                    let end = cap.get(0).unwrap().end();
                    let before = text[..start].chars().rev().take(20).collect::<String>();
                    let after = text[end..].chars().take(20).collect::<String>();
                    let context = format!("{}{}{}", before.chars().rev().collect::<String>(), &cap[0], after);
                    
                    constants.push(NumericalConstant {
                        value: num,
                        project_id: project_id.to_string(),
                        file_path: file_path.to_string(),
                        line_number,
                        context,
                    });
                }
            }
        }
    }
    
    // Extract from code (numbers not in comments)
    if config.extract_code {
        // Remove comments first to avoid double-counting
        let without_comments = remove_comments(text);
        
        for cap in re.captures_iter(&without_comments) {
            if let Ok(num) = cap[0].parse::<u64>() {
                if num >= config.min_value && num <= config.max_value {
                    // Get context
                    let start = cap.get(0).unwrap().start();
                    let end = cap.get(0).unwrap().end();
                    let before = without_comments[..start].chars().rev().take(20).collect::<String>();
                    let after = without_comments[end..].chars().take(20).collect::<String>();
                    let context = format!("{}{}{}", before.chars().rev().collect::<String>(), &cap[0], after);
                    
                    // Check if this is likely a year (4-digit number in certain ranges)
                    // We might want to exclude years or handle them specially
                    
                    constants.push(NumericalConstant {
                        value: num,
                        project_id: project_id.to_string(),
                        file_path: file_path.to_string(),
                        line_number,
                        context,
                    });
                }
            }
        }
    }
    
    // Deduplicate by value and context
    let mut seen = HashSet::new();
    let mut deduped = Vec::new();
    for c in constants {
        let key = (c.value, c.file_path.clone(), c.line_number);
        if seen.insert(key) {
            deduped.push(c);
        }
    }
    deduped
}

/// Remove Lean comments from text
fn remove_comments(text: &str) -> String {
    // Remove single-line comments (-- to end of line)
    let text = Regex::new(r"--.*$(?m)").unwrap().replace_all(text, "");
    
    // Remove multi-line comments (/- ... -/)
    // Use a simple non-nested approach
    let text = Regex::new(r"/-[^-]*-\/").unwrap().replace_all(&text, "");
    
    text.to_string()
}

/// Extract all numerical constants from a project
#[instrument(skip(project_path, config))]
pub fn extract_project_numerics(
    project_path: &Path,
    project_id: &str,
    config: &ExtractionConfig,
) -> anyhow::Result<ProjectNumerics> {
    let mut constants = Vec::new();
    let mut file_paths = Vec::new();
    
    // Walk through all files in the project
    for entry in walkdir::WalkDir::new(project_path).max_depth(10) {
        let entry = entry?;
        let path = entry.path();
        
        // Check if it's a file with a matching extension
        if path.is_file() {
            if let Some(ext) = path.extension() {
                if config.extensions.contains(&ext.to_string_lossy().to_string()) {
                    file_paths.push(path.to_path_buf());
                }
            }
        }
    }
    
    // Process each file
    for file_path in &file_paths {
        let content = fs::read_to_string(file_path)?;
        let relative_path = file_path.strip_prefix(project_path).unwrap_or(file_path);
        
        for (line_num, line) in content.lines().enumerate() {
            let line_constants = extract_numerics_from_text(
                line,
                project_id,
                &format!("{}", relative_path.display()),
                line_num + 1,
                config,
            );
            constants.extend(line_constants);
        }
    }
    
    // Compute factorizations and collect prime factors
    let mut factorizations = HashMap::new();
    let mut all_prime_factors = BTreeSet::new();
    
    for constant in &constants {
        let factorization = PrimeFactorization::compute(constant.value);
        factorizations.insert(constant.value, factorization.clone());
        for prime in factorization.prime_factors() {
            all_prime_factors.insert(prime);
        }
    }
    
    // Sort constants by value
    constants.sort();
    
    Ok(ProjectNumerics {
        project_id: project_id.to_string(),
        constants,
        factorizations,
        all_prime_factors,
    })
}

/// Extract numerics from all projects in git-versions
#[instrument(skip(config))]
pub fn extract_all_projects_numerics(config: &ExtractionConfig) -> anyhow::Result<NumericsGraph> {
    let git_base = &config.git_base;
    let mut graph = NumericsGraph::new();
    
    if !git_base.exists() {
        return Err(anyhow::anyhow!("Git base directory not found: {}", git_base.display()));
    }
    
    // Find all project directories
    let mut project_dirs = Vec::new();
    for entry in fs::read_dir(git_base)? {
        let entry = entry?;
        if entry.file_type()?.is_dir() {
            let path = entry.path();
            // Skip .git directories
            if path.file_name() == Some(std::ffi::OsStr::new(".git")) {
                continue;
            }
            project_dirs.push(path);
        }
    }
    
    project_dirs.sort();
    info!("Found {} project directories", project_dirs.len());
    
    // Process each project
    let mut total_constants = 0;
    let mut total_projects = 0;
    
    for project_path in &project_dirs {
        let project_name = project_path.file_name().unwrap_or_default().to_string_lossy().to_string();
        
        match extract_project_numerics(project_path, &project_name, config) {
            Ok(project_numerics) => {
                if !project_numerics.constants.is_empty() {
                    let constant_count = project_numerics.constants.len();
                    graph.add_project(project_numerics);
                    total_constants += constant_count;
                    total_projects += 1;
                    debug!(project = %project_name, constants = constant_count);
                } else {
                    debug!(project = %project_name, "No constants found");
                }
            }
            Err(e) => {
                warn!(project = %project_name, error = %e, "Failed to extract numerics");
            }
        }
    }
    
    info!(
        "Extracted numerics from {} projects, found {} constants",
        total_projects, total_constants
    );
    
    Ok(graph)
}

/// Save the numerics graph to a JSON file
pub fn save_graph(graph: &NumericsGraph, path: &Path) -> anyhow::Result<()> {
    let json = serde_json::to_string_pretty(graph)?;
    fs::write(path, json)?;
    info!("Saved numerics graph to {}", path.display());
    Ok(())
}

/// Load the numerics graph from a JSON file
pub fn load_graph(path: &Path) -> anyhow::Result<NumericsGraph> {
    let json = fs::read_to_string(path)?;
    let graph: NumericsGraph = serde_json::from_str(&json)?;
    info!("Loaded numerics graph from {}", path.display());
    Ok(graph)
}

/// Match constants against OEIS sequences
pub fn match_oeis_sequences(
    graph: &NumericsGraph,
    oeis_dir: &Path,
) -> anyhow::Result<HashMap<String, Vec<OeisMatch>>> {
    use std::collections::BTreeMap;
    
    let mut matches = HashMap::new();
    
    // First, collect all unique constants across all projects
    let mut all_constants: BTreeMap<u64, HashSet<String>> = BTreeMap::new();
    for (project_id, project) in &graph.projects {
        for constant in &project.constants {
            all_constants.entry(constant.value).or_default().insert(project_id.clone());
        }
    }
    
    info!("Matching {} unique constants against OEIS", all_constants.len());
    
    // Walk through OEIS sequences
    if !oeis_dir.exists() {
        warn!("OEIS directory not found: {}", oeis_dir.display());
        return Ok(matches);
    }
    
    let mut seq_count = 0;
    let mut match_count = 0;
    
    for entry in walkdir::WalkDir::new(oeis_dir) {
        let entry = entry?;
        let path = entry.path();
        
        if path.is_file() && path.extension() == Some(std::ffi::OsStr::new("seq")) {
            if let Ok(sequence) = parse_oeis_seq_file(path) {
                seq_count += 1;
                
                // Check each term in the sequence against our constants
                for (index, &term) in sequence.data.iter().enumerate() {
                    if let Some(projects) = all_constants.get(&term) {
                        let oeis_match = OeisMatch {
                            sequence: sequence.clone(),
                            index,
                            value: term,
                            projects: projects.clone(),
                        };
                        
                        // Store match by sequence ID
                        matches.entry(sequence.id.clone())
                            .or_default()
                            .push(oeis_match);
                        
                        match_count += 1;
                    }
                }
                
                if seq_count % 100 == 0 {
                    info!("Processed {} sequences, found {} matches", seq_count, match_count);
                }
            }
        }
    }
    
    info!(
        "OEIS matching complete: {} sequences, {} matches",
        seq_count, match_count
    );
    
    Ok(matches)
}

/// Compute similarity scores between all projects and OEIS sequences
/// Returns a map from project ID to its ranked OEIS sequences
#[instrument(skip(graph, oeis_dir, top_n))]
pub fn compute_oeis_similarity(
    graph: &NumericsGraph,
    oeis_dir: &Path,
    top_n: usize,
) -> anyhow::Result<HashMap<String, ProjectOeisRanking>> {
    use std::collections::BTreeMap;
    
    info!("Computing OEIS similarity scores...");
    
    // First, load all OEIS sequences
    let mut sequences: HashMap<String, OeisSequence> = HashMap::new();
    
    if oeis_dir.exists() {
        for entry in walkdir::WalkDir::new(oeis_dir) {
            let entry = entry?;
            let path = entry.path();
            
            if path.is_file() && path.extension() == Some(std::ffi::OsStr::new("seq")) {
                if let Ok(seq) = parse_oeis_seq_file(path) {
                    sequences.insert(seq.id.clone(), seq);
                }
            }
        }
    }
    
    info!("Loaded {} OEIS sequences", sequences.len());
    
    // Compute document frequency (DF) for IDF weighting
    // How many projects contain each constant
    let mut df: HashMap<u64, usize> = HashMap::new();
    for (_, project) in &graph.projects {
        let mut project_constants: HashSet<u64> = HashSet::new();
        for constant in &project.constants {
            project_constants.insert(constant.value);
        }
        for value in project_constants {
            *df.entry(value).or_default() += 1;
        }
    }
    
    let total_projects = graph.projects.len();
    
    // For each project, compute similarity with each OEIS sequence
    let mut project_rankings: HashMap<String, ProjectOeisRanking> = HashMap::new();
    
    for (project_id, project) in &graph.projects {
        let project_constants: HashSet<u64> = project.constants.iter().map(|c| c.value).collect();
        let project_primes: HashSet<u64> = project.all_prime_factors.iter().cloned().collect();
        
        let mut similarities: Vec<ProjectOeisSimilarity> = Vec::new();
        
        for (oeis_id, sequence) in &sequences {
            // Get constants from the sequence
            let seq_constants: HashSet<u64> = sequence.data.iter().cloned().collect();
            let seq_primes: HashSet<u64> = sequence.data.iter()
                .flat_map(|&v| PrimeFactorization::compute(v).prime_factors())
                .collect();
            
            // Intersection
            let const_intersection: HashSet<u64> = project_constants.intersection(&seq_constants).cloned().collect();
            let prime_intersection: HashSet<u64> = project_primes.intersection(&seq_primes).cloned().collect();
            
            let match_count = const_intersection.len();
            let prime_match_count = prime_intersection.len();
            
            if match_count == 0 && prime_match_count == 0 {
                continue; // No similarity
            }
            
            // Jaccard similarity for constants
            let const_union = project_constants.union(&seq_constants).count();
            let jaccard = if const_union > 0 {
                match_count as f64 / const_union as f64
            } else {
                0.0
            };
            
            // Cosine similarity (TF-IDF weighted)
            let mut cosine_numerator = 0.0;
            let mut project_magnitude = 0.0;
            let mut seq_magnitude = 0.0;
            
            for value in &const_intersection {
                // TF-IDF weight: log(total_projects / df(value))
                let idf = if let Some(&doc_freq) = df.get(value) {
                    (total_projects as f64 / doc_freq as f64).ln() + 1.0
                } else {
                    1.0
                };
                
                // For simplicity, TF is 1 for presence
                let weight = idf;
                cosine_numerator += weight * weight;
                project_magnitude += weight * weight;
                seq_magnitude += weight * weight;
            }
            
            let cosine = if project_magnitude > 0.0 && seq_magnitude > 0.0 {
                cosine_numerator / (project_magnitude.sqrt() * seq_magnitude.sqrt())
            } else {
                0.0
            };
            
            // Weighted score combining multiple metrics
            // Weight: 0.4 * jaccard + 0.4 * cosine + 0.1 * match_count + 0.1 * prime_match
            let weighted_score = 0.4 * jaccard + 
                              0.4 * cosine + 
                              0.1 * (match_count as f64 / 10.0).tan() + 
                              0.1 * (prime_match_count as f64);
            
            let similarity = ProjectOeisSimilarity {
                project_id: project_id.clone(),
                oeis_id: oeis_id.clone(),
                jaccard_similarity: jaccard,
                cosine_similarity: cosine,
                match_count,
                prime_match_count,
                matching_values: const_intersection.into_iter().collect(),
                weighted_score,
            };
            
            similarities.push(similarity);
        }
        
        // Sort by weighted score descending
        similarities.sort_by(|a, b| b.weighted_score.partial_cmp(&a.weighted_score).unwrap());
        
        // Take top N
        let top_sequences = similarities.iter().take(top_n).cloned().collect();
        
        let ranking = ProjectOeisRanking {
            project_id: project_id.clone(),
            similarities,
            top_sequences,
        };
        
        project_rankings.insert(project_id.clone(), ranking);
    }
    
    info!("Computed similarity scores for {} projects", project_rankings.len());
    
    Ok(project_rankings)
}

/// Generate a report showing top OEIS sequences for each project
pub fn generate_oeis_report(
    rankings: &HashMap<String, ProjectOeisRanking>,
    output_path: &Path,
) -> anyhow::Result<()> {
    use std::io::Write;
    
    let mut report = String::new();
    
    report.push_str(&format!("# OEIS Sequence Similarity Report\n\n"));
    report.push_str(&format!("Total projects with OEIS matches: {}\n\n", rankings.len()));
    
    // Sort projects by number of matches
    let mut projects: Vec<_> = rankings.iter().collect();
    projects.sort_by(|a, b| b.1.top_sequences.len().cmp(&a.1.top_sequences.len()));
    
    for (project_id, ranking) in &projects {
        if ranking.top_sequences.is_empty() {
            continue;
        }
        
        report.push_str(&format!("## Project: {}\n\n", project_id));
        report.push_str("| Rank | OEIS ID | Weighted Score | Jaccard | Cosine | Matches | Primes |\n");
        report.push_str("|------|---------|----------------|---------|--------|---------|--------|\n");
        
        for (i, sim) in ranking.top_sequences.iter().enumerate() {
            report.push_str(&format!(
                "| {} | {} | {:.4} | {:.4} | {:.4} | {} | {} |\n",
                i + 1,
                sim.oeis_id,
                sim.weighted_score,
                sim.jaccard_similarity,
                sim.cosine_similarity,
                sim.match_count,
                sim.prime_match_count
            ));
        }
        
        report.push_str("\n");
    }
    
    // Summary statistics
    report.push_str("## Summary Statistics\n\n");
    
    let total_matches: usize = rankings.values().map(|r| r.top_sequences.len()).sum();
    let avg_matches = total_matches as f64 / rankings.len() as f64;
    
    report.push_str(&format!("- Total OEIS matches across all projects: {}\n", total_matches));
    report.push_str(&format!("- Average matches per project: {:.2}\n", avg_matches));
    
    // Top OEIS sequences across all projects
    let mut all_oeis_scores: Vec<(String, f64, usize)> = Vec::new();
    for ranking in rankings.values() {
        for sim in &ranking.top_sequences {
            let entry = (sim.oeis_id.clone(), sim.weighted_score, sim.match_count);
            all_oeis_scores.push(entry);
        }
    }
    all_oeis_scores.sort_by(|a, b| b.1.partial_cmp(&a.1).unwrap());
    
    report.push_str("\n## Top OEIS Sequences Across All Projects\n\n");
    report.push_str("| Rank | OEIS ID | Best Score | Projects |\n");
    report.push_str("|------|---------|------------|----------|\n");
    
    let mut oeis_project_count: HashMap<String, usize> = HashMap::new();
    for (oeis_id, _, _) in &all_oeis_scores {
        *oeis_project_count.entry(oeis_id.clone()).or_default() += 1;
    }
    
    for (i, (oeis_id, score, _)) in all_oeis_scores.iter().take(20).enumerate() {
        let count = oeis_project_count.get(oeis_id).unwrap_or(&0);
        report.push_str(&format!("| {} | {} | {:.4} | {} |\n", i + 1, oeis_id, score, count));
    }
    
    fs::write(output_path, report)?;
    info!("Generated OEIS report at {}", output_path.display());
    
    Ok(())
}

/// Generate a JSON file with all similarity data
pub fn save_similarity_data(
    rankings: &HashMap<String, ProjectOeisRanking>,
    output_path: &Path,
) -> anyhow::Result<()> {
    let json = serde_json::to_string_pretty(rankings)?;
    fs::write(output_path, json)?;
    info!("Saved similarity data to {}", output_path.display());
    Ok(())
}

/// Parse an OEIS .seq file
fn parse_oeis_seq_file(path: &Path) -> anyhow::Result<OeisSequence> {
    let content = fs::read_to_string(path)?;
    let mut lines = content.lines();
    
    let mut id = String::new();
    let mut name = String::new();
    let mut data = Vec::new();
    let mut comments = Vec::new();
    let mut references = Vec::new();
    let mut links = Vec::new();
    
    while let Some(line) = lines.next() {
        if line.starts_with("%I ") {
            // ID line: %I A000040
            id = line.trim_start_matches("%I ").trim().to_string();
        } else if line.starts_with("%S ") || line.starts_with("%T ") || line.starts_with("%U ") {
            // Data lines: %S A000040 1,2,3,5,7,11
            let data_line = line.trim_start_matches(|c: char| c == '%' || c.is_whitespace());
            let parts: Vec<&str> = data_line.split_whitespace().collect();
            if parts.len() >= 2 {
                // Parse the sequence values (comma-separated after the ID)
                let values_str = parts[1..].join(" ");
                for val_str in values_str.split(',') {
                    if let Ok(val) = val_str.trim().parse::<u64>() {
                        data.push(val);
                    }
                }
            }
        } else if line.starts_with("%N ") {
            // Name line
            name = line.trim_start_matches("%N ").trim().to_string();
        } else if line.starts_with("%C ") {
            // Comment line
            let comment = line.trim_start_matches("%C ").trim().to_string();
            comments.push(comment);
        } else if line.starts_with("%H ") {
            // HTML line (links)
            let link = line.trim_start_matches("%H ").trim().to_string();
            links.push(link);
        } else if line.starts_with("%R ") {
            // Reference line
            let ref_line = line.trim_start_matches("%R ").trim().to_string();
            references.push(ref_line);
        }
    }
    
    if id.is_empty() {
        return Err(anyhow::anyhow!("No ID found in sequence file"));
    }
    
    Ok(OeisSequence {
        id,
        name,
        data,
        comments,
        references,
        links,
    })
}

/// Generate a DOT graph visualization of the numerics connections
pub fn generate_dot_graph(
    graph: &NumericsGraph,
    output_path: &Path,
) -> anyhow::Result<()> {
    
    let mut dot = String::new();
    dot.push_str("digraph NumericsGraph {\n");
    dot.push_str("  rankdir=LR;\n");
    dot.push_str("  node [shape=box];\n");
    dot.push_str("  edge [len=2];\n\n");
    
    // Add nodes for each project
    for project_id in graph.projects.keys() {
        let short_id = &project_id[..8.min(project_id.len())];
        dot.push_str(&format!("  \"{}\" [label=\"{}\"];\n", project_id, short_id));
    }
    
    dot.push_str("\n");
    
    // Add edges for connections
    let connections = graph.get_connections();
    let mut seen_edges = HashSet::new();
    
    for (src, dst, reasons) in &connections {
        let edge_key = if src < dst {
            format!("{}-{}", src, dst)
        } else {
            format!("{}-{}", dst, src)
        };
        
        if seen_edges.insert(edge_key) {
            let label = reasons.join(", ");
            dot.push_str(&format!(
                "  \"{}\" -> \"{}\" [label=\"{}\"];\n",
                src, dst, label
            ));
        }
    }
    
    dot.push_str("}\n");
    
    fs::write(output_path, dot)?;
    info!("Generated DOT graph at {}", output_path.display());
    
    Ok(())
}

/// Top-level command to extract numerics from all projects
#[instrument]
pub fn cmd_extract_numerics(
    git_base: Option<PathBuf>,
    output_dir: Option<PathBuf>,
    oeis_dir: Option<PathBuf>,
) -> anyhow::Result<()> {
    use std::time::Instant;
    
    let start = Instant::now();
    
    let config = ExtractionConfig {
        git_base: git_base.unwrap_or_else(|| PathBuf::from("./git-versions")),
        extensions: vec!["lean".to_string()],
        min_value: 2,
        max_value: u64::MAX,
        extract_comments: true,
        extract_code: true,
    };
    
    let output_dir = output_dir.unwrap_or_else(|| PathBuf::from("./numerics-output"));
    fs::create_dir_all(&output_dir)?;
    
    // Step 1: Extract numerics from all projects
    info!("Step 1: Extracting numerics from projects...");
    let graph = extract_all_projects_numerics(&config)?;
    
    // Save the graph
    let graph_path = output_dir.join("numerics_graph.json");
    save_graph(&graph, &graph_path)?;
    
    // Step 2: Match with OEIS if directory provided
    if let Some(oeis_dir_path) = oeis_dir {
        info!("Step 2: Matching with OEIS sequences...");
        let oeis_matches = match_oeis_sequences(&graph, &oeis_dir_path)?;
        
        // Add matches to graph
        // Note: We need to make graph mutable to add oeis_matches
        // For now, save separately
        let matches_path = output_dir.join("oeis_matches.json");
        fs::write(&matches_path, serde_json::to_string_pretty(&oeis_matches)?)?;
        info!("Saved OEIS matches to {}", matches_path.display());
        
        // Step 2.5: Compute similarity scores and rank OEIS sequences per project
        info!("Step 2.5: Computing OEIS similarity scores...");
        let top_n = 10; // Top 10 OEIS sequences per project
        let rankings = compute_oeis_similarity(&graph, &oeis_dir_path, top_n)?;
        
        // Save similarity data
        let similarity_path = output_dir.join("oeis_similarity.json");
        save_similarity_data(&rankings, &similarity_path)?;
        
        // Generate report
        let report_path = output_dir.join("OEIS_REPORT.md");
        generate_oeis_report(&rankings, &report_path)?;
    }
    
    // Step 3: Generate DOT graph
    info!("Step 3: Generating DOT graph...");
    let dot_path = output_dir.join("numerics_graph.dot");
    generate_dot_graph(&graph, &dot_path)?;
    
    // Step 4: Generate summary
    info!("Step 4: Generating summary...");
    let summary = generate_summary(&graph);
    let summary_path = output_dir.join("SUMMARY.md");
    fs::write(&summary_path, summary)?;
    
    let elapsed = start.elapsed();
    info!("Completed in {:.2}s", elapsed.as_secs_f64());
    
    Ok(())
}

/// Generate a summary report of the numerics graph
pub fn generate_summary(graph: &NumericsGraph) -> String {
    let mut summary = String::new();
    
    summary.push_str(&format!("# Numerics Graph Summary\n\n"));
    summary.push_str(&format!(
        "- Total projects: {}\n",
        graph.projects.len()
    ));
    
    let total_constants: usize = graph.projects.values().map(|p| p.constants.len()).sum();
    summary.push_str(&format!("- Total constants extracted: {}\n", total_constants));
    
    let total_unique_constants = graph.constant_to_projects.len();
    summary.push_str(&format!("- Unique constant values: {}\n", total_unique_constants));
    
    let total_primes = graph.prime_to_projects.len();
    summary.push_str(&format!("- Unique prime factors: {}\n", total_primes));
    
    let total_radicals = graph.radical_to_projects.len();
    summary.push_str(&format!("- Unique radicals: {}\n\n", total_radicals));
    
    // Top 10 most common constants
    summary.push_str("## Top 10 Most Common Constants\n\n");
    summary.push_str("| Value | Projects |\n");
    summary.push_str("|-------|----------|\n");
    
    let mut constants_by_frequency: Vec<_> = graph
        .constant_to_projects
        .iter()
        .map(|(value, projects)| (*value, projects.len()))
        .collect();
    constants_by_frequency.sort_by(|a, b| b.1.cmp(&a.1));
    
    for (value, count) in constants_by_frequency.iter().take(10) {
        summary.push_str(&format!("| {} | {} |\n", value, count));
    }
    
    summary.push_str("\n## Top 10 Most Common Prime Factors\n\n");
    summary.push_str("| Prime | Projects |\n");
    summary.push_str("|-------|----------|\n");
    
    let mut primes_by_frequency: Vec<_> = graph
        .prime_to_projects
        .iter()
        .map(|(prime, projects)| (*prime, projects.len()))
        .collect();
    primes_by_frequency.sort_by(|a, b| b.1.cmp(&a.1));
    
    for (prime, count) in primes_by_frequency.iter().take(10) {
        summary.push_str(&format!("| {} | {} |\n", prime, count));
    }
    
    // Projects with most connections
    summary.push_str("\n## Top 10 Most Connected Projects\n\n");
    summary.push_str("| Project | Connections |\n");
    summary.push_str("|---------|-------------|\n");
    
    let connections = graph.get_connections();
    let mut project_connections: HashMap<String, usize> = HashMap::new();
    for (src, dst, _) in &connections {
        *project_connections.entry(src.clone()).or_insert(0) += 1;
        *project_connections.entry(dst.clone()).or_insert(0) += 1;
    }
    
    let mut projects_by_connections: Vec<_> = project_connections.into_iter().collect();
    projects_by_connections.sort_by(|a, b| b.1.cmp(&a.1));
    
    for (project, count) in projects_by_connections.iter().take(10) {
        let short = &project[..8.min(project.len())];
        summary.push_str(&format!("| {} | {} |\n", short, count));
    }
    
    summary.push_str("\n## Largest Prime Factors\n\n");
    summary.push_str("| Prime | Projects |\n");
    summary.push_str("|-------|----------|\n");
    
    primes_by_frequency.sort_by(|a, b| b.0.cmp(&a.0));
    for (prime, count) in primes_by_frequency.iter().take(10) {
        summary.push_str(&format!("| {} | {} |\n", prime, count));
    }
    
    summary
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_prime_factorization() {
        let pf = PrimeFactorization::compute(123456);
        assert_eq!(pf.number, 123456);
        assert!(pf.factors.contains_key(&2));
        assert!(pf.factors.contains_key(&3));
        
        let pf = PrimeFactorization::compute(17);
        assert!(pf.is_prime());
        assert_eq!(pf.prime_factors(), vec![17]);
    }
    
    #[test]
    fn test_extract_numerics() {
        let text = "-- This is a comment with 123 and 456\n def foo := 789";
        let config = ExtractionConfig::default();
        let constants = extract_numerics_from_text(text, "test_project", "test.lean", 1, &config);
        
        assert!(!constants.is_empty());
        let values: Vec<u64> = constants.iter().map(|c| c.value).collect();
        assert!(values.contains(&123));
        assert!(values.contains(&456));
        assert!(values.contains(&789));
    }
}
