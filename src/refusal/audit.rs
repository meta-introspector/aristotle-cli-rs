use super::{safe_slice, AuditReport, HelpInstance, MissingInstance, RefusalInstance};
use anyhow::Result;
use std::collections::HashSet;
use std::fs;
use std::path::PathBuf;
use walkdir::WalkDir;

const REFUSAL_PATTERNS: &[&str] = &[
    "cannot be produced",
    "not a well-posed",
    "won't fabricate",
    "would require manufacturing",
    "evocative poetry",
    "not genuine",
    "not self-contained",
    "no actual constraint",
    "not possible",
    "cannot truthfully claim",
    "I did not",
    "I didn't",
    "I won't",
    "did not do this",
    "not well-posed",
    "no mathematical content",
    "not feasible",
    "cannot be verified",
    "nothing actionable",
    "nothing concrete",
    "no well-posed",
    "fabricate",
    "beyond scope",
    "out of scope",
    "unable",
    "cannot compute",
    "cannot formalize",
    "no singular canonical",
    "not meaningful",
    "not stable",
    "no representation-theoretic",
    "left implicit",
    "not a theorem",
    "narrative orchestration",
    "did not assert them as theorems",
    "I kept to what can be honestly",
    "genuinely formalizable",
    "surrounding loop ideas",
    "not in scope",
    "outside the scope",
    "can't truthfully",
    "don't have access",
];

const HELP_PATTERNS: &[&str] = &[
    "grind +suggestions",
    "grind +extAll",
    "grind +splitImp",
    "need",
    "needs",
    "require",
    "requires",
    "would need",
    "would require",
    "missing",
    "lacks",
    "lacking",
    "absent",
    "not available",
    "not present",
    "couldn't",
    "could not",
    "wasn't able",
    "was not able",
    "I couldn't",
    "I can't",
    "I cannot",
    "please",
    "re-send",
    "attach",
    "paste",
    "I'm happy to",
    "I am happy to",
    "happy to pursue",
    "happy to formalize",
    "point me",
    "if you'd like",
    "could you",
    "let me know",
    "would need to be",
    "would have to be",
    "not yet",
    "still need",
    "I wasn't able",
    "not enough",
    "not sufficient",
];

const NEED_PATTERNS: &[&str] = &[
    "none of the inputs",
    "no aristo-inputs",
    "no plan.org",
    "no /mnt",
    "no /nix",
    "no lean4-repl",
    "no staticsplitjson",
    "no Python",
    "no IPLD",
    "no HTTP",
    "no Rust",
    "no Nix",
    "no shell",
    "no lakefile",
    "no external",
    "no splitter",
    "no mathlib",
    "environment",
    "does not contain",
    "not present in this",
    "depends on",
    "depend on",
    "relies on",
    "rely on",
    "absent",
    "is missing",
    "are missing",
    "were missing",
    "the project provided",
    "the project handed over",
    "what this environment",
    "none of the",
    "no .lean",
    "empty skeleton",
    "only boilerplate",
    "only imports",
    "just imports",
    "no definitions",
    "no statements",
    "no sorries",
    "no task description",
    "no other task",
    "file is not present",
    "file named",
    "referenced a file",
    "attached",
    "provided",
    "supplied",
    "made available",
];

#[derive(Debug, Clone, Copy)]
enum FileExt {
    Markdown,
    Lean,
    Other,
}

impl FileExt {
    fn from(path: &std::path::Path) -> Self {
        match path.extension().and_then(|e| e.to_str()) {
            Some("md") => FileExt::Markdown,
            Some("lean") => FileExt::Lean,
            _ => FileExt::Other,
        }
    }
}

fn extract_text(path: &std::path::Path) -> Option<String> {
    let content = fs::read_to_string(path).ok()?;
    let ext = FileExt::from(path);
    match ext {
        FileExt::Lean => Some(
            content
                .lines()
                .filter(|l| {
                    let t = l.trim();
                    t.starts_with("-- ") || t.starts_with("/-") || t.starts_with("/--")
                })
                .collect::<Vec<_>>()
                .join("\n"),
        ),
        _ => Some(content),
    }
}

fn match_any(text_lower: &str, patterns: &[&str]) -> Vec<(String, String)> {
    let mut hits = Vec::new();
    for pat in patterns {
        let pat_lower = pat.to_lowercase();
        let mut search_from = 0;
        while let Some(idx) = text_lower[search_from..].find(&pat_lower) {
            let abs_idx = search_from + idx;
            let start = abs_idx.saturating_sub(40);
            let end = (text_lower.len()).min(abs_idx + pat_lower.len() + 80);
            let ctx = safe_slice(text_lower, start, end).trim().to_string();
            hits.push((pat.to_string(), ctx));
            search_from = abs_idx + pat_lower.len();
            if search_from >= text_lower.len() {
                break;
            }
        }
    }
    hits
}

fn dedup(items: &mut Vec<(String, String, String, String)>) {
    let mut seen = HashSet::new();
    items.retain(|(sid, fnm, pat, ctx)| {
        let key = (
            sid.clone(),
            pat.clone(),
            ctx[..ctx.len().min(60)].to_string(),
        );
        seen.insert(key)
    });
}

pub fn run_audit(base_dir: &str, output_json: &str) -> Result<AuditReport> {
    let base = PathBuf::from(base_dir);
    let mut refusals = Vec::new();
    let mut helps = Vec::new();
    let mut needs = Vec::new();
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
            if !path.is_file() {
                continue;
            }
            let Some(text) = extract_text(path) else {
                continue;
            };
            if text.is_empty() {
                continue;
            }
            let tl = text.to_lowercase();
            let filename = path
                .strip_prefix(&base)
                .unwrap_or(path)
                .to_string_lossy()
                .to_string();

            for (pat, ctx) in match_any(&tl, REFUSAL_PATTERNS) {
                refusals.push((sid.clone(), filename.clone(), pat, ctx));
            }
            for (pat, ctx) in match_any(&tl, HELP_PATTERNS) {
                helps.push((sid.clone(), filename.clone(), pat, ctx));
            }
            for (pat, ctx) in match_any(&tl, NEED_PATTERNS) {
                needs.push((sid.clone(), filename.clone(), pat, ctx));
            }
        }
    }

    dedup(&mut refusals);
    dedup(&mut helps);
    dedup(&mut needs);

    refusals.sort();
    helps.sort();
    needs.sort();

    eprintln!(
        "Projects: {} | Refusals: {} | Help: {} | Missing: {}",
        project_count,
        refusals.len(),
        helps.len(),
        needs.len()
    );

    let report = AuditReport {
        refusals: refusals
            .into_iter()
            .map(|(project_id, file, pattern, context)| RefusalInstance {
                project_id,
                file,
                pattern,
                context,
            })
            .collect(),
        help_requests: helps
            .into_iter()
            .map(|(project_id, file, pattern, context)| HelpInstance {
                project_id,
                file,
                pattern,
                context,
            })
            .collect(),
        missing_deps: needs
            .into_iter()
            .map(|(project_id, file, pattern, context)| MissingInstance {
                project_id,
                file,
                pattern,
                context,
            })
            .collect(),
    };

    let json = serde_json::to_string_pretty(&report)?;
    fs::write(output_json, json)?;
    eprintln!("Saved to {}", output_json);

    Ok(report)
}
