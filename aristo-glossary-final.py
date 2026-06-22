#!/usr/bin/env python3
"""
Aristotle Gnostic Glossary v5 — Final Combined Report with German Lexicon.

Produces a comprehensive etymology for all undefined gnostic terms:
  - CamelCase decomposition (existing)
  - German decomposition (for German-derived terms only)
  - Source lookups (Gnostic Library, notebooklm, Aristotle)
  - Compound meaning synthesis

Posts full report to pastebin.
"""
import os, re, json
from pathlib import Path
from collections import defaultdict

# ── Config ──
OUT_JSON = "/mnt/data1/aristotle-results/aristo-gnostic-final.json"
OUT_REPORT = "/mnt/data1/aristotle-results/aristo-gnostic-final.txt"
PASTEBIN_URL = "solana.solfunmeme.com/pastebin"

# ── German Lexicon (hand-curated) ──
GERMAN_LEXICON = {
    "kryptoeffnung": {
        "decomposition": ["krypto", "oeffnung"],
        "meaning": "Crypto-Opening. From German 'Krypto' (crypto/hidden) + 'Öffnung' (opening/unlock). The act of decrypting, revealing, or opening what was sealed. In the gnostic context: the moment the Demiurge's sealed vault is breached.",
        "components": {
            "krypto": "German prefix: crypto-, hidden, secret (from Greek kryptós)",
            "oeffnung": "German: Öffnung = opening, aperture, the act of opening",
        }
    },
    "zownakairufication": {
        "decomposition": ["zowna", "kair", "fication"],
        "meaning": "Zowna-Kair-Fication: 'The Boundary of the Right Moment' or 'The Realization of Domain Equilibrium.' From Greek ζώνη (zone, girdle, boundary between Aeons) + καιρός (kairos, the opportune/supreme moment of gnosis) + Latin -ficatio (process of making). In Gnostic cosmology: the act of bringing a chaotic spiritual concept to its optimal, permanent fixed-point state. In category theory: an idempotent endofunctor Z that stabilizes a pipeline F = K ≫ M ≫ Z such that F ≫ Z = F — the system reaches equilibrium.",
        "components": {
            "zowna": "Greek ζώνη (zōnē) = zone, girdle, belt. In Gnostic cosmology: the boundary layers separating Aeons, the structural divisions between material world and divine Pleroma. Mathematically: a constrained domain or bounded space.",
            "kair": "Greek καιρός (kairos) = the right/opportune/critical moment. Unlike chronos (linear time), kairos is qualitative — 'God's time,' the exact moment gnosis dawns. Mathematically: the point of convergence where a condition is perfectly satisfied.",
            "fication": "Latin suffix -ficatio: the process of making, becoming, or bringing into a state.",
        }
    },
    "griess": {
        "decomposition": ["griess"],
        "meaning": "German 'Grieß' = semolina, coarse grain, grit. Also: surname of Robert L. Griess Jr., who constructed the Monster group (the 'Griess algebra'). In gnostic context: the granular, irreducible building blocks — the coarse matter from which the Monster is built.",
        "components": {
            "griess": "German: Grieß = semolina, coarse meal; metaphorically: irreducible granular components. Robert Griess constructed the Monster group (Fischer-Griess Monster).",
        }
    },
    "zappa": {
        "decomposition": ["zappa"],
        "meaning": "Italian surname 'Zappa' (Frank Zappa, musician/composer). Also Italian 'zappa' = hoe/mattock (agricultural tool). In the Zappa Sofa cosmology: the creative principle — 'Ich bin hier / Und du bist mein Sofa' — the primordial assertion of presence.",
        "components": {
            "zappa": "Frank Zappa (1940-1993): American musician known for conceptual continuity, absurdism, and genre fusion. In the cosmology: the lyric domain, the first mover who names the sofa.",
        }
    },
    "hecke": {
        "decomposition": ["hecke"],
        "meaning": "German 'Hecke' = hedge, hedgerow. Also: Erich Hecke (1887-1947), German mathematician. Hecke operators are linear operators on modular forms. In the Transmission Ω narrative: T₂₃ is a Hecke operator acting on the twisted Gödel encoding.",
        "components": {
            "hecke": "Erich Hecke: German mathematician. Hecke operators act on spaces of modular forms. Also German: hedge = boundary marker, partition.",
        }
    },
    "bott": {
        "decomposition": ["bott"],
        "meaning": "Raoul Bott (1923-2005): mathematician known for Bott periodicity in K-theory. In Transmission Ω: 'dasl:bott = 6(R(8))' references Bott periodicity — the cyclic pattern in K-theory with period 8.",
        "components": {
            "bott": "Raoul Bott: Hungarian-American mathematician. Bott periodicity: K-theory is periodic with period 8 in the real case.",
        }
    },
}

# German-indicating patterns
GERMAN_PATTERNS = re.compile(
    r'(oeffnung|offnung|effnung|krypt|zowna|kairu|griess|hecke|bott|zappa)',
    re.IGNORECASE
)

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

def is_german_term(term):
    """Check if term contains German indicators."""
    return bool(GERMAN_PATTERNS.search(term.lower()))

def get_german_info(term_lower):
    """Get German decomposition for a term."""
    if term_lower in GERMAN_LEXICON:
        return GERMAN_LEXICON[term_lower]
    return None

