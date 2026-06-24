#!/usr/bin/env python3
"""Deduplicate LoadDecls/ReplStats in main.rs — keep only last copy."""
p = '/mnt/data1/time-2026/05-may/07/arist/src/main.rs'
lines = open(p).readlines()

# Find indices of all LoadDecls lines
load_idxs = [i for i, l in enumerate(lines) if 'LoadDecls {' in l]
repl_idxs = [i for i, l in enumerate(lines) if l.strip() == 'ReplStats,']

print(f'LoadDecls at: {load_idxs}')
print(f'ReplStats at: {repl_idxs}')

if len(load_idxs) > 1:
    # Keep the LAST one, delete all others
    keep_load = load_idxs[-1]
    keep_repl = repl_idxs[-1]
    
    for idx in sorted(load_idxs[:-1], reverse=True):
        # Find the /// comment line that starts this block
        start = idx
        while start > 0 and not lines[start-1].strip().startswith('/// Load'):
            start -= 1
        start -= 1  # include the comment line
        # Delete from start to repl_idxs (inclusive)
        repl_idx = repl_idxs[load_idxs.index(idx)]
        del lines[start:repl_idx+1]
    
    open(p, 'w').writelines(lines)
    print(f'Kept LoadDecls at line {keep_load}, removed {len(load_idxs)-1} duplicates')
