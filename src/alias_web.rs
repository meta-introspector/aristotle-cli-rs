//! alias_web — Simple HTTP server for editing Aristotle aliases.
//!
//! Serves a static HTML editor and provides a REST API for alias management.
//! Designed to run locally behind nginx or as a Cloudflare Worker-compatible backend.

use std::collections::HashMap;
use std::fs;
use std::io::{BufRead, BufReader, Read, Write};
use std::net::TcpListener;
use std::path::PathBuf;
use std::sync::{Arc, Mutex};

use anyhow::Result;
use serde::{Deserialize, Serialize};
use tracing::{debug, info};
use dirs;

const CORS_HEADERS: &str = "\
Access-Control-Allow-Origin: *\r\n\
Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n\
Access-Control-Allow-Headers: Content-Type\r\n";

#[derive(Debug, Serialize, Deserialize, Default)]
struct AliasFile {
    mappings: HashMap<String, String>,
    tags: HashMap<String, Vec<String>>,
}

#[derive(Clone)]
struct AliasState {
    path: PathBuf,
    data: Arc<Mutex<AliasFile>>,
}

pub fn start(port: u16, dir: Option<PathBuf>) -> Result<()> {
    let dir = dir.unwrap_or_else(|| {
        dirs::config_dir()
            .unwrap_or_else(|| PathBuf::from("."))
            .join("aristotle-manager")
    });
    let path = dir.join("aliases.json");
    fs::create_dir_all(&dir)?;

    let data = if path.exists() {
        let txt = fs::read_to_string(&path)?;
        serde_json::from_str(&txt).unwrap_or_default()
    } else {
        AliasFile::default()
    };

    let state = AliasState {
        path,
        data: Arc::new(Mutex::new(data)),
    };

    let addr = format!("0.0.0.0:{}", port);
    let listener = TcpListener::bind(&addr)?;
    info!(port = %port, "Alias web server listening");

    println!("Alias editor running on http://localhost:{}", port);

    for stream in listener.incoming() {
        let mut stream = stream?;
        let state = state.clone();
        std::thread::spawn(move || {
            let _ = handle_alias_request(&mut stream, &state);
        });
    }

    Ok(())
}

fn handle_alias_request(stream: &mut std::net::TcpStream, state: &AliasState) -> Result<()> {
    let _ = stream.set_read_timeout(Some(std::time::Duration::from_secs(30)));
    let mut reader = BufReader::new(stream.try_clone()?);
    let mut request_line = String::new();
    if reader.read_line(&mut request_line).is_err() {
        return Ok(());
    }

    let parts: Vec<&str> = request_line.trim().split_whitespace().collect();
    if parts.len() < 2 {
        return Ok(());
    }
    let method = parts[0];
    let path = parts[1];

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

    let mut body = vec![0u8; content_length];
    if content_length > 0 {
        let _ = reader.read_exact(&mut body);
    }

    debug!("{} {} ({} bytes)", method, path, body.len());

    let response = if method == "OPTIONS" {
        cors_response(200, "")
    } else if path == "/" || path == "/index.html" {
        serve_html()
    } else if path == "/api/v3/aliases" && method == "GET" {
        handle_list_aliases(state)
    } else if path == "/api/v3/aliases/set" && method == "POST" {
        handle_set_alias(state, &body, &content_type)
    } else if path == "/api/v3/aliases/remove" && method == "POST" {
        handle_remove_alias(state, &body, &content_type)
    } else if path == "/api/v3/aliases/clear" && method == "POST" {
        handle_clear_aliases(state)
    } else if path == "/api/v3/aliases/batch" && method == "POST" {
        handle_batch_aliases(state, &body, &content_type)
    } else {
        not_found()
    };

    stream.write_all(response.as_bytes())?;
    stream.flush()?;
    Ok(())
}

fn serve_html() -> String {
    let html = include_str!("alias_web.html");
    format!(
        "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n{}Content-Length: {}\r\n\r\n{}",
        CORS_HEADERS,
        html.len(),
        html
    )
}

fn handle_list_aliases(state: &AliasState) -> String {
    let data = state.data.lock().unwrap();
    json_response(200, &serde_json::to_string(&*data).unwrap_or_default())
}

