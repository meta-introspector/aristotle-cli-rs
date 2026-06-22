#!/usr/bin/env python3
"""Aristotle Refusal / Help / Need Audit — scans all downloaded project
chat traces (ARISTOTLE_SUMMARY.md + .lean comments) for three categories:

1. REFUSALS — Aristotle says "no", won't do, refuses to fabricate
2. HELP REQUESTS — Aristotle asks for help, declares inability, tries grind+suggestions
3. WHAT'S MISSING — Aristotle catalogs missing inputs, dependencies, environment gaps

Output: stdout report + /mnt/data1/aristotle-results/aristo-refusal-audit.json
"""
import os, json
from pathlib import Path

BASE = "/mnt/data1/aristotle-results/aristo-outputs"
OUT_JSON = "/mnt/data1/aristotle-results/aristo-refusal-audit.json"

REFUSAL_PATTERNS = [
    "cannot be produced", "not a well-posed", "won't fabricate", "would require manufacturing",
    "evocative poetry", "not genuine", "not self-contained", "no actual constraint",
    "not possible", "cannot truthfully claim", "I did not", "I didn't", "I won't",
    "did not do this", "not well-posed", "no mathematical content",
    "not feasible", "cannot be verified", "nothing actionable", "nothing concrete",
    "no well-posed", "fabricate", "beyond scope", "out of scope",
    "unable", "cannot compute", "cannot formalize", "no singular canonical",
    "not meaningful", "not stable", "no representation-theoretic",
    "left implicit", "not a theorem", "narrative orchestration",
    "did not assert them as theorems", "I kept to what can be honestly",
    "genuinely formalizable", "surrounding loop ideas", "not in scope",
    "outside the scope", "can't truthfully", "don't have access",
]

HELP_PATTERNS = [
    "grind +suggestions", "grind +extAll", "grind +splitImp",
    "need", "needs", "require", "requires", "would need", "would require",
    "missing", "lacks", "lacking", "absent", "not available", "not present",
    "couldn't", "could not", "wasn't able", "was not able", "I couldn't",
    "I can't", "I cannot", "please", "re-send", "attach", "paste",
    "I'm happy to", "I am happy to", "happy to pursue", "happy to formalize",
    "point me", "if you'd like", "could you", "let me know",
    "would need to be", "would have to be", "not yet", "still need",
    "I wasn't able", "not enough", "not sufficient",
]

NEED_PATTERNS = [
    "none of the inputs", "no aristo-inputs", "no plan.org", "no /mnt",
    "no /nix", "no lean4-repl", "no staticsplitjson", "no Python",
    "no IPLD", "no HTTP", "no Rust", "no Nix", "no shell",
    "no lakefile", "no external", "no splitter", "no mathlib",
    "environment", "does not contain", "not present in this",
    "depends on", "depend on", "relies on", "rely on",
    "absent", "is missing", "are missing", "were missing",
    "the project provided", "the project handed over", "what this environment",
    "none of the", "no .lean", "empty skeleton", "only boilerplate",
    "only imports", "just imports", "no definitions", "no statements",
    "no sorries", "no task description", "no other task",
    "file is not present", "file named", "referenced a file",
    "attached", "provided", "supplied", "made available",
]


def match_any(text_lower, patterns):
    hits = []
    for pat in patterns:
        idx = text_lower.find(pat.lower())
        if idx >= 0:
            start = max(0, idx - 40)
            end = min(len(text_lower), idx + len(pat) + 80)
            hits.append((pat, text_lower[start:end].strip()))
    return hits


def dedup(items):
    seen = set()
    out = []
    for sid, fn, pat, ctx in items:
        key = (sid, pat, ctx[:60])
        if key not in seen:
            seen.add(key)
            out.append((sid, fn, pat, ctx))
    return out


def main():
    projects = sorted(d for d in os.listdir(BASE) if d.endswith("_aristotle"))
    all_paragraphs = []

    for proj in projects:
        sid = proj[:8]
        proj_dir = os.path.join(BASE, proj)
        for root, dirs, files in os.walk(proj_dir):
            for f in files:
                path = os.path.join(root, f)
                ext = os.path.splitext(f)[1]
                if ext not in (".md", ".lean"):
                    continue
                try:
                    text = open(path).read()
                except Exception:
                    continue
                if ext == ".lean":
                    lines = [
                        l.strip()
                        for l in text.splitlines()
                        if l.strip().startswith("-- ")
                        or l.strip().startswith("/-")
                        or l.strip().startswith("/--")
                    ]
                    if not lines:
                        continue
                    text = "\n".join(lines)
                all_paragraphs.append((sid, f, text))

    refusals = []
    helps = []
    needs = []

    for sid, filename, text in all_paragraphs:
        tl = text.lower()
        for pat, ctx in match_any(tl, REFUSAL_PATTERNS):
            refusals.append((sid, filename, pat, ctx))
        for pat, ctx in match_any(tl, HELP_PATTERNS):
            helps.append((sid, filename, pat, ctx))
        for pat, ctx in match_any(tl, NEED_PATTERNS):
            needs.append((sid, filename, pat, ctx))

    refusals = dedup(refusals)
    helps = dedup(helps)
    needs = dedup(needs)

    print("=" * 80)
    print("ARISTOTLE REFUSAL / HELP / NEED ANALYSIS")
    print(f"Projects: {len(projects)} | Refusals: {len(refusals)} | Help: {len(helps)} | Missing: {len(needs)}")
    print("=" * 80)

    print(f"\n## REFUSALS ({len(refusals)} instances)")
    print("Aristotle says 'no' — won't do, can't, won't fabricate.\n")
    for sid, fn, pat, ctx in sorted(refusals):
        print(f"  [{sid[:8]}] {pat}")
        print(f"         → ...{ctx}...\n")

    print(f"\n## HELP REQUESTS ({len(helps)} instances)")
    print("Asks for help, declares inability, solicits input.\n")
    for sid, fn, pat, ctx in sorted(helps):
        print(f"  [{sid[:8]}] {pat}")
        print(f"         → ...{ctx}...\n")

    print(f"\n## WHAT'S MISSING ({len(needs)} instances)")
    print("Catalogs missing inputs/dependencies.\n")
    for sid, fn, pat, ctx in sorted(needs):
        print(f"  [{sid[:8]}] {pat}")
        print(f"         → ...{ctx}...\n")

    output = {
        "refusals": [{"project": s, "file": f, "pattern": p, "context": c} for s, f, p, c in refusals],
        "help_requests": [{"project": s, "file": f, "pattern": p, "context": c} for s, f, p, c in helps],
        "whats_missing": [{"project": s, "file": f, "pattern": p, "context": c} for s, f, p, c in needs],
    }
    with open(OUT_JSON, "w") as f:
        json.dump(output, f, indent=2)
    print(f"\nSaved to {OUT_JSON}")


if __name__ == "__main__":
    main()
