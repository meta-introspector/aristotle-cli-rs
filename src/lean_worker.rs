//! Load and run modules from downloaded Aristotle projects via the
//! lean-worker (gokujo) protocol.
//!
//! Every gate subcommand (`scan`, `graph`, `build`, `sorry`, `axioms`,
//! `check`) maps 1:1 onto a gokujo command, executed inside the resolved
//! project directory with the shared precompiled Mathlib cache wired in
//! (`shared_lean::configure_project`) and the rev-pinned nix Lean 4.28.0
//! first on PATH. `--json` streams gokujo's telemetry object to stdout.
//!
//! `run` builds the project (unless `--no-build`) and then executes a
//! module's `main` with `lean --run`, using a LEAN_PATH assembled from the
//! project's own oleans plus the shared package cache.

use anyhow::{Context, Result};
use clap::{Args, Subcommand};
use std::path::{Path, PathBuf};
use std::process::Command;
use tracing::{info, warn};

/// Nix-store Lean 4.28.0 whose olean headers match the shared mathlib cache
/// (gitrev v4.28.0). The other nix 4.28.0 build (181szlvcv, commit 7e01a1bf)
/// and the 4.30.0 system lean are INCOMPATIBLE with the cache oleans.
const LEAN_428_BIN: &str =
    "/mnt/data1/nix-store/store/75c91mcn5ric5m141r7hbf3hf8f12r7x-lean4-4.28.0/bin";

/// Shared precompiled package cache (see shared_lean::SHARED_PACKAGES).
const SHARED_PACKAGES: &str = "/mnt/data1/lean/dot_lake/packages";

#[derive(Subcommand)]
pub enum LeanCommands {
    /// Which Lean backends this machine can use.
    Doctor,
    /// Parse sources, list declarations.
    Scan(GateArgs),
    /// Import graph + verified topological order.
    Graph(GateArgs),
    /// Compile every module — no lake, no make.
    Build(GateArgs),
    /// Fail if any sorry/admit is reachable.
    Sorry(GateArgs),
    /// Audit the axioms behind every theorem.
    Axioms(GateArgs),
    /// Full gate: scan + graph + build + sorry + axioms.
    Check(GateArgs),
    /// Build the project, then run a module's `main`.
    Run {
        /// Aristotle project id.
        project_id: String,
        /// Module to run (`RequestProject.Foo`) or path to a .lean file.
        module: String,
        /// Source directory inside the project (default: auto-detect).
        #[arg(long)]
        src: Option<PathBuf>,
        /// Skip the build step (module oleans already exist).
        #[arg(long)]
        no_build: bool,
        /// Arguments forwarded to the module's `main` (after `--`).
        #[arg(last = true)]
        args: Vec<String>,
    },
}

#[derive(Args)]
pub struct GateArgs {
    /// Aristotle project id.
    pub project_id: String,
    /// Source directory inside the project (default: auto-detect).
    #[arg(long)]
    pub src: Option<PathBuf>,
    /// Emit a single JSON telemetry object on stdout.
    #[arg(long)]
    pub json: bool,
}

/// Resolve the on-disk root of a downloaded project: `<id>_aristotle` or
/// `<id>` under results_dir, descending into `output-final_aristotle` when
/// the tarball wrapper is present.
pub fn resolve_project_dir(results_dir: &Path, project_id: &str) -> Result<PathBuf> {
    for candidate in [
        results_dir.join(format!("{}_aristotle", project_id)),
        results_dir.join(project_id),
    ] {
        if candidate.is_dir() {
            let nested = candidate.join("output-final_aristotle");
            return Ok(if nested.is_dir() { nested } else { candidate });
        }
    }
    anyhow::bail!(
        "project {} not found under {} — run `fetch --project-id {}` first",
        project_id,
        results_dir.display(),
        project_id
    )
}

/// Locate a runnable gokujo binary: $GOKUJO_BIN, vendored prebuilt in the
/// repo, the toolchain-bootstrap cache, then PATH.
fn gokujo_bin() -> Result<PathBuf> {
    if let Some(p) = std::env::var_os("GOKUJO_BIN") {
        let p = PathBuf::from(p);
        if p.exists() {
            return Ok(p);
        }
    }
    // Vendored prebuilt next to the sources (walk up from CWD).
    let mut cwd = std::env::current_dir().context("could not read cwd")?;
    loop {
        let candidate = cwd.join("tools/gokujo/gokujo");
        if candidate.exists() {
            return Ok(candidate);
        }
        if !cwd.pop() {
            break;
        }
    }
    let manifest = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tools/gokujo/gokujo");
    if manifest.exists() {
        return Ok(manifest);
    }
    if let Ok(cached) = crate::toolchain::gokujo_bin_default() {
        if cached.exists() {
            return Ok(cached);
        }
    }
    if let Some(path) = std::env::var_os("PATH") {
        for dir in std::env::split_paths(&path) {
            let candidate = dir.join("gokujo");
            if candidate.is_file() {
                return Ok(candidate);
            }
        }
    }
    anyhow::bail!("gokujo binary not found — run `aristotle-manager toolchain bootstrap`")
}

