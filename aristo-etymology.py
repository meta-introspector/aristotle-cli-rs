#!/usr/bin/env python3
"""
Aristotle Gnostic Glossary v3 — Compound Word Decomposition.

For every undefined gnostic term, split camelCase into components,
look up each component in all sources (Gnostic Library, notebooklm,
Aristotle projects), and build etymological definitions.

Then post the full report to pastebin.
"""
import os, re, json
from pathlib import Path
from collections import defaultdict, Counter
from html.parser import HTMLParser

# ── Config ──
BASE_ARISTO = "/mnt/data1/aristotle-results/aristo-outputs"
BASE_GNOSTIC = os.path.expanduser("~/2026/06/22/gnostic-library/books")
BASE_NOTEBOOK = os.path.expanduser("~/notebooklm")
OUT_JSON = "/mnt/data1/aristotle-results/aristo-gnostic-etymology.json"

# ── HTML Text Extractor (fixed) ──
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
    try:
        with open(filepath) as f:
            html = f.read()
        ex = TextExtractor()
        ex.feed(html)
        text = ''.join(ex.text)
        return re.sub(r'\s+', ' ', text).strip()
    except:
        return ""

# ── CamelCase splitter ──
def split_camelcase(term):
    """Split camelCase/PascalCase into component words."""
    # Split on uppercase boundaries
    parts = re.findall(r'[A-Z][a-z]*|[a-z]+|[0-9]+', term)
    # Merge single uppercase followed by lowercase
    merged = []
    i = 0
    while i < len(parts):
        if i + 1 < len(parts) and re.match(r'^[A-Z]$', parts[i]) and re.match(r'^[a-z]', parts[i+1]):
            merged.append(parts[i] + parts[i+1])
            i += 2
        else:
            merged.append(parts[i])
            i += 1
    return [m.lower() for m in merged if len(m) > 1]

def count_word_in_texts(word, texts):
    """Count occurrences of word across a dict of {name: text}."""
    hits = []
    for name, text in texts.items():
        count = text.lower().count(word.lower())
        if count > 0:
            idx = text.lower().find(word.lower())
            if idx >= 0:
                snippet = text[max(0,idx-60):idx+len(word)+100].strip()
                hits.append({"source": name, "count": count, "context": snippet[:200]})
    return sorted(hits, key=lambda h: -h["count"])

