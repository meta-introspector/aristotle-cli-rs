#!/usr/bin/env python3
"""
Build the canonical DASL Lean module — a subset of mathlib-split declarations
organized by DASL category: ipld, cbor, monster, sheaf, microlean, weaver,
journal, primes, godel.

Usage: python3 build-dasl-module.py [mathlib-split-dir] [output-dir]
"""
import json, re, shutil, sys
from pathlib import Path
from collections import defaultdict

MATHLIB = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('aristotles_results/mathlib-split')
DASL_OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else Path('aristotles_results/dasl-lean')

CATEGORIES = {
    'dasl/ipld': {
        'terms': ['dasl', 'ipld', 'dag.cbor', 'dag_cbor', 'car.file', 'car_file',
                  'content.address', 'content_address', 'multihash', 'cid.v1', 'cid_v1',
                  'merkledag', 'merkle_dag', 'shmem', 'block.store', 'block_store'],
        'desc': 'DASL/IPLD content addressing and storage'
    },
    'dasl/cbor': {
        'terms': ['cbor', 'encode', 'decode', 'codec', 'varint', 'serialize', 'deserialize',
                  'roundtrip', 'round.trip', 'round_trip', 'major', 'bytearray.utf8'],
        'desc': 'CBOR encoding/decoding and codec layer'
    },
    'dasl/monster': {
        'terms': ['monster', 'moonshine', '196883', '196884', 'borcherds',
                  'supersingular', 'ssp', 'sporadic', 'cfsg', 'umbral',
                  'hecke.operator', 'hecke_operator', 'vertex.operator',
                  'vertex_algebra', 'voa', 'clifford', 'leech'],
        'desc': 'Monster group, Moonshine, and related algebra'
    },
    'dasl/sheaf': {
        'terms': ['sheaf', 'presheaf', 'stalk', 'germ', 'sheafification',
                  'cech', 'cohomology', 'topos', 'grothendieck', 'etale',
                  'restriction.map', 'restriction_map', 'gluing', 'descent',
                  'alexandrov', 'nerve', 'site', 'cover'],
        'desc': 'Sheaf theory and cohomology'
    },
    'dasl/microlean': {
        'terms': ['microlean', 'micro.lean', 'micro_lean', 'ffi', 'emitrust',
                  'emitcpp', 'emitjs', 'emitpython', 'emitemoji', 'emitcabi',
                  'isboxed', 'memops', 'ofexpr', 'reify', 'projector',
                  'polyglot', 'boxed', 'unboxed'],
        'desc': 'MicroLean verified polyglot FFI type system'
    },
    'dasl/weaver': {
        'terms': ['aristotleweaver', 'aristotle.weaver', 'simpleexpr', 'boundingbox',
                  'branchgraph', 'nodetobox', 'disjointboxes', 'layoutclean',
                  'sampleconfluence'],
        'desc': 'AristotleWeaver graph layout engine'
    },
    'dasl/journal': {
        'terms': ['merkle', 'journal', 'contentaddress', 'content.address',
                  'bladeaddr', 'cidnat', 'cidhex', 'blockchain', 'genesis'],
        'desc': 'Content-addressed Merkle journals'
    },
    'dasl/primes': {
        'terms': ['prime', 'factor', 'sspprime', 'primes', 'coprime', 'divisor',
                  'valuation', 'padic', 'p_adic', 'factorization', 'gcd', 'lcm'],
        'desc': 'Prime theory and factorization'
    },
    'dasl/godel': {
        'terms': ['godel', 'goedel', 'quine', 'self.apply', 'self_apply',
                  'reflect', 'introspection', 'metameme', 'rewrite', 'meta.reflective'],
        'desc': 'Godel numbering, reflection, and self-reference'
    },
}

def main():
    print(f"=== Building Canonical DASL Lean Module ===")
    print(f"Source: {MATHLIB}")
    print(f"Output: {DASL_OUT}\n")

    dasl_decls = defaultdict(list)

    for lean_file in sorted(MATHLIB.glob('Split/**/*.lean')):
        if '.git' in str(lean_file):
            continue
        decl_name = lean_file.stem
        try:
            content = lean_file.read_text(encoding='utf-8', errors='ignore').lower()
        except Exception:
            continue

        for cat, info in CATEGORIES.items():
            for term in info['terms']:
                pattern = term.replace('.', r'[._]?')
                if re.search(pattern, content):
                    dasl_decls[cat].append((decl_name, lean_file))
                    break

    DASL_OUT.mkdir(parents=True, exist_ok=True)
    total = 0

    for cat, info in CATEGORIES.items():
        decls = dasl_decls.get(cat, [])
        if not decls:
            continue

        cat_dir = DASL_OUT / cat
        cat_dir.mkdir(parents=True, exist_ok=True)
        unique = sorted(set(name for name, _ in decls))
        total += len(unique)

        for name, src in decls:
            dest = cat_dir / src.relative_to(MATHLIB)
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dest)

        print(f"  {cat:25s}  {len(unique):>4d} decls  — {info['desc']}")

    # Copy flake.nix files
    flakes = 0
    for lean_file in DASL_OUT.rglob('*.lean'):
        rel = lean_file.relative_to(DASL_OUT)
        flake_src = MATHLIB / rel.parent / 'flake.nix'
        flake_dst = lean_file.parent / 'flake.nix'
        if flake_src.exists() and not flake_dst.exists():
            shutil.copy2(flake_src, flake_dst)
            flakes += 1

    # Copy DAG and lakefile
    for f in MATHLIB.glob('dag.json'):
        shutil.copy2(f, DASL_OUT / 'dag.json')
    for f in MATHLIB.glob('lakefile.toml'):
        shutil.copy2(f, DASL_OUT / 'lakefile.toml')

    # Manifest
    manifest = {
        'name': 'dasl-lean',
        'description': 'Canonical DASL formalization subset from Aristotle projects',
        'total_declarations': total,
        'flakes': flakes,
        'categories': {
            cat: {
                'description': info['desc'],
                'count': len(set(n for n, _ in dasl_decls.get(cat, []))),
                'declarations': sorted(set(n for n, _ in dasl_decls.get(cat, [])))
            }
            for cat, info in CATEGORIES.items() if dasl_decls.get(cat)
        }
    }
    (DASL_OUT / 'dasl-manifest.json').write_text(json.dumps(manifest, indent=2))

    size = sum(f.stat().st_size for f in DASL_OUT.rglob('*') if f.is_file())
    print(f"\n=== Done ===")
    print(f"  {total} declarations, {flakes} flakes, {size/1024:.0f} KB")
    print(f"  {DASL_OUT}/dasl-manifest.json")

if __name__ == '__main__':
    main()
