//! Dedup and merge duplicate Aristotle project directories.
//!
//! The arist root accumulates multiple UUID dirs per submission when
//! submissions are retried or aborted: each attempt gets a fresh UUID.
//! Groups are identified by the `description` field of
//! `aristotle_status.json`. Canonical selection within a group:
//!
//!   1. has `output-final_aristotle/` (a completed download)
//!   2. newest `created_at`
//!   3. largest on-disk size
//!
//! Non-canonical dirs are moved into `dedup-archive/<date>/` (never
//! deleted — provenance rule) and a `dedup-report.json` is written with
//! the full decision table.

use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result, bail};
use serde::Serialize;
use tracing::{info, warn};

/// One project dir as seen by the scanner.
#[derive(Debug, Clone)]
struct ProjectEntry {
    dir: PathBuf,
    name: String,
    description: String,
    created_at: String,
    has_output: bool,
    size_bytes: u64,
}

#[derive(Serialize)]
struct ReportEntry {
    description: String,
    canonical: String,
    archived: Vec<String>,
}

#[derive(Serialize)]
struct Report {
    root: PathBuf,
    scanned: usize,
    duplicate_groups: usize,
    dirs_kept: usize,
    dirs_archived: usize,
    bytes_freed_hint: u64,
    groups: Vec<ReportEntry>,
}

/// Scan the root for project dirs with an `aristotle_status.json`.
fn scan(root: &Path) -> Result<Vec<ProjectEntry>> {
    let mut entries = Vec::new();
    for dent in fs::read_dir(root)? {
        let dent = dent?;
        let path = dent.path();
        if !path.is_dir() {
            continue;
        }
        let status_path = path.join("aristotle_status.json");
        if !status_path.is_file() {
            continue;
        }
        let raw = fs::read_to_string(&status_path)
            .with_context(|| format!("reading {}", status_path.display()))?;
        // status files are small JSON; parse just the two fields we need
        // without pulling in a full schema.
        let description = json_field(&raw, "description").unwrap_or_default();
        let created_at = json_field(&raw, "created_at").unwrap_or_default();
        let has_output = path.join("output-final_aristotle").is_dir();
        let size_bytes = dir_size(&path);
        entries.push(ProjectEntry {
            name: dent.file_name().to_string_lossy().to_string(),
            dir: path,
            description,
            created_at,
            has_output,
            size_bytes,
        });
    }
    Ok(entries)
}

/// Minimal string-field extractor for flat JSON (status files are tiny).
fn json_field(raw: &str, field: &str) -> Option<String> {
    let needle = format!("\"{}\"", field);
    let start = raw.find(&needle)? + needle.len();
    let rest = &raw[start..];
    let colon = rest.find(':')?;
    let after = &rest[colon + 1..];
    let after = after.trim_start();
    if let Some(stripped) = after.strip_prefix('"') {
        let end = stripped.find('"')?;
        Some(stripped[..end].to_string())
    } else {
        // non-string value (bool/number) — take up to next , or }
        let end = after.find(|c| c == ',' || c == '}').unwrap_or(after.len());
        Some(after[..end].trim().to_string())
    }
}

fn dir_size(path: &Path) -> u64 {
    fn walk(p: &Path, acc: &mut u64) {
        let Ok(dent) = fs::read_dir(p) else { return };
        for d in dent.flatten() {
            let Ok(md) = d.metadata() else { continue };
            if md.is_dir() {
                walk(&d.path(), acc);
            } else {
                *acc += md.len();
            }
        }
    }
    let mut acc = 0u64;
    walk(path, &mut acc);
    acc
}

/// Pick the canonical entry of a group.
fn pick_canonical(group: &[ProjectEntry]) -> &ProjectEntry {
    let mut best: Option<&ProjectEntry> = None;
    for e in group {
        let better = match best {
            None => true,
            Some(b) => {
                (e.has_output, e.created_at.as_str(), e.size_bytes)
                    > (b.has_output, b.created_at.as_str(), b.size_bytes)
            }
        };
        if better {
            best = Some(e);
        }
    }
    best.expect("non-empty group")
}

