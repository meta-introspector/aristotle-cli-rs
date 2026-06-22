#!/usr/bin/env python3
"""
Aristotle Gnostic Glossary — extracts all non-standard/cryptographic terms
from Aristotle's refusals, compares against WordNet/Wiktionary, and documents
which terms fall outside standard English dictionaries.

Strategy:
  1. Extract all capitalized terms, camelCase terms, and compound terms
     from ARISTOTLE_SUMMARY.md + .lean comments across all 11 projects.
  2. Look up each term in NLTK WordNet.
  3. Flag terms not found in WordNet as "undefined".
  4. For each undefined term, extract usage context and document:
     - what category it belongs to (crypto, math, gnostic, legal, etc.)
     - how Aristotle used it
     - what other terms it depends on or relates to
  5. Output a structured glossary JSON.

Output: /mnt/data1/aristotle-results/aristo-gnostic-glossary.json
"""
import os, re, json, sys
from pathlib import Path
from collections import defaultdict, Counter

BASE = "/mnt/data1/aristotle-results/aristo-outputs"
OUT_JSON = "/mnt/data1/aristotle-results/aristo-gnostic-glossary.json"

# ── Term extraction patterns ──
CAMEL_CASE = re.compile(r'\b([A-Z][a-z]+[A-Z][a-zA-Z]*|[a-z]+[A-Z][a-zA-Z]*)\b')
CAPITALIZED = re.compile(r'\b[A-Z][a-z]{3,}\b')  # Proper noun candidates
COMPOUND = re.compile(r'\b[a-z]+[-–][a-z]+\b')   # hyphenated compounds
BACKTICK = re.compile(r'`([^`]+)`')              # `code-quoted` terms
UNDERSCORE = re.compile(r'\b[a-z]+_[a-z]+\b')    # snake_case terms

# Known Lean/Mathlib terms to skip (common)
SKIP_TERMS = {
    "lean", "mathlib", "requestproject", "namespace", "open", "import",
    "set_option", "theorem", "lemma", "def", "inductive", "structure",
    "axiom", "sorry", "propext", "classical", "quot", "fin", "nat",
    "int", "bool", "list", "string", "prop", "type", "true", "false",
    "and", "or", "not", "forall", "exists", "aristo", "aristotle",
    "svg", "html", "png", "xml", "lake", "lakefile", "toml",
    "also", "already", "always", "never", "sometimes", "often", "yet",
    "still", "really", "actually", "simply", "maybe", "probably",
    "certainly", "definitely", "clearly", "perhaps", "indeed", "however",
    "therefore", "thus", "hence", "consequently", "moreover", "furthermore",
    "nevertheless", "nonetheless", "because", "since", "although",
}

def extract_terms(text):
    """Extract all candidate non-standard terms from text."""
    found = Counter()
    
    # CamelCase terms (most important for gnostic/crypto)
    for m in CAMEL_CASE.finditer(text):
        term = m.group(1)
        if term.lower() not in SKIP_TERMS and len(term) > 3:
            found[term] += 1
    
    # Backtick-quoted terms
    for m in BACKTICK.finditer(text):
        term = m.group(1)
        if term.lower() not in SKIP_TERMS and len(term) > 2:
            found[term] += 1
    
    # Capitalized proper nouns
    for m in CAPITALIZED.finditer(text):
        term = m.group(0)
        if term.lower() not in SKIP_TERMS:
            found[term] += 1
    
    # Hyphenated compounds
    for m in COMPOUND.finditer(text):
        term = m.group(0)
        if term.lower() not in SKIP_TERMS:
            found[term] += 1
    
    # snake_case
    for m in UNDERSCORE.finditer(text):
        term = m.group(0)
        if term.lower() not in SKIP_TERMS:
            found[term] += 1
    
    return found


def context_for_term(text, term, window=150):
    """Extract surrounding context where term appears."""
    contexts = []
    idx = 0
    while True:
        idx = text.find(term, idx)
        if idx == -1:
            break
        start = max(0, idx - window)
        end = min(len(text), idx + len(term) + window)
        ctx = text[start:end].strip()
        contexts.append(ctx)
        idx += len(term)
    return contexts[:5]  # max 5 contexts


def try_wordnet(term):
    """Check if term appears in WordNet."""
    try:
        from nltk.corpus import wordnet as wn
        # Try lowercase
        synsets = wn.synsets(term.lower())
        if synsets:
            return {
                "found": True,
                "definitions": [s.definition() for s in synsets[:3]],
                "pos": [s.pos() for s in synsets[:3]],
            }
        # Try with underscores for multi-word
        synsets = wn.synsets(term.lower().replace(" ", "_"))
        if synsets:
            return {
                "found": True,
                "definitions": [s.definition() for s in synsets[:3]],
                "pos": [s.pos() for s in synsets[:3]],
            }
        return {"found": False}
    except ImportError:
        return {"found": False, "error": "nltk/wordnet not available"}
    except Exception as e:
        return {"found": False, "error": str(e)}


