#!/usr/bin/env python3
"""Rewrite notebooklm_cross.rs with optimized batch-file-read approach."""
p = '/mnt/data1/time-2026/05-may/07/arist/src/notebooklm_cross.rs'

# Read the current file, find the slow section, replace with optimized version
old_slow = '''        // Build a map of file → [line numbers] to extract source text efficiently\n        let mut file_lines: BTreeMap<PathBuf, Vec<u64>> = BTreeMap::new();'''

new_fast = '''        // Optimized: read each unique source file once, then extract all decls\n        let mut file_texts: BTreeMap<PathBuf, Vec<String>> = BTreeMap::new();\n        let mut files_to_read: Vec<PathBuf> = Vec::new();\n        for d in &decls {\n            let fname = d["file"].as_str().unwrap_or("");\n            if !fname.is_empty() {\n                let sf = proj_dir.join(fname);\n                if !files_to_read.contains(&sf) { files_to_read.push(sf); }\n            }\n        }\n        for sf in &files_to_read {\n            if let Ok(f) = fs::File::open(sf) {\n                file_texts.insert(sf.clone(),\n                    BufReader::new(f).lines().filter_map(|l| l.ok()).collect());\n            }\n        }\n        println!("    read {} source files", files_to_read.len());\n\n        // Extract body for each declaration\n        for d in &decls {\n            let fname = d["file"].as_str().unwrap_or("");\n            let line = d["line"].as_u64().unwrap_or(0);\n            let sf = proj_dir.join(fname);\n            let body = file_texts.get(&sf).map(|lines| {\n                let start = (line as usize).saturating_sub(1);\n                lines[start..lines.len().min(start+30)].join("\\n")\n            }).unwrap_or_default();'''

t = open(p).read()
assert old_slow in t, "can't find old section"
t = t.replace(old_slow, new_fast)
open(p, 'w').write(t)
print('ok')
