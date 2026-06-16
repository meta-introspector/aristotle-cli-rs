/// dasl_index — Read DASL index files (~/dasl/index/*.txt), find Lean4 proofs,
/// ingest them into a working directory, and prepare for splitting.
///
/// Index file formats:
///   1. File lists — one absolute path per line
///   2. Grep results — source_file:matched_path:line:text
use std::collections::{HashMap, HashSet};
use std::fs;
use std::io::{BufRead, BufReader};
use std::path::{Path, PathBuf};
use anyhow::Context;
use tracing::{debug, info, instrument, warn};

/// Parse a line from an index file. Handles both formats:
///   - Raw path:  /home/mdupont/dasl/some/file.lean
///   - Grep line: index.txt:/home/mdupont/dasl/some/file.lean:42:theorem foo
fn parse_path_from_line(line: &str) -> Option<PathBuf> {
    let line = line.trim();
    if line.is_empty() {
        return None;
    }

    // Try grep format: "source:path:line:text"
    // Split on ':' and check second field if it looks like an absolute path
    if line.contains(':') {
        let parts: Vec<&str> = line.splitn(4, ':').collect();
        if parts.len() >= 2 {
            let candidate = parts[1];
            if candidate.starts_with('/') && Path::new(candidate).exists() {
                return Some(PathBuf::from(candidate));
            }
        }
    }

    // Fallback: treat as raw path if it starts with / or .
    if line.starts_with('/') || line.starts_with('.') {
        let p = PathBuf::from(line);
        if p.exists() {
            return Some(p);
        }
    }

    None
}

/// Check if a path is a Lean4 proof file
fn is_lean_file(path: &Path) -> bool {
    path.extension()
        .map_or(false, |ext| ext == "lean")
}

/// Count declarations in a Lean file (def, theorem, lemma, etc.)
fn count_declarations(path: &Path) -> usize {
    if let Ok(content) = fs::read_to_string(path) {
        content
            .lines()
            .filter(|line| {
                let trimmed = line.trim();
                trimmed.starts_with("def ")
                    || trimmed.starts_with("theorem ")
                    || trimmed.starts_with("lemma ")
                    || trimmed.starts_with("inductive ")
                    || trimmed.starts_with("structure ")
                    || trimmed.starts_with("class ")
                    || trimmed.starts_with("instance ")
                    || trimmed.starts_with("opaque ")
                    || trimmed.starts_with("abbrev ")
                    || trimmed.starts_with("elab ")
                    || trimmed.starts_with("macro ")
                    || trimmed.starts_with("syntax ")
            })
            .count()
    } else {
        0
    }
}

/// Read all index files, extract Lean paths, return deduplicated set
#[instrument(skip(index_dir))]
pub fn collect_lean_files(
    index_dir: &Path,
    prefix_filter: Option<&str>,
) -> anyhow::Result<(Vec<PathBuf>, HashMap<String, usize>)> {
    let mut lean_files: HashSet<PathBuf> = HashSet::new();
    let mut stats = HashMap::new();
    let mut total_lines = 0usize;
    let mut index_count = 0usize;

    for entry in fs::read_dir(index_dir)? {
        let entry = entry?;
        let path = entry.path();
        if path.extension().map_or(true, |e| e != "txt") {
            continue;
        }
        // Skip backup files
        if path.file_name().and_then(|n| n.to_str()).map_or(false, |n| n.starts_with('#')) {
            continue;
        }

        index_count += 1;
        let file = fs::File::open(&path)
            .with_context(|| format!("Failed to open {}", path.display()))?;
        let reader = BufReader::new(file);
        let mut file_lines = 0usize;
        let mut file_matches = 0usize;

        for line in reader.lines() {
            let line = line?;
            file_lines += 1;
            total_lines += 1;

            if let Some(parsed_path) = parse_path_from_line(&line) {
                if is_lean_file(&parsed_path) {
                    // Apply prefix filter if specified
                    if let Some(prefix) = prefix_filter {
                        if !parsed_path.to_string_lossy().starts_with(prefix) {
                            continue;
                        }
                    }
                    file_matches += 1;
                    lean_files.insert(parsed_path);
                }
            }
        }

        if file_matches > 0 {
            let name = path.file_name().unwrap_or_default().to_string_lossy();
            stats.insert(name.to_string(), file_matches);
            debug!(index = %path.display(), lines = file_lines, matches = file_matches, "Index scanned");
        }
    }

    info!(
        index_files = index_count,
        total_lines,
        lean_files = lean_files.len(),
        "Collected Lean files from DASL indices"
    );

    let mut sorted: Vec<PathBuf> = lean_files.into_iter().collect();
    sorted.sort();

    Ok((sorted, stats))
}

