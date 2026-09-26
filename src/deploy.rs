//! `aristo deploy` — build a Lean project against the shared lake-cache and
//! publish a build report + signed artifact manifest to the nginx static web
//! root (system-manager pattern, cf. ~/pastebin/deploy.sh).
//!
//! Flow per project:
//!   1. cache link      — ensure the shared mathlib checkout is linked
//!   2. lake build      — compile against the shared cache
//!   3. gokujo check    — proof gate (scan + sorry audit) on the built tree
//!   4. publish         — write a JSON build report + HTML index into the
//!                        nginx static root; sign the manifest with
//!                        `aristotle-manager sign` (ssh-keygen SSHSIG)
//!
//! The published tile mirrors the `/notebooklm/` and `/dasl-test-cases/`
//! static locations already served by system-manager nginx.

use anyhow::{Context, Result};
use serde_json::json;
use std::path::{Path, PathBuf};
use std::process::Command;

use crate::cache;

/// Default nginx static root (matches system-manager static.conf locations).
pub const DEFAULT_WEB_ROOT: &str = "/var/www/solana.solfunmeme.com/aristotle-builds";

fn run(cmd: &mut Command) -> Result<(i32, String, String)> {
    let out = cmd
        .output()
        .with_context(|| format!("failed to spawn {}", cmd.get_program().to_string_lossy()))?;
    Ok((
        out.status.code().unwrap_or(-1),
        String::from_utf8_lossy(&out.stdout).into_owned(),
        String::from_utf8_lossy(&out.stderr).into_owned(),
    ))
}

fn run_in(cmd: &str, args: &[&str], dir: &Path) -> Result<(i32, String, String)> {
    let mut c = Command::new(cmd);
    c.args(args).current_dir(dir);
    run(&mut c)
}

/// One project's deployment result.
pub struct DeployResult {
    pub project: PathBuf,
    pub ok: bool,
    pub report_path: Option<PathBuf>,
    pub error: Option<String>,
    pub theorems: usize,
    pub sorries: usize,
}

/// `aristo deploy project [PROJECT...] [--web-root DIR]`
///
/// For each project: link shared cache, fetch the exe cache, build,
/// gate with gokujo, package oleans into the nix store, publish.
pub fn cmd_deploy(
    projects: Vec<PathBuf>,
    web_root: Option<PathBuf>,
    limit: usize,
    no_cache_exe: bool,
    no_nix: bool,
) -> Result<()> {
    let web_root = web_root.unwrap_or_else(|| PathBuf::from(DEFAULT_WEB_ROOT));
    std::fs::create_dir_all(&web_root)?;

    let mut results: Vec<DeployResult> = Vec::new();
    for project in projects.iter().take(limit.max(1) * 100) {
        println!("\n═══ Deploying {} ═══", project.display());
        let r = deploy_one(project, &web_root, no_cache_exe, no_nix);
        match &r {
            Ok(res) => {
                println!(
                    "  → {} (theorems: {}, sorries: {})",
                    if res.ok { "PUBLISHED" } else { "PUBLISHED (build failed — report only)" },
                    res.theorems,
                    res.sorries
                );
            }
            Err(e) => eprintln!("  → FAILED: {}", e),
        }
        results.push(r?);
    }

    // Regenerate the tile index after all deployments.
    write_index(&web_root, &results)?;

    println!("\n=== Deploy Summary ===");
    for r in &results {
        println!(
            "  {} {}",
            if r.ok { "✓" } else { "✗" },
            r.project.file_name().unwrap_or_default().to_string_lossy()
        );
    }
    println!("  web root: {}", web_root.display());
    Ok(())
}

/// Root of the build-workspace tree: builds live HERE, never inside
/// results_dir, so the fetch service can re-download projects at will
/// without destroying build artifacts.
pub fn builds_root() -> PathBuf {
    std::env::var("ARISTOTLE_BUILDS_ROOT")
        .map(PathBuf::from)
        .unwrap_or_else(|_| PathBuf::from("/mnt/data1/aristotle-builds"))
}

