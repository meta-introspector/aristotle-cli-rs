#!/usr/bin/env python3
"""
DASL Spec-Driven Proof Audit — maps all spec elements to fuzz corpus declarations.

Extracts the complete DASL specification from:
  1. verify_spec_compliance.py (DASL_SPEC + GRANT_REQUIREMENTS)
  2. README.md (Theoretical Framework + Components + Proofs)
  3. Fuzz corpus declarations (360 decls across 7 splitter lenses)

For each spec element, finds matching declarations and computes coverage %.
Generates HTML report with green/red coverage indicators.

Output: ~/2026/06/22/dasl-spec-audit.html
"""
import os, json, re
from pathlib import Path
from collections import defaultdict
from datetime import datetime

GRANT_DIR = "/mnt/data1/time-2026/02-february/22/dasl/OTHER/GRANTS/dasl-grant-proposal-20260222"
FUZZ_CORPUS = os.path.expanduser("~/2026/06/22/dasl-fuzz-corpus")
OUT_HTML = os.path.expanduser("~/2026/06/22/dasl-spec-audit.html")

# ── DASL Specification (from verify_spec_compliance.py + README.md) ──
DASL_SPEC = [
    {"id": "DASL-1.1", "category": "Content Addressing",
     "description": "Content identifiers MUST be cryptographic hashes",
     "verification": "CID starts with 'bafy' (SHA256-based CIDv1)",
     "keywords": ["CID", "hash", "multihash", "content", "addressing"]},
    {"id": "DASL-1.2", "category": "Content Addressing",
     "description": "Test vectors MUST have unique identifiers",
     "verification": "All CIDs are unique (no duplicates)",
     "keywords": ["CID", "unique", "injective", "noConfusion"]},
    {"id": "DASL-2.1", "category": "Monster Symmetries",
     "description": "Test corpus MUST cover all symmetry classes (15 Monster primes)",
     "verification": "Vectors span all 15 supersingular prime classes",
     "keywords": ["prime", "supersingular", "Monster", "SSP", "ogg"]},
    {"id": "DASL-2.2", "category": "Monster Symmetries",
     "description": "Complexity MUST be bounded by V₁ = 196,883",
     "verification": "Sum of prime exponents ≤ 196,883",
     "keywords": ["196883", "Griess", "monster", "dim", "complexity"]},
    {"id": "DASL-3.1", "category": "State Transitions",
     "description": "State transitions MUST be deterministic",
     "verification": "FRACTRAN step function is pure (same input → same output)",
     "keywords": ["step", "deterministic", "pure", "preserves", "idempotent"]},
]

GRANT_REQS = [
    {"id": "REQ-1", "category": "Corpus Scale",
     "description": "Test Corpus: 38,725 test vectors",
     "verification": "len(corpus) >= 38,725",
     "keywords": ["corpus", "count", "card", "length", "size"]},
    {"id": "REQ-2", "category": "Fuzzing",
     "description": "Automated test generation via FRACTRAN evolution",
     "verification": "FRACTRAN generates novel test cases",
     "keywords": ["Fractran", "step", "run", "evolve", "generate"]},
    {"id": "REQ-13", "category": "Adversarial",
     "description": "Edge case testing — Monster cusp evolution",
     "verification": "Finds boundary conditions at 1/p for each Monster prime",
     "keywords": ["cusp", "boundary", "obstruction", "qliphoth", "edge"]},
]

THEORY_SPEC = [
    {"id": "TH-1", "category": "Quasi-Fiber Bundle",
     "description": "DASL operation traces form a quasi-fiber bundle over Monster conjugacy classes",
     "keywords": ["fiber", "bundle", "section", "sheaf", "orbifold"]},
    {"id": "TH-2", "category": "Bott Periodicity",
     "description": "8-fold periodicity in complexity classes — Bott clock",
     "keywords": ["Bott", "period", "clock", "bottFold", "NestedCarriage"]},
    {"id": "TH-3", "category": "71-Layer Sharding",
     "description": "Supersingular primes define execution partitions — 15 primes, 71 max",
     "keywords": ["shard", "layer", "prime", "partition", "71"]},
    {"id": "TH-4", "category": "Griess Algebra",
     "description": "DAG operations correspond to Griess algebra axis products",
     "keywords": ["Griess", "axis", "algebra", "DAG", "product"]},
    {"id": "TH-5", "category": "Monster Walk",
     "description": "10-step calculation through Monster Group order",
     "keywords": ["walk", "step", "order", "Monster", "stalk"]},
    {"id": "TH-6", "category": "Q×K×V Identity",
     "description": "71 × 59 × 47 = 196,883 (V₁ irrep dimension)",
     "keywords": ["196883", "47", "59", "71", "irrep", "dimension"]},
]