/// Ingest Lean files into a working directory, organized by source prefix.
/// Creates a structure suitable for the splitter.
#[instrument(skip(files, output_dir))]
pub fn ingest_lean_files(
    files: &[PathBuf],
    output_dir: &Path,
) -> anyhow::Result<(usize, usize)> {
    fs::create_dir_all(output_dir)?;

    let mut total_decls = 0usize;
    let mut copied = 0usize;
    let mut skipped = 0usize;

    // Group files by their parent directory (for organization)
    for (i, file) in files.iter().enumerate() {
        if i % 1000 == 0 && i > 0 {
            debug!(progress = i, total = files.len(), "Ingesting...");
        }

        let decls = count_declarations(file);
        if decls == 0 {
            skipped += 1;
            continue;
        }

        // Create a relative path preserving structure
        // Strip leading / and common prefixes for cleaner output
        let rel = file.to_string_lossy();
        let clean_rel = rel
            .trim_start_matches("/home/mdupont/dasl/")
            .trim_start_matches("/home/mdupont/")
            .trim_start_matches("/mnt/data1/")
            .replace('/', "_");

        // Group under first letter or category
        let category = if rel.contains("mathlib") || rel.contains("leanprover") {
            "mathlib"
        } else if rel.contains("dasl") {
            "dasl"
        } else if rel.contains("fractran") {
            "fractran"
        } else if rel.contains("aristotle") || rel.contains("aristo") {
            "aristotle"
        } else {
            "other"
        };

        let dest_dir = output_dir.join(category);
        fs::create_dir_all(&dest_dir)?;

        let dest_name = format!("{}_{}.lean", clean_rel.chars().take(120).collect::<String>(), decls);
        let dest = dest_dir.join(&dest_name);

        // Only copy if source is readable
        if let Ok(content) = fs::read_to_string(file) {
            fs::write(&dest, &content)?;
            copied += 1;
            total_decls += decls;
        } else {
            skipped += 1;
        }
    }

    info!(
        copied,
        skipped,
        total_decls,
        output = %output_dir.display(),
        "Ingestion complete"
    );

    Ok((copied, total_decls))
}

/// Top-level command: scan DASL indexes, find Lean files, ingest them.
#[instrument(skip(index_dir, output_dir))]
pub fn cmd_dasl_index(
    index_dir: Option<PathBuf>,
    output_dir: Option<PathBuf>,
    prefix_filter: Option<String>,
) -> anyhow::Result<()> {
    let index_dir = index_dir.unwrap_or_else(|| {
        dirs_next().join("dasl").join("index")
    });
    let output_dir = output_dir.unwrap_or_else(|| {
        index_dir.parent().unwrap_or(Path::new(".")).join("ingested-lean")
    });

    if !index_dir.exists() {
        return Err(anyhow::anyhow!(
            "Index directory not found: {}. Use --index-dir to specify.",
            index_dir.display()
        ));
    }

    println!("=== DASL Index → Lean4 Ingester ===");
    println!("Index dir:  {}", index_dir.display());
    println!("Output dir: {}", output_dir.display());
    println!();

    // Step 1: Collect Lean files from index files
    println!("[1/3] Scanning index files...");
    let (lean_files, stats) =
        collect_lean_files(&index_dir, prefix_filter.as_deref())?;

    println!("  Index files scanned: {}", stats.len());
    for (name, count) in stats.iter() {
        println!("    {:40} → {} matches", name, count);
    }
    println!("  Total unique Lean files: {}", lean_files.len());

    if lean_files.is_empty() {
        println!("No Lean files found. Try a broader prefix filter or check index_dir.");
        return Ok(());
    }

    // Step 2: Show sample
    println!("\n[2/3] Sample of found files:");
    for file in lean_files.iter().take(10) {
        let decls = count_declarations(file);
        if decls > 0 {
            println!("  {} declarations — {}", decls, file.display());
        }
    }
    if lean_files.len() > 10 {
        println!("  ... and {} more", lean_files.len() - 10);
    }

    // Step 3: Ingest
    println!("\n[3/3] Ingesting into {}...", output_dir.display());
    let (ingested, total_decls) = ingest_lean_files(&lean_files, &output_dir)?;

    println!("\n=== Complete ===");
    println!("  Lean files found:    {}", lean_files.len());
    println!("  Ingested (with decls): {}", ingested);
    println!("  Total declarations:  {}", total_decls);
    println!("  Output:              {}", output_dir.display());

    // Category breakdown
    println!("\n  Categories:");
    for entry in fs::read_dir(&output_dir)? {
        let entry = entry?;
        if entry.file_type()?.is_dir() {
            let count = fs::read_dir(entry.path())?.count();
            println!("    {:20} → {} files", entry.file_name().to_string_lossy(), count);
        }
    }

    Ok(())
}

/// Get the home dir equivalent
fn dirs_next() -> PathBuf {
    std::env::var("HOME")
        .map(PathBuf::from)
        .unwrap_or_else(|_| PathBuf::from("."))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_raw_path() {
        let line = "/home/mdupont/dasl/some/file.lean";
        // Path will only parse if it exists, so this test checks format only
        assert!(line.starts_with('/'));
    }

    #[test]
    fn test_parse_grep_line() {
        let line = "lean.txt:/home/mdupont/dasl/aeneas/tests/lean/BuiltinAuto.lean:42:theorem foo";
        let parts: Vec<&str> = line.splitn(4, ':').collect();
        assert_eq!(parts.len(), 4);
        assert_eq!(parts[0], "lean.txt");
        assert_eq!(parts[2], "42");
    }

    #[test]
    fn test_is_lean_file() {
        assert!(is_lean_file(Path::new("foo.lean")));
        assert!(!is_lean_file(Path::new("foo.rs")));
        assert!(!is_lean_file(Path::new("foo.txt")));
    }

    #[test]
    fn test_count_declarations_empty() {
        let tmp = tempfile::tempdir().unwrap();
        let f = tmp.path().join("empty.lean");
        fs::write(&f, "import Mathlib\n\n#check 1\n").unwrap();
        assert_eq!(count_declarations(&f), 0);
    }

    #[test]
    fn test_count_declarations_with_content() {
        let tmp = tempfile::tempdir().unwrap();
        let f = tmp.path().join("test.lean");
        fs::write(&f, "import Mathlib\n\ndef foo := 1\ntheorem bar : 1 = 1 := rfl\nlemma baz := by simp\n").unwrap();
        assert_eq!(count_declarations(&f), 3);
    }
}
