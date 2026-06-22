#!/usr/bin/env python3
"""
Aristotle Gnostic Glossary v2 — with Gnostic Library + notebooklm sources.

Sources:
  1. All 13 Aristotle project outputs (SUMMARY.md + .lean comments)
  2. Clovis Star Gnostic Library (~/2026/06/22/gnostic-library/books/)
  3. notebooklm corpus (~/notebooklm/aristo.txt, dasl-consolidated/)
  4. WordNet (optional, if nltk installed)

For each undefined term, provides:
  - Aristotle usage context (how the term was used in prompts/responses)
  - Gnostic Library definition (from canonical sources)
  - notebooklm context (Monster group, supersingular primes, etc.)
  - Categorization (gnostic/mystical, cryptographic, mathematical, legal, engineering)
  - Co-occurrence data (what other terms appear together)

Output: /mnt/data1/aristotle-results/aristo-gnostic-glossary-v2.json
"""
import os, re, json
from pathlib import Path
from collections import defaultdict, Counter
from html.parser import HTMLParser

# ── Config ──
BASE_ARISTO = "/mnt/data1/aristotle-results/aristo-outputs"
BASE_GNOSTIC = os.path.expanduser("~/2026/06/22/gnostic-library/books")
BASE_NOTEBOOK = os.path.expanduser("~/notebooklm")
OUT_JSON = "/mnt/data1/aristotle-results/aristo-gnostic-glossary-v2.json"

# ── HTML Text Extractor ──
class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.text = []
        self.tag_stack = []
    def handle_starttag(self, tag, attrs):
        self.tag_stack.append(tag)
        if tag in ('p', 'div', 'h1', 'h2', 'h3', 'h4', 'br', 'li', 'tr'):
            self.text.append('\n')
    def handle_endtag(self, tag):
        if self.tag_stack and self.tag_stack[-1] == tag:
            self.tag_stack.pop()
        if tag in ('p', 'div', 'h1', 'h2', 'h3', 'h4', 'br', 'li', 'tr'):
            self.text.append('\n')
    def handle_data(self, data):
        for t in self.tag_stack:
            if t in ('script', 'style'):
                return
        t = data.strip()
        if t:
            self.text.append(t + ' ')

def extract_html_text(filepath):
    """Extract readable text from an HTML file."""
    try:
        with open(filepath) as f:
            html = f.read()
        ex = TextExtractor()
        ex.feed(html)
        text = ''.join(ex.text)
        return re.sub(r'\s+', ' ', text).strip()
    except Exception:
        return ""


# ── Term Extraction (from any text) ──
CAMEL_CASE = re.compile(r'\b([A-Z][a-z]+[A-Z][a-zA-Z]*|[a-z]+[A-Z][a-zA-Z]*)\b')
BACKTICK = re.compile(r'`([^`]+)`')
CAPITALIZED = re.compile(r'\b[A-Z][a-z]{3,}\b')

SKIP_TERMS = {
    "lean", "mathlib", "requestproject", "namespace", "open", "import",
    "set_option", "theorem", "lemma", "def", "inductive", "structure",
    "axiom", "sorry", "propext", "classical", "quot", "fin", "nat",
    "int", "bool", "list", "string", "prop", "type", "true", "false",
    "and", "or", "not", "forall", "exists", "aristo", "aristotle",
    "svg", "html", "png", "xml", "lake", "lakefile", "toml",
    "this", "that", "these", "those", "what", "when", "where", "which",
    "with", "from", "have", "been", "were", "they", "their", "them",
    "about", "also", "each", "other", "some", "such", "only", "same",
    "into", "over", "after", "before", "between", "through", "during",
    "chapter", "section", "summary", "changes", "project", "file",
    "main", "what", "these", "those", "both", "full", "state",
    "standard", "package", "worked", "regenerate", "verified",
    "everything", "threshold", "tour", "gallery", "comic", "stage",
}

def extract_terms(text):
    found = Counter()
    for m in CAMEL_CASE.finditer(text):
        term = m.group(1)
        if term.lower() not in SKIP_TERMS and len(term) > 3:
            found[term] += 1
    for m in BACKTICK.finditer(text):
        term = m.group(1)
        if term.lower() not in SKIP_TERMS and len(term) > 2:
            found[term] += 1
    for m in CAPITALIZED.finditer(text):
        term = m.group(0)
        if term.lower() not in SKIP_TERMS:
            found[term] += 1
    return found


