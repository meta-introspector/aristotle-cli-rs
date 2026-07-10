/// num_graph — Extract numerical constants and prime factorizations to glue projects together.
/// 
/// This module:
/// 1. Extracts all numerical constants from Lean files
/// 2. Factorizes primes (when possible)
/// 3. Builds a graph where projects are connected via shared constants
/// 4. Identifies "glue" points - constants that appear in multiple projects

use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::fs;
use std::path::{Path, PathBuf};
use anyhow::{Context, Result};
use serde::Serialize;
use tracing::{debug, info, instrument, warn};

/// Information about a numerical constant
#[derive(Debug, Clone, Serialize)]
pub struct NumConst {
    /// The raw numerical value as it appears in source
    pub raw: String,
    /// Parsed integer value (if parseable)
    pub value: Option<u64>,
    /// Prime factorization (if applicable)
    pub factors: Option<Vec<(u64, u64)>>,  // (prime, exponent)
    /// Is this a prime number?
    pub is_prime: bool,
    /// Projects that define/use this constant
    pub projects: BTreeSet<String>,
    /// Source locations where this constant appears
    pub locations: Vec<String>,
}

/// The numerical constant graph
#[derive(Debug, Clone, Serialize)]
pub struct NumGraph {
    /// Map from constant value to its info
    pub constants: BTreeMap<u64, NumConst>,
    /// Map from project to constants it uses
    pub project_constants: HashMap<String, BTreeSet<u64>>,
    /// "Glue" constants - appear in multiple projects
    pub glue_constants: Vec<u64>,
}

impl NumGraph {
    pub fn new() -> Self {
        Self {
            constants: BTreeMap::new(),
            project_constants: HashMap::new(),
            glue_constants: Vec::new(),
        }
    }

    /// Add a constant occurrence
    pub fn add_constant(&mut self, value: u64, raw: &str, project: &str, location: &str) {
        let entry = self.constants.entry(value).or_insert_with(|| NumConst {
            raw: raw.to_string(),
            value: Some(value),
            factors: None,
            is_prime: false,
            projects: BTreeSet::new(),
            locations: Vec::new(),
        });
        
        entry.projects.insert(project.to_string());
        entry.locations.push(location.to_string());
        self.project_constants
            .entry(project.to_string())
            .or_default()
            .insert(value);
    }

    /// Finalize the graph: compute factorizations, identify primes, find glue
    pub fn finalize(&mut self) {
        // Factorize all constants
        for (value, const_info) in &mut self.constants {
            if let Some(factors) = factorize(*value) {
                const_info.factors = Some(factors.clone());
                const_info.is_prime = factors.len() == 1 && factors[0].1 == 1;
            }
        }
        
        // Find glue constants (appear in >1 project)
        self.glue_constants = self.constants
            .iter()
            .filter(|(_, c)| c.projects.len() > 1)
            .map(|(k, _)| *k)
            .collect();
        
        // Sort glue constants by number of projects (descending)
        self.glue_constants.sort_by(|a, b| {
            let a_count = self.constants.get(a).map(|c| c.projects.len()).unwrap_or(0);
            let b_count = self.constants.get(b).map(|c| c.projects.len()).unwrap_or(0);
            b_count.cmp(&a_count)
        });
    }

    /// Get constants that appear in a specific project
    pub fn get_project_constants(&self, project: &str) -> Vec<u64> {
        self.project_constants
            .get(project)
            .map(|s| s.iter().cloned().collect())
            .unwrap_or_default()
    }

    /// Get projects connected by a specific constant
    pub fn get_connected_projects(&self, constant: u64) -> Vec<String> {
        self.constants
            .get(&constant)
            .map(|c| c.projects.iter().cloned().collect())
            .unwrap_or_default()
    }
}

/// Simple prime factorization (for numbers up to ~10^12)
/// Returns None for numbers that are too large or take too long
fn factorize(mut n: u64) -> Option<Vec<(u64, u64)>> {
    if n < 2 {
        return None;
    }
    
    let mut factors = Vec::new();
    
    // Check divisibility by 2
    if n % 2 == 0 {
        let mut exp = 0;
        while n % 2 == 0 {
            exp += 1;
            n /= 2;
        }
        factors.push((2, exp));
    }
    
    // Check odd divisors up to sqrt(n)
    let limit = (n as f64).sqrt() as u64 + 1;
    let mut d = 3u64;
    while d <= limit && d * d <= n {
        if n % d == 0 {
            let mut exp = 0;
            while n % d == 0 {
                exp += 1;
                n /= d;
            }
            factors.push((d, exp));
        }
        d += 2;
        // Safety limit for large numbers
        if d > 1_000_000 {
            return None;
        }
    }
    
    if n > 1 {
        factors.push((n, 1));
    }
    
    if factors.is_empty() {
        None
    } else {
        Some(factors)
    }
}