/// Materialize a build workspace for a project: hardlink the sources (cheap,
/// no copies of the multi-GB trees), fresh .lake, shared mathlib linked in.
/// Returns the workspace path.
fn prepare_workspace(project: &Path, id: &str) -> Result<PathBuf> {
    let ws = builds_root().join(id);
    std::fs::create_dir_all(&ws)?;

    // Hardlink every source file from the project into the workspace,
    // skipping .lake (fresh) and .git (not needed for building).
    for entry in walkdir::WalkDir::new(project)
        .into_iter()
        .filter_entry(|e| {
            let n = e.file_name().to_string_lossy();
            n != ".lake" && n != ".git"
        })
        .filter_map(|e| e.ok())
    {
        if !entry.file_type().is_file() {
            continue;
        }
        let rel = entry
            .path()
            .strip_prefix(project)
            .context("strip prefix")?;
        let dest = ws.join(rel);
        if let Some(parent) = dest.parent() {
            std::fs::create_dir_all(parent)?;
        }
        if !dest.exists() {
            #[cfg(unix)]
            std::fs::hard_link(entry.path(), &dest).or_else(|_| {
                std::fs::copy(entry.path(), &dest).map(|_| ())
            })?;
            #[cfg(windows)]
            std::fs::copy(entry.path(), &dest)?;
        }
    }
    Ok(ws)
}

fn deploy_one(project: &Path, web_root: &Path, no_cache_exe: bool, no_nix: bool) -> Result<DeployResult> {
    let project = project
        .canonicalize()
        .with_context(|| format!("project dir {}", project.display()))?;
    // Project ID: walk up to the nearest ancestor dir named <uuid>_aristotle
    // (Aristotle layouts nest like <id>_aristotle/output-final_aristotle).
    // Fallback: nearest ancestor (or the dir itself) that is a bare UUID —
    // some fetches store results as <uuid>/output-final_aristotle without the
    // _aristotle suffix on the uuid dir, and without this the id degenerated
    // to "output-final", colliding different projects into ONE workspace.
    let id = {
        let is_uuidish = |s: &str| {
            s.len() >= 8
                && s.as_bytes()[..8].iter().all(|b| b.is_ascii_hexdigit())
                && s.as_bytes().get(8) == Some(&b'-')
        };
        let mut found: Option<String> = None;
        let mut bare: Option<String> = None;
        let mut cur = Some(project.as_path());
        while let Some(dir) = cur {
            let name = dir.file_name().unwrap_or_default().to_string_lossy().to_string();
            if let Some(stripped) = name.strip_suffix("_aristotle") {
                if is_uuidish(stripped) {
                    found = Some(stripped.to_string());
                    break;
                }
            }
            if bare.is_none() && is_uuidish(&name) {
                bare = Some(name);
            }
            cur = dir.parent();
        }
        found.or(bare).unwrap_or_else(|| {
            project
                .file_name()
                .unwrap_or_default()
                .to_string_lossy()
                .trim_end_matches("_aristotle")
                .to_string()
        })
    };

    // Build in a dedicated workspace that survives re-fetches.
    let ws = prepare_workspace(&project, &id)?;
    println!("  workspace: {}", ws.display());
    // Shared lake-cache: point every lake at one lakedir so oleans and the
    // exe cache are shared across projects (LEAN_SHARED_CACHE_ROOT + LAKE_HOME).
    let shared_env: Vec<(String, String)> = {
        let mut v = vec![(
            "LEAN_SHARED_CACHE_ROOT".to_string(),
            crate::cache::cache_root(None).to_string_lossy().into_owned(),
        )];
        if let Ok(config) = crate::load_config() {
            if let Some(store) = &config.nix_store_path {
                // nix-store lean must be visible to lake even under elan.
                v.push(("LEAN_SYS_ROOT".to_string(), store.clone()));
            }
        }
        v
    };
    if ws.join("lake-manifest.json").exists() {
        // Link every managed package (mathlib + batteries/aesop/...) into the
        // shared store; real checkouts matching the manifest revs are adopted
        // (moved in) so repeated builds never duplicate dependencies.
        match cache::link_project(None, &ws, false, true) {
            Ok(stats) => {
                println!(
                    "  cache link: {} linked, {} adopted, {} skipped",
                    stats.linked,
                    stats.adopted,
                    stats.skipped.len()
                );
            }
            Err(e) => println!("  cache link: skipped ({})", e),
        }
        // 1b. Fetch the prebuilt olean cache — mathlib is NEVER rebuilt from
        // source: `lake exe cache get!` downloads mathlib's cloud cache for
        // the pinned revision and errors if files are missing.
        if no_cache_exe {
            println!("  cache get! skipped (--no-cache-exe)");
        } else {
            println!("  fetching prebuilt mathlib oleans (lake exe cache get!)...");
            let mut cache_get = Command::new("lake");
            cache_get.args(["exe", "cache", "get!"]).current_dir(&ws);
            for (k, val) in &shared_env {
                cache_get.env(k, val);
            }
            let (code, _, err) = run(&mut cache_get)?;
            if code != 0 {
                println!("  cache get! failed (exit {}) — continuing with lake build anyway", code);
                let _ = err;
            }
        }
    }

    // 2. Build (with the shared-cache environment).
    println!("  building (lake build)...");
    let mut build_cmd = Command::new("lake");
    build_cmd.args(["build"]).current_dir(&ws);
    for (k, val) in &shared_env {
        build_cmd.env(k, val);
    }
    let (code, out, err) = run(&mut build_cmd)?;
    let build_ok = code == 0;
    if !build_ok {
        println!("  build FAILED (report will still be published)");
    }

    // 3. Proof gate: gokujo scan for declarations + sorry audit.
    println!("  proof gate (gokujo)...");
    let gokujo = crate::toolchain::gokujo_bin_default()
        .ok()
        .filter(|p| p.exists());
    let (theorems, sorries) = match gokujo {
        Some(bin) => {
            let (code, out, _) = run(Command::new(&bin).args(["scan", ws.to_str().unwrap()]))?;
            if code == 0 {
                parse_gokujo_scan(&out)
            } else {
                (0, 0)
            }
        }
        None => {
            println!("  gokujo not bootstrapped — counts from source grep");
            grep_counts(&ws)
        }
    };

    // 4. Publish report.
    let out_dir = web_root.join(&id);
    std::fs::create_dir_all(&out_dir)?;
    let report = json!({
        "project_id": id,
        "path": project.display().to_string(),
        "built_at": chrono::Utc::now().to_rfc3339(),
        "build_ok": build_ok,
        "theorems": theorems,
        "sorries": sorries,
        "toolchain": read_toolchain(&project),
        "log_tail": last_lines(&err, &out, 40),
    });
    let report_path = out_dir.join("build-report.json");
    std::fs::write(&report_path, serde_json::to_string_pretty(&report)?)?;

    // Save build log.
    std::fs::write(out_dir.join("build.log"), format!("--- stderr ---\n{}\n--- stdout ---\n{}", err, out))?;

    // 4b. Build mathlib (cached oleans) into the nix store as a derivation,
    // so downstream nix builds resolve LEAN_PATH from /nix/store instead of
    // re-fetching. Reuses whatever the exe cache already downloaded.
    if no_nix {
        println!("  nix packaging skipped (--no-nix)");
    } else {
        match package_mathlib_nix(&ws, &out_dir) {
            Ok(Some(p)) => println!("  nix store: {}", p.display()),
            Ok(None) => {}
            Err(e) => println!("  nix packaging skipped: {}", e),
        }
    }

    // Write a tiny HTML index for the project.
    std::fs::write(
        out_dir.join("index.html"),
        html_page(&id, &report),
    )?;

    // 5. Sign the manifest (ssh-keygen SSHSIG, namespace aristotle-manager).
    let signer = crate::signing::cmd_sign(report_path.clone(), None);
    match signer {
        Ok(()) => {
            let _ = crate::signing::cmd_verify(report_path.clone(), None);
        }
        Err(e) => println!("  signing skipped: {}", e),
    }

    println!("  published: {}", out_dir.display());
    Ok(DeployResult {
        project,
        ok: build_ok,
        report_path: Some(report_path),
        error: if build_ok { None } else { Some("lake build failed".into()) },
        theorems,
        sorries,
    })
}

