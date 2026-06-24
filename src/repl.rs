use std::path::PathBuf;
use std::process::Command;
use serde_json::Value;
use anyhow::{Result, Context};

/// Load declarations from Lean source dir into REPL.
/// The REPL /put endpoint accepts newline-delimited JSON — batch all decls in one POST.
pub fn cmd_load_decls(dir: Option<PathBuf>, dry_run: bool) -> Result<()> {
    let staticsplitjson = std::env::var("STATICSPLITJSON")
        .unwrap_or_else(|_| "/nix/store/hagadmgn61fhbxdq2md6p1jjb5plb52v-staticsplitjson/bin/staticsplitjson".to_string());

    let dirs: Vec<PathBuf> = if let Some(d) = dir {
        vec![d]
    } else {
        vec![
            PathBuf::from("aristotles_results/cb4f0854*/output-final_aristotle/RequestProject/Compute/IPLD/"),
            PathBuf::from("aristotles_results/fa51bcab*/output-final_aristotle/RequestProject/"),
        ]
    };

    let mut total = 0usize;
    for d in &dirs {
        let pattern = d.to_string_lossy().to_string();
        let paths: Vec<_> = if pattern.contains('*') {
            glob::glob(&pattern)?.filter_map(|p| p.ok()).collect()
        } else {
            vec![d.clone()]
        };

        for real_path in paths {
            if !real_path.exists() {
                println!("  not found: {}", real_path.display());
                continue;
            }
            println!("Scanning {}...", real_path.display());

            let output = Command::new(&staticsplitjson)
                .arg("--dir")
                .arg(&real_path)
                .output()
                .context("Failed to run staticsplitjson")?;

            if !output.status.success() {
                println!("  staticsplitjson failed");
                continue;
            }

            let stdout = String::from_utf8_lossy(&output.stdout);
            let decl_count = stdout.lines().filter(|l| !l.trim().is_empty()).count();
            println!("  Found {} declarations", decl_count);

            if !dry_run && !stdout.trim().is_empty() {
                // Batch all declarations in one POST (newline-delimited JSON)
                let client = reqwest::blocking::Client::new();
                match client
                    .post("http://localhost:8156/put")
                    .header("Content-Type", "application/json")
                    .body(stdout.clone().into_owned())
                    .timeout(std::time::Duration::from_secs(30))
                    .send()
                {
                    Ok(resp) => {
                        if resp.status().is_success() {
                            if let Ok(result) = resp.json::<Value>() {
                                let loaded = result["loaded"].as_u64().unwrap_or(0);
                                println!("  Loaded: {loaded}");
                                total += loaded as usize;
                            }
                        } else {
                            println!("  PUT failed: {}", resp.status());
                        }
                    }
                    Err(e) => println!("  PUT error: {e}"),
                }
            } else {
                total += decl_count;
            }
        }
    }

    if !dry_run {
        if let Ok(resp) = reqwest::blocking::get("http://localhost:8156/health") {
            if let Ok(health) = resp.json::<Value>() {
                println!("REPL total: {}", health["declarations"]);
            }
        }
    }

    println!("Done: {total} declarations");
    Ok(())
}

/// Show lean4-repl statistics
pub fn cmd_repl_stats() -> Result<()> {
    let resp = reqwest::blocking::get("http://localhost:8156/health")?;
    let health: Value = resp.json()?;
    println!("lean4-repl @ http://localhost:8156");
    println!("  declarations: {}", health["declarations"]);
    println!("  files:        {}", health["files"]);
    println!("  shmem:        {}", health["shmem"]);
    println!("  status:       {}", health["status"]);

    if let Ok(resp2) = reqwest::blocking::get("http://localhost:8156/search?q=") {
        if let Ok(decls) = resp2.json::<Vec<Value>>() {
            println!("  Recent declarations:");
            for d in decls.iter().take(5) {
                println!("    {} {}  ({})", d["kind"], d["name"], d["file"]);
            }
        }
    }
    Ok(())
}