fn handle_set_alias(state: &AliasState, body: &[u8], _content_type: &str) -> String {
    let body_str = String::from_utf8_lossy(body);
    let name = match serde_json::from_str::<serde_json::Value>(&body_str) {
        Ok(val) => val["name"].as_str().unwrap_or("").to_string(),
        Err(_) => return json_response(400, r#"{"error":"invalid json"}"#),
    };
    let uuid = match serde_json::from_str::<serde_json::Value>(&body_str) {
        Ok(val) => val["uuid"].as_str().unwrap_or("").to_string(),
        Err(_) => return json_response(400, r#"{"error":"invalid json"}"#),
    };
    if name.is_empty() || uuid.is_empty() {
        return json_response(400, r#"{"error":"name and uuid required"}"#);
    }

    let mut data = state.data.lock().unwrap();
    data.mappings.insert(name, uuid);
    drop(data);

    if let Err(e) = persist(state) {
        return json_response(500, &serde_json::json!({"error": e.to_string()}).to_string());
    }
    json_response(200, r#"{"ok":true}"#)
}

fn handle_remove_alias(state: &AliasState, body: &[u8], _content_type: &str) -> String {
    let body_str = String::from_utf8_lossy(body);
    let uuid = match serde_json::from_str::<serde_json::Value>(&body_str) {
        Ok(val) => val["uuid"].as_str().unwrap_or("").to_string(),
        Err(_) => return json_response(400, r#"{"error":"invalid json"}"#),
    };
    if uuid.is_empty() {
        return json_response(400, r#"{"error":"uuid required"}"#);
    }

    let mut data = state.data.lock().unwrap();
    data.mappings.retain(|_, v| v != &uuid);
    drop(data);

    if let Err(e) = persist(state) {
        return json_response(500, &serde_json::json!({"error": e.to_string()}).to_string());
    }
    json_response(200, r#"{"ok":true}"#)
}

fn handle_clear_aliases(state: &AliasState) -> String {
    let mut data = state.data.lock().unwrap();
    data.mappings.clear();
    data.tags.clear();
    drop(data);

    if let Err(e) = persist(state) {
        return json_response(500, &serde_json::json!({"error": e.to_string()}).to_string());
    }
    json_response(200, r#"{"ok":true}"#)
}

fn handle_batch_aliases(state: &AliasState, body: &[u8], _content_type: &str) -> String {
    let body_str = String::from_utf8_lossy(body);
    let updates: HashMap<String, String> = match serde_json::from_str::<serde_json::Value>(&body_str) {
        Ok(val) => {
            let mut m = HashMap::new();
            if let Some(obj) = val["updates"].as_object() {
                for (k, v) in obj {
                    if let Some(s) = v.as_str() {
                        m.insert(k.clone(), s.to_string());
                    }
                }
            }
            m
        }
        Err(_) => return json_response(400, r#"{"error":"invalid json"}"#),
    };

    let mut data = state.data.lock().unwrap();
    for (uuid, new_name) in &updates {
        data.mappings.retain(|_, v| v != uuid);
        data.mappings.insert(new_name.clone(), uuid.clone());
    }
    drop(data);

    if let Err(e) = persist(state) {
        return json_response(500, &serde_json::json!({"error": e.to_string()}).to_string());
    }
    json_response(200, r#"{"ok":true}"#)
}

fn persist(state: &AliasState) -> Result<()> {
    let data = state.data.lock().unwrap();
    let json = serde_json::to_string_pretty(&*data)?;
    fs::write(&state.path, json)?;
    Ok(())
}

fn json_response(status: u16, body: &str) -> String {
    let message = match status {
        200 => "OK",
        400 => "Bad Request",
        404 => "Not Found",
        500 => "Internal Server Error",
        _ => "Unknown",
    };
    format!(
        "HTTP/1.1 {} {}\r\n{}Content-Type: application/json\r\nContent-Length: {}\r\n\r\n{}",
        status, message, CORS_HEADERS, body.len(), body
    )
}

fn cors_response(status: u16, _body: &str) -> String {
    format!(
        "HTTP/1.1 {} OK\r\n{}Content-Length: 0\r\n\r\n",
        status, CORS_HEADERS
    )
}

fn not_found() -> String {
    json_response(404, r#"{"error":"not found"}"#)
}
