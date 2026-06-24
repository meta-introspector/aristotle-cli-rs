#!/usr/bin/env python3
"""Generate project list for notebooklm_cross.rs from all downloaded project directories."""
import os

dirs = []
for base in ['aristotles_results', '/mnt/data1/aristotle-results/aristo-outputs']:
    if not os.path.isdir(base):
        continue
    for d in sorted(os.listdir(base)):
        p = os.path.join(base, d, 'output-final_aristotle', 'RequestProject')
        if os.path.isdir(p):
            pid = d.split('-')[0][:8]
            dirs.append((pid, p))

# Deduplicate
seen = {}
for pid, path in dirs:
    if pid not in seen:
        seen[pid] = path

print(f'// {len(seen)} projects (deduplicated)')
for pid in sorted(seen):
    path = seen[pid]
    # Escape backslashes for Rust string
    path_escaped = path.replace('\\', '\\\\')
    print(f'    ("{pid}", "{path_escaped}"),')
