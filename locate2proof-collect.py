#!/usr/bin/env python3
"""
Collect DASL locate results, deduplicate, and prepare for locate2proof.
"""
import subprocess, os, sys
from pathlib import Path
from collections import defaultdict

OUT_DIR = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/tmp/locate2proof")

# Terms to search
TERMS = [
    "monster", "cbor", "hecke", "dasl", "DA51", "ipld",
    "clifford", "vertex", "conformal", "borcherds", "moonshine",
    "encode", "decode", "sheaf", "topos", "fractran"
]

# Filter patterns
IGNORE = ['.lake', '.git', 'lake-packages', 'node_modules', 'target/debug', 'target/release']

print("=== locate2proof — DASL term collector ===")
all_files = set()

for term in TERMS:
    try:
        result = subprocess.run(
            ['locate', term],
            capture_output=True, text=True, timeout=10
        )
        files = [
            f for f in result.stdout.splitlines()
            if f.endswith('.lean') and not any(p in f for p in IGNORE)
        ]
        all_files.update(files)
        print(f"  {term:15s}: {len(files):>5d} files")
    except subprocess.TimeoutExpired:
        print(f"  {term:15s}: timeout")
    except FileNotFoundError:
        print(f"  locate not found — using pre-collected data")
        break

print(f"\n  Total unique: {len(all_files)}")

# Group by source
sources = defaultdict(list)
for f in sorted(all_files):
    if 'DA51' in f:
        sources['DA51 (CBOR/Monster core)'].append(f)
    elif 'fractran-vm' in f:
        sources['fractran-vm (shards)'].append(f)
    elif 'experiments/qbert' in f:
        sources['qbert/oracle'].append(f)
    elif 'projects/monster' in f:
        sources['monster-osm'].append(f)
    elif 'projects/lean-split-tool' in f:
        sources['lean-split-tool'].append(f)
    elif 'zkperf' in f:
        sources['zkperf'].append(f)
    elif 'meta-introspector' in f:
        sources['meta-introspector'].append(f)
    else:
        sources['other'].append(f)

print("\n=== By source ===")
for src, files in sorted(sources.items(), key=lambda x: -len(x[1])):
    print(f"  {src}: {len(files)} files")
    if len(files) <= 10:
        for f in files:
            print(f"    {Path(f).name}")

# Save results
OUT_DIR.mkdir(parents=True, exist_ok=True)
(OUT_DIR / "dasl-lean-files.txt").write_text('\n'.join(sorted(all_files)) + '\n')

# Save per-category
for src, files in sources.items():
    safe = src.replace('/', '-').replace(' ', '_')
    (OUT_DIR / f"locate-{safe}.txt").write_text('\n'.join(files) + '\n')

# Update locate2proof config
config = {
    "inputDir": str(OUT_DIR),
    "outputDir": "/mnt/data1/time-2026/05-may/07/arist/locate2proof-output",
    "modules": [
        "DA51.CborVal", "DA51.Encode", "DA51.Decode", "DA51.Monster",
        "DA51.Hecke", "DA51.Vertex", "DA51.HVertex", "DA51.Borcherds",
        "DA51.Conformal", "DA51.Reflect", "DA51.SelfApply", "DA51.Exec",
        "DA51.Ternary", "DA51.Bivector", "DA51.CubicalKernel"
    ],
    "baseModule": "DA51",
    "locateResultsFile": str(OUT_DIR / "dasl-lean-files.txt")
}

import json
(OUT_DIR / "locate2proof-config.json").write_text(json.dumps(config, indent=2))

print(f"\n=== Output ===")
print(f"  {OUT_DIR}/dasl-lean-files.txt      — {len(all_files)} unique .lean files")
print(f"  {OUT_DIR}/locate2proof-config.json — Updated config for locate2proof")
print(f"  {OUT_DIR}/locate-*.txt             — Per-category file lists")
