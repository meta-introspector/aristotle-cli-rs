use anyhow::{Context, Result};
use std::path::{Path, PathBuf};
use std::process::Command;
use tracing::info;

use crate::load_config;

/// Nix-build: compile Lean project using nix store's lean binary + pre-built oleans.
///
/// Uses the nix store's Lean 4.29.1 installation which has 2,209 pre-compiled
/// Init + Std .olean files. Generates lakefile.lean and flake.nix automatically.
pub fn cmd_nix_build(
    input_dir: PathBuf,
    output_dir: Option<PathBuf>,
    nix_store: Option<String>,
    generate_flake: bool,
    dry_run: bool,
) -> Result<()> {
    let config = load_config()?;
    let output_dir = output_dir.unwrap_or_else(|| input_dir.join("build-out"));
    let nix_store = nix_store
        .or_else(|| config.nix_store_path.clone())
        .unwrap_or_else(|| {
            "/mnt/data1/nix-store/store/yy02jnq1m13zbmsahh87v5z9w91k4wwa-lean4-4.29.1".into()
        });
    let lean_bin = format!("{}/bin/lean", nix_store);
    let lean_path = format!("{}/lib/lean", nix_store);

    info!(
        input = %input_dir.display(),
        output = %output_dir.display(),
        nix_store = %nix_store,
        "Starting nix-build"
    );

    // 1. Check input directory has .lean files
    let lean_files: Vec<_> = std::fs::read_dir(&input_dir)?
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |x| x == "lean"))
        .collect();

    if lean_files.is_empty() {
        anyhow::bail!("No .lean files found in {}", input_dir.display());
    }

    info!("Found {} .lean files to build", lean_files.len());

    // 2. Check if lean binary exists
    let lean_path_buf = Path::new(&lean_bin);
    if !lean_path_buf.exists() {
        anyhow::bail!(
            "Lean binary not found at {}. Also tried: {}/bin/lean",
            lean_bin,
            nix_store
        );
    }

    // 3. Generate lakefile.lean and flake.nix if requested
    if generate_flake {
        generate_build_files(&input_dir, &nix_store)?;
    }

    if dry_run {
        info!("Dry-run — would build with:");
        info!("  lean:      {}", lean_bin);
        info!("  LEAN_PATH: {}", lean_path);
        info!("  files:     {} .lean files", lean_files.len());
        for f in &lean_files {
            info!("    - {}", f.path().display());
        }
        return Ok(());
    }

    // 4. Build: compile each .lean file with lean --make
    std::fs::create_dir_all(&output_dir)
        .with_context(|| format!("Cannot create output dir: {}", output_dir.display()))?;

    for f in &lean_files {
        let stem = f.path().file_stem().unwrap().to_string_lossy().into_owned();
        let out_file = output_dir.join(format!("{}.olean", stem));

        info!("Building: {} -> {}", stem, out_file.display());

        let status = Command::new(&lean_bin)
            .args(["--make", "--extra-lean-path", &lean_path])
            .arg(f.path())
            .args(["-o", &out_file.to_string_lossy()])
            .env("LEAN_PATH", &lean_path)
            .current_dir(&input_dir)
            .status()
            .with_context(|| format!("Failed to execute lean for {}", stem))?;

        if status.success() {
            info!("✅ Built: {}.olean", stem);
        } else {
            anyhow::bail!(
                "❌ lean build failed for {} (exit code: {:?})",
                stem,
                status.code()
            );
        }
    }

    info!("Build complete. Output: {}", output_dir.display());
    Ok(())
}

/// Generate lakefile.lean and flake.nix for a project directory.
fn generate_build_files(input_dir: &Path, nix_store: &str) -> Result<()> {
    let package_name = input_dir
        .file_stem()
        .map(|s| s.to_string_lossy().to_string())
        .unwrap_or_else(|| "lean-project".to_string());

    // Generate lakefile.lean
    let lakefile = input_dir.join("lakefile.lean");
    if !lakefile.exists() {
        let lakefile_content = format!(
            r#"import Lake
open Lake DSL

package "{pkg}" where
  version := v!"0.1.0"

lean_lib {pkg} where
  srcDir := "."
"#,
            pkg = package_name
        );
        std::fs::write(&lakefile, &lakefile_content)
            .with_context(|| format!("Cannot write {}", lakefile.display()))?;
        info!("Generated: {}", lakefile.display());
    }

    // Generate flake.nix
    let flake = input_dir.join("flake.nix");
    if !flake.exists() {
        let flake_content = format!(
            r#"{{
  description = "Nix build for {pkg} — using nix store lean";
  inputs = {{ nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; }};
  outputs = {{ self, nixpkgs }}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${{system}};
    leanStore = "{store}";
  in {{
    packages.${{system}}.default = pkgs.stdenv.mkDerivation {{
      name = "{pkg}";
      src = ./.;
      LEAN_PATH = "${{leanStore}}/lib/lean";
      buildPhase = ''
        ${{leanStore}}/bin/lean --make *.lean -o $out/lib/lean/{pkg}.olean
      '';
      installPhase = ''
        mkdir -p $out/lib/lean
        cp *.olean $out/lib/lean/
      '';
    }};
  }};
}}"#,
            pkg = package_name,
            store = nix_store
        );
        std::fs::write(&flake, &flake_content)
            .with_context(|| format!("Cannot write {}", flake.display()))?;
        info!("Generated: {}", flake.display());
    }

    Ok(())
}
