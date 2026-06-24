use std::collections::{BTreeMap, HashMap, HashSet};
use std::fs;
use std::path::{Path, PathBuf};
use anyhow::{Context, Result};
use regex::Regex;
use serde::Serialize;
use tracing::{debug, info, instrument, warn};
use walkdir::WalkDir;

// ── J-Invariant Prime Stratification ───────────────────────────────────

/// j-invariant q-expansion bands (canonical Sage truncation)
const J_BANDS: &[(&str, u64, u64, &str)] = &[
    ("q⁻¹",   0,      0,      "Identity origin"),
    ("q⁰",    2,     31,      "Foundation: 744 = 2³×3×31"),
    ("q¹",   32,   1823,      "Monster emergence: 196884 = 2²×3³×1823"),
    ("q²", 1824,   2099,      "Moonshine harmonics: 21493760 = 2⁸×5×2099"),
    ("q³", 2100, 355679,      "Higher irreps: 864299970"),
    ("O(q⁴)", 355680, u64::MAX, "Transcendental tail"),
];

fn get_band(max_p: u64) -> (&'static str, &'static str) {
    for (label, lo, hi, desc) in J_BANDS {
        if *lo <= max_p && max_p <= *hi {
            return (label, desc);
        }
    }
    ("q∞", "Beyond known coefficients")
}

fn max_prime_factor(n: u64) -> u64 {
    if n <= 1 {
        return 0;
    }
    let mut m = n;
    let mut max_p = 1u64;

    // Factor out 2s
    while m % 2 == 0 {
        max_p = 2;
        m /= 2;
    }

    // Factor odd primes
    let mut p = 3u64;
    while p * p <= m {
        while m % p == 0 {
            max_p = p;
            m /= p;
        }
        p += 2;
    }

    if m > 1 {
        max_p = m;
    }
    max_p
}

fn extract_integers(content: &str) -> Vec<u64> {
    let mut nums = Vec::new();
    let mut in_num = false;
    let mut current = 0u64;
    for ch in content.chars() {
        if ch.is_ascii_digit() {
            in_num = true;
            current = current.saturating_mul(10).saturating_add((ch as u8 - b'0') as u64);
        } else if in_num {
            if current > 1 && current < 1_000_000_000 {
                nums.push(current);
            }
            current = 0;
            in_num = false;
        }
    }
    if in_num && current > 1 && current < 1_000_000_000 {
        nums.push(current);
    }
    nums
}

/// Check if a declaration name is hash-noise (compiler internals, not math)
fn is_hash_noise(name: &str) -> bool {
    let patterns = [
        "Lean_PersistentHashMap", "Lean_PHash", "Lean_instInhabited",
        "Lean_SMap", "Std_HashMap", "Std_HashSet", "Lean_KeyedDecls",
        "Lean_ScopedEnvExtension", "Lean_PersistentEnvExtension",
        "Lean_SimplePersistentEnvExtension", "Lean_instMonad",
        "Lean_MonadCache", "Lean_instNonempty", "Lean_instExcept",
        "Lean_instToExpr", "Lean_instToMessageData",
        "Lean_instInhabitedOption", "Lean_instInhabitedPersistentArray",
        "Lean_instInhabitedPersistentEnv", "Lean_instInhabitedScopedEnvExtension",
        "Lean_instInhabitedStateStack", "Lean_instAddErrorMessage",
    ];
    patterns.iter().any(|p| name.contains(p))
}

#[derive(Debug, Serialize)]
struct DeclPrime {
    name: String,
    kind: String,
    file: String,
    line: usize,
    constants: Vec<u64>,
    max_prime: u64,
    band: String,
    band_desc: String,
    monster_hit: bool,
}