# ── Category guesser ──
def categorize_term(term):
    cats = []
    lower = term.lower()
    gnostic_markers = [
        "spoke", "transmission", "omega", "zownakairufication", "kryptoeffnung",
        "moonshine", "sofa", "bott", "hecke", "griess", "monster", "pleroma",
        "demiurge", "abraxas", "sophia", "archon", "gnosis", "pistis",
        "yaldabaoth", "pleromic", "aeon", "nous", "bythos", "sige", "logos",
        "horos", "stauros", "protennoia", "barbelo", "autogenes", "adamas",
        "sabaoth", "iaos", "elohim", "seth", "norea", "trimorphic", "allogenes",
        "zostrianos", "marsanes", "melchizedek", "valentinus", "valentinian",
        "ophite", "naassene", "basilides", "marcion", "hermetica", "poimandres",
        "spark", "shard", "zappa", "swirl", "cosmosofa", "harmonics",
    ]
    crypto_markers = [
        "godel", "hash", "crt", "prime", "factor", "mod", "residue",
        "cipher", "encrypt", "decode", "decoder", "crypto", "ring", "key",
        "shard", "signature", "witness", "zk", "commitment", "merkle",
    ]
    math_markers = [
        "sheaf", "section", "lattice", "betti", "matrix", "vector", "graph",
        "representation", "irrep", "functor", "category", "skeleton",
        "homology", "cohomology", "graded", "spectral", "modular",
        "elliptic", "jacobi", "theta", "fourier", "automorphic",
    ]
    legal_markers = [
        "statute", "law", "nj", "rullca", "bill", "federal", "legal",
        "citation", "solfunmeme", "dao", "governance", "compliance",
    ]
    philo_markers = [
        "dao", "tao", "cosmos", "sage", "heaven", "virtue", "shem",
        "kabbalah", "exodus", "angel", "laozi", "chapter", "concept",
    ]
    eng_markers = [
        "ipld", "car", "shmem", "cid", "http", "rest", "api", "json",
        "rust", "python", "nix", "flake", "docker", "kubernetes",
    ]
    for kw in gnostic_markers:
        if kw in lower:
            cats.append("gnostic/mystical")
            break
    for kw in crypto_markers:
        if kw in lower:
            cats.append("cryptographic")
            break
    for kw in math_markers:
        if kw in lower:
            cats.append("mathematical")
            break
    for kw in legal_markers:
        if kw in lower:
            cats.append("legal")
            break
    for kw in philo_markers:
        if kw in lower:
            cats.append("philosophical/religious")
            break
    for kw in eng_markers:
        if kw in lower:
            cats.append("engineering")
            break
    return cats if cats else ["uncategorized"]


