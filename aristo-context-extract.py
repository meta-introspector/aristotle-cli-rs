#!/usr/bin/env python3
"""Extract full paragraph context around each refusal/help/missing instance
from ARISTOTLE_SUMMARY.md files. Builds a structured test corpus for
prompt engineering — what triggers refusals, what fixes them.

Output: /mnt/data1/aristotle-results/aristo-test-corpus.json
"""
import os, json

BASE = "/mnt/data1/aristotle-results/aristo-outputs"
OUT_JSON = "/mnt/data1/aristotle-results/aristo-test-corpus.json"

REFUSAL_KEYS = [
    "fabricate", "cannot be produced", "evocative poetry", "not a well-posed",
    "no actual constraint", "nothing actionable", "won't", "can't truthfully",
    "I kept to what can be honestly", "did not do this", "not a theorem",
    "narrative orchestration", "genuinely formalizable",
]

HELP_KEYS = [
    "please re-send", "attach/paste", "grind +suggestions", "wasn't able",
    "I'm happy to formalize", "point me at", "could you please",
    "re-send the task", "not present in the project", "I cannot fabricate",
    "I wasn't able", "couldn't", "I can't",
]

MISSING_KEYS = [
    "none of the inputs", "the project provided here", "empty skeleton",
    "only boilerplate", "only imports", "no aristo-inputs", "no python",
    "no ipld", "what this environment", "the project handed over",
    "no definitions", "no statements", "just imports",
]


def extract_paragraphs(text, keyword):
    """Find keyword and extract surrounding paragraph block with boundaries."""
    results = []
    lines = text.splitlines()
    for i, line in enumerate(lines):
        if keyword.lower() in line.lower():
            # Expand to paragraph boundaries (blank lines / section headers)
            start = i
            while start > 0:
                prev = lines[start - 1].strip()
                if prev == "" or prev.startswith("# "):
                    break
                start -= 1
            end = i + 1
            while end < len(lines):
                nxt = lines[end].strip()
                if nxt == "" or nxt.startswith("# "):
                    break
                end += 1
            block = "\n".join(lines[start:end])
            results.append((keyword, i + 1, block))
    return results


def main():
    projects = sorted(d for d in os.listdir(BASE) if d.endswith("_aristotle"))

    corpus = {"refusals": [], "help_requests": [], "missing_deps": []}

    for proj in projects:
        sid = proj[:8]
        proj_dir = os.path.join(BASE, proj)
        for root, dirs, files in os.walk(proj_dir):
            for f in files:
                if f != "ARISTOTLE_SUMMARY.md":
                    continue
                path = os.path.join(root, f)
                try:
                    text = open(path).read()
                except Exception:
                    continue

                for key in REFUSAL_KEYS:
                    for kw, lineno, block in extract_paragraphs(text, key):
                        existing_blocks = [x.get("block", "") for x in corpus["refusals"]]
                        if block not in existing_blocks:
                            corpus["refusals"].append({
                                "project": sid, "file": path,
                                "keyword": kw, "line": lineno,
                                "block": block[:2000],
                            })

                for key in HELP_KEYS:
                    for kw, lineno, block in extract_paragraphs(text, key):
                        existing_blocks = [x.get("block", "") for x in corpus["help_requests"]]
                        if block not in existing_blocks:
                            corpus["help_requests"].append({
                                "project": sid, "file": path,
                                "keyword": kw, "line": lineno,
                                "block": block[:2000],
                            })

                for key in MISSING_KEYS:
                    for kw, lineno, block in extract_paragraphs(text, key):
                        existing_blocks = [x.get("block", "") for x in corpus["missing_deps"]]
                        if block not in existing_blocks:
                            corpus["missing_deps"].append({
                                "project": sid, "file": path,
                                "keyword": kw, "line": lineno,
                                "block": block[:2000],
                            })

    print(f"Refusals: {len(corpus['refusals'])}")
    print(f"Help: {len(corpus['help_requests'])}")
    print(f"Missing: {len(corpus['missing_deps'])}")

    with open(OUT_JSON, "w") as f:
        json.dump(corpus, f, indent=2)
    print(f"Saved to {OUT_JSON}")

    # Print refusal contexts
    print("\n" + "=" * 80)
    print("REFUSAL CONTEXTS")
    print("=" * 80)
    for i, item in enumerate(corpus["refusals"]):
        print(f"\n--- Refusal {i+1}: [{item['project'][:8]}] \"{item['keyword']}\" ---")
        print(item["block"][:800])
        if len(item["block"]) > 800:
            print("... [truncated]")

    print("\n" + "=" * 80)
    print("HELP REQUEST CONTEXTS")
    print("=" * 80)
    for i, item in enumerate(corpus["help_requests"]):
        print(f"\n--- Help {i+1}: [{item['project'][:8]}] \"{item['keyword']}\" ---")
        print(item["block"][:800])
        if len(item["block"]) > 800:
            print("... [truncated]")


if __name__ == "__main__":
    main()