#[instrument(skip(input_dir, output_dir))]
pub fn cmd_j_key(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let config = super::load_config()?;
    let input_dir = input_dir.unwrap_or_else(|| config.base_dir.join("consolidated"));
    let output_dir = output_dir.unwrap_or_else(|| config.base_dir.join("j-key"));
    fs::create_dir_all(&output_dir)?;

    info!(input = %input_dir.display(), output = %output_dir.display(), "J-key stratification");

    let mut results: Vec<DeclPrime> = Vec::new();

    // Walk input for .lean files (consolidated or atomized)
    for entry in WalkDir::new(&input_dir)
        .max_depth(5)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
    {
        let content = fs::read_to_string(entry.path())?;
        let file_name = entry.path()
            .file_name()
            .and_then(|s| s.to_str())
            .unwrap_or("unknown");

        // Parse declarations from .lean content
        let mut line_num = 0usize;
        let mut current_decl: Option<(String, String, usize)> = None;
        let mut decl_body = String::new();

        for line in content.lines() {
            line_num += 1;
            let trimmed = line.trim();

            // Check for declaration start
            let decl_kw = ["theorem", "def", "lemma", "example", "instance",
                           "class", "inductive", "structure", "abbrev", "axiom"];
            let mut found = None;
            for kw in &decl_kw {
                if trimmed.starts_with(kw) {
                    let after = &trimmed[kw.len()..];
                    if after.starts_with(' ') || after.starts_with('\t') {
                        found = Some((kw.to_string(), trimmed.to_string(), line_num));
                        break;
                    }
                }
            }

            if let Some((kind, first_line, ln)) = found {
                // Flush previous declaration
                if let Some((name, _, _)) = &current_decl {
                    if !is_hash_noise(name) {
                        let ints = extract_integers(&decl_body);
                        if !ints.is_empty() {
                            let max_p = ints.iter().map(|&n| max_prime_factor(n)).max().unwrap_or(0);
                            let (band, band_desc) = get_band(max_p);
                            let monster_primes = [47, 59, 71];
                            let monster_hit = ints.iter().any(|&n| monster_primes.iter().any(|&mp| n % mp == 0));
                            results.push(DeclPrime {
                                name: name.clone(),
                                kind: current_decl.as_ref().unwrap().0.clone(),
                                file: file_name.to_string(),
                                line: current_decl.as_ref().unwrap().2,
                                constants: ints,
                                max_prime: max_p,
                                band: band.to_string(),
                                band_desc: band_desc.to_string(),
                                monster_hit,
                            });
                        }
                    }
                }

                // Extract name from first line
                let after_kw = first_line[kind.len()..].trim_start();
                let after_attr = if after_kw.starts_with('@') {
                    after_kw.split(']').nth(1).unwrap_or(after_kw).trim_start()
                } else {
                    after_kw
                };
                let name = after_attr
                    .split(|c: char| c.is_whitespace() || c == '(' || c == ':' || c == '{')
                    .next()
                    .unwrap_or("")
                    .to_string();

                if !name.is_empty() && name != "-" && name != "_" {
                    current_decl = Some((kind, name, ln));
                    decl_body = first_line.to_string();
                    decl_body.push('\n');
                }
            } else if current_decl.is_some() {
                decl_body.push_str(line);
                decl_body.push('\n');
            }
        }

        // Flush last declaration
        if let Some((_kind, name, _ln)) = &current_decl {
            if !is_hash_noise(name) {
                let ints = extract_integers(&decl_body);
                if !ints.is_empty() {
                    let max_p = ints.iter().map(|&n| max_prime_factor(n)).max().unwrap_or(0);
                    let (band, band_desc) = get_band(max_p);
                    let monster_primes = [47, 59, 71];
                    let monster_hit = ints.iter().any(|&n| monster_primes.iter().any(|&mp| n % mp == 0));
                    results.push(DeclPrime {
                        name: name.clone(),
                        kind: current_decl.as_ref().unwrap().0.clone(),
                        file: file_name.to_string(),
                        line: current_decl.as_ref().unwrap().2,
                        constants: ints,
                        max_prime: max_p,
                        band: band.to_string(),
                        band_desc: band_desc.to_string(),
                        monster_hit,
                    });
                }
            }
        }
    }

    // Sort by band, then max_prime desc
    let band_order: HashMap<&str, usize> = J_BANDS.iter()
        .enumerate()
        .map(|(i, (label, _, _, _))| (*label, i))
        .collect();
    results.sort_by(|a, b| {
        band_order.get(a.band.as_str()).unwrap_or(&99)
            .cmp(band_order.get(b.band.as_str()).unwrap_or(&99))
            .then(b.max_prime.cmp(&a.max_prime))
    });

    // Build band breakdown
    let mut band_counts: BTreeMap<String, usize> = BTreeMap::new();
    let mut monster_decls: Vec<&DeclPrime> = Vec::new();
    for r in &results {
        *band_counts.entry(r.band.clone()).or_default() += 1;
        if r.monster_hit {
            monster_decls.push(r);
        }
    }

    let total = results.len();
    let with_constants = results.iter().filter(|r| !r.constants.is_empty()).count();
    let monster_count = monster_decls.len();

    // Write JSON output
    let output = serde_json::json!({
        "total_declarations": total,
        "declarations_with_constants": with_constants,
        "monster_hits": monster_count,
        "bands": band_counts,
        "results": results.iter().map(|r| serde_json::json!({
            "name": r.name,
            "kind": r.kind,
            "file": r.file,
            "line": r.line,
            "constants": r.constants,
            "max_prime": r.max_prime,
            "band": r.band,
            "band_desc": r.band_desc,
            "monster_hit": r.monster_hit,
        })).collect::<Vec<_>>(),
    });

    let json_path = output_dir.join("j-key-stratification.json");
    fs::write(&json_path, serde_json::to_string_pretty(&output)?)?;

    println!("J-key stratification complete:");
    println!("  Total declarations:       {}", total);
    println!("  With numerical constants: {}", with_constants);
    println!("  Monster prime hits:      {}", monster_count);
    println!("  Bands:");
    for (band, count) in &band_counts {
        println!("    {:>8}: {}", band, count);
    }
    if monster_count > 0 {
        println!("  Monster declarations:");
        for d in monster_decls.iter().take(15) {
            println!("    {} (prime={}, band={})", d.name, d.max_prime, d.band);
        }
    }
    println!("  Output: {}", json_path.display());

    info!(total, with_constants, monster_count, "J-key complete");
    Ok(())
}

// ── Functor Arrow Extraction ────────────────────────────────────────────

#[derive(Debug, Serialize)]
struct Arrow {
    source: String,
    target: String,
    arrow_type: String,
    weight: f64,
    description: String,
}

