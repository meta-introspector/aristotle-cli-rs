#!/usr/bin/env python3
"""
VM Name Graph Classifier

Processes all_lean_locate.txt.gz to:
1. Extract all Lean module names (basenames, normalized)
2. Build an undirected graph of names (edges share a core token)
3. Identify "junk loops" (cyclic/nested variants, UUID noise, AbstractLaw noise)
4. Identify core VM/machine types
5. Produce:
   - kept_names.txt   : canonical names to keep
   - deleted_names.txt : names to delete
   - graph_report.txt  : stats + summary
"""

import gzip
import re
import sys
from collections import defaultdict, Counter
from pathlib import Path

INPUT_GZ = "/home/mdupont/projects/arist/all_lean_locate.txt.gz"
OUT_DIR  = Path("/mnt/data1/time-2026/05-may/07/arist")
OUT_DIR.mkdir(parents=True, exist_ok=True)

# ── Core VM / machine type identifiers (lowercase, token-level)
CORE_VM_TOKENS = {
    "sbfmachine", "stackmachine", "softmachine", "mini2machine",
    "ziskmachine", "ziskmachinefull", "oodamachine", "machinetranslatable",
    "vonneumanniasmachine", "wumpusmachine", "votemachine", "tycoonmachine",
    "tournamentmachine", "qbertmachine", "oraclemachine", "mememachine",
    "marketmachine", "lordmachine", "invadersmachine", "hyperspacemachine",
    "frontiermachine", "flightmachine", "dashmachine", "universalmachineteachingset",
    "universalmachinedistinct", "universalgroupmachine", "universalmachinemain",
    "projectiveline32machine", "projectiveline27machine", "affinefourmachine",
    "moretransitivemachines", "morelargemachines", "mathieubigmachines",
    "evenmoretransitivemachines", "wasmmachine", "fractranvm", "wasm_emit",
    "wasmemit", "gearboxmachine", "extrusionmachine", "monster_vm_complete",
}

# Junk noise patterns (to delete)
JUNK_REGEXES = [
    re.compile(r"^\d+$"),                # pure numeric like 2, 42, 205
    re.compile(r"^abstractlaw_"),        # AbstractLaw lemma files
    re.compile(r"^causeq_"),             # causeq noise (contains 'machine' spuriously)
    re.compile(r"^divinvmonoid"),        # algebra noise
    re.compile(r"^divisionring_"),
    re.compile(r"^groupwithzero_"),
    re.compile(r"^real_inst"),
    re.compile(r"^server_variant_server_variant_"),  # deeply nested server_variant loops (>=3 levels)
    re.compile(r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}_"),  # UUID prefix
]

# Names that are definitely noise (not Lean modules of interest)
NON_LEAN_NOISE = {
    "wasmer", "wasm", "emit", "llvm", "divmod", "svm", "pool", "shard",
    "lambda", "fleet", "timing", "bus", "dedupe", "freetiercpuaudit",
    "skeleton", "basic", "main", "lean", "types", "defs", "server",
    "ratelimit", "oracle", "azure", "cloudrun", "multicloud",
}


def normalize(name: str) -> str:
    """Strip .lean/.ilean/.olean, lowercase."""
    for suf in (".ilean", ".olean", ".lean"):
        if name.lower().endswith(suf):
            name = name[:-len(suf)]
            break
    return name.lower().strip()


def extract_basename(line: str) -> str:
    return line.strip().split("/")[-1]


def is_core_vm(name: str) -> bool:
    return any(tok in name for tok in CORE_VM_TOKENS)


def is_junk(name: str) -> bool:
    if name in NON_LEAN_NOISE:
        return True
    return any(rx.search(name) for rx in JUNK_REGEXES)


def canonicalize(name: str) -> str:
    """
    Strip server_variant_ prefix and UUID prefix to get the canonical leaf.
    Recursively collapse nested server_variant_.
    """
    original = name
    changed = True
    while changed:
        changed = False
        if name.startswith("server_variant_"):
            name = name[len("server_variant_"):]
            changed = True
        uuid_match = re.match(r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}_", name)
        if uuid_match:
            name = name[uuid_match.end():]
            changed = True
        # Also strip server_variant_ embedded in the middle
        if "server_variant_" in name:
            name = re.sub(r"server_variant_", "", name)
            changed = True
    return name if name != original else name


def count_junk_depth(name: str) -> int:
    """Count how many server_variant_ prefixes / nesting levels are present."""
    return name.count("server_variant_")


def is_junk_loop(name: str) -> bool:
    """Return True if this name has >=3 nested server_variant_ (junk loop)."""
    return count_junk_depth(name) >= 3


