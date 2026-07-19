use anyhow::{Context, Result};
use serde::Serialize;
use serde_json;
use std::collections::HashSet;
/// term_graph — Build term-level dependency graph across Aristotle projects.
/// Each project is a "page", terms are nodes, edges represent usage/need relationships.
///
/// For each term, we track:
/// - Which project DEFINES it (canonical definition)
/// - Which projects USE it (dependencies)
/// - Which projects NEED it (requirements/imports)
use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::fs;
use std::path::{Path, PathBuf};
use std::sync::OnceLock;
use tracing::{info, instrument, warn};

/// Common Lean built-in identifiers to exclude from cross-project matching
static STOP_TERMS: OnceLock<HashSet<&'static str>> = OnceLock::new();
fn stop_terms() -> &'static HashSet<&'static str> {
    STOP_TERMS.get_or_init(|| {
        HashSet::from([
            "Nat",
            "Int",
            "Bool",
            "String",
            "List",
            "Option",
            "Unit",
            "True",
            "False",
            "Prop",
            "Type",
            "Sort",
            "Fin",
            "Rat",
            "Float",
            "Char",
            "UInt8",
            "UInt16",
            "UInt32",
            "UInt64",
            "USize",
            "Array",
            "Vector",
            "HashMap",
            "HashSet",
            "RBMap",
            "RBSet",
            "Std",
            "Lean",
            "DecidableEq",
            "Decidable",
            "BEq",
            "Hashable",
            "Inhabited",
            "Default",
            "ToString",
            "Repr",
            "OfNat",
            "Add",
            "Mul",
            "Sub",
            "Div",
            "Mod",
            "Pow",
            "Neg",
            "Inv",
            "Zero",
            "One",
            "OfScientific",
            "Function",
            "Eq",
            "HEq",
            "LT",
            "LE",
            "GT",
            "GE",
            "Ord",
            "Compare",
            "Monad",
            "Functor",
            "Applicative",
            "Alternative",
            "No",
            "All",
            "Every",
            "Each",
            "Some",
            "This",
            "For",
            "In",
            "With",
            "By",
            "As",
            "At",
            "On",
            "To",
            "From",
            "Of",
            "Is",
            "Has",
            "left",
            "right",
            "true",
            "false",
        ])
    })
}

/// Information about a single term
#[derive(Debug, Clone, Default, Serialize)]
pub struct TermInfo {
    /// Project that defines this term (canonical source)
    pub defined_by: Option<String>,
    /// Projects that use this term
    pub used_by: BTreeSet<String>,
    /// Projects that need/import this term
    pub needed_by: BTreeSet<String>,
    /// File where it's defined
    pub definition_file: Option<String>,
    /// Line number of definition
    pub definition_line: Option<usize>,
}

/// The term dependency graph
#[derive(Debug, Clone, Default, Serialize)]
pub struct TermGraph {
    /// Map from term name to its info
    pub terms: BTreeMap<String, TermInfo>,
    /// Map from project to terms it defines
    pub project_defines: HashMap<String, BTreeSet<String>>,
    /// Map from project to terms it uses
    pub project_uses: HashMap<String, BTreeSet<String>>,
    /// Map from project to terms it needs
    pub project_needs: HashMap<String, BTreeSet<String>>,
}

impl TermGraph {
    pub fn new() -> Self {
        Self::default()
    }

    /// Add a term definition
    pub fn add_definition(
        &mut self,
        term: &str,
        project: &str,
        file: Option<&str>,
        line: Option<usize>,
    ) {
        let info = self.terms.entry(term.to_string()).or_default();
        if info.defined_by.is_none() {
            info.defined_by = Some(project.to_string());
            info.definition_file = file.map(|s| s.to_string());
            info.definition_line = line;
        }
        self.project_defines
            .entry(project.to_string())
            .or_default()
            .insert(term.to_string());
    }

    /// Add a term usage
    pub fn add_usage(&mut self, term: &str, project: &str) {
        self.terms
            .entry(term.to_string())
            .or_default()
            .used_by
            .insert(project.to_string());
        self.project_uses
            .entry(project.to_string())
            .or_default()
            .insert(term.to_string());
    }

