//! `aristo sign` — sign and verify gokujo binaries (and any artifact).
//!
//! Uses ssh-keygen's built-in signature support (OpenSSH ≥ 8.0, present on
//! all modern OSes): `ssh-keygen -Y sign -f key file` produces a detached
//! `file.sig`, and `ssh-keygen -Y verify` checks it against a public key via
//! an allowed-signers file. No extra package manager needed — which matters
//! when the artifact being verified is the tiny Lean-compiled gokujo binary
//! itself.
//!
//! Namespace: `aristotle-manager` for all aristo signatures.
//! Key material lives in the config dir: `~/.config/aristotle-manager/signing/`.
//! The public key + allowed_signers are meant to be committed so anyone can
//! verify release binaries.

use anyhow::{Context, Result};
use std::path::{Path, PathBuf};
use std::process::Command;

pub const NAMESPACE: &str = "aristotle-manager";

fn signing_dir() -> Result<PathBuf> {
    let dir = dirs::config_dir()
        .context("could not determine config dir")?
        .join("aristotle-manager")
        .join("signing");
    std::fs::create_dir_all(&dir)?;
    Ok(dir)
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

fn ssh_keygen_available() -> bool {
    // `-V` prints the OpenSSH version banner (exit code is irrelevant there,
    // but the binary must exist and run).
    Command::new("ssh-keygen")
        .arg("-V")
        .output()
        .is_ok()
}

/// `aristo sign keygen` — create the signing keypair + allowed_signers if missing.
pub fn cmd_keygen(identity: Option<String>) -> Result<()> {
    if !ssh_keygen_available() {
        anyhow::bail!("ssh-keygen not found — install OpenSSH client tools");
    }
    let dir = signing_dir()?;
    let identity = identity.unwrap_or_else(|| {
        std::env::var("USER").unwrap_or_else(|_| "aristotle".to_string())
    });
    let key = dir.join("aristotle-signing");
    let allowed = dir.join("allowed_signers");

    if !key.exists() {
        let (code, _, err) = run(Command::new("ssh-keygen").args([
            "-t", "ed25519",
            "-f", key.to_str().unwrap(),
            "-N", "",
            "-C", &format!("aristotle-manager signing key ({})", identity),
        ]))?;
        if code != 0 {
            anyhow::bail!("ssh-keygen failed: {}", err);
        }
        println!("  generated {}", key.display());
    } else {
        println!("  key exists: {}", key.display());
    }

    // allowed_signers: <identity> <pubkey>
    let pub_line = std::fs::read_to_string(key.with_extension("pub"))?;
    let entry = format!("{} {}\n", identity, pub_line.trim());
    let existing = std::fs::read_to_string(&allowed).unwrap_or_default();
    if !existing.contains(pub_line.trim()) {
        std::fs::write(&allowed, format!("{}{}", existing, entry))?;
        println!("  added {} to {}", identity, allowed.display());
    }
    println!(
        "  publish these: {} {}",
        key.with_extension("pub").display(),
        allowed.display()
    );
    Ok(())
}

/// `aristo sign sign FILE` — produce FILE.sig (detached ssh signature).
pub fn cmd_sign(file: PathBuf, key: Option<PathBuf>) -> Result<()> {
    if !ssh_keygen_available() {
        anyhow::bail!("ssh-keygen not found");
    }
    let file = file.canonicalize().with_context(|| format!("{} not found", file.display()))?;
    let key = match key {
        Some(k) => k,
        None => signing_dir()?.join("aristotle-signing"),
    };
    if !key.exists() {
        anyhow::bail!(
            "no signing key at {} — run `aristotle-manager sign keygen` first",
            key.display()
        );
    }
    let (code, _, err) = run(Command::new("ssh-keygen").args([
        "-Y", "sign",
        "-f", key.to_str().unwrap(),
        "-n", NAMESPACE,
        file.to_str().unwrap(),
    ]))?;
    if code != 0 {
        anyhow::bail!("signing failed: {}", err);
    }
    let sig = sig_path(&file);
    println!("  signed {}", file.display());
    println!("  signature: {}", sig.display());
    Ok(())
}

fn sig_path(file: &Path) -> PathBuf {
    PathBuf::from(format!("{}.sig", file.display()))
}

/// `aristo sign verify FILE [SIG]` — check FILE.sig against allowed_signers.
pub fn cmd_verify(file: PathBuf, sig: Option<PathBuf>) -> Result<()> {
    if !ssh_keygen_available() {
        anyhow::bail!("ssh-keygen not found");
    }
    let dir = signing_dir()?;
    let file = file.canonicalize()?;
    let sig = sig.unwrap_or_else(|| sig_path(&file));
    let allowed = dir.join("allowed_signers");
    if !allowed.exists() {
        anyhow::bail!(
            "no {} — commit allowed_signers + pubkeys with the release",
            allowed.display()
        );
    }
    // The signing identity is the first principal in allowed_signers.
    let first_line = std::fs::read_to_string(&allowed)?
        .lines()
        .next()
        .unwrap_or("")
        .split_whitespace()
        .next()
        .unwrap_or("")
        .to_string();
    // NOTE: OpenSSH <= 8.9 reads the *message* from stdin for `-Y verify`;
    // a trailing file path silently hashes empty input. Pipe the file in.
    let mut verify = Command::new("ssh-keygen");
    verify.args([
        "-Y", "verify",
        "-f", allowed.to_str().unwrap(),
        "-I", &first_line,
        "-n", NAMESPACE,
        "-s", sig.to_str().unwrap(),
    ])
    .stdin(std::process::Stdio::piped());
    let mut child = verify
        .spawn()
        .context("failed to spawn ssh-keygen verify")?;
    std::io::Write::write_all(
        child.stdin.as_mut().context("no stdin")?,
        &std::fs::read(&file)?,
    )?;
    let out = child.wait_with_output()?;
    let code = out.status.code().unwrap_or(-1);
    let err = String::from_utf8_lossy(&out.stderr).into_owned();
    if code == 0 {
        println!("  GOOD: {} signed by {}", file.display(), first_line);
        Ok(())
    } else {
        anyhow::bail!("BAD signature for {}: {}", file.display(), err.trim())
    }
}

/// `aristo sign status` — show the signing setup.
pub fn cmd_status() -> Result<()> {
    let dir = signing_dir()?;
    println!("=== Aristotle Signing ===");
    println!("  dir: {}", dir.display());
    println!("  namespace: {}", NAMESPACE);
    for f in ["aristotle-signing", "aristotle-signing.pub", "allowed_signers"] {
        let p = dir.join(f);
        println!(
            "  {:<24} {}",
            f,
            if p.exists() { p.display().to_string() } else { "missing".to_string() }
        );
    }
    Ok(())
}