# ── Main processing
def main():
    print("[1/5] Scanning all_lean_locate.txt.gz ...", flush=True)

    name_counter = Counter()
    total_lines = 0
    core_names   = Counter()
    junk_names   = Counter()

    with gzip.open(INPUT_GZ, "rt", encoding="utf-8") as f:
        for line in f:
            total_lines += 1
            basename = extract_basename(line)
            normalized = normalize(basename)
            if not normalized:
                continue
            name_counter[normalized] += 1

            if is_core_vm(normalized) and not is_junk(normalized):
                core_names[normalized] += 1
            elif is_junk(normalized) or is_junk_loop(normalized):
                junk_names[normalized] += 1

    print(f"    Total file paths : {total_lines}", flush=True)
    print(f"    Unique names     : {len(name_counter)}", flush=True)

    # ── Build adjacency: for each junk name, find canonical target
    print("[2/5] Building graph (name -> canonical target) ...", flush=True)
    graph_edges = defaultdict(set)   # name -> set of canonical targets it maps to
    reverse_edges = defaultdict(set) # canonical -> set of names pointing to it

    # Consider only machine-related names (either core or junk with machine substring)
    MACHINE_SUBSTRINGS = ("machine", "vm", "wasm", "emit")
    machine_like_names = {
        n for n, c in name_counter.items()
        if any(s in n for s in MACHINE_SUBSTRINGS)
    }

    for name in machine_like_names:
        canonical = canonicalize(name)
        if canonical != name:
            graph_edges[name].add(canonical)
            reverse_edges[canonical].add(name)

    # ── Detect loops (cycles in the server_variant collapse)
    print("[3/5] Detecting junk loops / cycles ...", flush=True)
    loop_nodes = set()
    for name in machine_like_names:
        if is_junk_loop(name):
            loop_nodes.add(name)

    # ── Classify all names
    print("[4/5] Classifying names ...", flush=True)
    kept = set()
    deleted = set()

    # All names that are machine-related
    all_machine_names = machine_like_names

    for name, count in name_counter.items():
        if name not in all_machine_names:
            continue  # skip non-machine noise entirely

        # Always keep if it's a core VM name AND not junk loop
        if is_core_vm(name) and not is_junk_loop(name):
            kept.add(name)
            continue

        # Delete if junk or junk-loop
        if is_junk(name) or is_junk_loop(name):
            deleted.add(name)
            continue

        # Ambiguous "machine"/"wasm" / numeric suffix variants — delete
        if name in NON_LEAN_NOISE:
            deleted.add(name)
            continue

        # Anything with a purely numeric suffix like _2, _3, etc.
        if re.search(r"_\d+$", name):
            # keep the base, delete numbered variants
            base = re.sub(r"_\d+$", "", name)
            if name != base:
                deleted.add(name)
                continue

        # Default: for any remaining ambiguous name, mark for review
        kept.add(name)  # conservative — keep unless clearly junk

    # ── Write outputs
    print("[5/5] Writing output files ...", flush=True)

    with open(OUT_DIR / "kept_names.txt", "w") as f:
        for n in sorted(kept):
            f.write(f"{n}\n")

    with open(OUT_DIR / "deleted_names.txt", "w") as f:
        for n in sorted(deleted):
            f.write(f"{n}\n")

    # Graph report
    with open(OUT_DIR / "graph_report.txt", "w") as f:
        f.write(f"=== VM Name Graph Classification Report ===\n\n")
        f.write(f"Total file paths scanned : {total_lines}\n")
        f.write(f"Total unique names       : {len(name_counter)}\n")
        f.write(f"Machine-related names     : {len(all_machine_names)}\n\n")

        f.write(f"=== Core VM Names Found ({len(core_names)}) ===\n")
        for n, c in core_names.most_common(50):
            f.write(f"  {c:6d}  {n}\n")

        f.write(f"\n=== Junk/Loop Names Identified ({len(junk_names)}) ===\n")
        for n, c in junk_names.most_common(30):
            f.write(f"  {c:6d}  {n}\n")

        f.write(f"\n=== Kept Names ({len(kept)}) ===\n")
        for n in sorted(kept)[:100]:
            f.write(f"  {n}\n")
        f.write(f"  ... ({len(kept) - 100} more)\n")

        f.write(f"\n=== Deleted Names ({len(deleted)}) ===\n")
        for n in sorted(deleted)[:100]:
            f.write(f"  {n}\n")
        f.write(f"  ... ({len(deleted) - 100} more)\n")

        f.write(f"\n=== Graph Edges (sample, showing junk->canonical mapping) ===\n")
        edge_count = 0
        for junk_name, targets in list(graph_edges.items())[:50]:
            for target in targets:
                f.write(f"  {junk_name} -> {target}\n")
                edge_count += 1
        f.write(f"  ... ({len(graph_edges)} edges total)\n")

        f.write(f"\n=== Junk Loop Nodes (>3 nested server_variant) ===\n")
        for n in sorted(loop_nodes):
            f.write(f"  {n}\n")

    print("\n=== DONE ===", flush=True)
    print(f"Kept names     : {len(kept)}")
    print(f"Deleted names  : {len(deleted)}")
    print(f"Output files in {OUT_DIR}/")
    print(f"  - kept_names.txt")
    print(f"  - deleted_names.txt")
    print(f"  - graph_report.txt")


if __name__ == "__main__":
    main()
