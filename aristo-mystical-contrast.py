#!/usr/bin/env python3
"""
Contrast analysis: successful mystical formalizations vs. failures.

Research question: Why did Tao Te Ching, Zappa Sofa, and Shem HaMephorash succeed
while Transmission Ω was called "evocative poetry"?

Hypothesis: Mystical content succeeds when framed as "descriptive logic of essence" —
  - Terms/concepts are definable as an enumeration (Concept enum, term list)
  - Relations are structurable as typed fields (Cosmos structure, FiniteSimpleGroupChair)
  - Each claim is a proposition over these primitives (chapterN : Cosmos → Prop)
  It fails when framed as story without constraint:
  - Narrative links (Bott periodicity, Hecke operators, IPLD hashes) have no
    formal connection to the primitives
  - "Evocative analogy" vs "descriptive logic"

Output: /mnt/data1/aristotle-results/aristo-mystical-contrast.json
"""
import os, json
from pathlib import Path

BASE = "/mnt/data1/aristotle-results/aristo-outputs"
OUT_JSON = "/mnt/data1/aristotle-results/aristo-mystical-contrast.json"

# Projects with mystical/philosophical content
MYSTICAL_SUCCESS = ["a0392934", "48a1653a", "3cd7879d"]  # Tao, Zappa, Shem
MYSTICAL_FAILURE = ["69713c5d"]  # Transmission Omega

def extract_lean_structure(proj_prefix):
    """Extract namespace, definitions, theorems from .lean files."""
    proj_dir = None
    for d in os.listdir(BASE):
        if d.startswith(proj_prefix):
            proj_dir = os.path.join(BASE, d)
            break
    if not proj_dir:
        return None
    
    info = {
        "files": [],
        "namespaces": [],
        "defs": [],
        "theorems": [],
        "structures": [],
        "inductives": [],
    }
    
    for root, dirs, files in os.walk(proj_dir):
        for f in files:
            if not f.endswith(".lean"):
                continue
            path = os.path.join(root, f)
            rel = os.path.relpath(path, proj_dir)
            try:
                text = open(path).read()
            except:
                continue
            
            file_info = {"path": rel, "size": len(text.splitlines())}
            
            for line in text.splitlines():
                stripped = line.strip()
                if stripped.startswith("namespace "):
                    ns = stripped.replace("namespace ", "").strip()
                    if ns not in info["namespaces"]:
                        info["namespaces"].append(ns)
                elif stripped.startswith("def ") and " : " in stripped:
                    info["defs"].append(stripped[:120])
                elif stripped.startswith("theorem ") or stripped.startswith("lemma "):
                    info["theorems"].append(stripped[:120])
                elif stripped.startswith("structure "):
                    info["structures"].append(stripped[:120])
                elif stripped.startswith("inductive "):
                    info["inductives"].append(stripped[:120])
            
            info["files"].append(file_info)
    
    return info

def extract_summary_essence(proj_prefix):
    """Extract the 'essence logic' framing from SUMMARY.md."""
    proj_dir = None
    for d in os.listdir(BASE):
        if d.startswith(proj_prefix):
            proj_dir = os.path.join(BASE, d)
            break
    if not proj_dir:
        return None
    
    # Find SUMMARY.md
    for root, dirs, files in os.walk(proj_dir):
        if "ARISTOTLE_SUMMARY.md" in files:
            text = open(os.path.join(root, "ARISTOTLE_SUMMARY.md")).read()
            # Extract key framing phrases
            framing = []
            for line in text.splitlines():
                lower = line.lower().strip()
                if any(kw in lower for kw in [
                    "framework", "structure", "enumeration", "primitive",
                    "relation", "property", "proposition", "definition",
                    "axiom", "formalize", "declare", "define", "encode",
                    "realized as", "captured as", "model", "interpretation",
                    "each chapter", "each term", "every primitive",
                    "genuinely", "verifiable", "well-posed", "self-contained"
                ]):
                    framing.append(line.strip()[:200])
            return {
                "full_summary": text[:3000],
                "framing_phrases": framing[:30],
            }
    return None


results = {
    "successful": [],
    "failed": [],
}

for pid in MYSTICAL_SUCCESS:
    print(f"=== SUCCESS: {pid} ===")
    lean = extract_lean_structure(pid)
    summary = extract_summary_essence(pid)
    entry = {
        "project_id": pid,
        "lean_structure": lean,
        "summary_framing": summary,
    }
    results["successful"].append(entry)
    if lean:
        print(f"  Files: {len(lean['files'])}")
        print(f"  Namespaces: {lean['namespaces']}")
        print(f"  Defs: {len(lean['defs'])}, Theorems: {len(lean['theorems'])}")
        print(f"  Structures: {len(lean['structures'])}, Inductives: {len(lean['inductives'])}")
    if summary and summary.get("framing_phrases"):
        print(f"  Framing: {summary['framing_phrases'][:3]}")

for pid in MYSTICAL_FAILURE:
    print(f"\n=== FAILURE: {pid} ===")
    lean = extract_lean_structure(pid)
    summary = extract_summary_essence(pid)
    entry = {
        "project_id": pid,
        "lean_structure": lean,
        "summary_framing": summary,
    }
    results["failed"].append(entry)
    if lean:
        print(f"  Files: {len(lean['files'])}")
        print(f"  Namespaces: {lean['namespaces']}")
    if summary and summary.get("framing_phrases"):
        print(f"  Framing phrases: {summary['framing_phrases'][:5]}")

with open(OUT_JSON, "w") as f:
    json.dump(results, f, indent=2)
print(f"\nSaved to {OUT_JSON}")

# Analysis
print("\n" + "="*60)
print("CONTRAST: Mystical Success vs. Failure")
print("="*60)
print("""
SUCCESS PATTERNS (Tao, Zappa, Shem):
  - Primitive terms defined as ENUMERATION (Concept enum, term→prime list)
  - Relations as STRUCTURE FIELDS (Cosmos carries typed relations)
  - Claims as PROPOSITIONS over primitives (chapterN : Cosmos → Prop)
  - "Each chapter's English translation is recorded in a docstring and is
    the source of its encoding" — text as data, not as authority
  - "On using a new axiom for each term you cannot define: I do not use Lean
    axiom declarations... each undefined term is realized as a field of the
    parameter structure Cosmos" — primitives are parameters, not axioms

FAILURE PATTERNS (Transmission Omega):
  - "Evocative poetry rather than well-posed mathematics"
  - "No actual constraint linking a product of primes to a chosen residue
    triple, to a Bott-periodicity value, to a fixed content hash"
  - Narrative links are just references, not formal relations
  - Fixed when: user extracted specific arithmetic claims with formal
    constraints (prime factorizations, CRT equations)

THE ESSENCE-LOGIC PATTERN:
  1. Enumerate all primitive terms → inductive type / list
  2. Define all relations → structure fields with types
  3. Express each claim → proposition referencing primitives + relations
  4. Docstrings record the original text → text as data, not authority
  5. No "axiom" declarations → primitives are parameters, not assumptions
""")

if __name__ == "__main__":
    pass
