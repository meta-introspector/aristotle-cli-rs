#!/usr/bin/env python3
"""
push-decls-to-repl.py — Run staticsplitjson on source Lean projects,
push declarations to lean4-repl, and build token→CID inverted index.

Usage: python3 push-decls-to-repl.py [--dry-run]
"""
import json, os, sys, re, subprocess, requests
from pathlib import Path
from datetime import datetime
from collections import defaultdict

REPL = os.environ.get('LEAN4_REPL', 'http://localhost:8156')
S = '/nix/store/hagadmgn61fhbxdq2md6p1jjb5plb52v-staticsplitjson/bin/staticsplitjson'
DRY_RUN = '--dry-run' in sys.argv

SOURCES = [
    ('fa51bcab', '/mnt/data1/time-2026/05-may/07/arist/aristotles_results/fa51bcab*/output-final_aristotle/RequestProject/'),
    ('cb4f0854', '/mnt/data1/time-2026/05-may/07/arist/aristotles_results/cb4f0854*/output-final_aristotle/RequestProject/Compute/IPLD/'),
    ('1233bb96', '/mnt/data1/aristotle-results/aristo-outputs/1233bb96*/output-final_aristotle/RequestProject/'),
    ('899e7815', '/mnt/data1/aristotle-results/aristo-outputs/899e7815*/output-final_aristotle/RequestProject/'),
    ('e0147fc6', '/mnt/data1/aristotle-results/aristo-outputs/e0147fc6*/output-final_aristotle/RequestProject/'),
]

def extract_tokens(name, kind):
    tokens = set()
    tokens.add(name.lower())
    tokens.add(f'kind:{kind}')
    for part in re.findall(r'[A-Z][a-z]+|[A-Z]{2,}', name):
        tokens.add(part.lower())
    for word in name.replace('_', ' ').replace('.', ' ').split():
        w = word.lower().strip("()[]{}'")
        if len(w) >= 2:
            tokens.add(w)
    return sorted(tokens)

def main():
    print(f'=== Push Declarations to REPL ===')
    print(f'  REPL: {REPL}  Dry: {DRY_RUN}')
    
    total = 0
    errors = 0
    token_idx = defaultdict(list)
    
    for proj_name, proj_path in SOURCES:
        # Resolve glob
        import glob as g
        matches = sorted(g.glob(proj_path))
        if not matches:
            print(f'  ⚠ {proj_name}: not found ({proj_path})')
            continue
        real_path = matches[0]
        
        print(f'\n[{proj_name}] {real_path}')
        
        try:
            result = subprocess.run([S, '--dir', real_path],
                                    capture_output=True, text=True, timeout=120)
            if result.returncode != 0:
                print(f'  ⚠ staticsplitjson failed')
                continue
            
            count = 0
            for line in result.stdout.strip().split('\n'):
                line = line.strip()
                if not line:
                    continue
                try:
                    decl = json.loads(line)
                except json.JSONDecodeError:
                    continue
                
                name = decl.get('name', '?')
                kind = decl.get('kind', '?')
                
                # Build token index
                tokens = extract_tokens(name, kind)
                for t in tokens:
                    token_idx[t].append({'name': name, 'kind': kind, 'project': proj_name})
                
                # Push to REPL
                if not DRY_RUN:
                    try:
                        resp = requests.post(f'{REPL}/put', json=decl, timeout=10)
                        if resp.status_code == 200:
                            count += 1
                        else:
                            errors += 1
                    except Exception as e:
                        errors += 1
                else:
                    count += 1
            
            print(f'  {count} declarations loaded')
            total += count
            
        except Exception as e:
            print(f'  ⚠ Error: {e}')
    
    # Write token index
    out = {
        'indexed_at': datetime.now().isoformat(),
        'total_declarations': total,
        'unique_tokens': len(token_idx),
        'tokens': {k: v for k, v in token_idx.items()}
    }
    idx_path = Path('/home/mdupont/dasl-planning/data/token_index.json')
    idx_path.parent.mkdir(parents=True, exist_ok=True)
    idx_path.write_text(json.dumps(out, indent=2))
    print(f'\nToken index: {idx_path} ({idx_path.stat().st_size} bytes)')
    
    # Top tokens
    top = sorted(token_idx.items(), key=lambda x: len(x[1]), reverse=True)[:10]
    print(f'Top tokens:')
    for t, ds in top:
        print(f'  {t}: {len(ds)}')
    
    print(f'\n=== Total: {total} loaded, {errors} errors ===')


if __name__ == '__main__':
    main()