def categorize_term(term):
    """Guess the category of a term based on patterns."""
    cats = []
    lower = term.lower()
    
    if any(kw in lower for kw in ["godel", "hash", "crt", "prime", "factor",
                                     "mod", "residue", "cipher", "encrypt", "decode",
                                     "decoder", "crypto", "ring", "key", "shard"]):
        cats.append("cryptographic")
    
    if any(kw in lower for kw in ["spoke", "transmission", "omega", "zownakairufication",
                                     "kryptoeffnung", "moonshine", "sofa", "bott",
                                     "periodicity", "hecke", "griess", "monster"]):
        cats.append("gnostic/mystical")
    
    if any(kw in lower for kw in ["sheaf", "section", "lattice", "betti", "matrix",
                                     "vector", "graph", "representation", "irrep",
                                     "functor", "category", "skeleton"]):
        cats.append("mathematical")
    
    if any(kw in lower for kw in ["statute", "law", "nj", "rullca", "bill", "federal",
                                     "legal", "citation", "solfunmeme"]):
        cats.append("legal")
    
    if any(kw in lower for kw in ["dao", "tao", "cosmos", "sage", "heaven", "virtue",
                                     "shem", "kabbalah", "exodus", "angel"]):
        cats.append("philosophical/religious")
    
    if any(kw in lower for kw in ["ipld", "car", "shmem", "cid", "http", "rest", "api",
                                     "json", "rust", "python", "nix"]):
        cats.append("engineering")
    
    return cats if cats else ["uncategorized"]


def main():
    projects = sorted(d for d in os.listdir(BASE) if d.endswith("_aristotle"))
    
    # Phase 1: Extract all terms
    all_terms = Counter()
    term_contexts = defaultdict(list)
    
    for proj in projects:
        sid = proj[:8]
        proj_dir = os.path.join(BASE, proj)
        
        # Read SUMMARY.md + all .lean comments
        for root, dirs, files in os.walk(proj_dir):
            for f in files:
                path = os.path.join(root, f)
                ext = os.path.splitext(f)[1]
                if ext not in (".md", ".lean"):
                    continue
                try:
                    text = open(path).read()
                except:
                    continue
                
                if ext == ".lean":
                    # Extract only comments
                    lines = [l.strip() for l in text.splitlines()
                             if l.strip().startswith("-- ") or l.strip().startswith("/-")]
                    text = "\n".join(lines)
                
                terms = extract_terms(text)
                all_terms.update(terms)
                
                for term, count in terms.items():
                    ctxs = context_for_term(text, term)
                    for ctx in ctxs:
                        term_contexts[term].append({
                            "project": sid,
                            "file": os.path.relpath(path, proj_dir)[:80],
                            "context": ctx[:300],
                        })
    
    print(f"Total candidate terms: {len(all_terms)}")
    
    # Phase 2: Look up top terms in WordNet
    top_terms = all_terms.most_common(200)
    
    glossary = []
    undefined = []
    defined = []
    
    for term, freq in top_terms:
        if freq < 2:
            continue  # Skip singletons
        
        wn_result = try_wordnet(term)
        categories = categorize_term(term)
        contexts = term_contexts[term][:3]
        
        entry = {
            "term": term,
            "frequency": freq,
            "categories": categories,
            "wordnet": wn_result,
            "usage_contexts": contexts,
        }
        
        if wn_result.get("found"):
            defined.append(entry)
        else:
            undefined.append(entry)
        
        glossary.append(entry)
    
    print(f"  Defined (WordNet): {len(defined)}")
    print(f"  UNDEFINED: {len(undefined)}")
    
    # Phase 3: Organize by category
    by_category = defaultdict(list)
    for entry in undefined:
        for cat in entry["categories"]:
            by_category[cat].append(entry)
    
    print(f"\n=== UNDEFINED TERMS BY CATEGORY ===")
    for cat in sorted(by_category.keys()):
        terms = [e["term"] for e in by_category[cat]]
        print(f"  {cat} ({len(terms)}): {', '.join(terms[:15])}")
    
    # Phase 4: Build dependency graph (what terms co-occur?)
    print(f"\n=== TERM CO-OCCURRENCE (undefined terms that appear together) ===")
    cooccur = defaultdict(Counter)
    undefined_terms = {e["term"] for e in undefined}
    
    for proj in projects:
        proj_dir = os.path.join(BASE, proj)
        for root, dirs, files in os.walk(proj_dir):
            for f in files:
                if f != "ARISTOTLE_SUMMARY.md":
                    continue
                try:
                    text = open(os.path.join(root, f)).read()
                except:
                    continue
                # Find all undefined terms in this file
                present = [t for t in undefined_terms if t in text]
                for t1 in present:
                    for t2 in present:
                        if t1 < t2:
                            cooccur[t1][t2] += 1
    
    # Top co-occurring pairs
    cooccur_pairs = []
    for t1, neighbors in cooccur.items():
        for t2, count in neighbors.most_common(5):
            cooccur_pairs.append({"term_a": t1, "term_b": t2, "count": count})
    cooccur_pairs.sort(key=lambda x: -x["count"])
    
    for pair in cooccur_pairs[:30]:
        print(f"  {pair['term_a']:30s} ←→ {pair['term_b']:30s} ({pair['count']}x)")
    
    # Write output
    output = {
        "total_terms": len(all_terms),
        "defined_count": len(defined),
        "undefined_count": len(undefined),
        "by_category": {cat: [e["term"] for e in entries] for cat, entries in by_category.items()},
        "cooccurrence": cooccur_pairs[:50],
        "glossary": glossary,
    }
    
    with open(OUT_JSON, "w") as f:
        json.dump(output, f, indent=2, default=str)
    print(f"\nSaved glossary to {OUT_JSON}")
    
    # Phase 5: Print the undefined glossary
    print(f"\n{'='*60}")
    print("UNDEFINED GNOSTIC GLOSSARY")
    print(f"{'='*60}")
    for entry in undefined:
        print(f"\n── {entry['term']} (×{entry['frequency']}) [{', '.join(entry['categories'])}]")
        if entry["wordnet"].get("error"):
            print(f"   WordNet: {entry['wordnet']['error']}")
        for ctx in entry["usage_contexts"][:2]:
            print(f"   Context: ...{ctx['context'][:200]}...")
        if len(entry["usage_contexts"]) > 2:
            print(f"   (+ {len(entry['usage_contexts']) - 2} more contexts)")

if __name__ == "__main__":
    main()
