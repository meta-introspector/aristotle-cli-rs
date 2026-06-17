#!/usr/bin/env python3
"""
Scan DASL index Lean files for IPLD/CBOR/DASL terms and merge with mathlib-split subgraph.
"""
import json, re, os, sys
from pathlib import Path
from collections import defaultdict, deque, Counter

DASL_INDEX = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/home/mdupont/dasl/index")
SUBRAPH_FILE = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("aristotles_results/dasl-subgraph/dasl-clean-subgraph.json")
OUTPUT_DIR = Path(sys.argv[3]) if len(sys.argv) > 3 else Path("aristotles_results/dasl-subgraph")

# DASL patterns
DASL_PATTERNS = [
    (r'\bdasl\b', 'dasl'), (r'\bipld\b', 'ipld'), (r'\bcbor\b', 'cbor'),
    (r'\bdag[._-]?cbor\b', 'dag-cbor'), (r'\bdag[._-]?pb\b', 'dag-pb'),
    (r'\bcar[._-]?file\b', 'car-file'), (r'\bcid[._-]?v1\b', 'cid-v1'),
    (r'\bmultihash\b', 'multihash'), (r'\bipfs\b', 'ipfs'),
    (r'\bcontent[._-]?address(?:ed|ing)?\b', 'content-address'),
    (r'\bshmem\b', 'shmem'), (r'\bshared[._-]?memory\b', 'shared-memory'),
    (r'\bblock[._-]?store\b', 'block-store'), (r'\bmerkledag\b', 'merkledag'),
    (r'\bmulticodec\b', 'multicodec'), (r'\bvarint\b', 'varint'),
    (r'\bprotobuf\b', 'protobuf'), (r'\bsheaf\b', 'sheaf'),
    (r'\bstalk\b', 'stalk'), (r'\bpresheaf\b', 'presheaf'),
    (r'\btopos\b', 'topos'), (r'\bnatural[._-]?transformation\b', 'natural-transformation'),
    (r'\bcommutative[._-]?diagram\b', 'commutative-diagram'),
    (r'\baristotle\b', 'aristotle'), (r'\bweaver\b', 'weaver'),
    (r'\bmicro[._-]?lean\b', 'microlean'), (r'\baristotleweaver\b', 'aristotleweaver'),
    (r'\bcodec\b', 'codec'), (r'\bencode\b', 'encode'), (r'\bdecode\b', 'decode'),
    (r'\bserialize\b', 'serialize'), (r'\bdeserialize\b', 'deserialize'),
    # IPLD-specific
    (r'\blink\b.*\b(?:system|section|block)\b', 'ipld-link'),  # loose
    (r'\bhash\b.*\b(?:link|tree|dag)\b', 'hash-link'),
    (r'\b(?:0xd8|0x2a|tag\s*42)\b', 'cbor-tag42'),
]

print("=== DASL Index Lean Scanner ===")

# ── Parse lean.txt for actual file paths ──────────────────────────
lean_index = DASL_INDEX / "lean.txt"
files_to_scan = set()

if lean_index.exists():
    for line in lean_index.read_text().splitlines():
        line = line.strip()
        if not line or ':' not in line:
            continue
        # Format: index/source.txt:/actual/path
        parts = line.split(':', 1)
        if len(parts) >= 2:
            path = parts[1].strip()
            if path.endswith('.lean') and os.path.isfile(path):
                files_to_scan.add(path)

print(f"  lean.txt: {len(files_to_scan)} valid .lean files found")

# Also scan hecke_lean.txt
hecke_index = DASL_INDEX / "hecke_lean.txt"
if hecke_index.exists():
    for line in hecke_index.read_text().splitlines():
        path = line.strip()
        if path.endswith('.lean') and os.path.isfile(path):
            files_to_scan.add(path)

print(f"  + hecke_lean.txt: {len(files_to_scan)} total files to scan")

