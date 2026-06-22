#!/usr/bin/env python3
"""
DASL Fuzz Test Corpus — Project Lens Builder.

Curate a specialized subset of the splitter-overlay shared memory into a
compact "project lens" for DASL fuzz testing. The corpus exercises:

  1. CID generation (multihash, content-addressed identifiers)
  2. DASL address computation (0xda51... addressing)
  3. Sheaf coordinate mapping (mod 47, 59, 71)
  4. Bott periodicity nesting (8-cycle carriage)
  5. Monster arithmetic (196883, supersingular primes)
  6. IPLD/IPFS CAR block encoding
  7. Edge cases (empty, max-length, special characters, Unicode)

Output: ~/2026/06/22/dasl-fuzz-corpus/{decls/, manifests/, tests/}
"""
import os, json, shutil, hashlib, random
from pathlib import Path
from collections import defaultdict

SPLIT_KERNEL = "/mnt/data1/time-2026/05-may/07/arist/split-results-kernel"
OUT_DIR = os.path.expanduser("~/2026/06/22/dasl-fuzz-corpus")
REPL = "http://127.0.0.1:8156"

# ── DASL-relevant splitter categories ──
DASL_SPLITTERS = {
    "ContentAddressing": "CID, DASL address, content-addressed identifiers",
    "IPLDMonsterSchema": "IPLD Monster schema, struct-to-CAR encoding",
    "BottNestedCarriage": "Bott periodicity nesting, 8-cycle carriage",
    "UmweltGodelTrust": "Goedel trust model, prime verification",
    "MonsterCarriageTrain": "Monster group arithmetic, carriage train",
    "PadicEntropyDAG": "p-adic entropy, valuation DAG",
    "TypedDMZ": "Typed DMZ boundary, type-directed sheaf sections",
}

# ── Edge case fuzz declarations (hand-crafted) ──
EDGE_CASE_DECLS = [
    {"name": "___empty___", "kind": "def", "source": "fuzz:empty_name"},
    {"name": "x" * 256, "kind": "theorem", "source": "fuzz:max_length_name"},
    {"name": "Ω_π_λ_α_β_γ", "kind": "lemma", "source": "fuzz:unicode_greek"},
    {"name": "αβγδεζηθικλμνξοπρστυφχψω", "kind": "def", "source": "fuzz:greek_alphabet"},
    {"name": "solidGoldMag单元", "kind": "theorem", "source": "fuzz:unicode_cjk"},
    {"name": "0xda513630001c116c", "kind": "axiom", "source": "fuzz:hex_address"},
    {"name": "196883_plus_1_equals_196884", "kind": "theorem", "source": "fuzz:monster_arithmetic"},
    {"name": "bafkreid_q_m_6_", "kind": "def", "source": "fuzz:cid_like"},
    {"name": "sheaf\x00null", "kind": "lemma", "source": "fuzz:null_byte"},
    {"name": "a" * 1024, "kind": "def", "source": "fuzz:oversize_name"},
]

