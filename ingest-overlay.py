#!/usr/bin/env python3
"""
Ingest lean.index2.txt into REPL shmem + apply 13 splitter overlays.

Phase 1: Filter valid .lean files from index, run staticsplitjson, load into REPL via /put
Phase 2: Scan 13 splitter categories from split-results-kernel, cross-reference declarations
Phase 3: Build overlay topology JSON — which declarations appear in which splitters

Output: /mnt/data1/time-2026/05-may/07/arist/overlay-topology.json
"""
import os, json, subprocess, re
from collections import defaultdict, Counter
from pathlib import Path
import urllib.request

INDEX = "/mnt/data1/time-2026/06-june/26/index/lean.index2.txt"
STATICSPLIT = "/nix/store/hagadmgn61fhbxdq2md6p1jjb5plb52v-staticsplitjson/bin/staticsplitjson"
REPL = "http://127.0.0.1:8156"
SPLIT_KERNEL = "/mnt/data1/time-2026/05-may/07/arist/split-results-kernel"
OUT_OVERLAY = "/mnt/data1/time-2026/05-may/07/arist/overlay-topology.json"

def filter_valid_paths(limit=5000):
    """Filter index to valid .lean source files."""
    valid = []
    with open(INDEX) as f:
        for line in f:
            path = line.strip()
            if not path.endswith('.lean'):
                continue
            if any(skip in path for skip in ['.olean', '.ilean', '/.lake/', '/lake/', '/build/']):
                continue
            if os.path.isfile(path):
                valid.append(path)
                if len(valid) >= limit:
                    break
    return valid

def run_staticsplit(filepath):
    """Run staticsplitjson on a .lean file, return list of declarations."""
    try:
        result = subprocess.run([STATICSPLIT, filepath], capture_output=True, text=True, timeout=10)
        decls = []
        for line in result.stdout.strip().split('\n'):
            if line.strip():
                try:
                    decls.append(json.loads(line))
                except:
                    pass
        return decls
    except Exception as e:
        return []

def push_to_repl(decl):
    """Push a single declaration to REPL /put."""
    try:
        data = json.dumps(decl).encode()
        req = urllib.request.Request(f"{REPL}/put", data=data,
                                      headers={"Content-Type": "application/json"},
                                      method="POST")
        resp = urllib.request.urlopen(req, timeout=5)
        return json.loads(resp.read())
    except:
        return None

def scan_splitter_overlays():
    """Scan all 13 splitter categories in split-results-kernel."""
    overlays = {}
    if not os.path.isdir(SPLIT_KERNEL):
        return overlays
    
    for splitter_name in sorted(os.listdir(SPLIT_KERNEL)):
        splitter_dir = os.path.join(SPLIT_KERNEL, splitter_name)
        if not os.path.isdir(splitter_dir):
            continue
        
        split_dir = os.path.join(splitter_dir, "Split")
        if not os.path.isdir(split_dir):
            continue
        
        # Count split files
        decl_names = set()
        for f in os.listdir(split_dir):
            if f.endswith('.lean'):
                # Extract declaration name from filename
                name = f.replace('.lean', '')
                decl_names.add(name)
        
        overlays[splitter_name] = {
            "path": splitter_dir,
            "split_files": len(decl_names),
            "declarations": list(decl_names)[:100],  # sample
        }
    
    return overlays

def compute_overlap(ingested_names, overlays):
    """Compute which ingested declarations appear in which splitter overlays."""
    overlap = defaultdict(list)
    for splitter_name, data in overlays.items():
        splitter_decls = set(data.get("declarations", []))
        # Check overlap with ingested
        common = ingested_names & splitter_decls
        if common:
            overlap[f"in_{splitter_name}"] = len(common)
    
    return dict(overlap)

def main():
    print(f"=== Aristotle Index Ingestion + Overlay Topology ===\n")
    
    # Phase 1: Scan overlays
    print(f"=== Phase 1: Scan 13 splitter overlays ===")
    overlays = scan_splitter_overlays()
    total_splits = sum(o["split_files"] for o in overlays.values())
    print(f"  Splitters: {len(overlays)}")
    print(f"  Total split files: {total_splits}")
    for name, data in sorted(overlays.items()):
        print(f"    {name}: {data['split_files']} files")
    
    # Phase 2: Ingest from index
    print(f"\n=== Phase 2: Ingest from lean.index2.txt ===")
    
    # Read current REPL state
    try:
        health = json.loads(urllib.request.urlopen(f"{REPL}/health", timeout=5).read())
        print(f"  Current REPL state: {health.get('declarations', 0)} declarations, {health.get('files', 0)} files")
    except:
        print("  REPL not reachable")
        health = {"declarations": 0}
    
    # Process files
    limit = 500
    valid_paths = filter_valid_paths(limit)
    print(f"  Valid .lean files to process: {len(valid_paths)}/{limit}")
    
    ingested_names = set()
    total_decls = 0
    processed = 0
    
    for path in valid_paths:
        decls = run_staticsplit(path)
        for decl in decls:
            name = decl.get("name", "")
            ingested_names.add(name)
            # Push to REPL (skip if already have many)
            if health.get("declarations", 0) + total_decls < 10000:
                push_to_repl(decl)
            total_decls += 1
        
        processed += 1
        if processed % 100 == 0:
            print(f"  Processed {processed}/{len(valid_paths)} files, {total_decls} declarations, {len(ingested_names)} unique")
    
    print(f"  Total declarations: {total_decls}")
    print(f"  Unique names: {len(ingested_names)}")
    
    # Phase 3: Compute overlay topology
    print(f"\n=== Phase 3: Overlay topology ===")
    overlap = compute_overlap(ingested_names, overlays)
    
    if overlap:
        for splitter, count in sorted(overlap.items(), key=lambda x: -x[1]):
            print(f"  {splitter}: {count} overlapping declarations")
    else:
        print("  No direct overlap computed (sample size mismatch)")
    
    # Phase 4: Build output
    output = {
        "ingested_files": processed,
        "total_declarations": total_decls,
        "unique_declarations": len(ingested_names),
        "splitter_overlays": {
            name: {"split_files": data["split_files"]}
            for name, data in overlays.items()
        },
        "overlap": overlap,
        "splitter_count": len(overlays),
        "total_split_files": total_splits,
    }
    
    with open(OUT_OVERLAY, "w") as f:
        json.dump(output, f, indent=2)
    print(f"\n  Saved overlay topology to {OUT_OVERLAY}")
    
    # Print splitter names as the "overlay categories"
    print(f"\n=== 13 Overlay Categories ===")
    for i, name in enumerate(sorted(overlays.keys()), 1):
        print(f"  {i:2d}. {name}")

if __name__ == "__main__":
    main()
