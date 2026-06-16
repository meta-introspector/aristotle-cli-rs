#!/usr/bin/env python3
"""
Partition the DASL subgraph using spectral clustering, community detection,
and j-invariant prime bands. Outputs partition assignments for each node.

Usage: python3 partition-dasl.py [subgraph.json] [output-dir]
"""
import json, sys, math
from pathlib import Path
from collections import defaultdict, Counter

SUGRAPH = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('aristotles_results/dasl-subgraph/dasl-clean-subgraph.json')
OUTPUT = Path(sys.argv[2]) if len(sys.argv) > 2 else Path('aristotles_results/dasl-partitions')
STRAT = Path('aristotles_results/j-invariant-stratification.json')

import networkx as nx
from networkx.algorithms import community

def load_graph(subgraph_file):
    with open(subgraph_file) as f:
        data = json.load(f)
    G = nx.DiGraph()
    for node in data['nodes']:
        G.add_node(node, seed=(node in data.get('seeds', [])))
    for src, dst in data['edges']:
        G.add_edge(src, dst)
    return G, data.get('seeds', [])

def load_prime_bands(strat_file):
    """Load j-invariant prime band assignments."""
    if not strat_file.exists():
        return {}
    with open(strat_file) as f:
        data = json.load(f)
    bands = {}
    for name, info in data.get('declarations', {}).items():
        bands[name] = info.get('stratum', 'unknown')
    return bands

print("=== DASL Graph Partitioning ===\n")

# Load
G, seeds = load_graph(SUGRAPH)
print(f"Graph: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges")
print(f"Seeds: {len(seeds)}")

# Convert to undirected for partitioning
UG = G.to_undirected()

# ── Method 1: Louvain community detection ──────────────────────
print("\n[1] Louvain community detection...")
louvain = community.louvain_communities(UG, seed=42)
louvain_parts = {}
for i, comm in enumerate(louvain):
    for node in comm:
        louvain_parts[node] = i
louvain_counts = Counter(louvain_parts.values())
print(f"  {len(louvain)} communities")
for i, count in louvain_counts.most_common(10):
    seed_count = sum(1 for n in louvain if n in seeds and louvain_parts.get(n) == i)
    print(f"    community {i}: {count:>5d} nodes, {seed_count} seeds")

# ── Method 2: Label propagation ─────────────────────────────────
print("\n[2] Label propagation...")
lp = list(community.label_propagation_communities(UG))
lp_parts = {}
for i, comm in enumerate(lp):
    for node in comm:
        lp_parts[node] = i
print(f"  {len(lp)} communities")

# ── Method 3: Spectral clustering (sklearn) ─────────────────────
print("\n[3] Spectral clustering...")
try:
    from sklearn.cluster import SpectralClustering
    # Convert to adjacency matrix for top 2000 most-connected nodes
    top_nodes = sorted(G.nodes(), key=lambda n: G.degree(n), reverse=True)[:2000]
    sub_G = G.subgraph(top_nodes)
    adj = nx.to_scipy_sparse_array(sub_G, nodelist=top_nodes)
    
    for k in [5, 10, 15, 20]:
        sc = SpectralClustering(n_clusters=k, affinity='precomputed', random_state=42, n_init=10)
        labels = sc.fit_predict(adj.toarray())
        spectral_parts = {node: int(labels[i]) for i, node in enumerate(top_nodes)}
        counts = Counter(spectral_parts.values())
        print(f"  k={k}: {counts.most_common(5)}")
except Exception as e:
    print(f"  Error: {e}")

# ── Method 4: j-Invariant prime bands ───────────────────────────
print("\n[4] j-Invariant prime band partitioning...")
prime_bands = load_prime_bands(STRAT)
band_parts = defaultdict(list)
for node in G.nodes():
    # Try to match node name to prime band
    name = node.replace('.', '_')
    band = prime_bands.get(name, prime_bands.get(node, 'unclassified'))
    band_parts[band].append(node)

for band, nodes in sorted(band_parts.items(), key=lambda x: -len(x[1])):
    seed_count = sum(1 for n in nodes if n in seeds)
    print(f"  {band:20s}: {len(nodes):>5d} nodes, {seed_count} seeds")

# ── Method 5: DASL category partitioning ─────────────────────────
print("\n[5] DASL category partitioning...")
DASL_CATS = {
    'microlean': ['MicroLean', 'microlean', 'emit', 'ffi', 'boxed'],
    'weaver': ['AristotleWeaver', 'weaver', 'BoundingBox', 'SimpleExpr'],
    'cbor': ['CborVal', 'Encode', 'Decode', 'ByteArray', 'utf8', 'codec'],
    'monster': ['Monster', 'monster', 'Hecke', 'Vertex', 'Borcherds'],
    'sheaf': ['Sheaf', 'sheaf', 'Stalk', 'Cech', 'Topos'],
    'godel': ['Godel', 'Goedel', 'Reflect', 'SelfApply', 'quine'],
    'mathlib': ['Nat', 'Eq', 'List', 'String', 'Bool', 'Option', 'Array'],
    'other': []
}

cat_parts = defaultdict(list)
for node in G.nodes():
    classified = False
    for cat, terms in DASL_CATS.items():
        if cat == 'other': continue
        if any(t.lower() in node.lower() for t in terms):
            cat_parts[cat].append(node)
            classified = True
            break
    if not classified:
        cat_parts['other'].append(node)

for cat, nodes in sorted(cat_parts.items(), key=lambda x: -len(x[1])):
    seed_count = sum(1 for n in nodes if n in seeds)
    print(f"  {cat:15s}: {len(nodes):>5d} nodes, {seed_count} seeds")

# ── Save partitions ─────────────────────────────────────────────
OUTPUT.mkdir(parents=True, exist_ok=True)

result = {
    'graph': {
        'nodes': G.number_of_nodes(),
        'edges': G.number_of_edges(),
        'seeds': len(seeds),
    },
    'partitions': {
        'louvain': {
            'communities': len(louvain),
            'assignment': {str(n): p for n, p in louvain_parts.items()},
        },
        'j_invariant_bands': {
            'bands': {band: len(nodes) for band, nodes in band_parts.items()},
            'assignment': {node: band for band, nodes in band_parts.items() for node in nodes},
        },
        'dasl_categories': {
            'categories': {cat: len(nodes) for cat, nodes in cat_parts.items()},
            'assignment': {node: cat for cat, nodes in cat_parts.items() for node in nodes},
        },
    },
}

(OUTPUT / 'dasl-partitions.json').write_text(json.dumps(result, indent=2))
print(f"\nSaved: {OUTPUT}/dasl-partitions.json")
