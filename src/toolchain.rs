//! gokujo + Lean toolchain management.
//!
//! Gokujo (極上, "finest quality") is a single-file Lean 4 program that
//! replaces the roles of make, lake, elan and nix for preparing and checking
//! proofs. It compiles to a tiny native binary with a bare `lean` toolchain.
//!
//! This module wraps the vendored source in `tools/gokujo/` and exposes:
//!
//! - `aristo toolchain doctor`    — which Lean backends this machine can use
//! - `aristo toolchain bootstrap` — compile the vendored Gokujo.lean into a tiny native binary
//! - `aristo toolchain bundle`    — ship a Lean toolchain beside the binary (self-contained)
//! - `aristo toolchain release`   — write the per-platform build script for all targets
//!
//! The compiled binary is a few MB, has no runtime dependencies beyond libc,
//! and can parse/scan/check Lean projects with zero package managers involved.

use anyhow::{Context, Result};
use std::path::{Path, PathBuf};
use std::process::Command;

/// Default location of the vendored gokujo sources, relative to project root.
pub const GOKUJO_SRC: &str = "tools/gokujo/Gokujo.lean";
pub const GOKUJO_MAIN: &str = "tools/gokujo/GokujoMain.lean";
pub const GOKUJO_MD: &str = "tools/gokujo/GOKUJO.md";

/// Where the compiled gokujo binary is cached by default.
pub fn gokujo_bin_default() -> Result<PathBuf> {
    let base = dirs::cache_dir()
        .unwrap_or_else(|| PathBuf::from(".cache"))
        .join("aristotle-manager");
    Ok(base.join("bin/gokujo"))
}

/// Locate the vendored Gokujo.lean: walk up from CWD to find it in the repo,
/// fall back to the configured default.
fn find_gokujo_src() -> Result<PathBuf> {
    // 1. Relative to CWD (repo root or subdir).
    let mut cwd = std::env::current_dir().context("could not read cwd")?;
    loop {
        let candidate = cwd.join(GOKUJO_SRC);
        if candidate.exists() {
            return Ok(candidate);
        }
        if !cwd.pop() {
            break;
        }
    }
    // 2. Relative to this source file's crate dir (when built in-repo).
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(GOKUJO_SRC);
    if manifest.exists() {
        return Ok(manifest);
    }
    anyhow::bail!(
        "Gokujo.lean not found — expected vendored source at {}",
        GOKUJO_SRC
    )
}

fn run(cmd: &mut Command) -> Result<(i32, String, String)> {
    let out = cmd.output().context(format!("failed to spawn {}", cmd.get_program().to_string_lossy()))?;
    Ok((
        out.status.code().unwrap_or(-1),
        String::from_utf8_lossy(&out.stdout).into_owned(),
        String::from_utf8_lossy(&out.stderr).into_owned(),
    ))
}

/// Public helper for sibling modules: run a command, capture (code, stdout, stderr).
pub fn run_cmd(prog: &str, args: &[&str], cwd: Option<&Path>) -> Result<(i32, String, String)> {
    let mut c = Command::new(prog);
    c.args(args);
    if let Some(d) = cwd {
        c.current_dir(d);
    }
    run(&mut c)
}

/// Probe a command; return its trimmed stdout if exit 0.
fn probe(cmd: &str, args: &[&str]) -> Option<String> {
    let (code, out, _) = run(Command::new(cmd).args(args)).ok()?;
    (code == 0).then(|| out.lines().next().unwrap_or("").trim().to_string())
}

/// One Lean toolchain backend gokujo (and this module) knows about.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Backend {
    Elan,
    System,
    Nix,
    Lake,
}

impl Backend {
    pub fn name(self) -> &'static str {
        match self {
            Backend::Elan => "elan",
            Backend::System => "system",
            Backend::Nix => "nix",
            Backend::Lake => "lake",
        }
    }
}

/// Detect the best available Lean toolchain backend, in preference order:
/// elan (honours lean-toolchain pins) > system > nix > lake env.
pub fn detect_backends() -> Vec<(Backend, Option<String>)> {
    let elan_lean = std::env::var_os("HOME")
        .map(|h| PathBuf::from(h).join(".elan/bin/lean"))
        .filter(|p| p.exists())
        .map(|p| p.to_string_lossy().into_owned());
    let mut out = Vec::new();

    let elan = elan_lean
        .as_deref()
        .and_then(|p| probe(p, &["--version"]))
        .or_else(|| probe("lean", &["--version"]));
    out.push((Backend::Elan, elan));

    out.push((Backend::System, probe("lean", &["--version"])));
    out.push((Backend::Nix, probe("nix", &["--version"])));

    let lake = probe("lake", &["--version"]).map(|v| format!("lake env lean ({})", v));
    out.push((Backend::Lake, lake));
    out
}