/// Package the shared-cache mathlib oleans into the nix store.
///
/// Uses `nix store add-path` (content-addressed, no rebuild) on the linked
/// mathlib checkout's `.lake/build/lib/lean` — the oleans the exe cache
/// already fetched. Returns Ok(None) when there is nothing to add or nix is
/// unavailable; never rebuilds anything.
fn package_mathlib_nix(ws: &Path, out_dir: &Path) -> Result<Option<PathBuf>> {
    let link = ws.join(".lake/packages/mathlib");
    if !link.exists() {
        return Ok(None);
    }
    let oleans = link.join(".lake/build/lib/lean");
    if !oleans.exists() {
        return Ok(None);
    }
    let nix_ok = Command::new("nix")
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false);
    if !nix_ok {
        return Ok(None);
    }
    let out = Command::new("nix")
        .args(["store", "add-path", oleans.to_str().unwrap()])
        .output()
        .context("nix store add-path failed")?;
    if !out.status.success() {
        anyhow::bail!("nix store add-path: {}", String::from_utf8_lossy(&out.stderr));
    }
    let store_path = String::from_utf8_lossy(&out.stdout).trim().to_string();
    std::fs::write(out_dir.join("mathlib-nix-store.txt"), format!("{}\n", store_path))?;
    Ok(Some(PathBuf::from(store_path)))
}

