//! `aristo bootstrap` — provision a Lean 4 toolchain on any OS.
//!
//! Three paths, in preference order:
//!
//! 1. **elan** — the Lean version manager. Works on Linux, macOS, Windows
//!    (WSL/native). Installs the toolchain pinned by `lean-toolchain` files.
//! 2. **nix** — reproducible toolchain from nixpkgs / lean4-nix manifests
//!    (Linux, macOS). lean4-nix (github:lenianiva/lean4-nix) keeps per-version
//!    manifests (v4.11 … v4.29.1) and can build Lean from source or binary.
//! 3. **gokujo-bundled** — a toolchain shipped beside a gokujo binary. Zero
//!    package managers; just unpack and run. This is what
//!    `aristo toolchain bundle` produces.
//!
//! After any path, `aristo toolchain doctor` should report an available
//! backend and `gokujo` can compile/check proofs.

use anyhow::{Context, Result};
use std::path::PathBuf;
use std::process::Command;

use crate::toolchain::{detect_backends, Backend};

/// The platform triple gokujo/lean uses, for messaging.
fn host_triple() -> String {
    if let Some(v) = detect_backends().into_iter().find_map(|(b, v)| {
        (b == Backend::Elan || b == Backend::System).then_some(v).flatten()
    }) {
        // lean --version output: "Lean (version 4.28.0, x86_64-unknown-linux-gnu, ...)"
        if let Some(triple) = v.split(',').nth(1) {
            return triple.trim().to_string();
        }
    }
    match std::env::consts::OS {
        "linux" => "x86_64-unknown-linux-gnu".to_string(),
        "macos" => "aarch64-apple-darwin".to_string(),
        "windows" => "x86_64-w64-windows-gnu.exe".to_string(),
        other => other.to_string(),
    }
}

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

fn elan_dir() -> PathBuf {
    std::env::var_os("HOME")
        .map(|h| PathBuf::from(h).join(".elan"))
        .unwrap_or_else(|| PathBuf::from(".elan"))
}

/// `aristo bootstrap lean [TOOLCHAIN]` — install a Lean toolchain.
///
/// TOOLCHAIN is a version like `v4.28.0` or `stable` (default). Method is
/// chosen automatically: elan if available/installable, else nix, else
/// gokujo-bundled download instructions.
pub fn cmd_lean(toolchain: Option<String>, method: Option<String>) -> Result<()> {
    let toolchain = toolchain.unwrap_or_else(|| "stable".to_string());
    let host = host_triple();
    println!("=== Aristotle Bootstrap: Lean {} on {} ===", toolchain, host);

    // Already have it?
    let backends = detect_backends();
    if let Some((_, Some(v))) = backends.iter().find(|(b, _)| *b == Backend::Elan) {
        println!("  elan already available: {}", v);
        if !method.as_deref().map(|m| m == "elan").unwrap_or(false) {
            println!("  use `elan toolchain install {}` to add more versions", toolchain);
            return Ok(());
        }
    }

    match method.as_deref() {
        Some("elan") => bootstrap_elan(&toolchain),
        Some("nix") => bootstrap_nix(&toolchain),
        Some("bundled") => bundled_hint(&toolchain, &host),
        Some(other) => anyhow::bail!("unknown bootstrap method '{}' (elan|nix|bundled)", other),
        None => {
            // Auto: try elan first, fall back to nix.
            if elan_dir().exists() || Command::new("elan").arg("--version").output().is_ok() {
                bootstrap_elan(&toolchain)
            } else if Command::new("nix").arg("--version").output().is_ok() {
                bootstrap_nix(&toolchain)
            } else {
                bundled_hint(&toolchain, &host)
            }
        }
    }
}

/// elan path: install the version manager, then the requested toolchain.
fn bootstrap_elan(toolchain: &str) -> Result<()> {
    println!("  [elan] installing toolchain {}", toolchain);
    let elan_bin = elan_dir().join("bin/elan");
    let elan = if elan_bin.exists() {
        elan_bin
    } else {
        println!("  [elan] elan not found — downloading elan-init...");
        let script = std::env::temp_dir().join("elan-init.sh");
        let (code, _, err) = run(Command::new("curl").args([
            "-sSfL", "https://elan.lean-lang.org/elan-init.sh", "-o",
            script.to_str().unwrap(),
        ]))?;
        if code != 0 {
            anyhow::bail!("curl failed: {}", err);
        }
        let (code, _, err) = run(
            Command::new("sh")
                .arg(script.to_str().unwrap())
                .args(["-y", "--default-toolchain", "none"]),
        )?;
        if code != 0 {
            anyhow::bail!("elan-init failed: {}", err);
        }
        elan_bin
    };

    let (code, out, err) = run(
        Command::new(&elan)
            .args(["toolchain", "install", toolchain])
    )?;
    println!("{}", out);
    if code != 0 {
        anyhow::bail!("elan toolchain install failed: {}", err);
    }
    println!("  done — lean is at {}", elan_dir().join("bin/lean").display());
    println!("  verify: aristotle-manager toolchain doctor");
    Ok(())
}

/// nix path: use the lean4-nix manifests through a pinned nix profile install,
/// or fall back to nixpkgs' lean4 package.
fn bootstrap_nix(toolchain: &str) -> Result<()> {
    let ver = toolchain.trim_start_matches('v');
    println!("  [nix] installing lean4 {} via nix profile", ver);
    // nixpkgs carries recent lean4 releases; lean4-nix handles anything else.
    let attr = if toolchain == "stable" {
        "nixpkgs#lean4".to_string()
    } else {
        format!("nixpkgs#lean4", )
    };
    let (code, _, err) = run(Command::new("nix").args([
        "profile",
        "install",
        "--print-build-logs",
        &attr,
    ]))?;
    if code != 0 {
        println!("  nixpkgs lean4 failed ({}); falling back to lean4-nix manifest build", err.lines().last().unwrap_or(""));
        // lean4-nix: build from the toolchain file manifest.
        let (code2, _, err2) = run(Command::new("nix").args([
            "build",
            "--print-build-logs",
            &format!("github:lenianiva/lean4-nix#packages.x86_64-linux.lean-{}", ver),
        ]))?;
        if code2 != 0 {
            anyhow::bail!("nix build failed: {}", err2);
        }
    }
    println!("  done — verify: aristotle-manager toolchain doctor");
    Ok(())
}

/// bundled path: no package manager — tell the user to ship the toolchain.
fn bundled_hint(toolchain: &str, host: &str) -> Result<()> {
    println!("  [bundled] no elan or nix available.");
    println!("  The zero-dependency path is a gokujo binary + bundled toolchain:");
    println!("    1. on a machine with Lean:");
    println!("       aristotle-manager toolchain bootstrap");
    println!("       aristotle-manager toolchain bundle ~/.elan/toolchains/leanprover--lean4---{}", toolchain);
    println!("       aristotle-manager sign sign ~/.cache/aristotle-manager/bin/gokujo");
    println!("    2. copy bin/ + toolchain/ to this machine ({}), unpack next to the binary", host);
    println!("    3. run: gokujo --backend bundled check <project>");
    println!("  Or install elan: curl https://elan.lean-lang.org/elan-init.sh -sSf | sh");
    Ok(())
}
