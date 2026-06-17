#!/usr/bin/env python3
"""
dasl-term-filter v2 — DASL/IPLD/CBOR subgraph with hub filtering.
Removes mega-hub nodes (Nat, Eq, Bool, etc.) to reveal DASL structure.
"""
import json, re, os, sys
from pathlib import Path
from collections import defaultdict, deque, Counter

MATHLIB_SPLIT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("aristotles_results/mathlib-split")
OUTPUT_DIR = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("aristotles_results/dasl-subgraph")
DEPTH = int(sys.argv[3]) if len(sys.argv) > 3 else 8
HUB_THRESHOLD = int(sys.argv[4]) if len(sys.argv) > 4 else 50  # nodes with >N edges are filtered

# Load existing subgraph
subgraph_file = OUTPUT_DIR / "dasl-subgraph.json"
with open(subgraph_file) as f:
    subgraph = json.load(f)

# Count edge degrees
edge_counts = Counter()
for src, dst in subgraph['edges']:
    edge_counts[src] += 1
    edge_counts[dst] += 1

# Identify hub nodes (>HUB_THRESHOLD edges)
hubs = {node for node, count in edge_counts.items() if count > HUB_THRESHOLD}
print(f"=== DASL Subgraph Filter (hub threshold = {HUB_THRESHOLD} edges) ===")
print(f"  Total nodes: {len(subgraph['nodes'])}")
print(f"  Hub nodes (removed): {len(hubs)}")

# Filter edges: keep only edges where BOTH endpoints are non-hubs
# EXCEPT if an endpoint is a seed node
filtered_edges = []
for src, dst in subgraph['edges']:
    src_seed = src in subgraph['seeds']
    dst_seed = dst in subgraph['seeds']
    src_hub = src in hubs
    dst_hub = dst in hubs
    
    # Keep if both non-hub, or if one is a seed and the other is a non-hub
    if (not src_hub and not dst_hub):
        filtered_edges.append((src, dst))
    elif (src_seed and not dst_hub):
        filtered_edges.append((src, dst))
    elif (dst_seed and not src_hub):
        filtered_edges.append((src, dst))

filtered_nodes = set()
for src, dst in filtered_edges:
    filtered_nodes.add(src)
    filtered_nodes.add(dst)

print(f"  Filtered nodes: {len(filtered_nodes)}")
print(f"  Filtered edges: {len(filtered_edges)}")
print(f"  Seeds retained: {len(filtered_nodes & set(subgraph['seeds']))}")

# Find connected components among filtered nodes
def find_components(nodes, edges):
    adj = defaultdict(set)
    for s, d in edges:
        adj[s].add(d)
        adj[d].add(s)
    visited = set()
    components = []
    for node in nodes:
        if node in visited:
            continue
        comp = set()
        q = deque([node])
        while q:
            n = q.popleft()
            if n in visited:
                continue
            visited.add(n)
            comp.add(n)
            for neighbor in adj.get(n, set()):
                if neighbor not in visited:
                    q.append(neighbor)
        components.append(comp)
    return sorted(components, key=len, reverse=True)

components = find_components(filtered_nodes, filtered_edges)
print(f"\n  Connected components: {len(components)}")
for i, comp in enumerate(components[:10]):
    seeds_in = comp & set(subgraph['seeds'])
    print(f"    Component {i+1}: {len(comp)} nodes, {len(seeds_in)} seeds")

# Build output for the largest component
main = components[0] if components else set()
main_edges = [(s, d) for s, d in filtered_edges if s in main and d in main]

output = {
    "depth": DEPTH,
    "hub_threshold": HUB_THRESHOLD,
    "total_nodes": len(subgraph['nodes']),
    "filtered_nodes": len(main),
    "filtered_edges": len(main_edges),
    "hubs_removed": sorted(hubs),
    "seeds_in_component": sorted(main & set(subgraph['seeds'])),
    "nodes": sorted(main),
    "edges": main_edges,
    "all_components": [{"size": len(c), "seeds": sorted(c & set(subgraph['seeds']))} for c in components[:20]],
}

(OUTPUT_DIR / "dasl-filtered-subgraph.json").write_text(json.dumps(output, indent=2))

# Mermaid for main component
mermaid = ["graph TD", "  %% DASL/IPLD/CBOR filtered subgraph"]
for i, (src, dst) in enumerate(sorted(main_edges)[:300]):
    src_id = src.replace('.', '_').replace('-', '_').replace('#', '_')[:25]
    dst_id = dst.replace('.', '_').replace('-', '_').replace('#', '_')[:25]
    seed_mark = "★" if src in subgraph['seeds'] else ""
    mermaid.append(f'    {src_id}["{seed_mark}{src[:20]}"] --> {dst_id}["{dst[:20]}"]')

(OUTPUT_DIR / "dasl-filtered.mermaid").write_text('\n'.join(mermaid))

# Top seeds by connectivity
seed_edges = Counter()
for s, d in main_edges:
    if s in subgraph['seeds']:
        seed_edges[s] += 1
    if d in subgraph['seeds']:
        seed_edges[d] += 1

print(f"\n=== Top DASL seeds in filtered subgraph ===")
for node, count in seed_edges.most_common(20):
    print(f"  {node[:50]:50s} {count:>3d} filtered edges")

print(f"\n=== Output ===")
print(f"  {OUTPUT_DIR}/dasl-filtered-subgraph.json  — {len(main)} nodes, {len(main_edges)} edges")
print(f"  {OUTPUT_DIR}/dasl-filtered.mermaid        — Mermaid diagram")

# Show what the seeds actually are
print(f"\n=== Seed categories ===")
dasl_seeds = [s for s in subgraph['seeds']]
categories = defaultdict(list)
for s in dasl_seeds:
    if 'aristotle' in s.lower() or 'weaver' in s.lower():
        categories['aristotle-weaver'].append(s)
    elif 'bytearray' in s.lower() or 'utf8' in s.lower() or 'string' in s.lower():
        categories['bytecodec'].append(s)
    elif 'array' in s.lower() or 'list' in s.lower():
        categories['datastructures'].append(s)
    elif 'lean_' in s.lower() or 'meta' in s.lower() or 'elab' in s.lower():
        categories['lean-internals'].append(s)
    elif 'std_' in s.lower() or 'rio' in s.lower() or 'iter' in s.lower():
        categories['stdlib'].append(s)
    elif 'gcc' in s.lower() or 'tree' in s.lower():
        categories['gcc-trees'].append(s)
    elif 'microlean' in s.lower() or 'something' in s.lower():
        categories['microlean'].append(s)
    else:
        categories['other'].append(s)

for cat, seeds in sorted(categories.items(), key=lambda x: -len(x[1])):
    print(f"  {cat}: {len(seeds)} seeds — {seeds[:5]}")
