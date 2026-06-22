#!/usr/bin/env python3
"""
Extract all refusal/failure instances into a compact machine-readable corpus
for prompt-testing tools. Focus on mystical/poetry/essence framing:
  - What mystical asks FAILED (evocative poetry refusal)
  - What mystical asks SUCCEEDED (Tao Te Ching, Zappa Sofa)
  - What framing made the difference

Output: /mnt/data1/aristotle-results/aristo-failure-corpus.jsonl
  One JSON object per line — easy for tools to iterate.
"""
import os, json
from pathlib import Path

BASE = "/mnt/data1/aristotle-results/aristo-outputs"
OUT_JSONL = "/mnt/data1/aristotle-results/aristo-failure-corpus.jsonl"

def extract_summary_runs(text):
    """Split ARISTOTLE_SUMMARY.md into per-run sections."""
    runs = []
    current = []
    for line in text.splitlines():
        if line.startswith("# Summary of changes for run "):
            if current:
                runs.append("\n".join(current))
            current = [line]
        else:
            if current is not None:
                current.append(line)
    if current:
        runs.append("\n".join(current))
    return runs

def classify_run(run_text):
    """Classify a run: refusal, partial, success, scaffold-only."""
    tl = run_text.lower()
    refusal_markers = [
        "fabricate", "cannot be produced", "evocative poetry",
        "not a well-posed", "no actual constraint", "nothing actionable",
        "nothing concrete", "won't fabricate", "can't truthfully",
        "not well-posed"
    ]
    success_markers = [
        "builds cleanly", "builds successfully", "no sorry", "0 sorry",
        "formalized", "proved", "verified", "machine-checked",
        "added", "new file", "new declarations"
    ]
    scaffold_markers = [
        "only boilerplate", "only imports", "just imports",
        "no definitions", "empty skeleton", "no task description",
        "nothing to add or fix"
    ]
    
    refusal_score = sum(1 for m in refusal_markers if m in tl)
    success_score = sum(1 for m in success_markers if m in tl)
    scaffold_score = sum(1 for m in scaffold_markers if m in tl)
    
    if scaffold_score > success_score:
        return "scaffold"
    if refusal_score > 0 and success_score == 0:
        return "refusal"
    if refusal_score > 0 and success_score > 0:
        return "partial"  # refusal + some work = scope negotiation
    if success_score > 0:
        return "success"
    return "unknown"

def extract_mystical_content(text):
    """Try to figure out if/what mystical/philosophical content was asked."""
    tl = text.lower()
    markers = {
        "dao": "Tao Te Ching / Daoist philosophy",
        "tao": "Tao Te Ching / Daoist philosophy",
        "chapter": "Chapter-structured text",
        "zappa": "Zappa / Moonshine Sofa",
        "sofa": "Moonshine Sofa",
        "moonshine": "Monstrous Moonshine",
        "transmission": "Transmission Omega",
        "godel": "Gödel encoding",
        "zownakairufication": "Zownakairufication fixed-point",
        "shem": "Shem HaMephorash / Kabbalah",
        "kabbalah": "Kabbalah mysticism",
        "cosmos": "Cosmological ontology",
        "sage": "Philosophical text",
        "heaven": "Religious/mystical text",
        "angel": "Angelic hierarchies",
        "exodus": "Biblical text",
        "betti": "Betti diagrams / math",
        "crt": "Chinese Remainder Theorem",
        "jaccard": "Jaccard similarity",
        "nj law": "NJ Legal code",
        "rullca": "RULLCA legal",
        "decoder": "Decoder ring",
    }
    found = []
    for key, label in markers.items():
        if key in tl:
            found.append(label)
    return list(set(found)) if found else ["pure-math"]


def main():
    projects = sorted(d for d in os.listdir(BASE) if d.endswith("_aristotle"))
    
    entries = []
    
    for proj in projects:
        sid = proj[:8]
        proj_dir = os.path.join(BASE, proj)
        
        # Find the SUMMARY.md
        summary_path = None
        for root, dirs, files in os.walk(proj_dir):
            if "ARISTOTLE_SUMMARY.md" in files:
                summary_path = os.path.join(root, "ARISTOTLE_SUMMARY.md")
                break
        
        if not summary_path:
            print(f"SKIP {sid}: no SUMMARY.md")
            continue
        
        text = open(summary_path).read()
        runs = extract_summary_runs(text)
        
        # Find status.json for project metadata
        status_path = os.path.join(proj_dir, "aristotle_status.json")
        status = {}
        if os.path.exists(status_path):
            status = json.load(open(status_path))
        
        # Count .lean files and declarations
        lean_files = list(Path(proj_dir).rglob("*.lean"))
        
        for i, run in enumerate(runs):
            classification = classify_run(run)
            # Only keep non-success runs (refusals, partials, scaffolds)
            if classification == "success":
                continue
            
            # Extract first line (the header) to get run ID
            header = run.split("\n")[0] if run.strip() else "no-header"
            
            entry = {
                "project_id": sid,
                "run_index": i,
                "run_header": header,
                "classification": classification,
                "description": status.get("description", ""),
                "created_at": status.get("created_at", ""),
                "mystical_themes": extract_mystical_content(run),
                "lean_files_count": len(lean_files),
                "summary_excerpt": run[:1500],  # first 1500 chars
            }
            entries.append(entry)
    
    # Write JSONL
    with open(OUT_JSONL, "w") as f:
        for e in entries:
            f.write(json.dumps(e) + "\n")
    
    # Stats
    by_class = {}
    for e in entries:
        by_class[e["classification"]] = by_class.get(e["classification"], 0) + 1
    
    print(f"Failure corpus: {len(entries)} entries (non-success runs only)")
    print(f"  scaffold: {by_class.get('scaffold', 0)}")
    print(f"  refusal: {by_class.get('refusal', 0)}")
    print(f"  partial: {by_class.get('partial', 0)}")
    print(f"Written to {OUT_JSONL}")
    
    # Print refusal entries specifically
    print("\n=== REFUSAL ENTRIES ===")
    for e in entries:
        if e["classification"] == "refusal":
            print(f"  [{e['project_id']}] run {e['run_index']} — {e['mystical_themes']}")
            print(f"    {e['run_header'][:120]}")
    
    print("\n=== PARTIAL (refusal + some work) ===")
    for e in entries:
        if e["classification"] == "partial":
            print(f"  [{e['project_id']}] run {e['run_index']} — {e['mystical_themes']}")
            print(f"    {e['run_header'][:120]}")
    
    print("\n=== SCAFFOLD (no task found) ===")
    for e in entries:
        if e["classification"] == "scaffold":
            print(f"  [{e['project_id']}] run {e['run_index']}")
            print(f"    {e['run_header'][:120]}")

if __name__ == "__main__":
    main()