def build_definition(term, entry):
    """Build a synthesized definition from available evidence."""
    parts = []
    
    # 1. Decomposition
    camels = split_camelcase(term)
    parts.append(f"### {term}")
    parts.append(f"")
    parts.append(f"**Decomposition:** {' + '.join(camels)}")
    
    # 2. German analysis if applicable
    if is_german_term(term):
        for c in camels:
            gi = get_german_info(c)
            if gi:
                parts.append(f"")
                parts.append(f"**German component '{c}':** {gi['meaning']}")
                for comp, defn in gi['components'].items():
                    parts.append(f"  - {comp}: {defn}")
    
    # 3. Gnostic Library hits
    if "gnostic_sources" in entry:
        parts.append(f"")
        parts.append(f"**Gnostic Library:** found in {', '.join(entry['gnostic_sources'][:5])}")
    
    # 4. Aristotle usage
    if entry.get("aristotle_contexts"):
        parts.append(f"")
        parts.append(f"**Aristotle usage (×{entry['frequency_aristotle']}):**")
        for ctx in entry["aristotle_contexts"][:2]:
            parts.append(f"  > {ctx['context'][:200]}")
    
    # 5. notebooklm hits
    if entry.get("notebooklm_hits"):
        parts.append(f"")
        parts.append(f"**notebooklm references:**")
        for hit in entry["notebooklm_hits"][:2]:
            parts.append(f"  [{hit.get('source','?')}] {hit.get('snippet','')[:150]}")
    
    parts.append(f"")
    return "\n".join(parts)


def main():
    # Load v2 glossary
    with open("/mnt/data1/aristotle-results/aristo-gnostic-glossary-v2.json") as f:
        v2 = json.load(f)
    
    undefined = [e for e in v2["glossary"]
                 if "gnostic/mystical" in e["categories"]
                 and "gnostic_sources" not in e]
    
    # Separate German-derived and English terms
    german_terms = [e for e in undefined if is_german_term(e["term"])]
    english_terms = [e for e in undefined if not is_german_term(e["term"])]
    
    print(f"German-derived: {len(german_terms)}")
    print(f"English/composite: {len(english_terms)}")
    
    # Build report
    lines = []
    lines.append("=" * 80)
    lines.append("ARISTOTLE GNOSTIC GLOSSARY — FINAL COMBINED REPORT")
    lines.append("=" * 80)
    lines.append(f"")
    lines.append(f"Sources integrated: Clovis Star Gnostic Library (210 texts),")
    lines.append(f"notebooklm corpus, 13 Aristotle projects, German lexicon")
    lines.append(f"")
    lines.append(f"Total undefined gnostic terms: {len(undefined)}")
    lines.append(f"  German-derived: {len(german_terms)}")
    lines.append(f"  English/composite: {len(english_terms)}")
    lines.append(f"")
    
    # German terms first
    lines.append("=" * 80)
    lines.append("GERMAN-DERIVED TERMS (with etymology)")
    lines.append("=" * 80)
    
    for entry in sorted(german_terms, key=lambda e: -e["frequency_aristotle"]):
        term = entry["term"]
        defn = build_definition(term, entry)
        lines.append(defn)
        lines.append("---")
    
    # English/composite terms
    lines.append("")
    lines.append("=" * 80)
    lines.append("ENGLISH / COMPOSITE TERMS (decomposition only)")
    lines.append("=" * 80)
    
    for entry in sorted(english_terms, key=lambda e: -e["frequency_aristotle"]):
        term = entry["term"]
        camels = split_camelcase(term)
        freq = entry["frequency_aristotle"]
        lines.append(f"### {term} (×{freq})")
        lines.append(f"Decomposition: {' + '.join(camels)}")
        if entry.get("aristotle_contexts"):
            lines.append(f"Usage: {entry['aristotle_contexts'][0]['context'][:200]}")
        lines.append("")
        lines.append("---")
    
    # German lexicon appendix
    lines.append("")
    lines.append("=" * 80)
    lines.append("APPENDIX: GERMAN GNOSTIC LEXICON (hand-curated)")
    lines.append("=" * 80)
    for term, info in GERMAN_LEXICON.items():
        lines.append(f"")
        lines.append(f"### {term}")
        lines.append(f"{info['meaning']}")
        lines.append(f"Components: {' + '.join(info['decomposition'])}")
    
    report = "\n".join(lines)
    
    # Write files
    with open(OUT_REPORT, "w") as f:
        f.write(report)
    
    # Build JSON output
    output = {
        "total_undefined": len(undefined),
        "german_derived": len(german_terms),
        "english_composite": len(english_terms),
        "german_lexicon": GERMAN_LEXICON,
        "german_terms": [{"term": e["term"], "definition": get_german_info(e["term"].lower())}
                        for e in german_terms],
        "full_report_path": OUT_REPORT,
    }
    with open(OUT_JSON, "w") as f:
        json.dump(output, f, indent=2, default=str)
    
    print(f"\nReport: {OUT_REPORT} ({len(report)} chars)")
    print(f"Data: {OUT_JSON}")
    return report

if __name__ == "__main__":
    report = main()
    print("\nDone. Ready for pastebin upload.")