# ── Scan files for DASL terms ────────────────────────────────────
print(f"\n  Scanning {len(files_to_scan)} files...")
matches = defaultdict(list)  # pattern -> [(file, snippet)]
file_scores = defaultdict(int)

for i, filepath in enumerate(sorted(files_to_scan)):
    try:
        content = Path(filepath).read_text(encoding='utf-8', errors='ignore')
    except Exception:
        continue
    
    file_name = Path(filepath).name
    content_lower = content.lower()
    
    for pattern, label in DASL_PATTERNS:
        found = list(re.finditer(pattern, content_lower))
        if found:
            for m in found[:3]:  # up to 3 snippets per pattern per file
                ctx_start = max(0, m.start() - 30)
                ctx_end = min(len(content_lower), m.end() + 30)
                snippet = content_lower[ctx_start:ctx_end].replace('\n', ' ').strip()
                matches[label].append({
                    "file": filepath,
                    "match": m.group(0),
                    "snippet": snippet,
                })
            file_scores[filepath] += len(found)
    
    if (i + 1) % 1000 == 0:
        print(f"    {i+1}/{len(files_to_scan)} files scanned...")

print(f"  Done scanning.")

# ── Summary ──────────────────────────────────────────────────────
print(f"\n=== DASL Matches in Index Files ===")
total_matched_files = set()
for label, match_list in sorted(matches.items(), key=lambda x: -len(x[1])):
    files = {m['file'] for m in match_list}
    total_matched_files.update(files)
    if files:
        sample = sorted(files)[:3]
        print(f"  {label:25s} → {len(match_list):>4d} hits in {len(files):>3d} files")
        for f in sample[:2]:
            print(f"    {Path(f).name}")

print(f"\n  Total matched files: {len(total_matched_files)}")

# ── Top files by DASL relevance ──────────────────────────────────
print(f"\n=== Top 30 DASL-relevant files ===")
for fp, score in sorted(file_scores.items(), key=lambda x: -x[1])[:30]:
    name = Path(fp).name
    path_short = fp.replace('/home/mdupont/', '~/')
    print(f"  {score:>4d}  {name[:50]:50s}  {path_short[:80]}")

# ── Merge with existing subgraph ─────────────────────────────────
print(f"\n=== Merging with mathlib-split subgraph ===")
if SUBRAPH_FILE.exists():
    with open(SUBRAPH_FILE) as f:
        subgraph = json.load(f)
    print(f"  Existing subgraph: {len(subgraph['nodes'])} nodes, {len(subgraph['edges'])} edges")
    
    # Add index files as new nodes
    existing_nodes = set(subgraph['nodes'])
    new_nodes = set()
    for fp in total_matched_files:
        node_id = f"index::{Path(fp).name.replace('.lean', '')}"
        new_nodes.add(node_id)
    
    # Add edges: index files connect to their DASL-matched subgraph seeds
    new_edges = []
    for fp in total_matched_files:
        node_id = f"index::{Path(fp).name.replace('.lean', '')}"
        # Connect to all seeds (weak link - they share DASL keywords)
        for seed in subgraph['seeds'][:50]:  # cap at 50 connections per file
            new_edges.append((node_id, seed))
    
    all_nodes = sorted(existing_nodes | new_nodes)
    all_edges = subgraph['edges'] + [[s,d] for s,d in new_edges]
    
    merged = {
        "subgraph_source": str(SUBRAPH_FILE),
        "index_source": str(DASL_INDEX),
        "index_matched_files": len(total_matched_files),
        "new_nodes": len(new_nodes),
        "new_edges": len(new_edges),
        "nodes": all_nodes,
        "edges": all_edges,
        "seeds": subgraph['seeds'],
    }
    
    out_file = OUTPUT_DIR / "dasl-merged-subgraph.json"
    out_file.write_text(json.dumps(merged, indent=2))
    print(f"  + {len(new_nodes)} new nodes (index files)")
    print(f"  + {len(new_edges)} new edges (keyword-to-seed links)")
    print(f"  Output: {out_file}")
