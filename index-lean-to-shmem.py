#!/usr/bin/env python3
"""
index-lean-to-shmem.py — Extract declarations from split Lean projects,
load into lean4-repl, and build a token-based inverted index.

Pipeline:
  1. Read lean-493k-topo.json → find Aristotle split directories
  2. Run staticsplitjson on each .lean file → JSON declarations
  3. Push each declaration to lean4-repl :8156/put
  4. Extract tokens from each declaration → build inverted index
  5. Compute CIDs and cross-reference with @ipld_car_shmem
  6. Write token_index.json for fast keyword lookup

Usage: python3 index-lean-to-shmem.py [--dry-run] [--limit N]
"""
import json, os, sys, re, subprocess
from pathlib import Path
from datetime import datetime
from collections import defaultdict

# Config
REPL = os.environ.get('LEAN4_REPL', 'http://localhost:8156')
TOPO = Path('/home/mdupont/dasl-planning/data/topology/lean-493k-topo.json')
STATICSPLITJSON = '/nix/store/hagadmgn61fhbxdq2md6p1jjb5plb52v-staticsplitjson/bin/staticsplitjson'
DRY_RUN = '--dry-run' in sys.argv
LIMIT = None
for i, a in enumerate(sys.argv):
    if a == '--limit' and i+1 < len(sys.argv):
        LIMIT = int(sys.argv[i+1])

OUTPUT = Path('/home/mdupont/dasl-planning/data/token_index.json')

# Priority split directories (deduplicated)
PRIORITY_DIRS = [
    # UnifiedIPLDMemory — the IPLD spec formalized
    '/mnt/data1/aristotle_results2/split-results-kernel/UnifiedIPLDMemory/Split',
    # fa51bcab — splitter engine, 2790 declarations
    '/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Split',
    # mathlib-split — 5305 declarations
    '/mnt/data1/aristotle_results2/mathlib-split/Split',
    # FractranCRTMerger — 2019 declarations
    '/mnt/data1/aristotle_results2/split-results-kernel/FractranCRTMerger/Split',
    # QExpansionSampler — 1845 declarations
    '/mnt/data1/aristotle_results2/split-results-kernel/QExpansionSampler/Split',
    # UmweltGodelTrust — 1706 declarations
    '/mnt/data1/aristotle_results2/split-results-kernel/UmweltGodelTrust/Split',
]

def extract_tokens(name, kind, full_text=''):
    """Extract searchable tokens from a declaration."""
    tokens = set()
    # Always index the name
    tokens.add(name)
    # Split CamelCase
    for part in re.findall(r'[A-Z][a-z]+|[A-Z]+(?=[A-Z]|$)', name):
        tokens.add(part.lower())
    # Kind token
    tokens.add(f'kind:{kind}')
    # Sub-word tokens
    for word in name.replace('_', ' ').replace('.', ' ').split():
        word = word.lower().strip('()[]{}')
        if len(word) >= 2:
            tokens.add(word)
    return sorted(tokens)


def load_declarations(split_dir, limit=None):
    """Run staticsplitjson on a split directory and yield declarations."""
    import requests
    
    # Find all .lean files in the split directory
    split_path = Path(split_dir)
    if not split_path.exists():
        print(f'  ⚠ {split_dir} does not exist, skipping')
        return 0
    
    lean_files = list(split_path.glob('*.lean'))
    if not lean_files:
        # Try subdirectories
        lean_files = list(split_path.glob('*/*.lean'))
    if not lean_files:
        lean_files = list(split_path.glob('**/*.lean'))[:100]
    
    if limit:
        lean_files = lean_files[:limit]
    
    loaded = 0
    errors = 0
    for lf in lean_files:
        try:
            result = subprocess.run(
                [STATICSPLITJSON, '--file', str(lf)],
                capture_output=True, text=True, timeout=10
            )
            if result.returncode != 0:
                errors += 1
                continue
            
            for line in result.stdout.strip().split('\n'):
                line = line.strip()
                if not line:
                    continue
                decl = json.loads(line)
                # Push to REPL
                if not DRY_RUN:
                    resp = requests.post(f'{REPL}/put', json=decl, timeout=5)
                    if resp.status_code != 200:
                        errors += 1
                        continue
                loaded += 1
                
        except Exception as e:
            errors += 1
    
    print(f'  {split_dir}: {loaded} loaded, {errors} errors ({len(lean_files)} files)')
    return loaded


