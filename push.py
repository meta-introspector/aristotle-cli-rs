#!/usr/bin/env python3
"""Fast batch push of staticsplitjson output to lean4-repl."""
import sys, json, subprocess, requests

S = '/nix/store/hagadmgn61fhbxdq2md6p1jjb5plb52v-staticsplitjson/bin/staticsplitjson'
REPL = 'http://localhost:8156'
DIR = sys.argv[1] if len(sys.argv) > 1 else None

if not DIR:
    print("Usage: python3 push.py <dir>"); sys.exit(1)

print(f'Scanning {DIR}...')
result = subprocess.run([S, '--dir', DIR], capture_output=True, text=True, timeout=30)
lines = [l.strip() for l in result.stdout.split('\n') if l.strip()]

print(f'Pushing {len(lines)} declarations to REPL...')
session = requests.Session()
loaded = 0
errors = 0

for line in lines:
    try:
        decl = json.loads(line)
        resp = session.post(f'{REPL}/put', json=decl, timeout=5)
        if resp.status_code == 200:
            loaded += 1
        else:
            errors += 1
    except Exception as e:
        errors += 1
    
    if loaded % 200 == 0:
        print(f'  {loaded}/{len(lines)}...')

# Verify
health = session.get(f'{REPL}/health', timeout=3).json()
print(f'\nDone: {loaded} loaded, {errors} errors')
print(f'REPL total: {health["declarations"]}')