#[instrument(skip(input_dir, output_dir))]
pub fn cmd_arrows(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let config = super::load_config()?;
    let input_dir = input_dir.unwrap_or_else(|| config.base_dir.join("j-key"));
    let output_dir = output_dir.unwrap_or_else(|| config.base_dir.join("arrows"));
    fs::create_dir_all(&output_dir)?;

    info!(input = %input_dir.display(), output = %output_dir.display(), "Arrow extraction");

    // Load j-key stratification data
    let jkey_path = input_dir.join("j-key-stratification.json");
    if !jkey_path.exists() {
        return Err(anyhow::anyhow!(
            "j-key-stratification.json not found in {}. Run 'aristotle-manager j-key' first.",
            input_dir.display()
        ));
    }

    let jkey_data: serde_json::Value =
        serde_json::from_str(&fs::read_to_string(&jkey_path)?)?;

    let results: &Vec<serde_json::Value> = jkey_data["results"]
        .as_array()
        .context("No results array in j-key output")?;

    // Build a map: declaration name -> band
    let mut decl_band: HashMap<String, String> = HashMap::new();
    for r in results {
        if let (Some(name), Some(band)) = (r["name"].as_str(), r["band"].as_str()) {
            decl_band.insert(name.to_string(), band.to_string());
        }
    }

    // Extract arrows: relationships between declarations based on:
    // 1. Band transitions (qⁿ → qᵐ) — spectral flow
    // 2. Same-band groupings — structural clusters
    // 3. Monster prime connections — 47, 59, 71 bridges

    let mut arrows: Vec<Arrow> = Vec::new();
    let mut seen_pairs: HashSet<(String, String)> = HashSet::new();

    // Band transition arrows (spectral flow)
    let band_order: Vec<&str> = J_BANDS.iter().map(|(l, _, _, _)| *l).collect();
    for i in 0..band_order.len() {
        for j in i+1..band_order.len() {
            let src_decls: Vec<_> = decl_band.iter()
                .filter(|(_, b)| *b == band_order[i])
                .map(|(n, _)| n.clone())
                .take(10)
                .collect();
            let tgt_decls: Vec<_> = decl_band.iter()
                .filter(|(_, b)| *b == band_order[j])
                .map(|(n, _)| n.clone())
                .take(10)
                .collect();

            for src in &src_decls {
                for tgt in &tgt_decls {
                    let key = (src.clone(), tgt.clone());
                    if seen_pairs.insert(key.clone()) {
                        arrows.push(Arrow {
                            source: src.clone(),
                            target: tgt.clone(),
                            arrow_type: "spectral_flow".to_string(),
                            weight: 1.0 / (j - i) as f64,
                            description: format!("{} → {} band transition", band_order[i], band_order[j]),
                        });
                    }
                }
            }
        }
    }

    // Monster prime bridges
    let monster_results: Vec<_> = results.iter()
        .filter(|r| r["monster_hit"].as_bool().unwrap_or(false))
        .collect();
    for a in &monster_results {
        for b in &monster_results {
            if a["name"] != b["name"] {
                let key = (a["name"].as_str().unwrap().to_string(),
                           b["name"].as_str().unwrap().to_string());
                if seen_pairs.insert(key.clone()) {
                    arrows.push(Arrow {
                        source: key.0.clone(),
                        target: key.1.clone(),
                        arrow_type: "monster_bridge".to_string(),
                        weight: 1.0,
                        description: "Monster prime connection (47, 59, 71)".to_string(),
                    });
                }
            }
        }
    }

    // 5 Canonical spectral morphisms from the 2-category
    let canonical = [
        ("0xD8", "0x2A", "markov_transition", "DAG-CBOR CID signature"),
        ("0xD8", "T_p_spike_D8", "hecke_operator", "Periodic structure at 0xD8"),
        ("0x2A", "T_p_spike_2A", "hecke_operator", "Periodic structure at 0x2A"),
        ("0x2A", "freq2_high", "maass_shadow", "High frequency at 0x2A"),
        ("0xD8", "freq2_med", "maass_shadow", "Medium frequency at 0xD8"),
    ];
    for (src, tgt, atype, desc) in &canonical {
        arrows.push(Arrow {
            source: src.to_string(),
            target: tgt.to_string(),
            arrow_type: atype.to_string(),
            weight: 1.0,
            description: desc.to_string(),
        });
    }

    let arrow_count = arrows.len();
    let spectral = arrows.iter().filter(|a| a.arrow_type == "spectral_flow").count();
    let monster = arrows.iter().filter(|a| a.arrow_type == "monster_bridge").count();

    // Write output
    let output = serde_json::json!({
        "total_arrows": arrow_count,
        "spectral_flow": spectral,
        "monster_bridges": monster,
        "canonical_morphisms": 5,
        "arrows": arrows.iter().map(|a| serde_json::json!({
            "source": a.source,
            "target": a.target,
            "type": a.arrow_type,
            "weight": a.weight,
            "description": a.description,
        })).collect::<Vec<_>>(),
    });

    let json_path = output_dir.join("arrows.json");
    fs::write(&json_path, serde_json::to_string_pretty(&output)?)?;

    println!("Arrow extraction complete:");
    println!("  Total arrows:     {}", arrow_count);
    println!("  Spectral flow:    {}", spectral);
    println!("  Monster bridges:  {}", monster);
    println!("  Canonical morph:  5");
    println!("  Output:           {}", json_path.display());

    info!(arrow_count, spectral, monster, "Arrows complete");
    Ok(())
}

// ── Split by Band ───────────────────────────────────────────────────────