/// Prepend the rev-pinned nix Lean 4.28.0 to PATH so gokujo's backend
/// detection picks the cache-compatible toolchain first.
fn with_lean_428(cmd: &mut Command) {
    if Path::new(LEAN_428_BIN).is_dir() {
        let path = std::env::var_os("PATH").unwrap_or_default();
        let mut dirs = vec![PathBuf::from(LEAN_428_BIN)];
        dirs.extend(std::env::split_paths(&path));
        if let Ok(joined) = std::env::join_paths(dirs) {
            cmd.env("PATH", joined);
        }
    } else {
        warn!(path = LEAN_428_BIN, "nix lean 4.28.0 missing; falling back to ambient toolchain");
    }
}

/// LEAN_PATH fragment covering every shared precompiled package.
fn shared_lean_path() -> Vec<PathBuf> {
    let mut out = Vec::new();
    if let Ok(entries) = std::fs::read_dir(SHARED_PACKAGES) {
        for e in entries.flatten() {
            let lib = e.path().join(".lake/build/lib/lean");
            if lib.is_dir() {
                out.push(lib);
            }
        }
    }
    out
}

/// Default source dir: `RequestProject` when present, else the project root.
fn default_src(project_dir: &Path) -> PathBuf {
    let rp = project_dir.join("RequestProject");
    if rp.is_dir() {
        PathBuf::from("RequestProject")
    } else {
        PathBuf::from(".")
    }
}

/// Prepare a project directory for lean-worker use: wire the shared cache
/// symlink and canonicalize the mathlib path in lakefile.toml.
fn prepare(project_dir: &Path) -> Result<()> {
    crate::shared_lean::configure_project(project_dir)
        .with_context(|| format!("wiring shared lean cache in {}", project_dir.display()))
}

/// Run gokujo with stdio inherited; map its exit codes to errors.
fn exec_gokujo(bin: &Path, project_dir: &Path, args: &[&str]) -> Result<()> {
    info!(dir = %project_dir.display(), args = ?args, "gokujo");
    let mut cmd = Command::new(bin);
    cmd.args(args).current_dir(project_dir);
    with_lean_428(&mut cmd);
    let status = cmd.status().context("failed to spawn gokujo")?;
    match status.code().unwrap_or(-1) {
        0 => Ok(()),
        1 => anyhow::bail!("project failed `gokujo {}`", args.first().copied().unwrap_or("")),
        2 => anyhow::bail!("gokujo usage error"),
        3 => anyhow::bail!("no usable Lean toolchain (see `lean doctor`)"),
        c => anyhow::bail!("gokujo exited with code {}", c),
    }
}

pub fn cmd_lean(subcommand: &LeanCommands) -> Result<()> {
    let config = crate::load_config()?;
    let results_dir = config.results_dir.clone();
    let bin = gokujo_bin()?;

    match subcommand {
        LeanCommands::Doctor => {
            let mut cmd = Command::new(&bin);
            cmd.arg("doctor");
            with_lean_428(&mut cmd);
            let status = cmd.status().context("failed to spawn gokujo")?;
            if !status.success() {
                anyhow::bail!("gokujo doctor exited with {}", status);
            }
            Ok(())
        }
        LeanCommands::Scan(a) => gate(&bin, &results_dir, "scan", a),
        LeanCommands::Graph(a) => gate(&bin, &results_dir, "graph", a),
        LeanCommands::Build(a) => gate(&bin, &results_dir, "build", a),
        LeanCommands::Sorry(a) => gate(&bin, &results_dir, "sorry", a),
        LeanCommands::Axioms(a) => gate(&bin, &results_dir, "axioms", a),
        LeanCommands::Check(a) => gate(&bin, &results_dir, "check", a),
        LeanCommands::Run { project_id, module, src, no_build, args } => {
            let dir = resolve_project_dir(&results_dir, project_id)?;
            prepare(&dir)?;
            let src = src.clone().unwrap_or_else(|| default_src(&dir));

            if !no_build {
                let src_s = src.to_string_lossy().into_owned();
                exec_gokujo(&bin, &dir, &["build", &src_s])?;
            }

            let file = if module.ends_with(".lean") {
                dir.join(module)
            } else {
                dir.join(&src).join(format!("{}.lean", module.replace('.', "/")))
            };
            if !file.exists() {
                anyhow::bail!("module file not found: {}", file.display());
            }

            // LEAN_PATH: project oleans first, then the shared cache.
            let mut lp = vec![
                dir.join(".gokujo/build"),
                dir.join(".lake/build/lib/lean"),
            ];
            lp.extend(shared_lean_path());
            let lean_path = std::env::join_paths(&lp).context("building LEAN_PATH")?;

            let lean = Path::new(LEAN_428_BIN).join("lean");
            let lean = if lean.exists() { lean } else { PathBuf::from("lean") };
            info!(file = %file.display(), "lean --run");
            let status = Command::new(lean)
                .arg("--run")
                .arg(&file)
                .args(args)
                .current_dir(&dir)
                .env("LEAN_PATH", lean_path)
                .status()
                .context("failed to spawn lean")?;
            if !status.success() {
                anyhow::bail!("lean --run exited with {}", status);
            }
            Ok(())
        }
    }
}

fn gate(bin: &Path, results_dir: &Path, cmd: &str, args: &GateArgs) -> Result<()> {
    let dir = resolve_project_dir(results_dir, &args.project_id)?;
    prepare(&dir)?;
    let src = args
        .src
        .clone()
        .unwrap_or_else(|| default_src(&dir))
        .to_string_lossy()
        .into_owned();
    let mut argv = vec![cmd, src.as_str()];
    if args.json {
        argv.push("--json");
    }
    exec_gokujo(bin, &dir, &argv)
}
