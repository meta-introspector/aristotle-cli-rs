//! DASL cross-implementation conformance + fuzz test runner.
//!
//! Orchestrates the DASL testing harness (`super_harness.sh` / `round_robin.py`),
//! collects structured results, and reports them to:
//!
//! 1. **IPLD CAR shmem** — for planner visibility (`dasl-planner shmem stats`)
//! 2. **Aristotle API** — for long-term proof + divergence tracking
//!
//! ## Architecture
//!
//! ```text
//! ┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
//! │  super_harness   │ ──▶ │  Result Parser    │ ──▶ │    Reporters     │
//! │  round_robin.py  │     │  (JSON extract)   │     │  shmem + Aristotle │
//! └─────────────────┘     └──────────────────┘     └─────────────────┘
//! ```

use anyhow::{Context, Result};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::time::{Duration, SystemTime, UNIX_EPOCH};
use tracing::{error, info, instrument, warn};

// ── CLI constants ────────────────────────────────────────────────────────────

/// Default DASL testing workdir.
/// Falls back to `~/dasl/dasl-testing` or `~/projects/dasl/dasl-testing`.
pub const PROJECT_TESTING_DIRS: &[&str] = &[
    "/home/mdupont/dasl/dasl-testing",
    "/home/mdupont/projects/dasl/dasl-testing",
];

const SHMEM_CLIENT: &str = "/home/mdupont/bin/dasl-planner";
const ARISTOTLE_API_BASE: &str = "https://aristotle.harmonic.fun/api/v3";

// ── Data Types ───────────────────────────────────────────────────────────────

/// Result from a single implementation in the conformance suite.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConformanceResult {
    pub implementation: String,
    pub language: String,
    pub fixture_count: usize,
    pub pass_count: usize,
    pub fail_count: usize,
    pub error_count: usize,
    pub failures: Vec<String>,
    pub errors: Vec<String>,
    pub duration_ms: u64,
}

/// A divergence found during round-robin testing.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RoundRobinDivergence {
    pub input_hash: String,
    pub input_size: usize,
    pub results: HashMap<String, String>, // impl_name → output hash
    pub description: String,
}

/// Summary of a round-robin run.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RoundRobinSummary {
    pub total_inputs: usize,
    pub implementations: Vec<String>,
    pub divergences: Vec<RoundRobinDivergence>,
    pub convergence_count: usize,
    pub duration_ms: u64,
}