/// Resolve the lean + leanc commands to build gokujo with.
fn resolve_lean(backend: Option<Backend>) -> Result<(String, String)> {
    let home_lean = std::env::var_os("HOME")
        .map(|h| PathBuf::from(h).join(".elan/bin/lean"))
        .filter(|p| p.exists());
    let home_leanc = std::env::var_os("HOME")
        .map(|h| PathBuf::from(h).join(".elan/bin/leanc"))
        .filter(|p| p.exists());

    let lean = match backend {
        Some(Backend::System) => "lean".to_string(),
        Some(Backend::Elan) => home_lean
            .as_ref()
            .map(|p| p.to_string_lossy().into_owned())
            .unwrap_or_else(|| "lean".to_string()),
        Some(b) => anyhow::bail!("backend {} cannot compile gokujo directly", b.name()),
        None => home_lean
            .as_ref()
            .map(|p| p.to_string_lossy().into_owned())
            .filter(|p| Path::new(p).exists())
            .map(Ok)
            .unwrap_or_else(|| {
                if Path::new("lean").exists() || probe("lean", &["--version"]).is_some() {
                    Ok("lean".to_string())
                } else {
                    Err(anyhow::anyhow!(
                        "no Lean toolchain found — install elan (curl https://elan.lean-lang.org/elan-init.sh -sSf | sh) or `nix profile install nixpkgs#lean4`"
                    ))
                }
            })?,
    };
    let leanc = match backend {
        Some(Backend::System) => "leanc".to_string(),
        _ => home_leanc
            .as_ref()
            .map(|p| p.to_string_lossy().into_owned())
            .unwrap_or_else(|| "leanc".to_string()),
    };
    Ok((lean, leanc))
}

/// `aristo toolchain doctor` — report which toolchain backends work here.
pub fn cmd_doctor() -> Result<()> {
    println!("=== Aristotle Toolchain Doctor ===");
    println!();
    let backends = detect_backends();
    for (b, version) in &backends {
        match version {
            Some(v) => println!("  {:<8} available   {}", b.name(), v),
            None => println!("  {:<8} missing", b.name()),
        }
    }
    println!();

    // gokujo binary state
    let bin = gokujo_bin_default()?;
    if bin.exists() {
        println!("  gokujo   available   {} (cached)", bin.display());
    } else {
        println!("  gokujo   missing     run: aristotle-manager toolchain bootstrap");
    }
    let vendored = find_gokujo_src().ok();
    match vendored {
        Some(p) => println!("  source   available   {}", p.display()),
        None => println!("  source   missing     {}", GOKUJO_SRC),
    }

    // nix lean store (project-configured)
    if let Ok(config) = crate::load_config() {
        if let Some(store) = &config.nix_store_path {
            println!("  nixstore configured   {}", store);
        }
    }
    println!();
    let usable = backends.iter().any(|(b, v)| *b != Backend::Nix && v.is_some());
    println!(
        "  verdict: {}",
        if usable { "can compile and check proofs" } else { "no Lean toolchain — run `aristotle-manager bootstrap lean`" }
    );
    Ok(())
}