    /// Add a term need/import
    pub fn add_need(&mut self, term: &str, project: &str) {
        self.terms
            .entry(term.to_string())
            .or_default()
            .needed_by
            .insert(project.to_string());
        self.project_needs
            .entry(project.to_string())
            .or_default()
            .insert(term.to_string());
    }

    /// Get all terms that are defined but not used
    pub fn get_orphan_terms(&self) -> Vec<&str> {
        self.terms
            .iter()
            .filter(|(_, info)| info.defined_by.is_some() && info.used_by.is_empty())
            .map(|(term, _)| term.as_str())
            .collect()
    }

    /// Get all terms that are used but not defined
    pub fn get_missing_terms(&self) -> Vec<&str> {
        self.terms
            .iter()
            .filter(|(_, info)| info.defined_by.is_none() && !info.used_by.is_empty())
            .map(|(term, _)| term.as_str())
            .collect()
    }
}

/// Extract Lean4 term definitions and usages from a file
fn extract_lean_terms(file_path: &Path) -> Result<(Vec<(String, String)>, Vec<String>)> {
    let content = fs::read_to_string(file_path)
        .with_context(|| format!("Failed to read file: {}", file_path.display()))?;

    let mut definitions = Vec::new();
    let mut usages = Vec::new();

    // Simple heuristic: look for Lean4 definition patterns
    // This is a simplified parser - for full accuracy, we'd need a Lean4 parser

    for (_line_num, line) in content.lines().enumerate() {
        let trimmed = line.trim();

        // Skip comments and empty lines
        if trimmed.is_empty() || trimmed.starts_with("--") || trimmed.starts_with("#") {
            continue;
        }

        // Match definition patterns
        // theorem, lemma, def, axiom, inductive, structure, class, instance, etc.
        let def_keywords = [
            "theorem ",
            "lemma ",
            "def ",
            "axiom ",
            "inductive ",
            "structure ",
            "class ",
            "instance ",
            "abbrev ",
            "example ",
        ];

        for keyword in def_keywords {
            if let Some(rest) = trimmed.strip_prefix(keyword) {
                // Extract the term name (before (, :, :=, or whitespace)
                let term_name = rest.split_whitespace().next().and_then(|s| {
                    // Strip trailing symbols
                    let cleaned = s
                        .trim_end_matches(':')
                        .trim_end_matches(":=")
                        .trim_end_matches('(');
                    if cleaned.is_empty() || !cleaned.chars().any(|c| c.is_ascii_alphanumeric()) {
                        None
                    } else {
                        Some(cleaned.to_string())
                    }
                });
                if let Some(ref term) = term_name {
                    if !stop_terms().contains(term.as_str())
                        && !stop_terms().contains(term.split('.').next().unwrap_or(""))
                    {
                        definitions.push((term.clone(), file_path.display().to_string()));
                    }
                }
                break;
            }
        }

        // Match usage patterns (terms that appear after `open ` or in expressions)
        // This is a simplified approach - look for identifiers that look like Lean terms
        // For now, we'll extract all identifiers that start with uppercase
        // (Lean convention: types start with uppercase)
        let caps_words: Vec<&str> = trimmed
            .split(|c: char| !c.is_alphanumeric() && c != '_' && c != '.')
            .filter(|s| !s.is_empty())
            .filter(|s| {
                s.chars()
                    .next()
                    .map_or(false, |c| c.is_uppercase() || s.contains('.'))
            })
            .collect();

        for word in caps_words {
            // Filter for meaningful identifiers: at least one ASCII alphanum char
            let has_alphanum = word.chars().any(|c| c.is_ascii_alphanumeric());
            if !word.contains("Mathlib.")
                && !word.contains("Lean.")
                && word.len() > 1
                && !word.starts_with('.')
                && !word.starts_with("..")
                && has_alphanum
                && !word
                    .chars()
                    .all(|c| c.is_ascii_punctuation() || c.is_whitespace() || !c.is_ascii())
                && !stop_terms().contains(word)
                && !stop_terms().contains(word.split('.').next().unwrap_or(""))
            {
                usages.push(word.to_string());
            }
        }
    }

    Ok((definitions, usages))
}