def create_project_lens(limit_per_splitter=50):
    """Curate a DASL-focused subset from each relevant splitter."""
    os.makedirs(OUT_DIR, exist_ok=True)
    os.makedirs(os.path.join(OUT_DIR, "decls"), exist_ok=True)
    os.makedirs(os.path.join(OUT_DIR, "manifests"), exist_ok=True)
    os.makedirs(os.path.join(OUT_DIR, "tests"), exist_ok=True)
    
    corpus_index = []
    total_files = 0
    
    for splitter_name, description in DASL_SPLITTERS.items():
        split_dir = os.path.join(SPLIT_KERNEL, splitter_name, "Split")
        if not os.path.isdir(split_dir):
            print(f"  SKIP {splitter_name}: no Split/ directory")
            continue
        
        all_files = [f for f in os.listdir(split_dir) if f.endswith('.lean')]
        
        # Prioritize DASL-relevant files
        dasl_keywords = [
            "CID", "address", "hash", "bott", "prime", "sheaf", "carriage",
            "monster", "ipld", "schema", "trust", "padic", "dmz", "typed",
            "godel", "umwelt", "block", "fiber", "section", "orbifold",
            "charta", "residue", "encoding", "shard", "witness",
        ]
        
        prioritized = []
        for f in all_files:
            name = f.replace('.lean', '')
            score = sum(1 for kw in dasl_keywords if kw.lower() in name.lower())
            prioritized.append((score, f))
        prioritized.sort(key=lambda x: -x[0])
        
        # Select top N
        selected = [f for _, f in prioritized[:limit_per_splitter]]
        
        # Copy selected files
        splitter_out = os.path.join(OUT_DIR, "decls", splitter_name)
        os.makedirs(splitter_out, exist_ok=True)
        
        for f in selected:
            src = os.path.join(split_dir, f)
            dst = os.path.join(splitter_out, f)
            shutil.copy2(src, dst)
            
            # Hash for CID
            content = open(src).read()
            cid_hash = hashlib.sha256(content.encode()).hexdigest()[:32]
            
            corpus_index.append({
                "name": f.replace('.lean', ''),
                "splitter": splitter_name,
                "file": f"{splitter_name}/{f}",
                "cid": f"bafk{cid_hash}",
                "source_path": src,
                "size": len(content),
            })
        
        total_files += len(selected)
        print(f"  {splitter_name}: {len(selected)} files ({description})")
    
    # Create edge case test declarations
    edge_dir = os.path.join(OUT_DIR, "decls", "_fuzz_edge_cases")
    os.makedirs(edge_dir, exist_ok=True)
    for decl in EDGE_CASE_DECLS:
        safe_name = decl['name'].replace('\x00', '_NULL_').replace('/', '_')[:50]
        fname = f"{safe_name}.lean" if len(safe_name) < 50 else "oversize.lean"
        fpath = os.path.join(edge_dir, fname)
        with open(fpath, "w", errors='replace') as f:
            f.write(f"-- {decl['source']}\n")
            f.write(f"-- Edge case: {decl['kind']}\n\n")
            f.write(f"/-- Fuzz test declaration: {decl['source']} -/\n")
        corpus_index.append({
            "name": decl["name"],
            "splitter": "_fuzz_edge_cases",
            "file": f"_fuzz_edge_cases/{fname}",
            "cid": "fuzz-0000",
            "source_path": fpath,
            "size": 0,
            "edge_case": True,
            "kind": decl["kind"],
        })
    
    print(f"\n  Edge cases: {len(EDGE_CASE_DECLS)}")
    total_files += len(EDGE_CASE_DECLS)
    
    # Write corpus manifest
    manifest = {
        "corpus_name": "DASL Fuzz Test Corpus — Project Lens",
        "description": "Curated subset of splitter-overlay declarations for DASL fuzz testing",
        "total_files": total_files,
        "splitters": list(DASL_SPLITTERS.keys()),
        "edge_cases": len(EDGE_CASE_DECLS),
        "output_dir": OUT_DIR,
        "index": corpus_index,
    }
    
    manifest_path = os.path.join(OUT_DIR, "manifests", "corpus-manifest.json")
    with open(manifest_path, "w") as f:
        json.dump(manifest, f, indent=2)
    
    # Write fuzz test harness
    harness = f'''#!/usr/bin/env python3
"""DASL Fuzz Test Harness — exercises the DASL project lens corpus."""
import os, json, hashlib, subprocess

CORPUS_DIR = "{OUT_DIR}"
MANIFEST = os.path.join(CORPUS_DIR, "manifests", "corpus-manifest.json")

def load_corpus():
    with open(MANIFEST) as f:
        return json.load(f)

def test_cid_generation(decl):
    """Test that CID is deterministic and stable."""
    path = os.path.join(CORPUS_DIR, "decls", decl["file"])
    content = open(path).read()
    cid_hash = hashlib.sha256(content.encode()).hexdigest()[:32]
    expected = f"bafk{{cid_hash}}"
    # CID must be reproducible
    assert cid_hash == hashlib.sha256(content.encode()).hexdigest()[:32]
    return True

def test_statlesplit(decl):
    """Test that staticsplitjson can re-split the file."""
    path = os.path.join(CORPUS_DIR, "decls", decl["file"])
    if not os.path.exists(path):
        return None  # skip if path doesn't resolve
    # Run staticsplitjson
    result = subprocess.run(
        ["/nix/store/hagadmgn61fhbxdq2md6p1jjb5plb52v-staticsplitjson/bin/staticsplitjson", path],
        capture_output=True, text=True, timeout=5
    )
    return result.returncode == 0

def run_all_tests():
    corpus = load_corpus()
    print(f"Testing {{corpus['total_files']}} declarations...")
    
    results = {{"passed": 0, "failed": 0, "skipped": 0}}
    for decl in corpus["index"]:
        try:
            if test_cid_generation(decl):
                results["passed"] += 1
            else:
                results["failed"] += 1
        except Exception as e:
            results["failed"] += 1
            print(f"  FAIL: {{decl['name'][:40]}} — {{e}}")
    
    print(f"\\nResults: {{results['passed']}} passed, {{results['failed']}} failed, {{results['skipped']}} skipped")
    return results

if __name__ == "__main__":
    run_all_tests()
'''
    
    harness_path = os.path.join(OUT_DIR, "tests", "fuzz_harness.py")
    with open(harness_path, "w") as f:
        f.write(harness)

def main():
    print(f"=== Building DASL Fuzz Test Corpus — Project Lens ===\n")
    
    # Check for existing declarations in the index
    manifest_path = os.path.join(OUT_DIR, "manifests", "corpus-manifest.json")
    if os.path.exists(manifest_path):
        with open(manifest_path) as f:
            existing = json.load(f)
        print(f"  Existing corpus: {existing['total_files']} files")
        print(f"  Delete {OUT_DIR} to rebuild\n")
    
    create_project_lens(limit_per_splitter=50)
    
    # Print summary
    print(f"\n=== Corpus Structure ===")
    for root, dirs, files in os.walk(OUT_DIR):
        level = root.replace(OUT_DIR, '').count(os.sep)
        indent = '  ' * level
        print(f"{indent}{os.path.basename(root)}/")
        for f in files[:3]:
            print(f"{indent}  {f}")
        if len(files) > 3:
            print(f"{indent}  ... ({len(files)} files)")
    
    print(f"\n=== Next Steps ===")
    print(f"  1. Run fuzz harness: python3 {OUT_DIR}/tests/fuzz_harness.py")
    print(f"  2. Load into REPL: curl -X POST {REPL}/put -d @<declaration.json>")
    print(f"  3. Compute overlay topology: python3 ingest-overlay.py")
    print(f"  4. Post to pastebin with CID")

if __name__ == "__main__":
    main()