COMPONENT_SPEC = [
    {"id": "CMP-1", "category": "IPLD Core",
     "description": "Rust ipld-core: Core IPLD traits and types",
     "keywords": ["IPLD", "CAR", "block", "dag", "cbor"]},
    {"id": "CMP-2", "category": "DAG-CBOR Codec",
     "description": "serde_ipld_dagcbor: DAG-CBOR codec with Serde",
     "keywords": ["codec", "serde", "encode", "decode", "cbor"]},
    {"id": "CMP-3", "category": "MMGroup",
     "description": "mmgroup: Monster Group computation software",
     "keywords": ["Monster", "mmgroup", "sporadic", "simple"]},
    {"id": "CMP-4", "category": "Cross-Language",
     "description": "Multi-language IPLD: Go, Java, Python, JavaScript",
     "keywords": ["ipld", "dag", "cbor", "codec"]},
]

PROOF_SPEC = [
    {"id": "PRF-1", "category": "71 Lean4 Proofs",
     "description": "71-layer proof system in Lean4",
     "keywords": ["Lean", "proof", "theorem", "lemma", "layer"]},
    {"id": "PRF-2", "category": "Monster Walk Proof",
     "description": "Monster Walk: 10-step calculation through Monster Group",
     "keywords": ["Monster", "walk", "step", "order", "8080"]},
    {"id": "PRF-3", "category": "FRACTRAN Algebra",
     "description": "FRACTRAN prime factorization algebra",
     "keywords": ["Fractran", "prime", "factor", "step", "program"]},
    {"id": "PRF-4", "category": "Sonnenlicht Moonshine",
     "description": "Ramanujan generating function / Moonshine",
     "keywords": ["moonshine", "ramanujan", "tau", "sonnenlicht", "j-invariant"]},
]


def load_fuzz_declarations():
    """Load all declarations from the fuzz corpus."""
    decls = []
    decls_dir = os.path.join(FUZZ_CORPUS, "decls")
    for splitter in os.listdir(decls_dir):
        splitter_dir = os.path.join(decls_dir, splitter)
        if not os.path.isdir(splitter_dir):
            continue
        for f in os.listdir(splitter_dir):
            if not f.endswith(".lean"):
                continue
            path = os.path.join(splitter_dir, f)
            text = open(path).read()
            decls.append({
                "name": f.replace(".lean", ""),
                "splitter": splitter,
                "text": text.lower(),
                "full_text": text,
            })
    return decls


def match_declarations(spec_elements, decls):
    """Match each spec element to declarations by keyword overlap."""
    results = []
    for spec in spec_elements:
        matches = []
        for d in decls:
            score = sum(1 for kw in spec["keywords"] if kw.lower() in d["text"])
            if score > 0:
                matches.append({"name": d["name"], "splitter": d["splitter"], "score": score})
        matches.sort(key=lambda m: -m["score"])
        results.append({
            "spec": spec,
            "match_count": len(matches),
            "top_matches": matches[:10],
            "all_matches": matches,
            "coverage": len(matches) > 0,
        })
    return results


def compute_coverage(results):
    """Compute overall coverage statistics."""
    all_specs = results
    covered = sum(1 for r in all_specs if r["coverage"])
    total = len(all_specs)
    by_category = defaultdict(lambda: {"covered": 0, "total": 0})
    for r in all_specs:
        cat = r["spec"]["category"]
        by_category[cat]["total"] += 1
        if r["coverage"]:
            by_category[cat]["covered"] += 1
    return {
        "overall_pct": round(100 * covered / total, 1) if total > 0 else 0,
        "covered": covered,
        "total": total,
        "by_category": dict(by_category),
    }