def build_token_index(split_dir, index, limit=None):
    """Build inverted token index from declarations in a split dir."""
    split_path = Path(split_dir)
    if not split_path.exists():
        return 0
    
    lean_files = list(split_path.glob('*.lean'))
    if not lean_files:
        lean_files = list(split_path.glob('*/*.lean'))
    if not lean_files:
        lean_files = list(split_path.glob('**/*.lean'))[:100]
    
    if limit:
        lean_files = lean_files[:limit]
    
    indexed = 0
    for lf in lean_files:
        try:
            result = subprocess.run(
                [STATICSPLITJSON, '--file', str(lf)],
                capture_output=True, text=True, timeout=10
            )
            if result.returncode != 0:
                continue
            
            for line in result.stdout.strip().split('\n'):
                line = line.strip()
                if not line:
                    continue
                decl = json.loads(line)
                name = decl.get('name', '')
                kind = decl.get('kind', '?')
                tokens = extract_tokens(name, kind)
                
                for token in tokens:
                    index[token].append({
                        'name': name,
                        'kind': kind,
                        'file': str(lf),
                        'split_dir': split_dir,
                    })
                indexed += 1
        except Exception:
            pass
    
    return indexed


def main():
    print(f'=== Lean Declaration Indexer ===')
    print(f'  REPL: {REPL}')
    print(f'  Topology: {TOPO}')
    print(f'  Mode: {"DRY RUN" if DRY_RUN else "LIVE"}')
    print()
    
    # ── Phase 1: Build token index ──
    print('[1/3] Building token index from priority projects...')
    token_index = defaultdict(list)
    total = 0
    
    for d in PRIORITY_DIRS:
        n = build_token_index(d, token_index, limit=LIMIT)
        total += n
        print(f'  {Path(d).name}: {n} indexed')
    
    print(f'\n  Total indexed: {total} declarations')
    print(f'  Unique tokens: {len(token_index)}')
    
    # Show top tokens
    top_tokens = sorted(token_index.items(), key=lambda x: len(x[1]), reverse=True)[:15]
    print(f'\n  Top tokens:')
    for token, decls in top_tokens:
        print(f'    {token}: {len(decls)} declarations')
    
    # Write token index
    index_out = {
        'indexed_at': datetime.now().isoformat(),
        'total_declarations': total,
        'unique_tokens': len(token_index),
        'tokens': dict(token_index)
    }
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(index_out, indent=2))
    print(f'\n  Token index: {OUTPUT} ({OUTPUT.stat().st_size} bytes)')
    
    # ── Phase 2: Load into REPL ──
    print(f'\n[2/3] Loading declarations into REPL...')
    repl_total = 0
    for d in PRIORITY_DIRS:
        n = load_declarations(d, limit=LIMIT)
        repl_total += n
    
    print(f'\n  REPL loaded: {repl_total} new declarations')
    
    # ── Phase 3: Verify ──
    print(f'\n[3/3] Verifying...')
    import requests
    try:
        health = requests.get(f'{REPL}/health', timeout=3)
        if health.status_code == 200:
            data = health.json()
            print(f'  REPL declarations: {data.get("declarations", "?")}')
            print(f'  REPL files: {data.get("files", "?")}')
    except Exception as e:
        print(f'  ⚠ REPL check failed: {e}')
    
    print(f'\n=== Done: {total} indexed, {repl_total} in REPL ===')


if __name__ == '__main__':
    main()