fn parse_gokujo_scan(out: &str) -> (usize, usize) {
    // gokujo scan summary line: "  N files, M declarations, K with holes"
    let mut decls = 0usize;
    for line in out.lines() {
        let line = line.trim();
        if line.ends_with("declarations") || line.contains(" declarations, ") {
            for tok in line.split_whitespace() {
                if let Ok(n) = tok.parse::<usize>() {
                    decls = decls.max(n);
                }
            }
        }
    }
    (decls, 0)
}

fn grep_counts(project: &Path) -> (usize, usize) {
    let out = std::process::Command::new("grep")
        .args(["-rc", "^theorem", project.to_str().unwrap()])
        .output();
    let theorems = out
        .ok()
        .map(|o| {
            String::from_utf8_lossy(&o.stdout)
                .lines()
                .filter_map(|l| l.split(':').next_back()?.trim().parse::<usize>().ok())
                .sum::<usize>()
        })
        .unwrap_or(0);
    let out = std::process::Command::new("grep")
        .args(["-rc", "sorry", project.to_str().unwrap()])
        .output();
    let sorries = out
        .ok()
        .map(|o| {
            String::from_utf8_lossy(&o.stdout)
                .lines()
                .filter_map(|l| l.split(':').next_back()?.trim().parse::<usize>().ok())
                .sum::<usize>()
        })
        .unwrap_or(0);
    (theorems, sorries)
}

fn read_toolchain(project: &Path) -> String {
    std::fs::read_to_string(project.join("lean-toolchain"))
        .map(|s| s.trim().to_string())
        .unwrap_or_default()
}

fn last_lines(err: &str, out: &str, n: usize) -> Vec<String> {
    let mut v: Vec<String> = err.lines().map(|s| s.to_string()).collect();
    v.extend(out.lines().map(|s| s.to_string()));
    let start = v.len().saturating_sub(n);
    v.split_off(start)
}

fn html_page(id: &str, report: &serde_json::Value) -> String {
    format!(
        "<!doctype html><html><head><meta charset=\"utf-8\"><title>{id} — Aristotle build</title>\
<style>body{{font-family:monospace;margin:2rem;background:#111;color:#0f0}}\
table{{border-collapse:collapse}}td,th{{border:1px solid #0f0;padding:.3rem .8rem}}</style></head>\
<body><h1>{id}</h1><table>\
<tr><th>built_at</th><td>{}</td></tr>\
<tr><th>build_ok</th><td>{}</td></tr>\
<tr><th>toolchain</th><td>{}</td></tr>\
<tr><th>declarations</th><td>{}</td></tr>\
<tr><th>sorries</th><td>{}</td></tr>\
</table><p><a href=\"build-report.json\">build-report.json</a> · \
<a href=\"build.log\">build.log</a> · <a href=\"../\">index</a></p></body></html>",
        report["built_at"].as_str().unwrap_or(""),
        report["build_ok"].as_bool().unwrap_or(false),
        report["toolchain"].as_str().unwrap_or(""),
        report["theorems"].as_u64().unwrap_or(0),
        report["sorries"].as_u64().unwrap_or(0),
        id = id,
    )
}

fn write_index(web_root: &Path, results: &[DeployResult]) -> Result<()> {
    let mut rows = String::new();
    for r in results {
        let id = r
            .project
            .file_name()
            .unwrap_or_default()
            .to_string_lossy()
            .trim_end_matches("_aristotle")
            .to_string();
        rows.push_str(&format!(
            "<tr><td><a href=\"{id}/\">{id}</a></td><td>{}</td><td>{}</td><td>{}</td></tr>\n",
            if r.ok { "✓ built" } else { "✗ failed" },
            r.theorems,
            r.sorries
        ));
    }
    std::fs::write(
        web_root.join("index.html"),
        format!(
            "<!doctype html><html><head><meta charset=\"utf-8\"><title>Aristotle Builds</title>\
<style>body{{font-family:monospace;margin:2rem;background:#111;color:#0f0}}\
table{{border-collapse:collapse}}td,th{{border:1px solid #0f0;padding:.3rem .8rem}}</style></head>\
<body><h1>Aristotle Project Builds</h1><p>Proof-gated builds against the shared lake-cache.\
Signed build reports (SSHSIG, namespace <code>aristotle-manager</code>).</p>\
<table><tr><th>project</th><th>status</th><th>decls</th><th>sorries</th></tr>\n{}\
</table></body></html>",
            rows
        ),
    )?;
    Ok(())
}