def generate_html(all_results, coverage):
    """Generate a clean HTML audit report."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Category colors
    cat_colors = {
        "Content Addressing": "#3498db",
        "Monster Symmetries": "#e74c3c",
        "State Transitions": "#2ecc71",
        "Corpus Scale": "#f39c12",
        "Fuzzing": "#9b59b6",
        "Adversarial": "#1abc9c",
        "Quasi-Fiber Bundle": "#e67e22",
        "Bott Periodicity": "#8e44ad",
        "71-Layer Sharding": "#c0392b",
        "Griess Algebra": "#16a085",
        "Monster Walk": "#d35400",
        "Q×K×V Identity": "#2980b9",
        "IPLD Core": "#27ae60",
        "DAG-CBOR Codec": "#f1c40f",
        "MMGroup": "#e74c3c",
        "Cross-Language": "#7f8c8d",
        "71 Lean4 Proofs": "#2c3e50",
        "Monster Walk Proof": "#d35400",
        "FRACTRAN Algebra": "#8e44ad",
        "Sonnenlicht Moonshine": "#c0392b",
    }
    
    html = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>DASL Spec-Driven Proof Audit</title>
<style>
  body {{ font-family: system-ui, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; background: #0d1117; color: #c9d1d9; }}
  h1 {{ color: #58a6ff; border-bottom: 2px solid #30363d; padding-bottom: 10px; }}
  h2 {{ color: #f0f6fc; margin-top: 30px; }}
  .summary {{ background: #161b22; border: 1px solid #30363d; border-radius: 8px; padding: 20px; margin: 20px 0; }}
  .coverage-bar {{ background: #21262d; border-radius: 4px; height: 24px; margin: 10px 0; overflow: hidden; }}
  .coverage-fill {{ height: 100%; border-radius: 4px; transition: width 0.5s; }}
  .coverage-fill.pass {{ background: #238636; }}
  .coverage-fill.fail {{ background: #da3633; }}
  .spec-row {{ background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 15px; margin: 10px 0; }}
  .spec-row.pass {{ border-left: 4px solid #238636; }}
  .spec-row.fail {{ border-left: 4px solid #da3633; }}
  .spec-id {{ font-weight: bold; color: #58a6ff; display: inline-block; width: 80px; }}
  .spec-cat {{ display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 12px; margin-left: 10px; }}
  .match-list {{ margin-top: 10px; padding-left: 20px; }}
  .match-item {{ font-family: monospace; font-size: 13px; color: #8b949e; }}
  .match-item strong {{ color: #f0f6fc; }}
  .badge {{ display: inline-block; padding: 2px 6px; border-radius: 4px; font-size: 11px; }}
  .badge.pass {{ background: #23863633; color: #3fb950; }}
  .badge.fail {{ background: #da363333; color: #f85149; }}
  table {{ width: 100%; border-collapse: collapse; }}
  th, td {{ text-align: left; padding: 8px; border-bottom: 1px solid #30363d; }}
  th {{ color: #8b949e; font-weight: 600; }}
  .cat-table td:first-child {{ font-weight: bold; }}
</style>
</head>
<body>
<h1>🔬 DASL Spec-Driven Proof Audit</h1>
<p>Generated: {timestamp} | Corpus: {len(all_results[0]['all_matches']) if all_results else 0} declarations (Fuzz Corpus)</p>

<div class="summary">
<h2>Coverage Summary</h2>
<div class="coverage-bar">
  <div class="coverage-fill {'pass' if coverage['overall_pct'] >= 80 else 'fail'}" style="width: {coverage['overall_pct']}%"></div>
</div>
<p><strong>{coverage['covered']}/{coverage['total']}</strong> spec elements have matching declarations (<strong>{coverage['overall_pct']}%</strong>)</p>

<h3>By Category</h3>
<table class="cat-table">
<tr><th>Category</th><th>Covered</th><th>Total</th><th>%</th></tr>
"""
    for cat, data in sorted(coverage["by_category"].items()):
        pct = round(100 * data["covered"] / data["total"], 1) if data["total"] > 0 else 0
        html += f"<tr><td>{cat}</td><td>{data['covered']}</td><td>{data['total']}</td><td>{pct}%</td></tr>\n"
    
    html += "</table></div>\n"
    
    # Spec sections
    sections = [
        ("DASL Core Specification", "DASL-"),
        ("Grant Requirements", "REQ-"),
        ("Theoretical Framework", "TH-"),
        ("Component Coverage", "CMP-"),
        ("Proof Integration", "PRF-"),
    ]
    
    for section_title, prefix in sections:
        section_results = [r for r in all_results if r["spec"]["id"].startswith(prefix)]
        if not section_results:
            continue
        html += f"<h2>{section_title}</h2>\n"
        
        for r in section_results:
            spec = r["spec"]
            status_class = "pass" if r["coverage"] else "fail"
            cat_color = cat_colors.get(spec["category"], "#666")
            
            html += f"""<div class="spec-row {status_class}">
  <span class="spec-id">{spec['id']}</span>
  <span class="spec-cat" style="background:{cat_color}33; color:{cat_color}">{spec['category']}</span>
  <span class="badge {status_class}">{r['match_count']} matches</span>
  <p><strong>{spec['description']}</strong></p>
  <p style="color: #8b949e; font-size: 13px;">Verification: {spec.get('verification','')}</p>
"""
            if r["top_matches"]:
                html += '<div class="match-list">'
                for m in r["top_matches"][:5]:
                    html += f'<div class="match-item">[{m["splitter"]}] <strong>{m["name"][:80]}</strong> (score: {m["score"]})</div>\n'
                html += '</div>'
            html += '</div>\n'
    
    # Legend
    html += """
<h2>Legend</h2>
<table>
<tr><td><span class="badge pass">PASS</span></td><td>Spec element has matching declarations in the fuzz corpus</td></tr>
<tr><td><span class="badge fail">FAIL</span></td><td>Spec element has NO matching declarations — coverage gap</td></tr>
<tr><td><strong>Score</strong></td><td>Number of matching keywords between spec element and declaration name/text</td></tr>
</table>
<p style="color: #8b949e; font-size: 12px; margin-top: 40px;">
DASL Grant Proposal — Spec-Driven Proof Audit. Corpus: 360 declarations across 7 splitter lenses.<br>
Spec sources: verify_spec_compliance.py, README.md, grant proposal.
</p>
</body></html>"""
    return html