#[instrument(skip(input_dir, output_dir))]
pub fn cmd_split_by_band(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let config = super::load_config()?;
    let input_dir = input_dir.unwrap_or_else(|| config.base_dir.join("arrows"));
    let output_dir = output_dir.unwrap_or_else(|| config.base_dir.join("bands"));
    fs::create_dir_all(&output_dir)?;

    info!(input = %input_dir.display(), output = %output_dir.display(), "Split by band");

    // Load j-key stratification (primary source of band assignments)
    // Search: current dir, parent dir, or sibling j-key dir
    let jkey_data: serde_json::Value = {
        let candidates = vec![
            input_dir.join("j-key-stratification.json"),
            input_dir.parent().unwrap_or(&input_dir).join("j-key-stratification.json"),
            input_dir.parent().unwrap_or(&input_dir).join("j-key").join("j-key-stratification.json"),
            PathBuf::from("j-key-stratification.json"),
            PathBuf::from("j-key/j-key-stratification.json"),
        ];
        let found = candidates.iter().find(|p| p.exists())
            .ok_or_else(|| anyhow::anyhow!("j-key-stratification.json not found. Run 'aristotle-manager j-key' first."))?;
        serde_json::from_str(&fs::read_to_string(found)?)?
    };

    let results = jkey_data["results"].as_array()
        .context("No results in j-key output")?;

    // Group by band
    let mut band_groups: BTreeMap<String, Vec<&serde_json::Value>> = BTreeMap::new();
    for r in results {
        if let Some(band) = r["band"].as_str() {
            band_groups.entry(band.to_string()).or_default().push(r);
        }
    }

    for (band, decls) in &band_groups {
        let band_dir = output_dir.join(band);
        fs::create_dir_all(&band_dir)?;

        // Write per-band .lean file
        let mut lean = String::new();
        lean.push_str(&format!("-- Band: {} — {}\n", band,
            J_BANDS.iter().find(|(l,_,_,_)| *l == band).map(|(_,_,_,d)| *d).unwrap_or("")));
        lean.push_str(&format!("-- {} declarations\n\n", decls.len()));

        for d in decls {
            let name = d["name"].as_str().unwrap_or("");
            let kind = d["kind"].as_str().unwrap_or("");
            let file = d["file"].as_str().unwrap_or("");
            let line = d["line"].as_u64().unwrap_or(0);
            lean.push_str(&format!("-- [{}:{}] {} {} (prime={})\n",
                file, line, kind, name,
                d["max_prime"].as_u64().unwrap_or(0)));
        }

        fs::write(band_dir.join("declarations.lean"), &lean)?;

        // Write band manifest
        let manifest = serde_json::json!({
            "band": band,
            "count": decls.len(),
            "declarations": decls,
        });
        fs::write(
            band_dir.join("band-manifest.json"),
            serde_json::to_string_pretty(&manifest)?,
        )?;

        println!("  {:>8}: {} declarations", band, decls.len());
    }

    // Write master band index
    let band_index = serde_json::json!({
        "total_bands": band_groups.len(),
        "total_declarations": results.len(),
        "bands": band_groups.iter().map(|(b, ds)| serde_json::json!({
            "band": b,
            "count": ds.len(),
            "directory": format!("{}/", b),
        })).collect::<Vec<_>>(),
    });
    fs::write(
        output_dir.join("band-index.json"),
        serde_json::to_string_pretty(&band_index)?,
    )?;

    let total_bands = band_groups.len();
    println!("Split by band complete: {} bands, {} declarations -> {}",
        total_bands, results.len(), output_dir.display());

    info!(total_bands, "Split by band complete");
    Ok(())
}

// ── Generate Flake ──────────────────────────────────────────────────────

#[instrument(skip(band_dir, output_dir))]
pub fn cmd_gen_flake(band_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let config = super::load_config()?;
    let band_dir = band_dir.unwrap_or_else(|| config.base_dir.join("bands"));
    let output_dir = output_dir.unwrap_or_else(|| band_dir.clone());

    if !band_dir.exists() {
        return Err(anyhow::anyhow!(
            "Band directory not found: {}. Run 'aristotle-manager split-by-band' first.",
            band_dir.display()
        ));
    }

    info!(band_dir = %band_dir.display(), output = %output_dir.display(), "Generate flakes");

    let mut generated = 0u64;
    let mut skipped = 0u64;

    // Walk band subdirectories
    for entry in WalkDir::new(&band_dir)
        .min_depth(1)
        .max_depth(1)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_dir())
    {
        let band_name = entry.file_name().to_string_lossy().to_string();
        let flake_dir = output_dir.join(&band_name);
        fs::create_dir_all(&flake_dir)?;

        let flake_content = format!(
            r#"{{
  description = "DASL J-invariant band: {band} — auto-generated flake";
  inputs = {{
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git";
    flake-utils.url = "git+file:///mnt/data1/git/github.com/numtide/flake-utils.git";
  }};
  outputs = {{ self, nixpkgs, flake-utils }}:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${{system}}; in {{
        packages.default = pkgs.stdenv.mkDerivation {{
          name = "dasl-band-{band}";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp declarations.lean $out/
            cp band-manifest.json $out/
          '';
        }};
        devShells.default = pkgs.mkShell {{
          name = "dasl-band-{band}";
          buildInputs = [ pkgs.lean4 ];
          shellHook = ''
            echo "DASL band: {band} — {band_desc}"
            echo "Declarations: $(grep -c '^-- \\[' declarations.lean)"
          '';
        }};
      }});
}}
"#,
            band = band_name,
            band_desc = J_BANDS.iter()
                .find(|(l,_,_,d)| *l == band_name)
                .map(|(_,_,_,d)| *d)
                .unwrap_or("")
        );

        fs::write(flake_dir.join("flake.nix"), &flake_content)?;
        generated += 1;

        println!("  {:<8} -> {}/flake.nix", band_name, flake_dir.display());
    }

    // Write master flake (composes all bands)
    let band_names: Vec<String> = WalkDir::new(&band_dir)
        .min_depth(1).max_depth(1)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_dir())
        .map(|e| e.file_name().to_string_lossy().to_string())
        .collect();

    let bands_json = band_names.iter()
        .map(|b| format!("        \"{}\" = \"git+file://${{band_dir}}/{}\";", b, b))
        .collect::<Vec<_>>()
        .join("\n");

    let master_flake = format!(
        r#"{{
  description = "DASL J-invariant band lattice — master flake";
  inputs = {{
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git";
    flake-utils.url = "git+file:///mnt/data1/git/github.com/numtide/flake-utils.git";
  }};
  outputs = {{ self, nixpkgs, flake-utils }}:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${{system}}; in {{
        devShells.default = pkgs.mkShell {{
          name = "dasl-bands";
          buildInputs = [ pkgs.lean4 ];
          shellHook = ''
            echo "DASL J-invariant bands: {total_bands} bands, {total_decls} declarations"
            for band in {bands}; do
              echo "  $band"
            done
          '';
        }};
      }});
}}
"#,
        total_bands = band_names.len(),
        total_decls = "see band-index.json",
        bands = band_names.join(" "),
    );

    fs::write(output_dir.join("flake.nix"), &master_flake)?;

    println!("Flake generation complete: {} band flakes + 1 master",
        generated);
    println!("  Output: {}", output_dir.display());

    info!(generated, "Gen-flake complete");
    Ok(())
}