/// Format factorization as string (e.g., "2^2 * 3 * 5^3")
fn format_factors(factors: &[(u64, u64)]) -> String {
    factors
        .iter()
        .map(|(p, e)| {
            if *e == 1 {
                p.to_string()
            } else {
                format!("{}^", p)
            }
        })
        .collect::<Vec<_>>()
        .join(" * ")
}

/// Extract numerical constants from a Lean file
fn extract_numerical_consts(file_path: &Path) -> Result<Vec<(u64, String, String)>> {
    /// Returns (value, raw_text, file_path)
    
    let content = fs::read_to_string(file_path)
        .with_context(|| format!("Failed to read file: {}", file_path.display()))?;
    
    let mut results = Vec::new();
    
    // Regex-like pattern matching for numbers in Lean
    // Look for sequences of digits (optionally with underscores for readability)
    // Common patterns: 196883, 0x..., 2^10, etc.
    
    for (line_num, line) in content.lines().enumerate() {
        let trimmed = line.trim();
        
        // Skip comments
        if trimmed.starts_with("--") || trimmed.starts_with("#") {
            continue;
        }
        
        // Find all number literals in the line
        // Lean allows underscores in numbers: 1_000_000
        let tokens: Vec<&str> = trimmed
            .split(|c: char| !c.is_ascii_digit() && c != '_')
            .filter(|s| !s.is_empty())
            .collect();
        
        for token in tokens {
            // Remove underscores and parse
            let clean: String = token.chars().filter(|c| c.is_ascii_digit()).collect();
            if clean.len() > 10 { // Skip very long numbers (likely hashes)
                continue;
            }
            if let Ok(value) = clean.parse::<u64>() {
                // Skip very small numbers (likely indices or loop counters)
                if value > 100 || is_interesting_number(value) {
                    let raw = token.to_string();
                    let location = format!("{}:{}", file_path.display(), line_num + 1);
                    results.push((value, raw, location));
                }
            }
        }
        
        // Also look for specific known constants
        let known_consts = [
            "196883", "196884", "71", "59", "47", "1823", "67", "631",
            "39", "45", "4", "51", "56", "28", "23", "2", "29",
            "JANKO", "MATHIEU", "SUZUKI", "CONWAY", "BABY_MONSTER",
        ];
        
        for &const_name in &known_consts {
            if line.contains(const_name) {
                // Try to extract the actual number
                if let Ok(value) = const_name.parse::<u64>() {
                    let location = format!("{}:{}", file_path.display(), line_num + 1);
                    results.push((value, const_name.to_string(), location));
                }
            }
        }
    }
    
    Ok(results)
}

/// Check if a number is "interesting" (not just a loop counter or index)
fn is_interesting_number(n: u64) -> bool {
    // Numbers that are likely meaningful constants
    // Primes, products of small primes, known mathematical constants
    
    // Small primes
    let small_primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79];
    if small_primes.contains(&n) {
        return true;
    }
    
    // Products of small primes (likely factorizations)
    if n > 100 && n < 1_000_000 {
        // Check if it has few prime factors (structured number)
        if let Some(factors) = factorize(n) {
            if factors.len() <= 5 {
                return true;
            }
        }
    }
    
    // Known interesting numbers
    let known = [196883, 196884, 24, 60, 120, 168, 252, 336, 504, 720, 1008, 1440];
    known.contains(&n)
}

/// Process a single project directory, extract numerical constants
fn process_project_num(project_path: &Path) -> Result<(String, Vec<(u64, String, String)>)> {
    let project_name = project_path
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or("unknown")
        .to_string();
    
    let mut all_constants = Vec::new();
    
    // Walk through all .lean files in the project
    for entry in walkdir::WalkDir::new(project_path)
        .max_depth(10)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let path = entry.path();
        if path.extension().map_or(false, |ext| ext == "lean") {
            match extract_numerical_consts(path) {
                Ok(consts) => {
                    all_constants.extend(consts);
                }
                Err(e) => {
                    warn!(file = %path.display(), error = %e, "Failed to extract numerical constants");
                }
            }
        }
    }
    
    Ok((project_name, all_constants))
}