/// Process a single project directory, extract terms from all Lean files
fn process_project(project_path: &Path) -> Result<(String, Vec<(String, String)>, Vec<String>)> {
    let project_name = project_path
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or("unknown")
        .to_string();

    let mut all_definitions = Vec::new();
    let mut all_usages = Vec::new();

    // Walk through all .lean files in the project
    for entry in walkdir::WalkDir::new(project_path)
        .max_depth(5)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let path = entry.path();
        if path.extension().map_or(false, |ext| ext == "lean") {
            match extract_lean_terms(path) {
                Ok((defs, uses)) => {
                    all_definitions.extend(defs);
                    all_usages.extend(uses);
                }
                Err(e) => {
                    warn!(file = %path.display(), error = %e, "Failed to extract terms");
                }
            }
        }
    }

    Ok((project_name, all_definitions, all_usages))
}

/// Process a single extra directory (non-git-versions), using dir basename as project name
fn process_extra_dir(graph: &mut TermGraph, dir_path: &Path) -> Result<u64> {
    let dir_name = dir_path
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or("unknown")
        .to_string();

    info!(
        "Processing extra dir: {} ({})",
        dir_name,
        dir_path.display()
    );
    let mut count = 0u64;

    for entry in walkdir::WalkDir::new(dir_path)
        .max_depth(5)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let path = entry.path();
        if path.extension().map_or(false, |ext| ext == "lean") {
            match extract_lean_terms(path) {
                Ok((defs, uses)) => {
                    for (term, file) in &defs {
                        graph.add_definition(term, &dir_name, Some(file), None);
                    }
                    for term in &uses {
                        graph.add_usage(term, &dir_name);
                        graph.add_need(term, &dir_name);
                    }
                    count += 1;
                }
                Err(e) => {
                    warn!(file = %path.display(), error = %e, "Failed to extract terms");
                }
            }
        }
    }

    info!("Extra dir {}: {} lean files processed", dir_name, count);
    Ok(count)
}

/// Count .lean files in a directory (quick check, max 2 levels deep)
fn count_lean_files(dir: &Path) -> u64 {
    let mut count = 0u64;
    if let Ok(entries) = fs::read_dir(dir) {
        for entry in entries.flatten() {
            let path = entry.path();
            if path.is_dir() {
                // One level deeper
                if let Ok(sub_entries) = fs::read_dir(&path) {
                    for sub in sub_entries.flatten() {
                        if sub.path().extension().map_or(false, |ext| ext == "lean") {
                            count += 1;
                        }
                    }
                }
            } else if path.extension().map_or(false, |ext| ext == "lean") {
                count += 1;
            }
            if count > 100 {
                break; // Just need to know if there are any
            }
        }
    }
    count
}