// ── Dependency Graph ────────────────────────────────────────────────────

#[instrument(skip(input_dir, output_dir))]
pub fn cmd_dep_graph(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let config = super::load_config()?;
    let input_dir = input_dir.unwrap_or_else(|| config.base_dir.join("consolidated"));
    let output_dir = output_dir.unwrap_or_else(|| config.base_dir.join("dep-graph"));
    fs::create_dir_all(&output_dir)?;

    // Load consolidated manifest
    let mut manifest_path = None;
    for entry in WalkDir::new(&input_dir).max_depth(2).into_iter().filter_map(|e| e.ok()) {
        if entry.file_name() == "manifest.json" || entry.path().to_string_lossy().ends_with("_manifest.json") {
            manifest_path = Some(entry.path().to_path_buf());
            break;
        }
    }
    let manifest_path = manifest_path
        .ok_or_else(|| anyhow::anyhow!("No manifest.json found in {}. Run consolidate first.", input_dir.display()))?;

    let manifest: serde_json::Value = serde_json::from_str(&fs::read_to_string(&manifest_path)?)?;
    let decls = manifest["declarations"].as_array()
        .context("No declarations in manifest")?;

    // Build adjacency list
    let mut adj: HashMap<String, Vec<String>> = HashMap::new();
    let mut in_degree: HashMap<String, usize> = HashMap::new();
    let mut all_names: HashSet<String> = HashSet::new();

    for d in decls {
        let name = d["name"].as_str().unwrap_or("").to_string();
        if name.is_empty() { continue; }
        all_names.insert(name.clone());
        adj.entry(name.clone()).or_default();
        in_degree.entry(name.clone()).or_insert(0);

        if let Some(deps) = d["dependencies"].as_array() {
            for dep in deps {
                let dep_name = dep.as_str().unwrap_or("").to_string();
                if dep_name.is_empty() { continue; }
                adj.entry(name.clone()).or_default().push(dep_name.clone());
                *in_degree.entry(dep_name.clone()).or_insert(0) += 1;
                all_names.insert(dep_name.clone());
                adj.entry(dep_name.clone()).or_default();
                in_degree.entry(dep_name.clone()).or_insert(0);
            }
        }
    }

    // Find roots (no incoming edges) and leaves (no outgoing)
    let roots: Vec<_> = in_degree.iter()
        .filter(|(name, deg)| **deg == 0 && adj.get(*name).map_or(false, |v| !v.is_empty()))
        .map(|(n, _)| n.clone())
        .collect();
    let leaves: Vec<_> = adj.iter()
        .filter(|(_, deps)| deps.is_empty())
        .map(|(n, _)| n.clone())
        .collect();

    // Build edges (deduplicated)
    let mut edges: Vec<serde_json::Value> = Vec::new();
    let mut seen_edges: HashSet<(String, String)> = HashSet::new();
    for (src, deps) in &adj {
        for dst in deps {
            if seen_edges.insert((src.clone(), dst.clone())) {
                edges.push(serde_json::json!({"source": src, "target": dst}));
            }
        }
    }

    // Build nodes
    let nodes: Vec<serde_json::Value> = all_names.iter().map(|n| {
        let deg = adj.get(n).map_or(0, |v| v.len());
        let ideg = in_degree.get(n).copied().unwrap_or(0);
        let is_root = ideg == 0 && deg > 0;
        let is_leaf = deg == 0;
        serde_json::json!({
            "id": n,
            "out_degree": deg,
            "in_degree": ideg,
            "is_root": is_root,
            "is_leaf": is_leaf,
        })
    }).collect();

    let node_count = nodes.len();
    let edge_count = edges.len();
    let root_count = roots.len();
    let leaf_count = leaves.len();

    let graph = serde_json::json!({
        "nodes": nodes,
        "edges": edges,
        "stats": {
            "total_nodes": node_count,
            "total_edges": edge_count,
            "roots": root_count,
            "leaves": leaf_count,
            "density": if node_count > 1 {
                (2.0 * edge_count as f64) / (node_count * (node_count - 1)) as f64
            } else { 0.0 },
        },
        "roots": roots.iter().take(50).collect::<Vec<_>>(),
        "leaves": leaves.iter().take(50).collect::<Vec<_>>(),
    });

    fs::write(output_dir.join("dep-graph.json"), serde_json::to_string_pretty(&graph)?)?;

    println!("Dependency graph built:");
    println!("  Nodes:  {}", node_count);
    println!("  Edges:  {}", edge_count);
    println!("  Roots:  {}", root_count);
    println!("  Leaves: {}", leaf_count);
    println!("  Output: {}", output_dir.join("dep-graph.json").display());

    info!(node_count, edge_count, root_count, leaf_count, "Dep-graph complete");
    Ok(())
}

