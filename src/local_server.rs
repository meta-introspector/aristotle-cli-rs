//! Local Aristotle API server — self-check proofs before submitting.
//!
//! Architecture:
//!   1. Accept submission (prompt + Lean4 files) on local port
//!   2. Write files to temp dir, run `lean` to verify
//!   3. Return result (pass/fail + output)
//!   4. Optionally forward to real Aristotle API for cross-check
//!
//! Endpoints (mirroring aristotle.harmonic.fun/api/v3):
//!   POST /api/v3/project          — submit new project
//!   POST /api/v3/project/:id/ask  — ask follow-up question
//!   GET  /api/v3/project/:id      — check project status
//!   GET  /api/v3/project/:id/result — download result
//!   GET  /health                   — health check

use std::collections::HashMap;
use std::fs;
use std::io::{BufRead, BufReader, Read, Write};
use std::net::TcpListener;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::{Arc, Mutex};

use anyhow::{Context, Result};
use serde::Serialize;
use tracing::{debug, error, info, warn};

/// Stored project state
#[derive(Debug, Clone, Serialize)]
pub struct LocalProject {
    pub project_id: String,
    pub description: String,
    pub status: u8,             // 0=pending, 1=processing, 2=done
    pub has_files: bool,
    pub created_at: String,
    pub last_updated: String,
    pub lean_result: Option<String>,
    pub remote_id: Option<String>, // forwarded to real Aristotle
    pub files: Vec<String>,     // paths to saved .lean files
}

/// State shared across request handlers
#[derive(Default)]
pub struct ServerState {
    pub projects: HashMap<String, LocalProject>,
    pub port: u16,
    pub forward: bool,          // forward passing proofs to remote?
}

pub struct AristoServer {
    state: Arc<Mutex<ServerState>>,
    listener: TcpListener,
    forward_url: Option<String>,
    api_key: String,
}

/// CORS preflight for browser tiles
const CORS_HEADERS: &str = "\
Access-Control-Allow-Origin: *\r\n\
Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n\
Access-Control-Allow-Headers: x-api-key, Content-Type\r\n";

impl AristoServer {
    pub fn start(port: u16, forward: bool, api_key: &str) -> Result<()> {
        let addr = format!("0.0.0.0:{}", port);
        let listener = TcpListener::bind(&addr)?;
        let state = Arc::new(Mutex::new(ServerState {
            port,
            forward,
            ..Default::default()
        }));
        let forward_url = if forward {
            Some("https://aristotle.harmonic.fun/api/v3".to_string())
        } else {
            None
        };

        info!("Aristotle local server listening on {}", port);
        println!("Aristotle local server listening on {}", port);
        if forward {
            println!("  Forwarding passing proofs to aristotle.harmonic.fun");
        }

        for stream in listener.incoming() {
            let mut stream = stream?;
            let state = state.clone();
            let forward_url = forward_url.clone();
            let api_key = api_key.to_string();

            std::thread::spawn(move || {
                handle_request(&mut stream, &state, &forward_url, &api_key);
            });
        }

        Ok(())
    }
}

