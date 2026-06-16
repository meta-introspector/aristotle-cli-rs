#!/usr/bin/env python3
"""
Submit unified DASL chunks to Aristotle API with rate limiting and tracking.
Resumes where left off — skips already-submitted chunks.

Usage: python3 submit-chunks.py [--retry-failed]
"""
import json, subprocess, os, sys, time, glob
from pathlib import Path

CHUNKS_DIR = 'aristotles_results/aristotle-chunks'
TRACKING_FILE = 'aristotles_results/aristotle-submitted.json'
PROJECT_DIR = 'aristotles_results/unified-dasl'
DELAY = 60  # seconds between submissions (rate limit)

API_KEY = os.environ.get('ARISTOTLE_API_KEY', '')
if not API_KEY:
    print("ERROR: Set ARISTOTLE_API_KEY")
    sys.exit(1)

# Load tracking
submitted = {}
if os.path.exists(TRACKING_FILE):
    with open(TRACKING_FILE) as f:
        submitted = json.load(f)

# Add previously known submissions
known = {
    'unified-dasl-001.txt': 'a27cf872-5c5d-4a81-b34b-cbfc56eb3f00',
    'unified-dasl-002.txt': '2e66d20c-f932-45b6-9fa8-623be8facb48',
    'unified-dasl-003.txt': 'c8150c48-1fb8-432b-9680-fa6027589ceb',
    'unified-dasl-004.txt': '92c0b91b-d9b6-4bf8-8cf4-d75ed248dbc6',
    'unified-dasl-005.txt': '75f381bb-75ec-4ad6-8dac-c46236a5f24b',
    'unified-dasl-006.txt': '55f227c1-339f-42cc-ae36-7af193038065',
    'unified-dasl-007.txt': '8fab55fa-06b4-4365-a5b7-d68b21760092',
    'unified-dasl-008.txt': '68c83868-16f0-4414-9d92-e1e0764dd13d',
    'unified-dasl-009.txt': '450aa408-4fbe-463a-9d54-6f9306684ef9',
    'unified-dasl-010.txt': 'ca866d40-218d-4a23-b7cb-e2f12a6cedbe',
}
submitted.update(known)

# Find pending chunks
all_chunks = sorted(glob.glob(f'{CHUNKS_DIR}/unified-dasl-*.txt'))
pending = [c for c in all_chunks if os.path.basename(c) not in submitted]
retry = '--retry-failed' in sys.argv

if retry:
    pending = all_chunks  # retry all

print(f"Submitted: {len(submitted)}, Pending: {len(pending)}")

for chunk_file in pending:
    name = os.path.basename(chunk_file)
    prompt = Path(chunk_file).read_text()
    
    print(f"\nSubmitting {name} ({len(prompt)} chars)...")
    
    try:
        result = subprocess.run(
            ['aristotle', 'submit', '--project-dir', PROJECT_DIR,
             '--api-key', API_KEY, prompt],
            capture_output=True, text=True, timeout=60
        )
        
        for line in result.stdout.splitlines():
            if 'Project created' in line:
                pid = line.split()[-1]
                submitted[name] = pid
                print(f"  {line}")
            elif 'Error' in line or 'error' in line.lower():
                print(f"  {line}")
        
        if result.returncode != 0:
            print(f"  stderr: {result.stderr[:300]}")
            
    except subprocess.TimeoutExpired:
        print(f"  Timeout — API may be busy")
    except Exception as e:
        print(f"  Error: {e}")
    
    # Save after each submission
    with open(TRACKING_FILE, 'w') as f:
        json.dump(submitted, f, indent=2)
    
    if len(pending) > 1:
        print(f"  Waiting {DELAY}s...")
        time.sleep(DELAY)

print(f"\n=== Done: {len(submitted)} chunks submitted ===")
for name, pid in sorted(submitted.items()):
    print(f"  {name}: {pid}")
