#!/usr/bin/env python3
"""
DASL Fuzz Corpus — Import Dependency Analyzer & Chunk Merger.

Phases:
  1. Extract imports from all 360 declarations in the fuzz corpus
  2. Build import dependency graph
  3. Find natural clusters (declarations sharing prerequisites)
  4. Merge each cluster into a compilable .lean chunk with all prereqs
  5. Generate summary per chunk: what it contains, what it depends on

Output: ~/2026/06/22/dasl-fuzz-corpus/chunks/
"""
import os, re, json
from collections import defaultdict, Counter
from pathlib import Path

CORPUS = os.path.expanduser("~/2026/06/22/dasl-fuzz-corpus")
DECLS_DIR = os.path.join(CORPUS, "decls")
CHUNKS_DIR = os.path.join(CORPUS, "chunks")
MANIFEST_PATH = os.path.join(CORPUS, "manifests", "corpus-manifest.json")
SUMMARY_PATH = os.path.join(CORPUS, "manifests", "chunk-summary.json")

os.makedirs(CHUNKS_DIR, exist_ok=True)


def load_declarations():
    """Load all declarations with their imports from the corpus."""
    decls = []
    for splitter in sorted(os.listdir(DECLS_DIR)):
        splitter_dir = os.path.join(DECLS_DIR, splitter)
        if not os.path.isdir(splitter_dir):
            continue
        for f in sorted(os.listdir(splitter_dir)):
            if not f.endswith(".lean"):
                continue
            path = os.path.join(splitter_dir, f)
            text = open(path).read()
            imports = re.findall(r"^import (.+)$", text, re.MULTILINE)
            # Extract the target signature from the comment
            sig_match = re.search(r"-- (theorem|def|lemma|inductive|structure) (.+)$", text, re.MULTILINE)
            sig = sig_match.group(0).replace("-- ", "") if sig_match else f.replace(".lean", "")
            decls.append({
                "name": f.replace(".lean", ""),
                "splitter": splitter,
                "file": path,
                "imports": imports,
                "import_count": len(imports),
                "signature": sig[:200],
                "body": text,
            })
    return decls


def analyze_imports(decls):
    """Analyze import frequency and dependency structure."""
    import_freq = Counter()
    for d in decls:
        for imp in d["imports"]:
            import_freq[imp] += 1
    return import_freq


def find_clusters(decls, min_shared=2):
    """Group declarations into clusters based on shared prerequisites.
    Uses greedy graph clustering: declarations sharing >= min_shared imports
    are merged into the same cluster."""
    # Build adjacency: d1 connected to d2 if they share >= min_shared imports
    adj = defaultdict(set)
    for i, d1 in enumerate(decls):
        for j, d2 in enumerate(decls):
            if i >= j:
                continue
            shared = set(d1["imports"]) & set(d2["imports"])
            if len(shared) >= min_shared:
                adj[d1["name"]].add(d2["name"])
                adj[d2["name"]].add(d1["name"])
    
    # Greedy clustering
    visited = set()
    clusters = []
    decl_map = {d["name"]: d for d in decls}
    
    for d in decls:
        if d["name"] in visited:
            continue
        # BFS to find connected component
        component = []
        queue = [d["name"]]
        while queue:
            name = queue.pop(0)
            if name in visited:
                continue
            visited.add(name)
            if name in decl_map:
                component.append(decl_map[name])
            for neighbor in adj.get(name, []):
                if neighbor not in visited:
                    queue.append(neighbor)
        if component:
            clusters.append(component)
    
    return clusters


def merge_cluster(cluster, cluster_id, import_freq):
    """Merge a cluster of declarations into a single compilable .lean chunk."""
    # Collect all unique imports, sorted by frequency (most shared first)
    all_imports = set()
    for d in cluster:
        all_imports.update(d["imports"])
    sorted_imports = sorted(all_imports, key=lambda imp: -import_freq.get(imp, 0))
    
    # Build the merged file
    lines = []
    lines.append(f"/-!")
    lines.append(f"  DASL Fuzz Chunk {cluster_id}: {len(cluster)} declarations")
    lines.append(f"  Splitters: {', '.join(sorted(set(d['splitter'] for d in cluster)))}")
    lines.append(f"  Prerequisites: {len(sorted_imports)} imports")
    lines.append(f"-/")
    lines.append("")
    
    for imp in sorted_imports:
        lines.append(f"import {imp}")
    lines.append("")
    
    for d in cluster:
        lines.append(f"/-- [{d['splitter']}] {d['signature'][:120]} -/")
        lines.append(f"-- {d['name']}")
        # Include the body (stub with import structure)
        body_lines = d["body"].split("\n")
        for bl in body_lines:
            if bl.startswith("import "):
                continue  # imports already added
            lines.append(bl)
        lines.append("")
    
    return "\n".join(lines)