/// Dedup the project dirs under `root`.
///
/// `dry_run` reports without moving anything. Archived dirs go to
/// `<root>/dedup-archive/<YYYYMMDD>/` and the report is written to
/// `<root>/dedup-report.json` in both modes.
pub fn cmd_dedup(root: Option<PathBuf>, dry_run: bool, execute: bool) -> Result<()> {
    if execute && dry_run {
        bail!("--dry-run and --execute are mutually exclusive");
    }
    let root = match root {
        Some(r) => r,
        None => std::env::current_dir()?,
    };
    if !root.is_dir() {
        bail!("root {} is not a directory", root.display());
    }

    let entries = scan(&root)?;
    info!(root = %root.display(), scanned = entries.len(), "Scan complete");
    println!("Scanned {} project dirs under {}", entries.len(), root.display());

    // group by description
    let mut groups: Vec<(String, Vec<ProjectEntry>)> = Vec::new();
    {
        use std::collections::BTreeMap;
        let mut by_desc: BTreeMap<String, Vec<ProjectEntry>> = BTreeMap::new();
        for e in entries {
            by_desc.entry(e.description.clone()).or_default().push(e);
        }
        for (desc, mut es) in by_desc {
            es.sort_by(|a, b| a.name.cmp(&b.name));
            if es.len() > 1 {
                groups.push((desc, es));
            }
        }
    }

    if groups.is_empty() {
        println!("No duplicate groups found.");
        return Ok(());
    }

    let archive_dir = root.join("dedup-archive").join(today_compact());
    if !dry_run && !archive_dir.is_dir() {
        fs::create_dir_all(&archive_dir)?;
    }

    let mut report = Report {
        root: root.clone(),
        scanned: 0,
        duplicate_groups: groups.len(),
        dirs_kept: 0,
        dirs_archived: 0,
        bytes_freed_hint: 0,
        groups: Vec::new(),
    };

    for (desc, group) in &groups {
        let canonical = pick_canonical(group);
        let mut archived = Vec::new();
        for e in group {
            if e.dir == canonical.dir {
                continue;
            }
            report.scanned += 1;
            report.bytes_freed_hint += e.size_bytes;
            archived.push(e.name.clone());
            if dry_run {
                println!(
                    "[dry-run] would archive {} -> {} ({} bytes)",
                    e.name,
                    archive_dir.display(),
                    e.size_bytes
                );
            } else {
                let target = archive_dir.join(&e.name);
                if target.exists() {
                    warn!(dir = %e.name, "Archive target exists, skipping");
                    continue;
                }
                fs::rename(&e.dir, &target)
                    .with_context(|| format!("moving {} to archive", e.name))?;
                println!("archived {} ({} bytes)", e.name, e.size_bytes);
                report.dirs_archived += 1;
            }
        }
        report.dirs_kept += 1;
        println!(
            "group '{}…': canonical = {} (output={}, {} bytes), {} dup(s)",
            &desc[..desc.len().min(50)],
            canonical.name,
            canonical.has_output,
            canonical.size_bytes,
            archived.len()
        );
        report.groups.push(ReportEntry {
            description: desc.clone(),
            canonical: canonical.name.clone(),
            archived,
        });
    }

    let report_path = root.join("dedup-report.json");
    fs::write(&report_path, serde_json::to_string_pretty(&report)?)?;
    println!(
        "\nReport: {} ({} groups, {} archived, ~{} bytes)",
        report_path.display(),
        report.duplicate_groups,
        report.dirs_archived,
        report.bytes_freed_hint
    );
    if dry_run {
        println!("Dry run — nothing was moved. Re-run with --execute to apply.");
    }
    Ok(())
}

fn today_compact() -> String {
    // 20260911 — no chrono dep; use date from the environment.
    std::process::Command::new("date")
        .arg("+%Y%m%d")
        .output()
        .ok()
        .and_then(|o| String::from_utf8(o.stdout).ok())
        .map(|s| s.trim().to_string())
        .unwrap_or_else(|| "unknown-date".to_string())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn json_field_string() {
        let raw = r#"{"created_at": "2026-08-23T05:29:07.152958", "description": "2605.30106 rust-lang/rust", "has_files": true}"#;
        assert_eq!(json_field(raw, "description").unwrap(), "2605.30106 rust-lang/rust");
        assert_eq!(json_field(raw, "created_at").unwrap(), "2026-08-23T05:29:07.152958");
        assert_eq!(json_field(raw, "has_files").unwrap(), "true");
    }

    #[test]
    fn pick_canonical_prefers_output() {
        let mk = |name: &str, out: bool, ts: &str| ProjectEntry {
            dir: PathBuf::from(name),
            name: name.into(),
            description: "d".into(),
            created_at: ts.into(),
            has_output: out,
            size_bytes: 100,
        };
        let group = vec![mk("a", false, "2026-06-16"), mk("b", true, "2026-06-15")];
        assert_eq!(pick_canonical(&group).name, "b");
    }
}