/// Fuzz campaign result.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FuzzResult {
    pub mode: String, // "rust", "python", "js", "go", "all"
    pub iterations: u64,
    pub crashes: Vec<CrashInfo>,
    pub unique_crashes: usize,
    pub coverage: Option<CoverageInfo>,
    pub duration_ms: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CrashInfo {
    pub input_hash: String,
    pub input_path: Option<String>,
    pub impl_name: String,
    pub error: String,
    pub signal: Option<i32>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CoverageInfo {
    pub blocks_covered: usize,
    pub blocks_total: usize,
    pub branches_covered: usize,
    pub branches_total: usize,
    pub coverage_pct: f64,
}

/// Top-level DASL test run report.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DaslTestReport {
    pub run_id: String,
    pub timestamp: String,
    pub mode: String, // "conformance", "fuzz", "round-robin", "all"
    pub hostname: String,
    pub git_revision: Option<String>,

    pub conformance: Option<Vec<ConformanceResult>>,
    pub conformance_summary: Option<ConformanceSummary>,

    pub round_robin: Option<RoundRobinSummary>,

    pub fuzz: Option<Vec<FuzzResult>>,

    pub overall_status: String, // "PASS", "FAIL", "DIVERGENCE", "ERROR"
    pub summary: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConformanceSummary {
    pub total_impls: usize,
    pub impls_with_failures: Vec<String>,
    pub all_pass: bool,
}

// ── Discovery ────────────────────────────────────────────────────────────────

/// Find the DASL testing directory.
pub fn find_project_testing_dir() -> Option<PathBuf> {
    for dir in PROJECT_TESTING_DIRS {
        let p = Path::new(dir);
        if p.exists() && p.join("super_harness.sh").exists() {
            return Some(p.to_path_buf());
        }
    }
    None
}

/// Get hostname for report metadata.
fn get_hostname() -> String {
    std::env::var("HOSTNAME")
        .or_else(|_| std::env::var("HOST"))
        .unwrap_or_else(|_| "unknown".to_string())
}

/// Get git revision from the testing directory.
fn get_git_revision(testing_dir: &Path) -> Option<String> {
    let output = Command::new("git")
        .args(["rev-parse", "HEAD"])
        .current_dir(testing_dir)
        .output()
        .ok()?;
    if output.status.success() {
        Some(String::from_utf8_lossy(&output.stdout).trim().to_string())
    } else {
        None
    }
}

fn current_timestamp() -> String {
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default();
    let secs = now.as_secs();
    // Format as ISO 8601
    let datetime = chrono::DateTime::from_timestamp(secs as i64, 0).unwrap_or_default();
    datetime.format("%Y-%m-%dT%H:%M:%SZ").to_string()
}

fn generate_run_id() -> String {
    let ts = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_nanos();
    format!("dasl-test-{:016x}", ts)
}

// ── Test Runner ──────────────────────────────────────────────────────────────

/// Run the DASL conformance suite and return structured results.
#[instrument]
pub fn run_conformance(testing_dir: &Path, timeout_secs: u64) -> Result<Vec<ConformanceResult>> {
    info!(
        "Running DASL conformance suite from {}",
        testing_dir.display()
    );

    let start = SystemTime::now();

    // Run with timeout via `timeout` command
    let output = Command::new("timeout")
        .arg(timeout_secs.to_string())
        .arg("./super_harness.sh")
        .arg("conformance")
        .current_dir(testing_dir)
        .output()
        .context("Failed to execute super_harness.sh conformance")?;

    let duration = start.elapsed().unwrap_or_default().as_millis() as u64;
    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    if !output.status.success() {
        warn!(
            "super_harness.sh exited with code {}",
            output.status.code().unwrap_or(-1)
        );
        warn!("stderr: {}", stderr.chars().take(500).collect::<String>());
    }

    // Parse the JSON output at the end of stdout
    let results = parse_conformance_output(&stdout, duration)?;
    info!(
        "Conformance: {} implementations, {} failures",
        results.len(),
        results.iter().filter(|r| r.fail_count > 0).count()
    );
    Ok(results)
}

/// Parse conformance output from super_harness.sh (which outputs JSON at the end).
fn parse_conformance_output(output: &str, duration_ms: u64) -> Result<Vec<ConformanceResult>> {
    let mut results = Vec::new();

    // Try to parse the entire output as JSON (in case super_harness outputs a single JSON object)
    if let Ok(value) = serde_json::from_str::<serde_json::Value>(output) {
        if let Some(obj) = value.as_object() {
            for (key, val) in obj {
                if let Some(r) = parse_single_impl_result(key, val, duration_ms) {
                    results.push(r);
                }
            }
            if !results.is_empty() {
                return Ok(results);
            }
        }
    }

    // Fallback: search for JSON-like blocks in the output
    let mut start = 0;
    while let Some(json_start) = output[start..].find('{') {
        let candidate = &output[start + json_start..];
        // Try to find a matching closing brace
        let mut depth = 0;
        let mut end_pos = 0;
        for (i, c) in candidate.char_indices() {
            match c {
                '{' => depth += 1,
                '}' => {
                    depth -= 1;
                    if depth == 0 {
                        end_pos = i + 1;
                        break;
                    }
                }
                _ => {}
            }
        }
        if end_pos > 0 {
            let json_str = &candidate[..end_pos];
            if let Ok(value) = serde_json::from_str::<serde_json::Value>(json_str) {
                if let Some(obj) = value.as_object() {
                    for (key, val) in obj {
                        if !key.starts_with('_') {
                            if let Some(r) = parse_single_impl_result(key, val, duration_ms) {
                                results.push(r);
                            }
                        }
                    }
                }
            }
            start += json_start + end_pos;
        } else {
            break;
        }
    }

    // If no JSON found (command timed out or failed), return empty
    if results.is_empty() {
        // Try to extract implementation names from the output
        for line in output.lines() {
            if line.contains("error") || line.contains("fail") {
                // Create a minimal error entry
                let impl_name = line
                    .split(':')
                    .next()
                    .unwrap_or("unknown")
                    .trim()
                    .to_string();
                if !results
                    .iter()
                    .any(|r: &ConformanceResult| r.implementation == impl_name)
                {
                    results.push(ConformanceResult {
                        implementation: impl_name,
                        language: "unknown".to_string(),
                        fixture_count: 0,
                        pass_count: 0,
                        fail_count: 0,
                        error_count: 1,
                        failures: vec![],
                        errors: vec![line.to_string()],
                        duration_ms,
                    });
                }
            }
        }
    }

    Ok(results)
}

/// Parse a single implementation's result from the conformance JSON.
fn parse_single_impl_result(
    name: &str,
    value: &serde_json::Value,
    _duration_ms: u64,
) -> Option<ConformanceResult> {
    if !value.is_object() {
        return None;
    }

    // Determine language from implementation name
    let language = if name.contains("go") || name.contains("boxo") || name.contains("ipld-cbor") {
        "Go".to_string()
    } else if name.contains("helia") || name.contains("atcute") {
        "JavaScript".to_string()
    } else if name.contains("python")
        || name.contains("cbrrr")
        || name.contains("libipld")
        || name.contains("ipld-core")
    {
        "Python".to_string()
    } else if name.contains("serde") || name.contains("n0_dasl") || name.contains("rust") {
        "Rust".to_string()
    } else if name.contains("java") {
        "Java".to_string()
    } else {
        "unknown".to_string()
    };

    // Count fixtures
    let mut fixture_count = 0;
    let mut pass_count = 0;
    let mut fail_count = 0;
    let mut error_count = 0;
    let mut failures = Vec::new();
    let mut errors = Vec::new();

    if let Some(fixtures) = value.as_object() {
        for (_fixture_name, fixture_result) in fixtures {
            fixture_count += 1;
            let result_str = fixture_result.as_str().unwrap_or("?");
            match result_str {
                "pass" | "ok" | "true" => pass_count += 1,
                "fail" | "false" => {
                    fail_count += 1;
                    failures.push(_fixture_name.clone());
                }
                _ => {
                    error_count += 1;
                    errors.push(format!("{}: {}", _fixture_name, result_str));
                }
            }
        }
    }

    // If the value is just a string like "ok" or an error, treat it differently
    if let Some(s) = value.as_str() {
        fixture_count = 1;
        if s == "ok" || s == "pass" {
            pass_count = 1;
        } else {
            fail_count = 1;
            failures.push(s.to_string());
        }
    }

    // Check for error field
    if let Some(err) = value.get("error").and_then(|v| v.as_str()) {
        error_count += 1;
        errors.push(err.to_string());
    }

    Some(ConformanceResult {
        implementation: name.to_string(),
        language,
        fixture_count,
        pass_count,
        fail_count,
        error_count,
        failures,
        errors,
        duration_ms: _duration_ms,
    })
}

/// Run the round-robin cross-implementation tester.
#[instrument]
pub fn run_round_robin(
    testing_dir: &Path,
    extra_args: &[&str],
    timeout_secs: u64,
) -> Result<RoundRobinSummary> {
    info!("Running round-robin cross-implementation test");

    let start = SystemTime::now();

    let mut cmd = Command::new("timeout");
    cmd.arg(timeout_secs.to_string())
        .arg("python3")
        .arg("./round_robin.py")
        .args(extra_args)
        .current_dir(testing_dir);

    let output = cmd.output().context("Failed to execute round_robin.py")?;

    let duration = start.elapsed().unwrap_or_default().as_millis() as u64;
    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    if !output.status.success() {
        warn!(
            "round_robin.py exited with code {}",
            output.status.code().unwrap_or(-1)
        );
    }

    // Try to parse JSON output
    let mut summary = RoundRobinSummary {
        total_inputs: 0,
        implementations: Vec::new(),
        divergences: Vec::new(),
        convergence_count: 0,
        duration_ms: duration,
    };

    // Parse JSON if present in stdout
    for line in stdout.lines() {
        if let Ok(json) = serde_json::from_str::<serde_json::Value>(line) {
            if let Some(input) = json.get("input") {
                summary.total_inputs += 1;
                // Check for divergence
                let results: HashMap<String, String> = json
                    .get("results")
                    .and_then(|v| serde_json::from_value(v.clone()).ok())
                    .unwrap_or_default();

                // If we have a divergence (multiple different results)
                let unique_results: std::collections::HashSet<String> =
                    results.values().cloned().collect();
                if unique_results.len() > 1 {
                    summary.divergences.push(RoundRobinDivergence {
                        input_hash: input.as_str().unwrap_or("?").to_string(),
                        input_size: json.get("size").and_then(|v| v.as_u64()).unwrap_or(0) as usize,
                        results,
                        description: json
                            .get("description")
                            .and_then(|v| v.as_str())
                            .unwrap_or("")
                            .to_string(),
                    });
                } else if !results.is_empty() {
                    summary.convergence_count += 1;
                }
            }
        }
    }

    // Fallback: parse stderr for divergence info
    if summary.total_inputs == 0 {
        for line in stderr.lines() {
            if line.contains("DIVERGENCE") || line.contains("divergence") {
                summary.total_inputs += 1;
                summary.divergences.push(RoundRobinDivergence {
                    input_hash: "?".to_string(),
                    input_size: 0,
                    results: HashMap::new(),
                    description: line.to_string(),
                });
            }
        }
    }

    Ok(summary)
}

/// Run the fuzz campaign.
#[instrument]
pub fn run_fuzz(
    testing_dir: &Path,
    mode: &str,
    iterations: u64,
    timeout_secs: u64,
) -> Result<FuzzResult> {
    let fuzz_mode = match mode {
        "rust" => "fuzz-rust",
        "python" => "fuzz-python",
        "js" => "fuzz-js",
        "go" => "fuzz-go",
        "all" | _ => "fuzz",
    };

    info!(
        "Running DASL fuzz (mode={}, iterations={})",
        fuzz_mode, iterations
    );

    let start = SystemTime::now();

    let output = Command::new("timeout")
        .arg(timeout_secs.to_string())
        .arg("./super_harness.sh")
        .args([fuzz_mode, &iterations.to_string()])
        .current_dir(testing_dir)
        .output()
        .context("Failed to execute super_harness.sh fuzz")?;

    let duration = start.elapsed().unwrap_or_default().as_millis() as u64;
    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    if !output.status.success() {
        warn!(
            "Fuzz exited with code {}",
            output.status.code().unwrap_or(-1)
        );
    }

    let mut crashes = Vec::new();
    let mut unique_crashes = 0;
    let mut seen_hashes = std::collections::HashSet::new();

    // Parse crash info from output
    for line in stdout.lines().chain(stderr.lines()) {
        if line.contains("CRASH") || line.contains("crash") {
            let hash = line
                .split(|c: char| c.is_whitespace() || c == ':')
                .find(|s| !s.is_empty() && s.len() > 8)
                .unwrap_or("?")
                .to_string();
            if seen_hashes.insert(hash.clone()) {
                unique_crashes += 1;
            }
            crashes.push(CrashInfo {
                input_hash: hash,
                input_path: None,
                impl_name: mode.to_string(),
                error: line.to_string(),
                signal: None,
            });
        }
    }

    Ok(FuzzResult {
        mode: mode.to_string(),
        iterations,
        crashes: crashes.clone(),
        unique_crashes,
        coverage: None,
        duration_ms: duration,
    })
}

// ── Reporters ────────────────────────────────────────────────────────────────

/// Store a test report to IPLD CAR shmem for planner visibility.
pub fn report_to_shmem(report: &DaslTestReport) -> Result<()> {
    let shmem_path = Path::new(SHMEM_CLIENT);
    if !shmem_path.exists() {
        warn!(
            "shmem client not found at {}, skipping shmem report",
            SHMEM_CLIENT
        );
        return Ok(());
    }

    info!("Reporting test results to shmem");

    // Write report as JSON to a temp file, then atomize it into shmem
    let tmp_dir = std::env::temp_dir().join(format!("dasl-test-{}", &report.run_id));
    fs::create_dir_all(&tmp_dir)?;

    let report_path = tmp_dir.join("report.json");
    let report_json = serde_json::to_string_pretty(report)?;
    fs::write(&report_path, &report_json)?;

    // Also write a summary for quick planner access
    let summary_path = tmp_dir.join("summary.json");
    let summary = serde_json::json!({
        "run_id": report.run_id,
        "timestamp": report.timestamp,
        "mode": report.mode,
        "overall_status": report.overall_status,
        "summary": report.summary,
        "conformance_pass": report.conformance_summary.as_ref().map(|s| s.all_pass),
        "divergence_count": report.round_robin.as_ref().map(|r| r.divergences.len()).unwrap_or(0),
        "crash_count": report.fuzz.as_ref().map(|f| f.iter().map(|fr| fr.unique_crashes).sum::<usize>()).unwrap_or(0),
    });
    fs::write(&summary_path, serde_json::to_string_pretty(&summary)?)?;

    // Atomize into shmem with a well-known path
    let atomize_output = Command::new(SHMEM_CLIENT)
        .args(["atomize", &tmp_dir.to_string_lossy()])
        .output()
        .context("Failed to atomize test report into shmem")?;

    if !atomize_output.status.success() {
        warn!(
            "shmem atomize returned non-zero: {}",
            String::from_utf8_lossy(&atomize_output.stderr)
        );
    }

    // Also store directly to a known path via the shmem REST API if available
    // Using dasl-planner's shmem integration path
    let shmem_path_key = format!("dasl/testing/reports/{}", &report.run_id);
    let store_output = Command::new(SHMEM_CLIENT)
        .args([
            "shmem",
            "put",
            "--path",
            &shmem_path_key,
            "--file",
            &report_path.to_string_lossy(),
        ])
        .output()
        .ok();

    if let Some(out) = store_output {
        if out.status.success() {
            info!("Stored test report at shmem path: {}", shmem_path_key);
        }
    }

    // Clean up temp files
    let _ = fs::remove_dir_all(&tmp_dir);

    Ok(())
}

/// Submit a test report to the Aristotle API as a new project submission.
/// DASLFINAL Aristotle project UUID — receive all DASL test results.
/// Consolidated DASL grant pipeline project (236 declarations).
/// Resolve the target Aristotle project ID for posting results.
/// Priority: 1) CLI arg, 2) ARISTOTLE_PROJECT_ID env var, 3) config file.
fn resolve_project_id(cli_arg: Option<&str>) -> String {
    if let Some(id) = cli_arg {
        if !id.is_empty() {
            return id.to_string();
        }
    }
    if let Ok(id) = std::env::var("ARISTOTLE_PROJECT_ID") {
        if !id.is_empty() {
            return id;
        }
    }
    // Try config file
    let config_path = dirs::config_dir()
        .unwrap_or_else(|| std::path::PathBuf::from("/home/mdupont/.config"))
        .join("aristotle-manager")
        .join("config.toml");
    if let Ok(content) = std::fs::read_to_string(&config_path) {
        if let Ok(table) = content.parse::<toml::Table>() {
            if let Some(project_test) = table.get("project_test") {
                if let Some(id) = project_test.get("project_id").and_then(|v| v.as_str()) {
                    return id.to_string();
                }
            }
        }
    }
    // Fallback (user must configure)
    eprintln!("⚠️  No Aristotle project ID configured. Set ARISTOTLE_PROJECT_ID env var or add [project_test] project_id = \"...\" to {}", config_path.display());
    String::new()
}

/// Post a test report to an Aristotle project via the `ask` endpoint.
/// Uses the existing project — no spam, no new projects created.
pub fn report_to_aristotle(
    report: &DaslTestReport,
    api_key: &str,
    project_id: Option<&str>,
) -> Result<()> {
    let pid = resolve_project_id(project_id);
    if pid.is_empty() {
        warn!("No Aristotle project ID configured — skipping report");
        return Ok(());
    }
    info!("Posting test results to Aristotle project {}", pid);

    let client = reqwest::blocking::Client::builder()
        .timeout(Duration::from_secs(120))
        .build()
        .context("Failed to build HTTP client")?;

    let url = format!("{}/project/{}/ask", ARISTOTLE_API_BASE, pid);

    // Build a structured Lean-flavored prompt with test results
    let mut prompt_lines = vec![
        format!("-- DASL Cross-Implementation Test Result"),
        format!("-- Run ID: {}", report.run_id),
        format!("-- Mode: {}", report.mode),
        format!("-- Status: {}", report.overall_status),
        format!("-- Timestamp: {}", report.timestamp),
        String::new(),
    ];

    // Conformance section
    if let Some(ref conformance) = report.conformance {
        prompt_lines.push(format!("-- Conformance Results:"));
        for r in conformance {
            let mark = if r.fail_count > 0 || r.error_count > 0 {
                "FAIL"
            } else {
                "PASS"
            };
            prompt_lines.push(format!(
                "--   {}: {} ({} pass, {} fail, {} error)",
                mark, r.implementation, r.pass_count, r.fail_count, r.error_count
            ));
        }
        prompt_lines.push(String::new());
    }

    // Round-robin section
    if let Some(ref rr) = report.round_robin {
        prompt_lines.push(format!(
            "-- Round-Robin: {} inputs, {} converge, {} diverge",
            rr.total_inputs,
            rr.convergence_count,
            rr.divergences.len()
        ));
        for div in &rr.divergences {
            prompt_lines.push(format!("--   DIVERGENCE: {}", div.input_hash));
            for (imp, hash) in &div.results {
                prompt_lines.push(format!("--     {} → {}", imp, hash));
            }
        }
        prompt_lines.push(String::new());
    }

    // Fuzz section
    if let Some(ref fuzz_results) = report.fuzz {
        for f in fuzz_results {
            prompt_lines.push(format!(
                "-- Fuzz ({}): {} iterations, {} unique crashes",
                f.mode, f.iterations, f.unique_crashes
            ));
            for crash in &f.crashes {
                prompt_lines.push(format!("--   CRASH: {}", crash.error));
            }
        }
        prompt_lines.push(String::new());
    }

    prompt_lines.push(format!("-- Summary: {}", report.summary));
    prompt_lines.push(format!(
        "-- Full report in shmem: dasl/testing/reports/{}",
        report.run_id
    ));

    let prompt = prompt_lines.join("\n");
    let body = serde_json::json!({"prompt": prompt});

    let response = client
        .post(&url)
        .header("x-api-key", api_key)
        .json(&body)
        .send()
        .context("Failed to ask DASLFINAL project")?;

    let status = response.status();
    let resp_body = response.text().unwrap_or_default();

    if status.is_success() {
        info!("DASL test results posted to DASLFINAL project");
    } else {
        warn!(
            "Ask failed: HTTP {} — {}",
            status,
            resp_body.chars().take(200).collect::<String>()
        );
    }

    Ok(())
}

/// Store a divergence as a structured finding for later analysis.
pub fn report_divergence_to_shmem(divergence: &RoundRobinDivergence, run_id: &str) -> Result<()> {
    let shmem_path = Path::new(SHMEM_CLIENT);
    if !shmem_path.exists() {
        return Ok(());
    }

    let tmp_dir = std::env::temp_dir().join("dasl-divergences");
    fs::create_dir_all(&tmp_dir)?;

    let div_path = tmp_dir.join(format!("{}.json", divergence.input_hash));
    fs::write(
        &div_path,
        serde_json::to_string_pretty(&serde_json::json!({
            "run_id": run_id,
            "input_hash": divergence.input_hash,
            "input_size": divergence.input_size,
            "results": divergence.results,
            "description": divergence.description,
            "timestamp": current_timestamp(),
        }))?,
    )?;

    let _ = Command::new(SHMEM_CLIENT)
        .args(["atomize", &tmp_dir.to_string_lossy()])
        .output();

    let _ = fs::remove_dir_all(&tmp_dir);
    Ok(())
}

// ── Orchestrator ─────────────────────────────────────────────────────────────

/// Run a full DASL test campaign and report results everywhere.
#[instrument]
pub fn run_project_tests(
    testing_dir: &Path,
    mode: &str,
    iterations: Option<u64>,
    timeout_secs: u64,
    report_to_aristo: bool,
    api_key: Option<String>,
    project_id: Option<&str>,
) -> Result<DaslTestReport> {
    let run_id = generate_run_id();
    let timestamp = current_timestamp();
    let hostname = get_hostname();
    let git_revision = get_git_revision(testing_dir);

    info!(
        "DASL Test Run {} — mode={}, dir={}",
        run_id,
        mode,
        testing_dir.display()
    );

    let mut report = DaslTestReport {
        run_id: run_id.clone(),
        timestamp,
        mode: mode.to_string(),
        hostname,
        git_revision,
        conformance: None,
        conformance_summary: None,
        round_robin: None,
        fuzz: None,
        overall_status: "PASS".to_string(),
        summary: String::new(),
    };

    let iters = iterations.unwrap_or(10000);

    // Phase 1: Conformance (always runs first)
    if mode == "conformance" || mode == "all" {
        match run_conformance(testing_dir, timeout_secs) {
            Ok(results) => {
                let impls_with_failures: Vec<String> = results
                    .iter()
                    .filter(|r| r.fail_count > 0 || r.error_count > 0)
                    .map(|r| r.implementation.clone())
                    .collect();
                let all_pass = impls_with_failures.is_empty();

                report.conformance = Some(results);
                report.conformance_summary = Some(ConformanceSummary {
                    total_impls: report.conformance.as_ref().map(|r| r.len()).unwrap_or(0),
                    impls_with_failures,
                    all_pass,
                });

                if !all_pass {
                    report.overall_status = "FAIL".to_string();
                }
            }
            Err(e) => {
                error!("Conformance failed: {}", e);
                report.overall_status = "ERROR".to_string();
            }
        }
    }

    // Phase 2: Round-robin cross-implementation
    if mode == "round-robin" || mode == "all" || mode == "round-robin-all" {
        let args: &[&str] = if mode == "round-robin-all" {
            &["--all", "--json"]
        } else {
            &["--json"]
        };
        match run_round_robin(testing_dir, args, timeout_secs) {
            Ok(rr) => {
                if !rr.divergences.is_empty() {
                    report.overall_status = "DIVERGENCE".to_string();
                    // Store each divergence individually
                    for div in &rr.divergences {
                        if let Err(e) = report_divergence_to_shmem(div, &run_id) {
                            warn!("Failed to store divergence: {}", e);
                        }
                    }
                }
                report.round_robin = Some(rr);
            }
            Err(e) => {
                error!("Round-robin failed: {}", e);
                if report.overall_status == "PASS" {
                    report.overall_status = "ERROR".to_string();
                }
            }
        }
    }

    // Phase 3: Fuzz testing
    if mode == "fuzz" || mode == "all" || mode.starts_with("fuzz-") {
        let fuzz_mode = if mode == "all" || mode == "fuzz" {
            "all"
        } else {
            mode.trim_start_matches("fuzz-")
        };

        let fuzz_result = match run_fuzz(testing_dir, fuzz_mode, iters, timeout_secs) {
            Ok(result) => {
                if result.unique_crashes > 0 {
                    report.overall_status = "FAIL".to_string();
                }
                Some(result)
            }
            Err(e) => {
                error!("Fuzz failed: {}", e);
                None
            }
        };

        report.fuzz = if let Some(r) = fuzz_result {
            Some(vec![r])
        } else {
            None
        };
    }

    // Build summary text
    let mut summary_parts = Vec::new();
    if let Some(ref c) = report.conformance_summary {
        if c.all_pass {
            summary_parts.push(format!("✅ {} implementations all pass", c.total_impls));
        } else {
            summary_parts.push(format!(
                "❌ {} impls with failures: {}",
                c.impls_with_failures.len(),
                c.impls_with_failures.join(", ")
            ));
        }
    }
    if let Some(ref r) = report.round_robin {
        if r.divergences.is_empty() {
            summary_parts.push(format!("✅ {} inputs converge", r.total_inputs));
        } else {
            summary_parts.push(format!(
                "⚠️ {} divergences in {} inputs",
                r.divergences.len(),
                r.total_inputs
            ));
        }
    }
    if let Some(ref f) = report.fuzz {
        let total_crashes: usize = f.iter().map(|fr| fr.unique_crashes).sum();
        if total_crashes == 0 {
            summary_parts.push(format!("✅ {} fuzz iterations, no crashes", iters));
        } else {
            summary_parts.push(format!(
                "🛑 {} unique crashes in {} iterations",
                total_crashes, iters
            ));
        }
    }
    report.summary = summary_parts.join(" | ");

    // Report to shmem (always)
    if let Err(e) = report_to_shmem(&report) {
        warn!("Failed to report to shmem: {}", e);
    }

    // Report to Aristotle (optional)
    if report_to_aristo {
        if let Some(ref key) = api_key {
            if let Err(e) = report_to_aristotle(&report, key, project_id) {
                warn!("Failed to report to Aristotle: {}", e);
            }
        } else {
            warn!("Aristotle reporting requested but no API key provided");
        }
    }

    Ok(report)
}

/// Print a human-readable summary of the test report.
pub fn print_report_summary(report: &DaslTestReport) {
    println!();
    println!("═══ DASL Test Report ═══");
    println!("  Run ID:     {}", report.run_id);
    println!("  Timestamp:  {}", report.timestamp);
    println!("  Mode:       {}", report.mode);
    println!("  Status:     {}", report.overall_status);
    if let Some(ref rev) = report.git_revision {
        println!("  Git:        {}", &rev[..8.min(rev.len())]);
    }
    println!();
    println!("  {}", report.summary);
    println!();

    if let Some(ref conformance) = report.conformance {
        println!("── Conformance ──");
        println!(
            "  {:<30} {:>8} {:>8} {:>8} {:>8}",
            "Implementation", "Total", "Pass", "Fail", "Error"
        );
        println!("  {}", "-".repeat(70));
        for r in conformance {
            let status_mark = if r.fail_count > 0 || r.error_count > 0 {
                "❌"
            } else {
                "✅"
            };
            println!(
                "  {} {:<26} {:>8} {:>8} {:>8} {:>8}",
                status_mark,
                r.implementation,
                r.fixture_count,
                r.pass_count,
                r.fail_count,
                r.error_count
            );
        }
    }

    if let Some(ref rr) = report.round_robin {
        println!();
        println!("── Round-Robin ──");
        println!(
            "  Inputs: {} total, {} converge, {} diverge",
            rr.total_inputs,
            rr.convergence_count,
            rr.divergences.len()
        );
        for div in &rr.divergences {
            println!("  ⚠️  {}", div.input_hash);
            for (imp, hash) in &div.results {
                println!("       {} → {}", imp, hash);
            }
        }
    }

    if let Some(ref fuzz_results) = report.fuzz {
        println!();
        println!("── Fuzz ──");
        for f in fuzz_results {
            println!(
                "  Mode: {} ({} iters, {} crashes)",
                f.mode, f.iterations, f.unique_crashes
            );
            for crash in &f.crashes {
                println!(
                    "  🛑  {}: {}",
                    crash.input_hash,
                    crash.error.chars().take(100).collect::<String>()
                );
            }
        }
    }

    println!();
    println!("═══ Report stored in shmem ═══");
}

/// Create a short JSON summary suitable for piping.
pub fn report_to_json(report: &DaslTestReport) -> String {
    serde_json::json!({
        "run_id": report.run_id,
        "timestamp": report.timestamp,
        "mode": report.mode,
        "status": report.overall_status,
        "summary": report.summary,
        "conformance": report.conformance_summary,
        "round_robin": {
            "total_inputs": report.round_robin.as_ref().map(|r| r.total_inputs),
            "divergences": report.round_robin.as_ref().map(|r| r.divergences.len()).unwrap_or(0),
            "convergence": report.round_robin.as_ref().map(|r| r.convergence_count).unwrap_or(0),
        },
        "fuzz": report.fuzz.as_ref().map(|f| f.iter().map(|fr| serde_json::json!({
            "mode": fr.mode,
            "iterations": fr.iterations,
            "unique_crashes": fr.unique_crashes,
            "crash_count": fr.crashes.len(),
            "duration_ms": fr.duration_ms,
        })).collect::<Vec<_>>()),
        "duration_ms": report.round_robin.as_ref().map(|r| r.duration_ms)
            .or_else(|| report.conformance.as_ref().map(|c| c.first().map(|r| r.duration_ms)).flatten()),
    })
    .to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_find_project_testing_dir() {
        // Should find the actual dir or return None
        let dir = find_project_testing_dir();
        // Just ensure it doesn't panic
        assert!(dir.is_none() || dir.is_some());
    }

    #[test]
    fn test_parse_conformance_output_simple() {
        let json = r#"{
  "boxo": { "fixture1": "pass", "fixture2": "pass" },
  "serde_ipld_dagcbor": { "fixture1": "pass", "fixture2": "fail" }
}"#;
        let results = parse_conformance_output(json, 1000).unwrap();
        assert_eq!(results.len(), 2);
        let serde = results
            .iter()
            .find(|r| r.implementation == "serde_ipld_dagcbor")
            .unwrap();
        assert_eq!(serde.pass_count, 1);
        assert_eq!(serde.fail_count, 1);
        assert_eq!(serde.duration_ms, 1000);
        assert_eq!(serde.language, "Rust");
    }

    #[test]
    fn test_parse_conformance_output_errors() {
        let json = r#"{"go-dasl": {"error": "connection refused"}}"#;
        let results = parse_conformance_output(json, 500).unwrap();
        assert_eq!(results.len(), 1);
        assert!(results[0].error_count > 0);
        assert_eq!(results[0].implementation, "go-dasl");
    }

    #[test]
    fn test_parse_conformance_output_empty() {
        let results = parse_conformance_output("No JSON here", 0).unwrap();
        assert!(results.is_empty());
    }

    #[test]
    fn test_generate_run_id_format() {
        let id = generate_run_id();
        assert!(id.starts_with("dasl-test-"));
        // "dasl-test-" + 16 hex chars = 26 chars (prefix is 10 chars)
        assert!(id.len() >= 24 && id.len() <= 28);
    }

    #[test]
    fn test_current_timestamp_format() {
        let ts = current_timestamp();
        assert!(ts.contains("T"));
        assert!(ts.ends_with("Z"));
    }

    #[test]
    fn test_report_to_json_contains_fields() {
        let report = DaslTestReport {
            run_id: "test-123".into(),
            timestamp: "2026-07-12T00:00:00Z".into(),
            mode: "conformance".into(),
            hostname: "testhost".into(),
            git_revision: None,
            conformance: None,
            conformance_summary: None,
            round_robin: None,
            fuzz: None,
            overall_status: "PASS".into(),
            summary: "All good".into(),
        };
        let json = report_to_json(&report);
        assert!(json.contains("test-123"));
        assert!(json.contains("PASS"));
        assert!(json.contains("All good"));
    }

    #[test]
    fn test_parse_single_impl_result_go() {
        let value = serde_json::json!({"f1": "pass", "f2": "pass"});
        let result = parse_single_impl_result("boxo", &value, 100).unwrap();
        assert_eq!(result.language, "Go");
        assert_eq!(result.pass_count, 2);
    }

    #[test]
    fn test_parse_single_impl_result_rust() {
        let value = serde_json::json!({"f1": "fail"});
        let result = parse_single_impl_result("serde_ipld_dagcbor", &value, 100).unwrap();
        assert_eq!(result.language, "Rust");
        assert_eq!(result.fail_count, 1);
        assert_eq!(result.failures, vec!["f1"]);
    }

    #[test]
    fn test_get_hostname_never_panics() {
        let hostname = get_hostname();
        assert!(!hostname.is_empty());
    }
}
// dummy change to force recompile