// ── Mycelium: Categorical Structure ────────────────────────────────────

#[instrument(skip(input_dir, output_dir))]
pub fn cmd_mycelium(input_dir: Option<PathBuf>, output_dir: Option<PathBuf>) -> Result<()> {
    let config = super::load_config()?;
    let input_dir = input_dir.unwrap_or_else(|| config.base_dir.join("dep-graph"));
    let output_dir = output_dir.unwrap_or_else(|| config.base_dir.join("mycelium"));
    fs::create_dir_all(&output_dir)?;

    // Load dependency graph
    let graph_path = input_dir.join("dep-graph.json");
    if !graph_path.exists() {
        return Err(anyhow::anyhow!("dep-graph.json not found. Run 'aristotle-manager dep-graph' first."));
    }
    let graph: serde_json::Value = serde_json::from_str(&fs::read_to_string(&graph_path)?)?;

    let nodes = graph["nodes"].as_array().context("No nodes")?;
    let edges = graph["edges"].as_array().context("No edges")?;

    // Build edge map for quick lookup
    let mut outgoing: HashMap<String, Vec<String>> = HashMap::new();
    let mut incoming: HashMap<String, Vec<String>> = HashMap::new();
    for e in edges {
        let src = e["source"].as_str().unwrap_or("").to_string();
        let tgt = e["target"].as_str().unwrap_or("").to_string();
        outgoing.entry(src.clone()).or_default().push(tgt.clone());
        incoming.entry(tgt).or_default().push(src);
    }

    // ── 0-cells (objects): all nodes ──
    let zero_cells: Vec<_> = nodes.iter()
        .map(|n| (n["id"].as_str().unwrap_or("").to_string(),
                  n["is_root"].as_bool().unwrap_or(false),
                  n["is_leaf"].as_bool().unwrap_or(false)))
        .filter(|(id, _, _)| !id.is_empty())
        .collect();

    // ── 1-cells (morphisms): direct dependency edges ──
    let one_cells: Vec<_> = edges.iter()
        .map(|e| (e["source"].as_str().unwrap_or("").to_string(),
                  e["target"].as_str().unwrap_or("").to_string()))
        .filter(|(s, t)| !s.is_empty() && !t.is_empty())
        .collect();

    // ── 2-cells (hypermorphisms): shared dependency hubs ──
    // Two declarations that both depend on the same third form a 2-cell
    let mut two_cells: Vec<serde_json::Value> = Vec::new();
    let mut seen_pairs: HashSet<(String, String)> = HashSet::new();
    for target in incoming.keys() {
        let sources = &incoming[target];
        for i in 0..sources.len() {
            for j in i+1..sources.len() {
                let pair = if sources[i] < sources[j] {
                    (sources[i].clone(), sources[j].clone())
                } else {
                    (sources[j].clone(), sources[i].clone())
                };
                if seen_pairs.insert(pair.clone()) {
                    two_cells.push(serde_json::json!({
                        "source_1": pair.0,
                        "source_2": pair.1,
                        "target": target,
                        "type": "shared_dependency",
                    }));
                }
            }
        }
    }

    // ── Terminal morphisms: orbifold residues ──
    // (70 mod 71, 9 mod 59, 8 mod 47) — the three Monster primes
    let terminal = serde_json::json!({
        "orbifold_residues": {
            "monster_primes": [47, 59, 71],
            "residue_47": 8,
            "residue_59": 9,
            "residue_71": 70,
        },
        "voa_algebra": {
            "dimensions": [15, 194, 170],
            "description": "VOA-graded algebra dimensions from CDDL step 3",
        },
        "j_invariant": {
            "q_minus_1": 1,
            "q_0": 744,
            "q_1": 196884,
            "q_2": 21493760,
            "q_3": 864299970,
            "monster_relation": "196884 = 196883 + 1 = 47×59×71 + 1",
        },
    });

    // ── Assemble mycelium ──
    let mycelium = serde_json::json!({
        "structure": {
            "0_cells": zero_cells.len(),
            "1_cells": one_cells.len(),
            "2_cells": two_cells.len(),
            "terminal_morphisms": 3,
        },
        "0_cells_sample": zero_cells.iter().take(20).map(|(id, root, leaf)| {
            serde_json::json!({"id": id, "is_root": root, "is_leaf": leaf})
        }).collect::<Vec<_>>(),
        "1_cells_sample": one_cells.iter().take(20).map(|(s, t)| {
            serde_json::json!({"source": s, "target": t})
        }).collect::<Vec<_>>(),
        "2_cells_sample": two_cells.iter().take(20).collect::<Vec<_>>(),
        "2_cells_total": two_cells.len(),
        "terminal": terminal,
    });

    fs::write(output_dir.join("mycelium.json"), serde_json::to_string_pretty(&mycelium)?)?;

    println!("Mycelium categorical structure:");
    println!("  0-cells (objects):           {}", zero_cells.len());
    println!("  1-cells (morphisms):         {}", one_cells.len());
    println!("  2-cells (hypermorphisms):    {}", two_cells.len());
    println!("  Terminal morphisms:          3 (Monster primes 47, 59, 71)");
    println!("  VOA algebra:                 15×194×170");
    println!("  Output: {}", output_dir.join("mycelium.json").display());

    info!(zc = zero_cells.len(), oc = one_cells.len(), tc = two_cells.len(), "Mycelium complete");
    Ok(())
}

