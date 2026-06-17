#!/usr/bin/env python3
"""Deduplicate and fix flake.nix paths for unified mathlib-split."""
import os, sys, json, shutil, re
from pathlib import Path

SPLIT_DIR = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("aristotles_results/split-results")
OUT_DIR = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("aristotles_results/mathlib-split")

print(f"=== Deduplicating & fixing paths: {SPLIT_DIR} -> {OUT_DIR} ===")

if OUT_DIR.exists():
    shutil.rmtree(OUT_DIR)
OUT_DIR.mkdir(parents=True, exist_ok=True)

seen = {}  # decl_path -> source_project
total = 0

# Step 1: Copy unique .lean files
for lean_file in sorted(SPLIT_DIR.glob("**/Split/**/*.lean")):
    parts = lean_file.relative_to(SPLIT_DIR).parts
    proj_name = parts[0]
    decl_path = lean_file.relative_to(SPLIT_DIR / proj_name)
    total += 1
    
    if str(decl_path) not in seen:
        seen[str(decl_path)] = proj_name
        target = OUT_DIR / decl_path
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(lean_file, target)

uniq = len(seen)
print(f"  .lean files: {total} total -> {uniq} unique")

# Step 2: Copy and fix flake.nix files with relative paths
flake_count = 0
for flake_file in sorted(SPLIT_DIR.glob("**/flake.nix")):
    parts = flake_file.relative_to(SPLIT_DIR).parts
    proj_name = parts[0]
    decl_subpath = flake_file.relative_to(SPLIT_DIR / proj_name)
    decl_dir = str(decl_subpath.parent)
    
    target = OUT_DIR / decl_subpath
    if target.exists():
        continue  # already copied from a previous project
    
    # Read and fix paths
    content = flake_file.read_text()
    
    # Replace absolute project paths with relative paths within mathlib-split
    # Pattern: path:/absolute/path/to/split-results/PROJECT/Declaration
    def fix_path(m):
        full = m.group(0)
        decl = m.group(1).strip()
        # Convert to relative path within mathlib-split
        rel = os.path.relpath(str(OUT_DIR / decl), str(target.parent))
        return f'{decl}.url = "path:{rel}"'
    
    content = re.sub(
        r'(\S+)\.url = "path:.*?/split-results/[^/]+/(\S+)"',
        lambda m: f'{m.group(1)}.url = "path:{os.path.relpath(str(OUT_DIR / m.group(2)), str(target.parent))}"',
        content
    )
    
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(content)
    flake_count += 1

print(f"  flake.nix files: {flake_count} (paths fixed to relative)")

# Step 3: Merge dag.json
merged_dag = {}
for dag_file in SPLIT_DIR.glob("*/dag.json"):
    try:
        dag = json.loads(dag_file.read_text())
        for k, v in dag.items():
            if k not in merged_dag:
                merged_dag[k] = v
    except Exception:
        pass

(OUT_DIR / "dag.json").write_text(json.dumps(merged_dag, indent=2))
print(f"  dag.json: {len(merged_dag)} nodes")

# Step 4: Copy lakefile
for lf in SPLIT_DIR.glob("*/lakefile.toml"):
    shutil.copy2(lf, OUT_DIR / "lakefile.toml")
    break

size = sum(f.stat().st_size for f in OUT_DIR.rglob("*") if f.is_file())
print(f"\n=== Done: {OUT_DIR} ===")
print(f"  Size: {size / 1024 / 1024:.1f} MB")
print(f"  {uniq} unique declarations, {flake_count} flakes")

# Show a sample fixed flake
sample = next(OUT_DIR.glob("**/flake.nix"), None)
if sample:
    lines = sample.read_text().split("\n")
    # Find path lines
    path_lines = [l for l in lines if "url =" in l]
    print(f"\n  Sample: {sample.relative_to(OUT_DIR)}")
    for l in path_lines[:5]:
        print(f"    {l.strip()}")