# ── Main ──
def main():
    # ---- Load all sources ----
    print("Loading sources...")
    
    # Gnostic Library
    gnostic_texts = {}
    for book_dir in sorted(os.listdir(BASE_GNOSTIC)):
        path = os.path.join(BASE_GNOSTIC, book_dir, "text.html")
        if os.path.isfile(path):
            text = extract_html_text(path)
            if text and len(text) > 100:
                gnostic_texts[book_dir] = text
    print(f"  Gnostic Library: {len(gnostic_texts)} texts")
    
    # notebooklm
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
    dasl_dir = os.path.join(BASE_NOTEBOOK, "dasl-consolidated")
    if os.path.isdir(dasl_dir):
        for nf in os.listdir(dasl_dir):
            if nf.endswith(".txt") or nf.endswith(".md"):
                try:
                    with open(os.path.join(dasl_dir, nf)) as f:
                        nb_texts[f"dasl/{nf}"] = f.read()
                except:
                    pass
    print(f"  notebooklm: {len(nb_texts)} files")
    
    # Aristotle
    projects = sorted(d for d in os.listdir(BASE_ARISTO) if d.endswith("_aristotle"))
    aristo_texts = {}
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
                rel = os.path.relpath(path, proj_dir)[:80]
                aristo_texts[f"{sid}/{rel}"] = text
    print(f"  Aristotle: {len(aristo_texts)} fragments")
    
    all_texts = {}
    all_texts.update({f"gnostic/{k}": v for k, v in gnostic_texts.items()})
    all_texts.update({f"nb/{k}": v for k, v in nb_texts.items()})
    all_texts.update({f"aristo/{k}": v for k, v in aristo_texts.items()})
    
    # ---- Load existing glossary v2 ----
    with open("/mnt/data1/aristotle-results/aristo-gnostic-glossary-v2.json") as f:
        v2 = json.load(f)
    
    # Find undefined gnostic terms
    undefined = [e for e in v2["glossary"]
                 if "gnostic/mystical" in e["categories"]
                 and "gnostic_sources" not in e]
    
    print(f"\nUndefined gnostic terms to decompose: {len(undefined)}")
    
    # ---- Decompose each undefined term ----
    etymology = {}
    
    for entry in undefined:
        term = entry["term"]
        parts = split_camelcase(term)
        
        comp_defs = {}
        for part in parts:
            if len(part) < 2:
                continue
            # Look up each component
            gnostic_hits = count_word_in_texts(part, gnostic_texts)
            nb_hits = count_word_in_texts(part, nb_texts)
            aristo_hits = count_word_in_texts(part, aristo_texts)
            
            comp_defs[part] = {
                "gnostic_hits": gnostic_hits[:3],
                "nb_hits": nb_hits[:3],
                "aristo_hits": aristo_hits[:3],
            }
        
        etymology[term] = {
            "term": term,
            "frequency": entry["frequency_aristotle"],
            "components": parts,
            "component_definitions": comp_defs,
            "aristotle_contexts": entry["aristotle_contexts"],
            "notebooklm_hits": entry.get("notebooklm_hits", []),
        }
    
    # ---- Build report ----
    report_lines = []
    report_lines.append("=" * 80)
    report_lines.append("ARISTOTLE GNOSTIC ETYMOLOGY — Compound Word Decomposition Report")
    report_lines.append("=" * 80)
    report_lines.append(f"")
    report_lines.append(f"Sources: {len(gnostic_texts)} Gnostic Library texts, "
                        f"{len(nb_texts)} notebooklm files, {len(projects)} Aristotle projects")
    report_lines.append(f"Undefined gnostic terms analyzed: {len(etymology)}")
    report_lines.append(f"")
    report_lines.append("METHOD: Each undefined CamelCase term is split into component words.")
    report_lines.append("Each component is looked up in all three source corpora.")
    report_lines.append("Components with dictionary hits provide 'etymological anchoring'.")
    report_lines.append("Components with NO hits are genuinely novel/invented terms.")
    report_lines.append("")
    
    for term, data in sorted(etymology.items()):
        report_lines.append("-" * 60)
        report_lines.append(f"TERM: {term} (×{data['frequency']})")
        report_lines.append(f"Decomposition: {' + '.join(data['components'])}")
        report_lines.append("")
        
        # Check which components have any source hits
        anchored = []
        novel = []
        for part, hits in data["component_definitions"].items():
            total_hits = len(hits["gnostic_hits"]) + len(hits["nb_hits"]) + len(hits["aristo_hits"])
            if total_hits > 0:
                anchored.append(part)
            else:
                novel.append(part)
        
        if anchored:
            report_lines.append(f"  ANCHORED components (found in sources): {', '.join(anchored)}")
        if novel:
            report_lines.append(f"  NOVEL components (no source hits): {', '.join(novel)}")
        report_lines.append("")
        
        # Show supporting evidence for anchored components
        for part in anchored:
            hits = data["component_definitions"][part]
            for hit in hits["gnostic_hits"][:1]:
                report_lines.append(f"  [{part}] Gnostic Library / {hit['source']}:")
                report_lines.append(f"    {hit['context'][:180]}")
            for hit in hits["nb_hits"][:1]:
                report_lines.append(f"  [{part}] notebooklm / {hit['source']}:")
                report_lines.append(f"    {hit['context'][:180]}")
        
        # Show Aristotle usage context
        if data["aristotle_contexts"]:
            report_lines.append(f"")
            report_lines.append(f"  ARISTOTLE USAGE:")
            for ctx in data["aristotle_contexts"][:2]:
                report_lines.append(f"    [{ctx['project'][:8]}] {ctx['context'][:180]}")
        
        report_lines.append("")
    
    # ---- Stats summary ----
    all_components = set()
    novel_components = set()
    anchored_components = set()
    
    for term, data in etymology.items():
        for part, hits in data["component_definitions"].items():
            all_components.add(part)
            total = len(hits["gnostic_hits"]) + len(hits["nb_hits"]) + len(hits["aristo_hits"])
            if total > 0:
                anchored_components.add(part)
            else:
                novel_components.add(part)
    
    report_lines.append("=" * 80)
    report_lines.append("SUMMARY")
    report_lines.append("=" * 80)
    report_lines.append(f"  Total undefined gnostic terms: {len(etymology)}")
    report_lines.append(f"  Total unique components: {len(all_components)}")
    report_lines.append(f"  Anchored (found in sources): {len(anchored_components)}")
    report_lines.append(f"  Novel (no source hits): {len(novel_components)}")
    report_lines.append("")
    report_lines.append("Anchored components with dictionary support:")
    for c in sorted(anchored_components):
        report_lines.append(f"    {c}")
    report_lines.append("")
    report_lines.append("Novel components (invented/domain-specific):")
    for c in sorted(novel_components):
        report_lines.append(f"    {c}")
    
    report = "\n".join(report_lines)
    
    # ---- Write files ----
    # JSON data
    output = {
        "total_terms": len(etymology),
        "total_components": len(all_components),
        "anchored_components": len(anchored_components),
        "novel_components": len(novel_components),
        "anchored_component_list": sorted(anchored_components),
        "novel_component_list": sorted(novel_components),
        "etymology": etymology,
    }
    with open(OUT_JSON, "w") as f:
        json.dump(output, f, indent=2, default=str)
    
    # Text report
    report_path = "/mnt/data1/aristotle-results/aristo-etymology-report.txt"
    with open(report_path, "w") as f:
        f.write(report)
    
    print(f"\nReport: {report_path} ({len(report)} chars)")
    print(f"Data: {OUT_JSON}")
    print(f"\nAnchored: {len(anchored_components)} components")
    print(f"Novel: {len(novel_components)} components")
    print(f"\nNovel components: {', '.join(sorted(novel_components))}")
    
    return report_path

if __name__ == "__main__":
    main()