// ── Canonical Flake: Split + Mathlib Resolution ───────────────────────

#[instrument(skip(input_dir, output_dir, mathlib_split))]
pub fn cmd_canonical_flake(
    input_dir: PathBuf,
    output_dir: Option<PathBuf>,
    mathlib_split: Option<PathBuf>,
) -> Result<()> {
    let config = super::load_config()?;
    let input_dir = fs::canonicalize(&input_dir)?;
    let output_dir = output_dir
        .unwrap_or_else(|| config.base_dir.join("canonical-flakes"));
    let mathlib_split = mathlib_split
        .unwrap_or_else(|| PathBuf::from("/home/mdupont/projects/lean-split-tool/mathlib-split"))
        .canonicalize()?;

    fs::create_dir_all(&output_dir)?;

    // 1. Collect .lean files (skip .lake build dirs)
    let lean_files: Vec<PathBuf> = WalkDir::new(&input_dir)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
        .filter(|e| !e.path().to_string_lossy().contains(".lake"))
        .map(|e| e.path().to_path_buf())
        .collect();

    let total = lean_files.len();
    info!(total, input = %input_dir.display(), "Found lean files");

    // 2. Build mathlib-split index: module name -> directory path
    let mut mathlib_index: HashMap<String, PathBuf> = HashMap::new();
    for entry in WalkDir::new(&mathlib_split)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_dir())
    {
        let flake = entry.path().join("flake.nix");
        if flake.exists() {
            for file_entry in std::fs::read_dir(entry.path())? {
                let file_entry = file_entry?;
                let path = file_entry.path();
                if path.extension().map_or(false, |e| e == "lean") {
                    let rel = path.strip_prefix(&mathlib_split)?;
                    let mod_name = rel.to_string_lossy()
                        .strip_suffix(".lean")
                        .unwrap_or("")
                        .replace(std::path::MAIN_SEPARATOR, ".");
                    mathlib_index.insert(mod_name, entry.path().to_path_buf());
                }
            }
        }
    }
    info!(indexed = mathlib_index.len(), "Mathlib-split index built");

    // 3. For each .lean file: resolve imports, write flake
    let import_re = Regex::new(r"import\s+Mathlib\.(\S+)")?;
    let mut written = 0u64;
    let mut resolved_total = 0u64;

    for lean_path in &lean_files {
        let rel = lean_path.strip_prefix(&input_dir)?;
        let file_stem = rel.file_stem().unwrap().to_string_lossy().to_string();
        let mod_name = rel.to_string_lossy()
            .strip_suffix(".lean")
            .unwrap_or("")
            .replace(std::path::MAIN_SEPARATOR, ".");
        let out_dir = output_dir
            .join(rel.parent().unwrap_or(Path::new("")))
            .join(&file_stem);
        fs::create_dir_all(&out_dir)?;

        // Copy .lean file
        fs::copy(lean_path, out_dir.join(rel.file_name().unwrap()))?;

        // Parse imports
        let content = fs::read_to_string(lean_path)?;
        let mut resolved: Vec<(String, PathBuf)> = Vec::new();
        for cap in import_re.captures_iter(&content) {
            let imp = cap.get(1).unwrap().as_str();
            if imp.starts_with('"') || imp.starts_with('`') || imp.len() < 3 {
                continue;
            }
            if let Some(canonical) = mathlib_index.get(imp) {
                resolved.push((imp.to_string(), canonical.clone()));
            }
        }
        resolved.sort();
        resolved.dedup_by_key(|(imp, _)| imp.clone());

        // Generate flake.nix
        let mut input_lines = String::new();
        let mut input_names = String::new();
        for (imp_name, canonical_path) in &resolved {
            let safe = imp_name.replace('.', "_").replace('\'', "prime").replace('"', "dq");
            input_lines.push_str(&format!("    {}.url = \"path:{}\";\n", safe, canonical_path.display()));
            input_names.push_str(&format!(", {}", safe));
        }

        let flake = format!(
            r#"{{
  description = "Declaration: {mod}";
  inputs = {{
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
{inputs}
  }};
  outputs = {{ self, nixpkgs, flake-utils{input_names} }}:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${{system}}; in {{
        packages.default = pkgs.stdenv.mkDerivation {{
          pname = "decl-{mod}";
          version = "0.1.0";
          src = ./.;
          phases = [ "unpackPhase" "installPhase" ];
          installPhase = ''
            mkdir -p $out
            cp {lean} $out/
          '';
        }};
      }});
}}
"#,
            mod = mod_name,
            inputs = input_lines,
            input_names = input_names,
            lean = rel.file_name().unwrap().to_string_lossy(),
        );
        fs::write(out_dir.join("flake.nix"), &flake)?;
        written += 1;
        resolved_total += resolved.len() as u64;
    }

    println!("Canonical flakes:");
    println!("  Modules:     {}", written);
    println!("  Resolved:    {} Mathlib imports", resolved_total);
    println!("  Mathlib ref: {}", mathlib_split.display());
    println!("  Output:      {}", output_dir.display());

    info!(written, resolved_total, "Canonical flake generation complete");
    Ok(())
}

// ── Canonical Flake All: Process every downloaded Aristotle project ──

