#!/usr/bin/env python3
"""
Aristotle Gnostic Glossary v4 — German Dictionary Integration.

Adds German compound-word splitting using:
  1. Local German wordlist (~/2026/06/22/german-dict/words.txt)
  2. Fallback: hand-curated German lexicon for gnostic/crypto terms
  3. Integration with existing 3-source etymology pipeline

Outputs compound splits for German terms like:
  - Kryptoeffnung → Krypto + Öffnung
  - Zownakairufication → Zaun + Kehre + fication
"""
import os, re, json, urllib.request
from pathlib import Path
from collections import defaultdict

GERMAN_DICT = os.path.expanduser("~/2026/06/22/german-dict")
GERMAN_WORDS = os.path.join(GERMAN_DICT, "words.txt")

# ── Hand-curated German lexicon for gnostic/crypto compound terms ──
# These are the words our decomposition needs that may not be in a standard
# German wordlist (compound fragments, technical terms, proper names).
GERMAN_GNOSTIC_LEXICON = {
    # From Kryptoeffnung (Crypto-Opening)
    "krypto": {"lemma": "Krypto", "meaning": "crypto-, hidden, secret (from Greek kryptós)"},
    "oeffnung": {"lemma": "Öffnung", "meaning": "opening, aperture, unlock"},
    "offnung": {"lemma": "Öffnung", "meaning": "opening (without umlaut)"},
    "effnung": {"lemma": "Öffnung", "meaning": "opening (prefix form)"},
    
    # From Zownakairufication
    "zaun": {"lemma": "Zaun", "meaning": "fence, enclosure, boundary"},
    "zowna": {"lemma": "Zowna", "meaning": "possibly: zone/region (cognate with Zone/Zaun)"},
    "kehre": {"lemma": "Kehre", "meaning": "turn, bend, curve, reversal"},
    "kairu": {"lemma": "Kairu", "meaning": "possibly: Kairos (opportune moment) or Kehre variant"},
    "fikation": {"lemma": "-fikation", "meaning": "suffix: making, becoming (from Latin -ficatio)"},
    
    # Griess (German word for semolina/grit)
    "griess": {"lemma": "Grieß", "meaning": "semolina, grit, coarse grain; also: surname (Griess algebra)"},
    
    # From Zappa (surname)
    "zappa": {"lemma": "Zappa", "meaning": "Italian surname (Frank Zappa); possibly from zappa (hoe/mattock)"},
    
    # German mathematical/crypto compounds
    "krypt": {"lemma": "Krypt-", "meaning": "crypto- prefix (hidden)"},
    "kryptoeffnung": {"lemma": "Kryptoeffnung", "meaning": "crypto-opening: the act of decrypting/revealing"},
    
    # Common German compound fragments
    "keit": {"lemma": "-keit", "meaning": "noun suffix: -ness, -ity (abstract quality)"},
    "ung": {"lemma": "-ung", "meaning": "noun suffix: -ing (process/result)"},
    "tion": {"lemma": "-tion", "meaning": "Latin suffix: -tion (process)"},
    "ieren": {"lemma": "-ieren", "meaning": "verb suffix: to do/make (from French -ier)"},
}

# ── Load or download German wordlist ──
def load_german_wordlist():
    """Load German words from local file or download from GitHub."""
    words = set()
    os.makedirs(GERMAN_DICT, exist_ok=True)
    
    # Try local file first
    if os.path.exists(GERMAN_WORDS):
        with open(GERMAN_WORDS) as f:
            words = set(l.strip().lower() for l in f if l.strip())
        print(f"  Loaded {len(words)} German words from local file")
        return words
    
    # Try downloading
    sources = [
        "https://raw.githubusercontent.com/enz/german-wordlist/master/words.txt",
        "https://raw.githubusercontent.com/gambolputty/german-nouns/master/german_nouns.txt",
    ]
    for url in sources:
        try:
            print(f"  Downloading: {url} ...")
            req = urllib.request.Request(url, headers={"User-Agent": "aristo-glossary/1.0"})
            data = urllib.request.urlopen(req, timeout=15).read().decode("utf-8", errors="replace")
            words = set(l.strip().lower() for l in data.splitlines() if l.strip())
            # Save locally
            with open(GERMAN_WORDS, "w") as f:
                f.write("\n".join(sorted(words)))
            print(f"  Downloaded {len(words)} German words → {GERMAN_WORDS}")
            return words
        except Exception as e:
            print(f"  Failed: {e}")
    
    print("  No German wordlist available — using hand-curated lexicon only")
    return set()