/// `aristo toolchain bootstrap [-o BIN]` — compile the vendored Gokujo.lean
/// into a tiny native binary using the best available toolchain.
///
/// Two-stage build (matches upstream):
///   1. lean Gokujo.lean  -> Gokujo.olean + gokujo.c  (library, no main)
///   2. lean GokujoMain.lean -> gmain.c               (root `main`)
///   3. leanc gmain.c gokujo.o -> gokujo binary
pub fn cmd_bootstrap(out: Option<PathBuf>, backend: Option<String>) -> Result<PathBuf> {
    let src = find_gokujo_src()?;
    let src_dir = src.parent().context("gokujo source has no parent dir")?.to_path_buf();
    let main_src = src_dir
        .join("GokujoMain.lean")
        .canonicalize()
        .with_context(|| format!("{} not found", src_dir.join("GokujoMain.lean").display()))?;
    let bin = out.unwrap_or_else(|| gokujo_bin_default().unwrap_or_else(|_| PathBuf::from("gokujo")));
    let build_dir = src_dir.join(".gokujo-build");
    std::fs::create_dir_all(&build_dir)?;

    let backend = match backend.as_deref() {
        None => None,
        Some("elan") => Some(Backend::Elan),
        Some("system") => Some(Backend::System),
        Some(other) => anyhow::bail!("unknown backend '{}' (elan|system)", other),
    };
    let (lean, leanc) = resolve_lean(backend)?;
    println!("  using lean: {}", lean);

    let olean = build_dir.join("Gokujo.olean");
    let cfile = build_dir.join("gokujo.c");

    println!("  [1/3] {} (library, no imports)...", src.display());
    let (code, _, err) = run(
        Command::new(&lean)
            .args(["-o", olean.to_str().unwrap(), "-c", cfile.to_str().unwrap(), src.to_str().unwrap()])
            .current_dir(&src_dir),
    )?;
    if code != 0 {
        anyhow::bail!("lean compile failed:\n{}", err);
    }

    println!("  [2/3] {} (root main)...", main_src.display());
    let main_c = build_dir.join("gmain.c");
    let (code, _, err) = run(
        Command::new(&lean)
            .args(["-o", build_dir.join("GokujoMain.olean").to_str().unwrap(), "-c", main_c.to_str().unwrap(), main_src.to_str().unwrap()])
            // Stage 1 wrote Gokujo.olean into build_dir — search there.
            .env("LEAN_PATH", &build_dir)
            .current_dir(&src_dir),
    )?;
    if code != 0 {
        anyhow::bail!("lean main compile failed:\n{}", err);
    }

    println!("  [3/3] linking native binary...");
    if let Some(parent) = bin.parent() {
        std::fs::create_dir_all(parent)?;
    }
    // Link from the build dir so relative object paths resolve.
    let (code, _, err) = run(
        Command::new(&leanc)
            .args(["-c", "gokujo.c", "-o", "gokujo.o"])
            .current_dir(&build_dir),
    )?;
    if code != 0 {
        anyhow::bail!("leanc compile failed:\n{}", err);
    }
    let (code, _, err) = run(
        Command::new(&leanc)
            .args(["gmain.c", "gokujo.o", "-o", bin.to_str().unwrap()])
            .current_dir(&build_dir),
    )?;
    if code != 0 {
        anyhow::bail!("leanc link failed:\n{}", err);
    }

    // Smoke test
    let (code, out, _) = run(Command::new(&bin).arg("version"))?;
    if code != 0 {
        anyhow::bail!("gokujo binary does not run (exit {})", code);
    }
    println!("  wrote {}", bin.display());
    println!("  {}", out.lines().next().unwrap_or("gokujo"));
    Ok(bin)
}

/// `aristo toolchain bundle <TOOLCHAIN_DIR> [-o DIR]` — copy a Lean toolchain
/// beside the gokujo binary so the pair is self-contained (no elan, no nix).
pub fn cmd_bundle(toolchain_dir: PathBuf, out: Option<PathBuf>) -> Result<()> {
    if !toolchain_dir.join("bin/lean").exists() {
        anyhow::bail!("{} does not look like a Lean toolchain (no bin/lean)", toolchain_dir.display());
    }
    let dest = out.unwrap_or_else(|| {
        gokujo_bin_default()
            .map(|b| b.parent().unwrap().to_path_buf().join("toolchain"))
            .unwrap_or_else(|_| PathBuf::from("toolchain"))
    });
    println!("  bundling {} -> {}", toolchain_dir.display(), dest.display());
    let (code, _, err) = run(Command::new("cp").args(["-a", toolchain_dir.to_str().unwrap(), dest.to_str().unwrap()]))?;
    if code != 0 {
        anyhow::bail!("copy failed: {}", err);
    }
    let (code, out, _) = run(Command::new(dest.join("bin/lean")).arg("--version"))?;
    if code != 0 {
        anyhow::bail!("bundled toolchain does not run: {}", err);
    }
    println!("  bundled {} — the binary+toolchain pair is self-contained", out.lines().next().unwrap_or("").trim());
    Ok(())
}

/// `aristo toolchain release [-o SCRIPT]` — write the shell script that builds
/// every per-platform gokujo artifact (Linux/macOS × standalone/bundled/system/…).
pub fn cmd_release(out: Option<PathBuf>) -> Result<()> {
    // Delegate to gokujo's own release writer when a binary exists, else
    // generate a portable script directly from the vendored source.
    let bin = gokujo_bin_default().ok().filter(|p| p.exists());
    if let Some(bin) = bin {
        let args = match out {
            Some(o) => vec!["release".to_string(), "-o".to_string(), o.to_string_lossy().into_owned()],
            None => vec!["release".to_string()],
        };
        let (code, stdout, stderr) = run(Command::new(&bin).args(&args))?;
        print!("{}", stdout);
        if code != 0 {
            anyhow::bail!("gokujo release failed: {}", stderr);
        }
        return Ok(());
    }
    anyhow::bail!("no gokujo binary — run `aristotle-manager toolchain bootstrap` first")
}

/// Print the location of the vendored markdown manual (what `gokujo help` prints).
pub fn cmd_manual() -> Result<()> {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(GOKUJO_MD);
    if path.exists() {
        println!("{}", path.display());
    } else {
        // fall back to repo-root search
        let mut cwd = std::env::current_dir()?;
        loop {
            let c = cwd.join(GOKUJO_MD);
            if c.exists() {
                println!("{}", c.display());
                break;
            }
            if !cwd.pop() {
                anyhow::bail!("{} not found", GOKUJO_MD);
            }
        }
    }
    Ok(())
}