#[instrument(skip(output_dir, mathlib_split))]
pub fn cmd_canonical_flake_all(
    output_dir: Option<PathBuf>,
    mathlib_split: Option<PathBuf>,
) -> Result<()> {
    let config = super::load_config()?;
    let output_base = output_dir
        .unwrap_or_else(|| config.base_dir.join("canonical-flakes"));

    // Find all *_aristotle/ project directories in both locations:
    //   git_base  — older downloads (time-2026 tree)
    //   results_dir — canonical download location
    let mut dirs: Vec<PathBuf> = Vec::new();
    let mut seen = std::collections::HashSet::new();

    for base in [&config.git_base, &config.results_dir] {
        if let Ok(entries) = std::fs::read_dir(base) {
            for entry in entries.filter_map(|e| e.ok()) {
                let path = entry.path();
                if path.is_dir() {
                    if let Some(name) = path.file_name() {
                        let name = name.to_string_lossy();
                        if name.ends_with("_aristotle") && seen.insert(name.to_string()) {
                            dirs.push(path);
                        }
                    }
                }
            }
        }
    }

    let total = dirs.len();
    info!(total, "Found downloaded Aristotle projects");
    println!("Processing {} Aristotle projects...", total);

    let mut succeeded = 0u64;
    let mut total_mods = 0u64;
    let mut total_resolved = 0u64;

    for (i, dir) in dirs.iter().enumerate() {
        let proj_name = dir
            .file_name()
            .unwrap_or_default()
            .to_string_lossy()
            .replace("_aristotle", "");
        let proj_out = output_base.join(&proj_name);

        // Look for the output-final_aristotle subdirectory
        let lean_root = dir.join("output-final_aristotle");
        if !lean_root.exists() {
            debug!(name = %proj_name, "No output-final_aristotle, skipping");
            continue;
        }

        // Check for .lean files
        let has_lean = WalkDir::new(&lean_root)
            .max_depth(3)
            .into_iter()
            .filter_map(|e| e.ok())
            .any(|e| e.path().extension().map_or(false, |ext| ext == "lean"));

        if !has_lean {
            debug!(name = %proj_name, "No .lean files, skipping");
            continue;
        }

        println!("[{}/{}] {} ...", i + 1, total, proj_name);

        match cmd_canonical_flake(
            lean_root.clone(),
            Some(proj_out.clone()),
            mathlib_split.clone(),
        ) {
            Ok(()) => {
                succeeded += 1;
                // Count results from the output directory
                if let Ok(files) = std::fs::read_dir(&proj_out) {
                    let count = files
                        .filter_map(|e| e.ok())
                        .filter(|e| e.path().is_dir())
                        .count() as u64;
                    total_mods += count;
                    // Count resolved imports across all flake.nix files
                    for entry in WalkDir::new(&proj_out)
                        .into_iter()
                        .filter_map(|e| e.ok())
                        .filter(|e| e.file_name() == "flake.nix")
                    {
                        if let Ok(content) = std::fs::read_to_string(entry.path()) {
                            total_resolved += content.matches("path:").count() as u64;
                        }
                    }
                }
            }
            Err(e) => {
                eprintln!("  FAIL {}: {}", proj_name, e);
            }
        }
    }

    println!("\nCanonical Flake All complete:");
    println!("  Projects:   {}/{} succeeded", succeeded, total);
    println!("  Modules:    {}", total_mods);
    println!("  Resolved:   {} Mathlib imports", total_resolved);
    println!("  Output:     {}", output_base.display());

    info!(succeeded, total_mods, total_resolved, "Canonical flake all complete");
    Ok(())
}

// ── Merge Projects: Combine multiple Aristotle projects into one ──────

#[instrument(skip(project_ids, output_dir))]
pub fn cmd_merge_projects(project_ids: &[String], output_dir: PathBuf) -> Result<()> {
    let config = super::load_config()?;
    fs::create_dir_all(&output_dir)?;
    let rp_dir = output_dir.join("RequestProject");
    fs::create_dir_all(&rp_dir)?;

    let mut total = 0u64;
    let mut found = 0u64;

    for pid in project_ids {
        let proj_dir = config
            .results_dir
            .join(format!("{}_aristotle/output-final_aristotle/RequestProject", pid));

        if !proj_dir.exists() {
            warn!(project = %pid, "Project not found, skipping");
            continue;
        }
        found += 1;

        let mut copied = 0u64;
        for entry in WalkDir::new(&proj_dir)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().extension().map_or(false, |ext| ext == "lean"))
        {
            let fname = entry.file_name().to_string_lossy().to_string();
            let dest = rp_dir.join(format!("{}_{}", pid, fname));
            fs::copy(entry.path(), &dest)?;
            copied += 1;
        }
        println!("  {} -> {} files", pid, copied);
        total += copied;
    }

    // Copy lakefile and lean-toolchain from first project
    let first_pid = project_ids.first().map(|s| s.as_str()).unwrap_or("");
    let src_base = config
        .results_dir
        .join(format!("{}_aristotle/output-final_aristotle", first_pid));
    for fname in &["lakefile.toml", "lean-toolchain"] {
        let src = src_base.join(fname);
        if src.exists() {
            fs::copy(&src, output_dir.join(fname))?;
            println!("  Copied {}", fname);
        }
    }

    println!("\nMerge complete:");
    println!("  Projects:  {}/{}", found, project_ids.len());
    println!("  Files:     {}", total);
    println!("  Output:    {}", output_dir.display());

    info!(found, total, "Merge projects complete");
    Ok(())
}
