#!/usr/bin/env python3
"""
Build the unified DASL Lean project from the canonical dasl-lean module.
Creates a proper lake project with module structure, lakefile.toml,
lean-toolchain, and per-declaration .lean files organized by category.

Usage: python3 build-unified-dasl.py [dasl-lean-dir] [output-dir]
"""
import json, shutil, sys
from pathlib import Path
from collections import defaultdict

DASL_LEAN = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('aristotles_results/dasl-lean')
UNIFIED = Path(sys.argv[2]) if len(sys.argv) > 2 else Path('aristotles_results/unified-dasl')

MANIFEST_FILE = DASL_LEAN / 'dasl-manifest.json'

print(f"=== Building Unified DASL Project ===")
print(f"Source: {DASL_LEAN}")
print(f"Output: {UNIFIED}\n")

# Load manifest
if MANIFEST_FILE.exists():
    with open(MANIFEST_FILE) as f:
        manifest = json.load(f)
else:
    print("No manifest found, scanning directory...")
    manifest = {'categories': {}}
    for cat_dir in sorted(DASL_LEAN.glob('dasl/*')):
        cat = cat_dir.relative_to(DASL_LEAN)
        decls = sorted(f.stem for f in cat_dir.rglob('*.lean'))
        manifest['categories'][str(cat)] = {'declarations': decls, 'count': len(decls)}

UNIFIED.mkdir(parents=True, exist_ok=True)

# ── 1. Create module structure ──────────────────────────────────
# Unified module layout:
#   UnifiedDasl/
#     Ipld/        — content addressing
#     Cbor/        — encoding/decoding
#     Monster/     — group theory
#     Sheaf/       — sheaf theory
#     MicroLean/   — polyglot FFI
#     Weaver/      — graph layout
#     Journal/     — Merkle journals
#     Primes/      — factorization
#     Godel/       — self-reference

CAT_MAP = {
    'dasl/ipld': 'UnifiedDasl/Ipld',
    'dasl/cbor': 'UnifiedDasl/Cbor',
    'dasl/monster': 'UnifiedDasl/Monster',
    'dasl/sheaf': 'UnifiedDasl/Sheaf',
    'dasl/microlean': 'UnifiedDasl/MicroLean',
    'dasl/weaver': 'UnifiedDasl/Weaver',
    'dasl/journal': 'UnifiedDasl/Journal',
    'dasl/primes': 'UnifiedDasl/Primes',
    'dasl/godel': 'UnifiedDasl/Godel',
}

# ── 2. Copy declarations ─────────────────────────────────────────
total_files = 0

for src_cat, dst_cat in CAT_MAP.items():
    src_dir = DASL_LEAN / src_cat
    if not src_dir.is_dir():
        continue
    
    dst_dir = UNIFIED / dst_cat
    dst_dir.mkdir(parents=True, exist_ok=True)
    
    cat_files = 0
    for lean_file in sorted(src_dir.rglob('*.lean')):
        # Read content
        content = lean_file.read_text(encoding='utf-8', errors='ignore')
        
        # Write to unified directory (flatten: just the file name)
        dest = dst_dir / lean_file.name
        dest.write_text(content)
        cat_files += 1
    
    total_files += cat_files
    cat_name = dst_cat.split('/')[-1]
    print(f"  {cat_name:15s}  {cat_files:>4d} files  →  {dst_cat}")

print(f"\n  Total: {total_files} declarations")

# ── 3. Create lakefile.toml ─────────────────────────────────────
lakefile = '''name = "unified-dasl"
version = "0.1.0"
defaultTargets = ["UnifiedDasl"]

[[require]]
name = "mathlib"
git = "https://github.com/leanprover-community/mathlib4.git"
rev = "v4.28.0"

[[lean_lib]]
name = "UnifiedDasl"
globs = ["UnifiedDasl.+", "UnifiedDasl.*.+"]
'''

(UNIFIED / 'lakefile.toml').write_text(lakefile)

# ── 4. Create lean-toolchain ────────────────────────────────────
toolchain = DASL_LEAN.parent / 'mathlib-split'  
# Try to find lean-toolchain from splitter-engine
tc = Path('splitter-engine/lean-toolchain')
if tc.exists():
    shutil.copy2(tc, UNIFIED / 'lean-toolchain')
else:
    (UNIFIED / 'lean-toolchain').write_text('leanprover/lean4:v4.28.0\n')

# ── 5. Create README ────────────────────────────────────────────
readme = f'''# Unified DASL — Canonical Formalization Module

## Structure

{chr(10).join(f"  {dst.split('/')[-1]:15s} — {src}" for src, dst in CAT_MAP.items() if (DASL_LEAN / src).is_dir())}

## Statistics

  Total declarations: {total_files}
  Categories: {sum(1 for src in CAT_MAP if (DASL_LEAN / src).is_dir())}
  Source: {len(manifest.get('categories', {}))} DASL categories from mathlib-split

## Build

```bash
cd unified-dasl
lake build
```

## Mathematical Core

  j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + O(q⁴)
  Monster: 196883 = 47 × 59 × 71
  SSP basis: [2,3,5,7,11,13,17,19,23,29,31,41,47,59,71]
'''

(UNIFIED / 'README.md').write_text(readme)

# ── 6. Summary ──────────────────────────────────────────────────
size = sum(f.stat().st_size for f in UNIFIED.rglob('*') if f.is_file())
print(f"\n=== Unified DASL Project ===")
print(f"  {UNIFIED}/")
print(f"  {total_files} declarations")
print(f"  {size/1024:.0f} KB")
print(f"  lakefile.toml, lean-toolchain, README.md")
print(f"\n  To build: cd {UNIFIED} && lake build")
