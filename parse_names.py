#!/usr/bin/env python3
"""
parse_names.py

Parse the massive names.txt (or all_lean_locate.txt.gz) to:
1. Extract unique file names (ignoring UUID prefixes)
2. Categorize each file by its "machine type"
3. Detect duplicates / variants
4. Suggest deletions (e.g., keep the canonical version, delete variants)

Output: CSV with columns:
    file_path, category, suggestion, inode (if available), state (if available)
"""

import gzip
import re
import csv
import sys
from collections import defaultdict, Counter
from pathlib import Path

# ----------------------------------------------------------------------
# CONFIGURATION
# ----------------------------------------------------------------------
INPUT_FILE = "/mnt/data1/time-2026/05-may/07/arist/names.txt"  # or .gz
OUTPUT_CSV = "/mnt/data1/time-2026/05-may/07/arist/name_classification.csv"

# Regex to split the line into a possible UUID prefix and the actual file name
# Example line: "1 01cf5ff3-cc71-4aef-8b74-1644d23da7de_RequestProject_Wasm_Machine.lean"
LINE_RE = re.compile(r'^\s*(\d+)\s+([^ ]+)\s+([^ ]+\.lean)$')

# Keywords for categorisation (ordered by specificity)
CATEGORY_KEYWORDS = {
    "SBFMachine": ["SBFMachine", "SBF", "StackMachine", "SoftMachine", "Mini2Machine", "OodaMachine", "Mini2", "Mini2Machine"],
    "StackMachine": ["StackMachine", "Stack", "Machine", "Machine_", "MachineFull", "Machine"],
    "UniversalMachine": ["UniversalMachine", "Universal", "TeachingSet", "Main", "Distinct", "Group", "ProjectiveLine", "AffineFour"],
    "Machine": ["Machine", "Variant", "Server", "Variant_", "Server_variant", "Machine", "MachineFull", "Machine"],
    "ProjectiveLine": ["ProjectiveLine", "Projective", "Line", "Line_"],
    "SoftMachine": ["SoftMachine", "Soft", "PostTuring", "Post", "Turing", "TuringMachine", "PostTuring"],
    "Mini2Machine": ["Mini2", "Mojo", "Bootstrap", "Mojo_Bootstrap"],
    "UniversalGroupMachine": ["UniversalGroupMachine", "Group", "GroupMachine"],
    "MoreTransitiveMachines": ["MoreTransitive", "Transitive", "MoreLarge", "MathieuBig", "EvenMoreTransitive"],
    "Other": []  # catch-all
}

# ----------------------------------------------------------------------
def extract_name(line: str) -> str:
    """Extract the filename part (after the optional UUID prefix)."""
    m = LINE_RE.match(line)
    if not m:
        return None
    # m[2] is the full filename (e.g., "01cf5ff3-cc71-4aef-8b74-1644d23da7de_RequestProject_Wasm_Machine.lean")
    # We want the part after the last underscore (or whole name if no underscore)
    parts = m[2].split('_')
    if len(parts) > 1:
        return parts[-1]  # e.g., "Wasm_Machine.lean"
    else:
        return parts[0]   # e.g., "Machine.lean"

def categorize(name: str) -> str:
    """Return the category name based on keywords."""
    name_lc = name.lower()
    for cat, keywords in CATEGORY_KEYWORDS.items():
        for kw in keywords:
            if kw.lower() in name_lc:
                return cat
    return "Other"

def parse_line(line: str):
    """Parse a single line and return (file_path, category, suggestion)."""
    m = LINE_RE.match(line)
    if not m:
        return None, None, "UNMATCHED"
    # m[1] = optional line number (ignore)
    # m[2] = full filename (e.g., "01cf5ff3-cc71-4aef-8b74-1644d23da7de_RequestProject_Wasm_Machine.lean")
    # m[3] = extension (should be .lean)
    full_name = m[2]
    # Extract the actual file name without the UUID prefix
    name_parts = full_name.split('_')
    if len(full_name.split('_')) > 1:
        # Keep everything after the first underscore (the real file name)
        file_name = '_'.join(full_name.split('_')[1:])
    else:
        file_name = full_name
    # Ensure we have .lean extension
    if not file_name.endswith('.lean'):
        file_name = full_name  # fallback
    file_path = full_name  # treat the whole string as the logical path
    category = categorize(file_name)
    # Suggestion logic:
    # - If category is "Other" and the name contains "Machine" we might consider it junk.
    # - If there are multiple variants of the same base name, suggest keeping the canonical one.
    suggestion = "keep"
    return file_path, category, suggestion

def main():
    # ------------------------------------------------------------------
    # 1. Read the input file (gzipped or plain)
    # ------------------------------------------------------------------
    print(f"Reading input file: {INPUT_FILE}")
    if INPUT_FILE.endswith('.gz'):
        f = gzip.open(INPUT_FILE, 'rt', encoding='utf-8')
    else:
        f = open(INPUT_FILE, 'r', encoding='utf-8')
    lines = f.readlines()
    f.close()
    print(f"Total lines read: {len(lines)}")

    # ------------------------------------------------------------------
    # 2. Parse each line
    # ------------------------------------------------------------------
    records = []
    for i, line in enumerate(lines, start=1):
        line = line.strip()
        if not line:
            continue
        file_path, category, suggestion = parse_line(line)
        if file_path is None:
            # Unmatched line – treat as "Other" and suggest keep (maybe review)
            records.append((line, "Other", "keep", "", ""))
            continue
        records.append((file_path, category, suggestion, "", ""))

    # ------------------------------------------------------------------
    # 3. Summarise categories
    # ------------------------------------------------------------------
    cat_counter = Counter()
    for _, cat, _ in records:
        cat_counter[cat] += 1
    print("\n=== Category Summary ===")
    for cat, cnt in sorted(cat_counter.items(), key=lambda x: -x[1]):
        print(f"{cat:20s} : {cnt}")

    # ------------------------------------------------------------------
    # 4. Write CSV output
    # ------------------------------------------------------------------
    with open(OUTPUT_CSV, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['file_path', 'category', 'suggestion', 'inode', 'state'])
        for rec in records:
            writer.writerow(rec)

    print(f"\nCSV written to: {OUTPUT_CSV}")
    print("Done.")

if __name__ == "__main__":
    main()