/// Build numerical constant graph from git-versions directory
#[instrument(skip(git_base, output_dir))]
pub fn build_num_graph(
    git_base: &Path,
    output_dir: Option<PathBuf>,
) -> Result<NumGraph> {
    info!("Building numerical constant graph from {}", git_base.display());
    
    let git_versions_dir = git_base.join("git-versions");
    
    if !git_versions_dir.exists() {
        return Err(anyhow::anyhow!(
            "git-versions directory not found: {}",
            git_versions_dir.display()
        ));
    }
    
    let mut graph = NumGraph::new();
    let mut projects_processed = 0u64;
    let mut constants_found = 0u64;
    
    // Find all project directories in git-versions
    for entry in fs::read_dir(&git_versions_dir)? {
        let entry = entry?;
        if entry.file_type()?.is_dir() {
            let project_path = entry.path();
            let project_name = entry.file_name().to_string_lossy().to_string();
            
            info!("Processing project: {}", project_name);
            
            match process_project_num(&project_path) {
                Ok((_, constants)) => {
                    projects_processed += 1;
                    for (value, raw, location) in constants {
                        graph.add_constant(value, &raw, &project_name, &location);
                        constants_found += 1;
                    }
                }
                Err(e) => {
                    warn!(project = %project_name, error = %e, "Failed to process project");
                }
            }
        }
    }
    
    // Finalize the graph
    graph.finalize();
    
    info!(
        projects = projects_processed,
        constants = constants_found,
        unique_constants = graph.constants.len(),
        glue_constants = graph.glue_constants.len(),
        "Numerical constant graph built"
    );
    
    // Save results if output_dir specified
    if let Some(output_dir) = output_dir {
        fs::create_dir_all(&output_dir)?;
        
        // Save graph as JSON
        let graph_json = serde_json::to_string_pretty(&graph)?;
        fs::write(output_dir.join("num_graph.json"), &graph_json)?;
        
        // Save summary
        let summary = serde_json::json!({
            "total_constants": graph.constants.len(),
            "total_projects": graph.project_constants.len(),
            "glue_constants": graph.glue_constants.len(),
            "primes_found": graph.constants.iter().filter(|(_, c)| c.is_prime).count(),
            "factorized": graph.constants.iter().filter(|(_, c)| c.factors.is_some()).count(),
        });
        fs::write(output_dir.join("num_summary.json"), serde_json::to_string_pretty(&summary)?)?;
        
        // Save DOT format
        let dot = generate_num_dot_graph(&graph);
        fs::write(output_dir.join("num_graph.dot"), dot)?;
        
        // Save markdown report
        let report = generate_num_report(&graph);
        fs::write(output_dir.join("num_report.md"), &report)?;
        
        info!("Results saved to {}", output_dir.display());
    }
    
    Ok(graph)
}

/// Generate DOT format graph for visualization
pub fn generate_num_dot_graph(graph: &NumGraph) -> String {
    let mut dot = String::new();
    dot.push_str("digraph NumGraph {\n");
    dot.push_str("  rankdir=LR;\n");
    dot.push_str("  node [shape=ellipse];\n\n");
    
    // Glue constants in the center
    dot.push_str("  // Glue Constants (shared across projects)\n");
    for &value in &graph.glue_constants {
        if let Some(const_info) = graph.constants.get(&value) {
            let label = if let Some(ref factors) = const_info.factors {
                format!("{}\\n{}", value, format_factors(factors))
            } else {
                value.to_string()
            };
            dot.push_str(&format!("  \"{}\" [shape=doublecircle, label=\"{}\"];\n", value, label));
        }
    }
    dot.push_str("\n");
    
    // Projects as boxes
    dot.push_str("  // Projects\n");
    for (project, constants) in &graph.project_constants {
        dot.push_str(&format!("  \"{}_proj\" [shape=box, label=\"{}\", style=filled, color=lightblue];\n", project, project));
        
        // Connect project to its constants
        for &value in constants {
            dot.push_str(&format!("  \"{}_proj\" -> \"{}\";\n", project, value));
        }
    }
    
    dot.push_str("}\n");
    dot
}

