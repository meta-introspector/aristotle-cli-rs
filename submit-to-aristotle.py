#!/usr/bin/env python3
"""
Submit unified DASL project to Aristotle API as new project input.
Chunks the 751 declarations into manageable prompts and submits them.

Usage: python3 submit-to-aristotle.py [--dry-run] [--chunk-size 50]
"""
import json, sys, os
from pathlib import Path
from collections import defaultdict

UNIFIED = Path('aristotles_results/unified-dasl')
API_KEY = os.environ.get('ARISTOTLE_API_KEY', '')
DRY_RUN = '--dry-run' in sys.argv
CHUNK_SIZE = 50
for i, a in enumerate(sys.argv):
    if a == '--chunk-size' and i+1 < len(sys.argv):
        CHUNK_SIZE = int(sys.argv[i+1])

if not API_KEY and not DRY_RUN:
    print("ERROR: Set ARISTOTLE_API_KEY environment variable")
    sys.exit(1)

# Load declarations by category
categories = {}
for cat_dir in sorted(UNIFIED.glob('UnifiedDasl/*')):
    cat = cat_dir.name
    files = sorted(f.name for f in cat_dir.glob('*.lean'))
    if files:
        categories[cat] = files

print(f"=== Aristotle Submission: Unified DASL ===\n")
print(f"Categories: {len(categories)}")
print(f"Total declarations: {sum(len(f) for f in categories.values())}")
print(f"Chunk size: {CHUNK_SIZE}")

# Build submission chunks
chunks = []
all_decls = []
for cat, files in categories.items():
    for f in files:
        all_decls.append((cat, f))

for i in range(0, len(all_decls), CHUNK_SIZE):
    chunk = all_decls[i:i+CHUNK_SIZE]
    chunks.append(chunk)

print(f"Chunks: {len(chunks)}")

# Build prompts
for ci, chunk in enumerate(chunks):
    # Group by category
    by_cat = defaultdict(list)
    for cat, decl in chunk:
        by_cat[cat].append(decl)
    
    cat_summary = '\n'.join(
        f"## {cat} ({len(decls)} declarations)\n" +
        '\n'.join(f"  - {d.replace('.lean', '')}" for d in decls[:20]) +
        (f"\n  ... +{len(decls)-20} more" if len(decls) > 20 else "")
        for cat, decls in sorted(by_cat.items())
    )
    
    prompt = f"""# Unified DASL Formalization — Chunk {ci+1}/{len(chunks)}

## Context

This is part of the Unified DASL project — a canonical formalization combining
the DASL/IPLD/CBOR mathematical ecosystem into a single Lean4 project.

## Mathematical Foundation

The j-invariant q-expansion provides the natural periodic table:
  j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + O(q⁴)

Monster group: 196883 = 47 × 59 × 71 (minimal non-trivial irrep)
SSP basis: Cl(15,0,0) = [2,3,5,7,11,13,17,19,23,29,31,41,47,59,71]

## Declarations to Formalize ({len(chunk)} items)

{cat_summary}

## Task

For each declaration above:
1. Write a complete Lean4 formalization with full proofs
2. Connect to existing mathlib theorems where possible  
3. Ensure all proofs are sorry-free and kernel-checked
4. Add proper imports and module structure
5. Place in RequestProject/ module for Aristotle submission

## Architecture

These declarations form a commutative sheaf:
  - Ipld: content addressing layer (CID, multihash, Merkle DAG)
  - Cbor: encoding/decoding layer (codec, round-trip)
  - Monster: group theory (Hecke operators, vertex algebras, moonshine)
  - Sheaf: gluing layer (Čech cohomology, restriction maps)
  - MicroLean: type system (polyglot FFI: Rust/C++/JS/Python/CABI)
  - Weaver: visualization (graph layout, bounding boxes)
  - Journal: persistence (Merkle chains, content-addressed blocks)
  - Primes: arithmetic (SSP factorization, valuations)
  - Godel: meta-layer (self-reference, reflection, quines)
"""

    chunk_file = Path(f'aristotles_results/aristotle-chunks/unified-dasl-{ci+1:03d}.txt')
    chunk_file.parent.mkdir(parents=True, exist_ok=True)
    chunk_file.write_text(prompt)
    
    print(f"  Chunk {ci+1:03d}: {len(chunk)} decls, {len(prompt)} chars → {chunk_file.name}")

print(f"\n=== {'DRY RUN' if DRY_RUN else 'Ready to submit'} ===")
print(f"  {len(chunks)} chunks in aristotles_results/aristotle-chunks/")
print(f"  Total: {sum(len(c) for c in chunks)} declarations")

if not DRY_RUN:
    print(f"\n  To submit, use the Aristotle CLI or API with each chunk file.")
    print(f"  API endpoint: https://aristotle.harmonic.fun/api/v3/project")
    print(f"  Method: POST with multipart form data")
    print(f"  Field 'input': contents of each chunk file")