/// Build term graph from git-versions directory and optional extra directories
#[instrument(skip(git_base, extra_dirs, output_dir))]
pub fn build_term_graph(
    git_base: &Path,
    extra_dirs: &[PathBuf],
    output_dir: Option<PathBuf>,
) -> Result<TermGraph> {
    info!("Building term dependency graph from {}", git_base.display());

    let mut graph = TermGraph::new();
    let mut projects_processed = 0u64;
    let mut files_scanned = 0u64;
    let mut definitions_found = 0u64;
    let mut usages_found = 0u64;

    // Process git-versions projects
    // First try git_base/git-versions/, then git_base/ (direct UUID dirs)
    let git_versions_dir = git_base.join("git-versions");
    let project_base = if git_versions_dir.exists() {
        git_versions_dir.clone()
    } else {
        // UUID directories directly under git_base (config-driven path)
        git_base.to_path_buf()
    };

    if project_base.exists() {
        let mut project_count = 0u64;
        for entry in fs::read_dir(&project_base)? {
            let entry = entry?;
            if entry.file_type()?.is_dir() {
                let project_path = entry.path();
                let project_name = entry.file_name().to_string_lossy().to_string();

                // Quick check: skip if no .lean files
                let lean_count = count_lean_files(&project_path);
                if lean_count == 0 {
                    continue;
                }

                project_count += 1;
                if project_count % 50 == 0 {
                    info!(
                        "Progress: {} projects processed (current: {})",
                        project_count, project_name
                    );
                }

                match process_project(&project_path) {
                    Ok((_, definitions, usages)) => {
                        projects_processed += 1;
                        files_scanned += lean_count;

                        for (term, file) in &definitions {
                            graph.add_definition(term, &project_name, Some(file), None);
                            definitions_found += 1;
                        }

                        for term in &usages {
                            graph.add_usage(term, &project_name);
                            usages_found += 1;
                        }

                        for term in &usages {
                            graph.add_need(term, &project_name);
                        }
                    }
                    Err(e) => {
                        warn!(project = %project_name, error = %e, "Failed to process project");
                    }
                }
            }
        }
        info!(
            "Processed {} projects from {}",
            project_count,
            project_base.display()
        );
    } else {
        warn!(
            "Project base directory not found: {} (tried {})",
            project_base.display(),
            git_versions_dir.display()
        );
    }

    // Process extra directories
    for extra_dir in extra_dirs {
        if extra_dir.exists() {
            match process_extra_dir(&mut graph, extra_dir) {
                Ok(count) => files_scanned += count,
                Err(e) => {
                    warn!(dir = %extra_dir.display(), error = %e, "Failed to process extra dir")
                }
            }
        } else {
            warn!("Extra dir not found: {}", extra_dir.display());
        }
    }

    info!(
        projects = projects_processed,
        files = files_scanned,
        definitions = definitions_found,
        usages = usages_found,
        terms = graph.terms.len(),
        "Term graph built"
    );

    // Save results if output_dir specified
    if let Some(output_dir) = output_dir {
        fs::create_dir_all(&output_dir)?;

        // Save term graph as JSON
        let graph_json = serde_json::to_string_pretty(&graph)?;
        fs::write(output_dir.join("term_graph.json"), &graph_json)?;

        // Save summary statistics
        let summary = serde_json::json!({
            "total_terms": graph.terms.len(),
            "total_projects": graph.project_defines.len(),
            "defined_terms": graph.terms.iter().filter(|(_, v)| v.defined_by.is_some()).count(),
            "used_terms": graph.terms.iter().filter(|(_, v)| !v.used_by.is_empty()).count(),
            "needed_terms": graph.terms.iter().filter(|(_, v)| !v.needed_by.is_empty()).count(),
            "orphan_terms": graph.get_orphan_terms().len(),
            "missing_terms": graph.get_missing_terms().len(),
            "projects_with_definitions": graph.project_defines.len(),
            "projects_with_usages": graph.project_uses.len(),
            "projects_with_needs": graph.project_needs.len(),
        });
        fs::write(
            output_dir.join("term_summary.json"),
            serde_json::to_string_pretty(&summary)?,
        )?;

        // Save DOT format for visualization
        let dot = generate_dot_graph(&graph);
        fs::write(output_dir.join("term_graph.dot"), dot)?;

        info!("Results saved to {}", output_dir.display());
    }

    Ok(graph)
}

/// Generate DOT format graph for visualization
pub fn generate_dot_graph(graph: &TermGraph) -> String {
    let mut dot = String::new();
    dot.push_str("digraph TermGraph {\n");
    dot.push_str("  rankdir=LR;\n");
    dot.push_str("  node [shape=box];\n\n");

    // Group projects as subgraphs
    dot.push_str("  // Projects\n");
    for (project, terms) in &graph.project_defines {
        dot.push_str(&format!("  subgraph cluster_{} {{\n", project));
        dot.push_str(&format!("    label=\"{}\";\n", project));
        dot.push_str("    style=filled;\n");
        dot.push_str("    color=lightgrey;\n");
        for term in terms {
            let _label = format!(
                "{}\\\n{}",
                term,
                graph
                    .terms
                    .get(term)
                    .and_then(|t| t.defined_by.as_deref())
                    .unwrap_or("")
            );
            dot.push_str(&format!("    \"{}\";\n", term));
        }
        dot.push_str("  }}\n\n");
    }

    // Add edges for usages
    dot.push_str("  // Defines -> Used by\n");
    for (term, info) in &graph.terms {
        if let Some(def_project) = &info.defined_by {
            for use_project in &info.used_by {
                if def_project != use_project {
                    dot.push_str(&format!(
                        "  \"{}\" -> \"{}\" [label=\"uses\", color=blue];\n",
                        term, use_project
                    ));
                }
            }
        }
    }

    dot.push_str("}\n");
    dot
}