fn handle_request(
    stream: &mut std::net::TcpStream,
    state: &Arc<Mutex<ServerState>>,
    forward_url: &Option<String>,
    api_key: &str,
) {
    let _ = stream.set_read_timeout(Some(std::time::Duration::from_secs(120)));

    let mut reader = BufReader::new(stream.try_clone().unwrap_or_else(|_| unreachable!()));
    let mut request_line = String::new();
    if reader.read_line(&mut request_line).is_err() {
        return;
    }

    let parts: Vec<&str> = request_line.trim().split_whitespace().collect();
    if parts.len() < 2 {
        return;
    }
    let method = parts[0];
    let path = parts[1];

    // Read headers
    let mut content_length = 0usize;
    let mut content_type = String::new();
    loop {
        let mut line = String::new();
        if reader.read_line(&mut line).is_err() {
            break;
        }
        let line = line.trim().to_lowercase();
        if line.is_empty() {
            break;
        }
        if line.starts_with("content-length:") {
            content_length = line[15..].trim().parse().unwrap_or(0);
        }
        if line.starts_with("content-type:") {
            content_type = line[13..].trim().to_string();
        }
    }

    // Read body
    let mut body = vec![0u8; content_length];
    if content_length > 0 {
        let _ = reader.read_exact(&mut body);
    }

    debug!("{} {} (body: {} bytes)", method, path, content_length);

    // Route
    let response = if method == "OPTIONS" {
        cors_response(200, "")
    } else if path == "/health" {
        json_response(200, r#"{"status":"ok"}"#)
    } else if path.starts_with("/api/v3/project") {
        let subpath = path.strip_prefix("/api/v3/project").unwrap_or("");
        handle_api(method, subpath, &body, content_type, state, forward_url, api_key)
    } else {
        json_response(404, r#"{"error":"not found"}"#)
    };

    let _ = stream.write_all(response.as_bytes());
    let _ = stream.flush();
}

fn handle_api(
    method: &str,
    subpath: &str,
    body: &[u8],
    _content_type: String,
    state: &Arc<Mutex<ServerState>>,
    forward_url: &Option<String>,
    api_key: &str,
) -> String {
    match (method, subpath) {
        ("POST", "" | "/") => handle_submit(body, state, forward_url, api_key),
        ("GET", path) if path.len() > 1 => {
            let path = path.trim_start_matches('/');
            if path.ends_with("/result") {
                let id = path.trim_end_matches("/result");
                handle_get_result(id, state)
            } else if path.ends_with("/ask") {
                json_response(200, r#"{"detail":"use POST for ask"}"#)
            } else {
                handle_get_project(path, state)
            }
        }
        ("POST", path) if path.ends_with("/ask") => {
            let id = path.trim_start_matches('/').trim_end_matches("/ask");
            handle_ask(id, body, state, forward_url, api_key)
        }
        _ => json_response(404, r#"{"error":"not found"}"#),
    }
}

/// POST /api/v3/project — submit a new project
fn handle_submit(
    body: &[u8],
    state: &Arc<Mutex<ServerState>>,
    forward_url: &Option<String>,
    api_key: &str,
) -> String {
    // Parse multipart form to extract 'body' field
    let body_str = String::from_utf8_lossy(body);
    let (prompt, files) = parse_multipart_form(&body_str);

    let project_id = uuid_v4();
    let now = timestamp();

    // Save files to temp dir and run lean
    let mut lean_result = None;
    let mut saved_files = Vec::new();
    let work_dir = std::env::temp_dir().join(format!("aristo-{}", &project_id[..8]));
    let _ = fs::create_dir_all(&work_dir);

    for (name, content) in &files {
        let path = work_dir.join(name);
        let _ = fs::write(&path, content);
        saved_files.push(path.to_string_lossy().to_string());
    }

    // Run lean on all .lean files
    if !saved_files.is_empty() {
        lean_result = Some(run_lean_check(&work_dir, &saved_files));
    } else {
        lean_result = Some("No .lean files submitted — skipping local check".to_string());
    }

    let passed = lean_result.as_ref().map_or(false, |r| r.contains("PASS"));

    let mut project = LocalProject {
        project_id: project_id.clone(),
        description: prompt.chars().take(80).collect(),
        status: if passed { 2 } else { 2 }, // always mark done locally
        has_files: !files.is_empty(),
        created_at: now.clone(),
        last_updated: now,
        lean_result,
        remote_id: None,
        files: saved_files,
    };

    // Forward to real Aristotle if enabled AND proof passed
    if passed && forward_url.is_some() {
        match forward_submit(&prompt, &files, forward_url.as_ref().unwrap(), api_key) {
            Ok(remote_id) => {
                info!("Forwarded to Aristotle: {}", remote_id);
                project.remote_id = Some(remote_id);
            }
            Err(e) => {
                warn!("Forward to Aristotle failed: {}", e);
            }
        }
    }

    let mut st = state.lock().unwrap();
    st.projects.insert(project_id.clone(), project.clone());
    drop(st);

    info!("Project {} submitted (passed={})", project_id, passed);
    serde_json::to_string_pretty(&project).unwrap_or_else(|_| r#"{"error":"serialize"}"#.into())
}

/// POST /api/v3/project/:id/ask
fn handle_ask(
    id: &str,
    body: &[u8],
    state: &Arc<Mutex<ServerState>>,
    forward_url: &Option<String>,
    api_key: &str,
) -> String {
    let body_str = String::from_utf8_lossy(body);
    let prompt = parse_json_field(&body_str, "prompt").unwrap_or_default();

    let st = state.lock().unwrap();
    let project = st.projects.get(id).cloned();
    drop(st);

    let local_answer = if let Some(ref proj) = project {
        format!("Local: project {} has {} files. Lean result: {:?}",
            proj.project_id, proj.files.len(), proj.lean_result)
    } else {
        "Project not found locally".to_string()
    };

    // Forward ask to remote if configured
    if let (Some(url), Some(proj)) = (forward_url, &project) {
        if let Some(ref remote_id) = proj.remote_id {
            match forward_ask(remote_id, &prompt, url, api_key) {
                Ok(remote_answer) => {
                    return json_response(200, &serde_json::json!({
                        "local": local_answer,
                        "remote": remote_answer,
                    }).to_string());
                }
                Err(e) => warn!("Forward ask failed: {}", e),
            }
        }
    }

    json_response(200, &serde_json::json!({
        "local": local_answer,
        "project_id": id,
        "status": "QUEUED",
    }).to_string())
}

/// GET /api/v3/project/:id
fn handle_get_project(id: &str, state: &Arc<Mutex<ServerState>>) -> String {
    let st = state.lock().unwrap();
    if let Some(proj) = st.projects.get(id) {
        return serde_json::to_string_pretty(proj).unwrap_or_default();
    }
    json_response(404, r#"{"error":"project not found"}"#)
}

/// GET /api/v3/project/:id/result
fn handle_get_result(id: &str, state: &Arc<Mutex<ServerState>>) -> String {
    let st = state.lock().unwrap();
    if let Some(proj) = st.projects.get(id) {
        return json_response(200, &serde_json::json!({
            "project_id": id,
            "lean_result": proj.lean_result,
            "remote_id": proj.remote_id,
            "files": proj.files,
        }).to_string());
    }
    json_response(404, r#"{"error":"not found"}"#)
}

// ── Lean4 proof checker ───────────────────────────────────────────────

fn run_lean_check(work_dir: &Path, files: &[String]) -> String {
    let mut output = String::new();
    let mut all_passed = true;

    for file in files {
        let path = Path::new(file);
        let filename = path.file_name().map(|s| s.to_string_lossy().to_string()).unwrap_or_default();

        match Command::new("lean")
            .arg(file)
            .current_dir(work_dir)
            .output()
        {
            Ok(out) => {
                let stdout = String::from_utf8_lossy(&out.stdout);
                let stderr = String::from_utf8_lossy(&out.stderr);
                if out.status.success() {
                    output.push_str(&format!("PASS {} (status=0)\n", filename));
                    if !stdout.is_empty() {
                        output.push_str(&format!("  stdout: {}\n", stdout.trim()));
                    }
                } else {
                    all_passed = false;
                    output.push_str(&format!("FAIL {} (status={})\n", filename, out.status));
                    if !stdout.is_empty() {
                        output.push_str(&format!("  stdout: {}\n", stdout.trim()));
                    }
                    if !stderr.is_empty() {
                        output.push_str(&format!("  stderr: {}\n", stderr.trim()));
                    }
                }
            }
            Err(e) => {
                all_passed = false;
                output.push_str(&format!("ERROR {}: {}\n", filename, e));
            }
        }
    }

    if all_passed {
        output.push_str("\n=== ALL PROOFS PASSED ===");
    } else {
        output.push_str("\n=== SOME PROOFS FAILED ===");
    }

    output
}

// ── Remote forwarding ─────────────────────────────────────────────────

fn forward_submit(prompt: &str, files: &[(String, String)], base_url: &str, api_key: &str) -> Result<String, String> {
    let url = format!("{}/project", base_url);
    let body = serde_json::json!({
        "prompt": prompt,
        "files": files.iter().fold(serde_json::Map::new(), |mut m, (k, v)| { m.insert(k.clone(), serde_json::json!(v)); m }),
    });

    let client = reqwest::blocking::Client::builder()
        .timeout(std::time::Duration::from_secs(60))
        .build()
        .map_err(|e| e.to_string())?;

    let form = reqwest::blocking::multipart::Form::new()
        .text("body", body.to_string());

    let resp = client
        .post(&url)
        .header("x-api-key", api_key)
        .multipart(form)
        .send()
        .map_err(|e| e.to_string())?;

    if resp.status().is_success() {
        let text = resp.text().map_err(|e| e.to_string())?;
        let json: serde_json::Value = serde_json::from_str(&text).map_err(|e| e.to_string())?;
        json["project_id"].as_str()
            .map(|s| s.to_string())
            .ok_or_else(|| "no project_id".to_string())
    } else {
        Err(format!("HTTP {}", resp.status()))
    }
}

fn forward_ask(project_id: &str, prompt: &str, base_url: &str, api_key: &str) -> Result<String, String> {
    let url = format!("{}/project/{}/ask", base_url, project_id);
    let client = reqwest::blocking::Client::builder()
        .timeout(std::time::Duration::from_secs(60))
        .build()
        .map_err(|e| e.to_string())?;

    let resp = client
        .post(&url)
        .header("x-api-key", api_key)
        .json(&serde_json::json!({"prompt": prompt}))
        .send()
        .map_err(|e| e.to_string())?;

    if resp.status().is_success() {
        resp.text().map_err(|e| e.to_string())
    } else {
        Err(format!("HTTP {}", resp.status()))
    }
}

// ── Helpers ───────────────────────────────────────────────────────────

fn parse_multipart_form(body: &str) -> (String, Vec<(String, String)>) {
    let mut prompt = String::new();
    let mut files: Vec<(String, String)> = Vec::new();

    // Look for name="body" field containing JSON
    if let Some(start) = body.find(r#"name="body""#) {
        if let Some(content_start) = body[start..].find("\r\n\r\n") {
            let json = &body[start + content_start + 4..];
            // Find next boundary
            let json_end = json.find("\r\n--").unwrap_or(json.len());
            let json_str = &json[..json_end];
            if let Ok(val) = serde_json::from_str::<serde_json::Value>(json_str) {
                prompt = val["prompt"].as_str().unwrap_or("").to_string();
                if let Some(obj) = val["files"].as_object() {
                    for (k, v) in obj {
                        files.push((k.clone(), v.as_str().unwrap_or("").to_string()));
                    }
                }
            }
        }
    }

    (prompt, files)
}

fn parse_json_field(body: &str, field: &str) -> Option<String> {
    // Try JSON first, then form-encoded
    if let Ok(val) = serde_json::from_str::<serde_json::Value>(body) {
        return val[field].as_str().map(|s| s.to_string());
    }
    None
}

fn json_response(status: u16, body: &str) -> String {
    let message = match status {
        200 => "OK",
        404 => "Not Found",
        500 => "Internal Server Error",
        _ => "Unknown",
    };
    format!(
        "HTTP/1.1 {} {}\r\nContent-Type: application/json\r\n{}Content-Length: {}\r\n\r\n{}",
        status, message, CORS_HEADERS, body.len(), body
    )
}

fn cors_response(status: u16, _body: &str) -> String {
    format!(
        "HTTP/1.1 {} OK\r\n{}Content-Length: 0\r\n\r\n",
        status, CORS_HEADERS
    )
}

fn timestamp() -> String {
    use std::time::{SystemTime, UNIX_EPOCH};
    let secs = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs();
    format!("local-{}", secs)
}

fn uuid_v4() -> String {
    use std::time::{SystemTime, UNIX_EPOCH};
    let now = SystemTime::now().duration_since(UNIX_EPOCH).unwrap_or_default();
    format!("local-{:016x}", now.as_nanos() & 0xffffffffffffffff)
}
