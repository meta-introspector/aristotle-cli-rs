#!/usr/bin/env python3
"""
Detect stale Aristotle projects — those updated on the API since last download.
Removes stale IDs from processed.txt so they re-download on next run.

Usage: python3 detect-stale.py [--dry-run]
"""
import json, os, sys
from datetime import datetime

RESULTS_DIR = 'aristotles_results'
PROCESSED_FILE = f'{RESULTS_DIR}/aristotle_processed.txt'
PROJECTS_JSON = f'{RESULTS_DIR}/aristotle_projects.json'

def main():
    dry_run = '--dry-run' in sys.argv

    with open(PROJECTS_JSON) as f:
        api_data = json.load(f)

    with open(PROCESSED_FILE) as f:
        processed = set(l.strip() for l in f if l.strip())

    api_projects = {}
    for p in api_data['projects']:
        pid = p.get('project_id', '')
        api_projects[pid] = {
            'last_updated': p.get('last_updated', ''),
            'has_files': p.get('has_files', False),
            'description': (p.get('description', '') or '')[:80],
        }

    stale = []
    for d in sorted(os.listdir(RESULTS_DIR)):
        if not d.endswith('_aristotle'):
            continue
        pid = d.replace('_aristotle', '')
        meta_file = os.path.join(RESULTS_DIR, d, 'aristotle_metadata.json')
        if not os.path.exists(meta_file):
            continue
        with open(meta_file) as f:
            meta = json.load(f)
        
        api_info = api_projects.get(pid)
        if not api_info:
            continue
        
        if meta.get('extracted_at', '') < api_info['last_updated']:
            stale.append({
                'id': pid,
                'extracted': meta['extracted_at'],
                'updated': api_info['last_updated'],
                'description': api_info['description'],
            })

    print(f"API projects: {len(api_projects)}")
    print(f"Downloaded: {len(processed)}")
    print(f"Stale (updated since download): {len(stale)}")
    print()

    if stale:
        print("=== Stale projects ===")
        for s in sorted(stale, key=lambda x: x['updated'], reverse=True):
            print(f"  {s['id']}")
            print(f"    downloaded: {s['extracted'][:19]}")
            print(f"    updated:    {s['updated'][:19]}")
            print(f"    {s['description']}")

        if not dry_run:
            stale_ids = {s['id'] for s in stale}
            new_processed = processed - stale_ids
            with open(PROCESSED_FILE, 'w') as f:
                for pid in sorted(new_processed):
                    f.write(pid + '\n')
            print(f"\n  Removed {len(stale_ids)} stale IDs from {PROCESSED_FILE}")
            print(f"  Run 'cargo run -- download' to fetch updates")
        else:
            print("\n  Dry run — no changes made. Remove --dry-run to apply.")

if __name__ == '__main__':
    main()