/// Generate a merge plan: which projects to merge based on term overlap
pub fn generate_merge_plan(graph: &TermGraph) -> Vec<(String, String, usize)> {
    let mut overlaps: Vec<(String, String, usize)> = Vec::new();

    let projects: Vec<&String> = graph.project_defines.keys().collect();

    for i in 0..projects.len() {
        for j in i + 1..projects.len() {
            let p1 = projects[i];
            let p2 = projects[j];

            let terms1: &BTreeSet<String> = graph.project_defines.get(p1).unwrap();
            let terms2: &BTreeSet<String> = graph.project_defines.get(p2).unwrap();

            let shared: usize = terms1.intersection(terms2).count();

            if shared > 0 {
                overlaps.push((p1.clone(), p2.clone(), shared));
            }
        }
    }

    // Sort by shared terms (descending)
    overlaps.sort_by(|a, b| b.2.cmp(&a.2));
    overlaps
}

/// Generate markdown report of the term graph
pub fn generate_report(graph: &TermGraph) -> String {
    let mut report = String::new();

    report.push_str("# Aristotle Term Dependency Graph\n\n");
    report.push_str(&format!("Total terms: {}\n", graph.terms.len()));
    report.push_str(&format!(
        "Total projects: {}\n\n",
        graph.project_defines.len()
    ));

    report.push_str("## Top Defined Terms\n\n");
    report.push_str("| Term | Defined By | Used By |\n");
    report.push_str("|------|-----------|---------|\n");

    let mut sorted_terms: Vec<_> = graph.terms.iter().collect();
    sorted_terms.sort_by(|a, b| b.1.used_by.len().cmp(&a.1.used_by.len()));

    for (term, info) in sorted_terms.iter().take(20) {
        let used_by = info
            .used_by
            .iter()
            .take(3)
            .cloned()
            .collect::<Vec<_>>()
            .join(", ");
        report.push_str(&format!(
            "| {} | {} | {} |\n",
            term,
            info.defined_by.as_deref().unwrap_or(""),
            used_by
        ));
    }

    report.push_str("\n## Projects with Most Definitions\n\n");
    report.push_str("| Project | Definitions |\n");
    report.push_str("|---------|-------------|\n");

    let mut sorted_projects: Vec<_> = graph.project_defines.iter().collect();
    sorted_projects.sort_by(|a, b| b.1.len().cmp(&a.1.len()));

    for (project, terms) in sorted_projects.iter().take(20) {
        report.push_str(&format!("| {} | {} |\n", project, terms.len()));
    }

    report.push_str("\n## Merge Suggestions\n\n");
    let merge_plan = generate_merge_plan(graph);
    report.push_str("Projects with overlapping terms that could be merged:\n\n");
    report.push_str("| Project 1 | Project 2 | Shared Terms |\n");
    report.push_str("|----------|----------|--------------|\n");

    for (p1, p2, count) in merge_plan.iter().take(20) {
        report.push_str(&format!("| {} | {} | {} |\n", p1, p2, count));
    }

    report
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_term_graph_basic() {
        let mut graph = TermGraph::new();

        graph.add_definition("MyTerm", "project1", Some("file.lean"), Some(42));
        graph.add_usage("MyTerm", "project2");
        graph.add_usage("MyTerm", "project3");
        graph.add_need("MyTerm", "project2");

        assert_eq!(graph.terms.len(), 1);
        let info = graph.terms.get("MyTerm").unwrap();
        assert_eq!(info.defined_by, Some("project1".to_string()));
        assert!(info.used_by.contains("project2"));
        assert!(info.used_by.contains("project3"));
        assert!(info.needed_by.contains("project2"));

        assert_eq!(graph.project_defines.get("project1").unwrap().len(), 1);
        assert_eq!(graph.project_uses.get("project2").unwrap().len(), 1);
    }

    #[test]
    fn test_extract_lean_terms() {
        // Create a temp Lean file
        use std::io::Write;
        let temp_dir = tempfile::tempdir().unwrap();
        let lean_file = temp_dir.path().join("test.lean");
        let mut f = fs::File::create(&lean_file).unwrap();
        writeln!(f, "theorem my_theorem : Nat := 42").unwrap();
        writeln!(f, "def MyType := Nat").unwrap();
        writeln!(f, "example : MyType := 1").unwrap();

        let (defs, uses) = extract_lean_terms(&lean_file).unwrap();
        assert!(defs.iter().any(|(name, _)| name == "my_theorem"));
        assert!(defs.iter().any(|(name, _)| name == "MyType"));
        // Should find usages of Mathlib terms or other capitalized identifiers
    }
}