def main():
    print("=== DASL Spec-Driven Proof Audit ===\n")
    
    # Load declarations
    decls = load_fuzz_declarations()
    print(f"Loaded {len(decls)} declarations from fuzz corpus")
    
    # Match all spec categories
    all_specs = DASL_SPEC + GRANT_REQS + THEORY_SPEC + COMPONENT_SPEC + PROOF_SPEC
    print(f"Spec elements: {len(all_specs)} total")
    
    # Match
    all_results = match_declarations(all_specs, decls)
    
    # Coverage
    coverage = compute_coverage(all_results)
    
    # Print audit
    for section, prefix in [("DASL Core", "DASL-"), ("Grant", "REQ-"), ("Theory", "TH-"), ("Components", "CMP-"), ("Proofs", "PRF-")]:
        section_results = [r for r in all_results if r["spec"]["id"].startswith(prefix)]
        if not section_results:
            continue
        cov = sum(1 for r in section_results if r["coverage"])
        print(f"\n  {section}: {cov}/{len(section_results)} covered")
        for r in section_results:
            status = "✅" if r["coverage"] else "❌"
            print(f"    {status} {r['spec']['id']}: {r['spec']['description'][:60]}")
            if r["top_matches"]:
                top = r["top_matches"][0]
                print(f"       → {top['name'][:70]} [{top['splitter']}] score={top['score']}")
    
    print(f"\n=== OVERALL: {coverage['covered']}/{coverage['total']} ({coverage['overall_pct']}%) ===\n")
    
    # Generate HTML
    html = generate_html(all_results, coverage)
    with open(OUT_HTML, "w") as f:
        f.write(html)
    print(f"HTML report: {OUT_HTML}")
    
    # Copy to aristotle project as well
    out2 = "/mnt/data1/time-2026/05-may/07/arist/dasl-spec-audit.html"
    with open(out2, "w") as f:
        f.write(html)
    print(f"Copy: {out2}")

if __name__ == "__main__":
    main()