def main():
    print("=== DASL Fuzz Corpus — Import Analysis & Chunk Merge ===\n")
    
    # Phase 1: Load
    print("Phase 1: Loading declarations...")
    decls = load_declarations()
    print(f"  Loaded {len(decls)} declarations from corpus")
    
    # Phase 2: Analyze imports
    print("\nPhase 2: Import analysis...")
    import_freq = analyze_imports(decls)
    print(f"  Unique imports: {len(import_freq)}")
    print(f"  Top 10 shared prerequisites:")
    for imp, count in import_freq.most_common(10):
        print(f"    {imp}: {count}")
    
    # Phase 3: Find clusters
    print("\nPhase 3: Clustering by shared prerequisites...")
    clusters = find_clusters(decls, min_shared=2)
    print(f"  Found {len(clusters)} clusters (connected components in import graph)")
    
    # Sort clusters by size
    clusters.sort(key=len, reverse=True)
    
    # Show cluster sizes
    sizes = Counter(len(c) for c in clusters)
    for size, count in sorted(sizes.items(), reverse=True):
        print(f"    Size {size}: {count} cluster(s)")
    
    # Phase 4: Merge each cluster
    print("\nPhase 4: Merging clusters into compilable chunks...")
    chunk_summaries = []
    
    for i, cluster in enumerate(clusters[:20]):  # Top 20 clusters
        if len(cluster) < 2:
            continue
        
        chunk_id = f"chunk_{i+1:03d}"
        merged = merge_cluster(cluster, chunk_id, import_freq)
        
        # Determine chunk name from dominant splitter
        splitter_counts = Counter(d["splitter"] for d in cluster)
        dominant = splitter_counts.most_common(1)[0][0]
        
        chunk_path = os.path.join(CHUNKS_DIR, f"{chunk_id}_{dominant}.lean")
        with open(chunk_path, "w") as f:
            f.write(merged)
        
        summary = {
            "chunk_id": chunk_id,
            "file": f"chunks/{chunk_id}_{dominant}.lean",
            "size": len(cluster),
            "dominant_splitter": dominant,
            "splitters": list(splitter_counts.keys()),
            "declarations": [d["name"] for d in cluster],
            "signatures": [d["signature"][:150] for d in cluster],
            "shared_imports": len(set.intersection(*[set(d["imports"]) for d in cluster]) if cluster else set()),
            "total_imports": len(set().union(*[set(d["imports"]) for d in cluster])),
            "prerequisites": sorted(set().union(*[set(d["imports"]) for d in cluster])),
        }
        chunk_summaries.append(summary)
        
        print(f"  {chunk_id}: {len(cluster)} decls, {summary['total_imports']} prereqs → {summary['file']}")
    
    # Phase 5: Write summary
    print("\nPhase 5: Writing chunk summary...")
    output = {
        "total_declarations": len(decls),
        "total_clusters": len(clusters),
        "merged_chunks": len(chunk_summaries),
        "top_prerequisites": dict(import_freq.most_common(30)),
        "chunks": chunk_summaries,
    }
    with open(SUMMARY_PATH, "w") as f:
        json.dump(output, f, indent=2)
    print(f"  Summary: {SUMMARY_PATH}")
    
    # Print final stats
    merged_decls = sum(c["size"] for c in chunk_summaries)
    print(f"\n  Merged: {merged_decls}/{len(decls)} declarations into {len(chunk_summaries)} chunks")
    print(f"  Remaining: {len(decls) - merged_decls} unclustered declarations")
    
    print(f"\n=== Chunk Directory ===")
    for f in sorted(os.listdir(CHUNKS_DIR)):
        path = os.path.join(CHUNKS_DIR, f)
        print(f"  {f} ({len(open(path).read().splitlines())} lines)")

if __name__ == "__main__":
    main()