# ── German compound splitter (simple greedy) ──
def split_german_compound(term, wordlist):
    """Simple greedy German compound splitter.
    Goes right-to-left, trying to match known German words.
    Falls back to hand-curated lexicon for unmatched fragments.
    """
    term_lower = term.lower()
    
    # Try known splits from hand-curated lexicon
    if term_lower in GERMAN_GNOSTIC_LEXICON:
        return [{"part": term_lower, "type": "gnostic_lexicon", 
                 "meaning": GERMAN_GNOSTIC_LEXICON[term_lower]["meaning"]}]
    
    # Greedy right-to-left split
    parts = []
    remaining = term_lower
    while remaining:
        found = False
        # Try longest match first
        for i in range(len(remaining), 2, -1):
            candidate = remaining[:i]
            if candidate in wordlist or candidate in GERMAN_GNOSTIC_LEXICON:
                if candidate in GERMAN_GNOSTIC_LEXICON:
                    parts.append({"part": candidate, "type": "gnostic_lexicon",
                                  "meaning": GERMAN_GNOSTIC_LEXICON[candidate]["meaning"]})
                else:
                    parts.append({"part": candidate, "type": "german_dict"})
                remaining = remaining[i:]
                found = True
                break
        if not found:
            # Try single char or fragment
            if len(remaining) <= 2:
                parts.append({"part": remaining, "type": "fragment"})
                break
            # Try minimum 2-char match
            c2 = remaining[:2]
            if c2 in wordlist or c2 in GERMAN_GNOSTIC_LEXICON:
                parts.append({"part": c2, "type": "dict_short"})
                remaining = remaining[2:]
            else:
                parts.append({"part": remaining[0], "type": "fragment"})
                remaining = remaining[1:]
    
    return parts


# ── CamelCase splitter (existing) ──
def split_camelcase(term):
    parts = re.findall(r'[A-Z][a-z]*|[a-z]+|[0-9]+', term)
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


# ── Main decomposition with German support ──
def decompose_term(term, german_words):
    """Decompose a gnostic term, trying German splits for components."""
    camels = split_camelcase(term)
    results = []
    
    for camel in camels:
        # Check if this component is a German compound
        de_parts = split_german_compound(camel, german_words)
        
        # If it split into 2+ German words, it's a compound
        if len(de_parts) > 1:
            for p in de_parts:
                results.append({
                    "component": camel,
                    "german_part": p["part"],
                    "type": p.get("type", "unknown"),
                    "meaning": p.get("meaning", ""),
                })
        else:
            # Check if single German word
            if camel in german_words or camel in GERMAN_GNOSTIC_LEXICON:
                meaning = ""
                if camel in GERMAN_GNOSTIC_LEXICON:
                    meaning = GERMAN_GNOSTIC_LEXICON[camel]["meaning"]
                results.append({
                    "component": camel,
                    "german_part": camel,
                    "type": "single_german",
                    "meaning": meaning,
                })
            else:
                results.append({
                    "component": camel,
                    "german_part": camel,
                    "type": "unknown",
                    "meaning": "",
                })
    
    return results


# ── Main ──
def main():
    print("Loading German dictionary...")
    german_words = load_german_wordlist()
    
    # Add gnostic lexicon terms
    all_german = german_words | set(GERMAN_GNOSTIC_LEXICON.keys())
    print(f"  Total German lexicon: {len(all_german)} words\n")
    
    # Load glossary v2
    with open("/mnt/data1/aristotle-results/aristo-gnostic-glossary-v2.json") as f:
        v2 = json.load(f)
    
    undefined = [e for e in v2["glossary"]
                 if "gnostic/mystical" in e["categories"]
                 and "gnostic_sources" not in e]
    
    print(f"Analyzing {len(undefined)} undefined gnostic terms with German decomposition:\n")
    
    for entry in sorted(undefined, key=lambda e: -e["frequency_aristotle"]):
        term = entry["term"]
        deps = decompose_term(term, all_german)
        
        # Only show terms where German analysis added value
        has_german = any(d["type"] in ("gnostic_lexicon", "single_german") for d in deps)
        has_compound = sum(1 for d in deps if d["component"] != d["german_part"]) > 0
        
        if has_german or has_compound:
            freq = entry["frequency_aristotle"]
            print(f"  {term} (×{freq})")
            for d in deps:
                tag = ""
                if d.get("meaning"):
                    tag = f" = {d['meaning'][:80]}"
                if d["component"] != d["german_part"]:
                    print(f"    {d['component']} → {d['german_part']} [{d['type']}]{tag}")
                elif d["type"] != "unknown":
                    print(f"    {d['component']} [{d['type']}]{tag}")
            print()
    
    # Show German-capable splits for the key terms
    print("=" * 60)
    print("GERMAN COMPOUND SPLITS FOR KEY TERMS")
    print("=" * 60)
    key_terms = ["Kryptoeffnung", "Zownakairufication", "Griess", "ZappaOntology"]
    for term in key_terms:
        print(f"\n  {term}:")
        deps = decompose_term(term, all_german)
        for d in deps:
            if d.get("meaning"):
                print(f"    {d['component']}: {d['meaning']}")
            elif d["component"] != d["german_part"]:
                print(f"    {d['component']} → {d['german_part']}")
            else:
                print(f"    {d['component']} = {d['type']}")

if __name__ == "__main__":
    main()