# ── Main ──
def main():
    # ---- Phase 1: Load Gnostic Library definitions ----
    print("Loading Gnostic Library...")
    gnostic_texts = {}
    # Load ALL books with text.html
    for book_dir in sorted(os.listdir(BASE_GNOSTIC)):
        path = os.path.join(BASE_GNOSTIC, book_dir, "text.html")
        if os.path.isfile(path):
            text = extract_html_text(path)
            if text and len(text) > 100:
                gnostic_texts[book_dir] = text

    print(f"  Loaded {len(gnostic_texts)} gnostic source texts")

    # Build gnostic term index
    gnostic_terms = {}
    for book, text in gnostic_texts.items():
        terms = extract_terms(text)
        for term in terms:
            if term not in gnostic_terms:
                gnostic_terms[term] = []
            gnostic_terms[term].append(book)

    # ---- Phase 2: Load notebooklm sources ----
    print("Loading notebooklm sources...")
    nb_texts = {}
    nb_files = ["aristo.txt", "all.txt"]
    for nf in nb_files:
        path = os.path.join(BASE_NOTEBOOK, nf)
        if os.path.exists(path):
            try:
                with open(path) as f:
                    nb_texts[nf] = f.read()
            except:
                pass
    # Also check dasl-consolidated
    dasl_dir = os.path.join(BASE_NOTEBOOK, "dasl-consolidated")
    if os.path.isdir(dasl_dir):
        for nf in os.listdir(dasl_dir):
            if nf.endswith(".txt") or nf.endswith(".md"):
                try:
                    with open(os.path.join(dasl_dir, nf)) as f:
                        nb_texts[f"dasl/{nf}"] = f.read()
                except:
                    pass
    print(f"  Loaded {len(nb_texts)} notebooklm source files")

    # ---- Phase 3: Load Aristotle project texts ----
    print("Loading Aristotle project texts...")
    projects = sorted(d for d in os.listdir(BASE_ARISTO) if d.endswith("_aristotle"))
    aristo_texts = {}
    aristo_terms = Counter()
    term_contexts = defaultdict(list)

    for proj in projects:
        sid = proj[:8]
        proj_dir = os.path.join(BASE_ARISTO, proj)
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
                    lines = [l.strip() for l in text.splitlines()
                             if l.strip().startswith("-- ") or l.strip().startswith("/-")]
                    text = "\n".join(lines)

                rel = os.path.relpath(path, proj_dir)[:80]
                aristo_texts[f"{sid}/{rel}"] = text

                terms = extract_terms(text)
                aristo_terms.update(terms)

                for term in terms:
                    idx = text.find(term)
                    if idx >= 0:
                        start = max(0, idx - 60)
                        end = min(len(text), idx + len(term) + 80)
                        term_contexts[term].append({
                            "project": sid,
                            "context": text[start:end].strip()[:200],
                        })

    print(f"  Loaded {len(aristo_texts)} Aristotle text fragments")
    print(f"  {len(aristo_terms)} unique terms from Aristotle")

    # ---- Phase 4: Build the glossary ----
    print("Building glossary...")
    glossary = []

    top_terms = aristo_terms.most_common(300)
    for term, aristo_freq in top_terms:
        if aristo_freq < 2:
            continue

        cats = categorize_term(term)
        entry = {
            "term": term,
            "frequency_aristotle": aristo_freq,
            "categories": cats,
            "aristotle_contexts": term_contexts[term][:3],
        }

        # Gnostic library definitions
        if term in gnostic_terms:
            entry["gnostic_sources"] = gnostic_terms[term]
            # Get a definition snippet
            for book in gnostic_terms[term][:3]:
                if book in gnostic_texts:
                    text = gnostic_texts[book]
                    idx = text.lower().find(term.lower())
                    if idx >= 0:
                        snippet = text[max(0,idx-80):idx+len(term)+200].strip()
                        entry.setdefault("gnostic_definitions", {})[book] = snippet[:300]

        # notebooklm hits
        nb_hits = []
        for nb_name, nb_text in nb_texts.items():
            if term in nb_text:
                idx = nb_text.find(term)
                snippet = nb_text[max(0,idx-40):idx+len(term)+120].strip()
                nb_hits.append({"source": nb_name, "snippet": snippet[:200]})
        if nb_hits:
            entry["notebooklm_hits"] = nb_hits[:3]

        glossary.append(entry)

    # ---- Phase 5: Co-occurrence ----
    cooccur = defaultdict(Counter)
    all_aristo_terms = {e["term"] for e in glossary}
    for key, text in aristo_texts.items():
        present = [t for t in all_aristo_terms if t in text]
        for t1 in present:
            for t2 in present:
                if t1 < t2:
                    cooccur[t1][t2] += 1

    cooccur_pairs = []
    for t1, neighbors in cooccur.items():
        for t2, count in neighbors.most_common(3):
            if count >= 2:
                cooccur_pairs.append({"term_a": t1, "term_b": t2, "count": count})
    cooccur_pairs.sort(key=lambda x: -x["count"])

    # ---- Phase 6: Stats ----
    by_category = defaultdict(list)
    gnostic_defined = 0
    for entry in glossary:
        for cat in entry["categories"]:
            by_category[cat].append(entry["term"])
        if "gnostic_sources" in entry:
            gnostic_defined += 1

    print(f"\n=== GLOSSARY STATS ===")
    print(f"  Total glossary entries: {len(glossary)}")
    print(f"  Found in Gnostic Library: {gnostic_defined}")
    print(f"  Found in notebooklm: {sum(1 for e in glossary if 'notebooklm_hits' in e)}")
    for cat, terms in sorted(by_category.items()):
        print(f"  {cat}: {len(terms)} terms")

    # ---- Write output ----
    output = {
        "total_entries": len(glossary),
        "gnostic_library_defined": gnostic_defined,
        "sources": {
            "gnostic_library": len(gnostic_texts),
            "notebooklm": len(nb_texts),
            "aristotle_projects": len(projects),
        },
        "by_category": {cat: terms for cat, terms in by_category.items()},
        "cooccurrence": cooccur_pairs[:50],
        "glossary": glossary,
    }

    with open(OUT_JSON, "w") as f:
        json.dump(output, f, indent=2, default=str)
    print(f"\nSaved to {OUT_JSON}")

    # Print gnostic terms with library definitions
    print(f"\n=== GNOSTIC TERMS WITH LIBRARY DEFINITIONS ===")
    for entry in glossary:
        if "gnostic_sources" in entry:
            print(f"\n  {entry['term']} ({', '.join(entry['categories'])})")
            print(f"    Aristotle: ×{entry['frequency_aristotle']}")
            for book, defn in entry.get("gnostic_definitions", {}).items():
                print(f"    [{book}] {defn[:200]}...")
            if "notebooklm_hits" in entry:
                for hit in entry["notebooklm_hits"][:1]:
                    print(f"    [nb:{hit['source']}] {hit['snippet'][:150]}")

if __name__ == "__main__":
    main()
