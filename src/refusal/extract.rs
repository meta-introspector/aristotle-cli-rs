use super::{safe_truncate, AuditReport, HelpInstance, MissingInstance, RefusalInstance};
use anyhow::Result;
use std::fs;
use std::path::PathBuf;
use walkdir::WalkDir;

const REFUSAL_KEYS: &[&str] = &[
    "fabricate",
    "cannot be produced",
    "evocative poetry",
    "not a well-posed",
    "no actual constraint",
    "nothing actionable",
    "won't",
    "can't truthfully",
    "I kept to what can be honestly",
    "did not do this",
    "not a theorem",
    "narrative orchestration",
    "genuinely formalizable",
];

const HELP_KEYS: &[&str] = &[
    "please re-send",
    "attach/paste",
    "grind +suggestions",
    "wasn't able",
    "I'm happy to formalize",
    "point me at",
    "could you please",
    "re-send the task",
    "not present in the project",
    "I cannot fabricate",
    "I wasn't able",
    "couldn't",
    "I can't",
];

const MISSING_KEYS: &[&str] = &[
    "none of the inputs",
    "the project provided here",
    "empty skeleton",
    "only boilerplate",
    "only imports",
    "no aristo-inputs",
    "no python",
    "no ipld",
    "what this environment",
    "the project handed over",
    "no definitions",
    "no statements",
    "just imports",
];

fn extract_paragraphs(text: &str, keyword: &str) -> Vec<(String, usize, String)> {
    let mut results = Vec::new();
    let lines: Vec<&str> = text.lines().collect();
    for (i, line) in lines.iter().enumerate() {
        if line.to_lowercase().contains(&keyword.to_lowercase()) {
            let mut start = i;
            while start > 0 {
                let prev = lines[start - 1].trim();
                if prev.is_empty() || prev.starts_with("# ") {
                    break;
                }
                start -= 1;
            }
            let mut end = i + 1;
            while end < lines.len() {
                let nxt = lines[end].trim();
                if nxt.is_empty() || nxt.starts_with("# ") {
                    break;
                }
                end += 1;
            }
            let block = lines[start..end].join("\n");
            results.push((keyword.to_string(), i + 1, block));
        }
    }
    results
}

pub fn run_extract(base_dir: &str, output_json: &str) -> Result<AuditReport> {
    let base = PathBuf::from(base_dir);
    let mut refusals = Vec::new();
    let mut helps = Vec::new();
    let mut missing = Vec::new();
    let mut project_count = 0usize;

    for entry in WalkDir::new(&base)
        .min_depth(1)
        .max_depth(5)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir())
    {
        let name = entry.file_name().to_string_lossy();
        if !name.ends_with("_aristotle") {
            continue;
        }
        project_count += 1;
        let sid = name[..name.len().min(8)].to_string();

        for item in WalkDir::new(entry.path())
            .into_iter()
            .filter_map(|e| e.ok())
        {
            let path = item.path();
            if !path.is_file()
                || path
                    .file_name()
                    .map(|f| f != "ARISTOTLE_SUMMARY.md")
                    .unwrap_or(true)
            {
                continue;
            }
            let text = fs::read_to_string(path)?;

            for key in REFUSAL_KEYS {
                for (kw, lineno, block) in extract_paragraphs(&text, key) {
                    let truncated = if block.len() > 2000 {
                        format!("{}...[truncated]", safe_truncate(&block, 2000))
                    } else {
                        block
                    };
                    refusals.push(RefusalInstance {
                        project_id: sid.clone(),
                        file: path.to_string_lossy().to_string(),
                        pattern: kw,
                        context: format!("L{}: {}", lineno, truncated),
                    });
                }
            }

            for key in HELP_KEYS {
                for (kw, lineno, block) in extract_paragraphs(&text, key) {
                    let truncated = if block.len() > 2000 {
                        format!("{}...[truncated]", safe_truncate(&block, 2000))
                    } else {
                        block
                    };
                    helps.push(HelpInstance {
                        project_id: sid.clone(),
                        file: path.to_string_lossy().to_string(),
                        pattern: kw,
                        context: format!("L{}: {}", lineno, truncated),
                    });
                }
            }

            for key in MISSING_KEYS {
                for (kw, lineno, block) in extract_paragraphs(&text, key) {
                    let truncated = if block.len() > 2000 {
                        format!("{}...[truncated]", safe_truncate(&block, 2000))
                    } else {
                        block
                    };
                    missing.push(MissingInstance {
                        project_id: sid.clone(),
                        file: path.to_string_lossy().to_string(),
                        pattern: kw,
                        context: format!("L{}: {}", lineno, truncated),
                    });
                }
            }
        }
    }

    refusals.sort_by(|a, b| {
        a.project_id
            .cmp(&b.project_id)
            .then(a.pattern.cmp(&b.pattern))
    });
    helps.sort_by(|a, b| {
        a.project_id
            .cmp(&b.project_id)
            .then(a.pattern.cmp(&b.pattern))
    });
    missing.sort_by(|a, b| {
        a.project_id
            .cmp(&b.project_id)
            .then(a.pattern.cmp(&b.pattern))
    });

    let report = AuditReport {
        refusals,
        help_requests: helps,
        missing_deps: missing,
    };

    let json = serde_json::to_string_pretty(&report)?;
    fs::write(output_json, json)?;

    eprintln!("Projects: {}", project_count);
    eprintln!("Refusals: {}", report.refusals.len());
    eprintln!("Help: {}", report.help_requests.len());
    eprintln!("Missing: {}", report.missing_deps.len());
    eprintln!("Saved to {}", output_json);

    Ok(report)
}