/// Generate markdown report
pub fn generate_num_report(graph: &NumGraph) -> String {
    let mut report = String::new();
    
    report.push_str("# Numerical Constant Analysis\n\n");
    report.push_str(&format!("Total constants: {}\n", graph.constants.len()));
    report.push_str(&format!("Total projects: {}\n", graph.project_constants.len()));
    report.push_str(&format!("Glue constants (shared): {}\n\n", graph.glue_constants.len()));
    
    report.push_str("## Top Glue Constants (by number of projects)\n\n");
    report.push_str("| Constant | Projects | Factorization |\n");
    report.push_str("|----------|----------|--------------|\n");
    
    for &value in &graph.glue_constants {
        if let Some(const_info) = graph.constants.get(&value) {
            let projects = const_info.projects.iter().take(5).cloned().collect::<Vec<_>>().join(", ");
            let factors = const_info.factors.as_ref()
                .map(|f| format_factors(f))
                .unwrap_or_else(|| "N/A".to_string());
            report.push_str(&format!("| {} | {} | {} |\n", value, const_info.projects.len(), factors));
        }
    }
    
    report.push_str("\n## Prime Numbers Found\n\n");
    let primes: Vec<u64> = graph.constants
        .iter()
        .filter(|(_, c)| c.is_prime)
        .map(|(k, _)| *k)
        .collect();
    
    if !primes.is_empty() {
        report.push_str("| Prime | Projects |\n");
        report.push_str("|-------|----------|\n");
        for prime in primes.iter().take(20) {
            if let Some(const_info) = graph.constants.get(prime) {
                report.push_str(&format!("| {} | {} |\n", prime, const_info.projects.len()));
            }
        }
    }
    
    report.push_str("\n## Factorization Table\n\n");
    report.push_str("| Number | Factorization | Projects |\n");
    report.push_str("|--------|--------------|----------|\n");
    
    let mut sorted_consts: Vec<u64> = graph.constants.keys().cloned().collect();
    sorted_consts.sort();
    
    for value in sorted_consts.iter().take(50) {
        if let Some(const_info) = graph.constants.get(value) {
            if let Some(ref factors) = const_info.factors {
                let projects_count = const_info.projects.len();
                report.push_str(&format!("| {} | {} | {} |\n", value, format_factors(factors), projects_count));
            }
        }
    }
    
    report.push_str("\n## Project Connections\n\n");
    report.push_str("Projects connected by shared constants:\n\n");
    
    // Build connection matrix
    for &glue_value in &graph.glue_constants {
        if let Some(const_info) = graph.constants.get(&glue_value) {
            if const_info.projects.len() > 1 {
                let projects: Vec<&String> = const_info.projects.iter().collect();
                report.push_str(&format!("\n### {} (in {} projects)\n", glue_value, projects.len()));
                report.push_str("- Projects: ");
                report.push_str(&projects.iter().map(|p| p.as_str()).collect::<Vec<_>>().join(", "));
                report.push_str("\n");
            }
        }
    }
    
    report
}

/// Generate merge suggestions based on numerical constant overlap
pub fn generate_num_merge_plan(graph: &NumGraph) -> Vec<(String, String, Vec<u64>)> {
    /// Returns list of (project1, project2, [shared_constants]) sorted by overlap
    let mut overlaps: Vec<(String, String, Vec<u64>)> = Vec::new();
    
    let projects: Vec<String> = graph.project_constants.keys().cloned().collect();
    
    for i in 0..projects.len() {
        for j in i+1..projects.len() {
            let p1 = &projects[i];
            let p2 = &projects[j];
            
            let consts1: &BTreeSet<u64> = graph.project_constants.get(p1).unwrap();
            let consts2: &BTreeSet<u64> = graph.project_constants.get(p2).unwrap();
            
            let shared: Vec<u64> = consts1.intersection(consts2).cloned().collect();
            
            if !shared.is_empty() {
                overlaps.push((p1.clone(), p2.clone(), shared));
            }
        }
    }
    
    // Sort by number of shared constants (descending)
    overlaps.sort_by(|a, b| b.2.len().cmp(&a.2.len()));
    overlaps
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_factorize() {
        assert_eq!(factorize(12), Some(vec![(2, 2), (3, 1)]));
        assert_eq!(factorize(196883), Some(vec![(71, 1), (59, 1), (47, 1)]));
        assert_eq!(factorize(196884), Some(vec![(2, 2), (3, 3), (1823, 1)]));
        assert_eq!(factorize(17), Some(vec![(17, 1)]));
    }
    
    #[test]
    fn test_num_graph_basic() {
        let mut graph = NumGraph::new();
        
        graph.add_constant(196883, "196883", "project1", "file1.lean:10");
        graph.add_constant(196883, "196883", "project2", "file2.lean:20");
        graph.add_constant(71, "71", "project1", "file1.lean:15");
        graph.add_constant(59, "59", "project2", "file2.lean:25");
        
        graph.finalize();
        
        assert_eq!(graph.constants.len(), 3);
        assert!(graph.glue_constants.contains(&196883));
        assert!(!graph.glue_constants.contains(&71));
        
        assert_eq!(graph.get_project_constants("project1").len(), 2);
        assert_eq!(graph.get_connected_projects(196883).len(), 2);
    }
}
