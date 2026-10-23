#!/usr/bin/env python3
"""
Process the massive all_lean_locate.txt.gz file to:
1. Extract all Lean file names (basename)
2. Count frequencies
3. Identify core machine types
4. Detect and remove junk loops/variants
5. Output a cleaned list and statistics

Output:
- cleaned_names.txt: names to keep (one per line)
- stats.txt: summary of what was kept/deleted
"""

import gzip
import re
import sys
from collections import defaultdict, Counter
from pathlib import Path

# ----------------------------------------------------------------------
# CONFIGURATION
# ----------------------------------------------------------------------
INPUT_GZ = "/home/mdupont/projects/arist/all_lean_locate.txt.gz"
OUTPUT_DIR = Path("/mnt/data1/time-2026/05-may/07/arist")
CLEANED_LIST = OUTPUT_DIR / "cleaned_names.txt"
STATS_FILE = OUTPUT_DIR / "stats.txt"

# Core machine categories (keep these)
CORE_MACHINES = {
    "SBFMachine", "StackMachine", "SoftMachine", "Mini2Machine",
    "ZiskMachine", "ZiskMachineFull", "OodaMachine", "MachineTranslatable",
    "VonNeumannIASMachine", "WumpusMachine", "VoteMachine", "TycoonMachine",
    "TournamentMachine", "QbertMachine", "OracleMachine", "MemeMachine",
    "MarketMachine", "LordMachine", "InvadersMachine", "HyperspaceMachine",
    "FrontierMachine", "FlightMachine", "DashMachine", "UniversalMachine",
    "UniversalMachineMain", "UniversalMachineTeachingSet", "UniversalGroupMachine",
    "ProjectiveLine32Machine", "ProjectiveLine27Machine", "AffineFourMachine",
    "MoreTransitiveMachines", "MoreLargeMachines", "MathieuBigMachines",
    "EvenMoreTransitiveMachines", "Machine", "MachineFull", "server_variant_Machine"
}

# Junk patterns to exclude
JUNK_PATTERNS = [
    r'^\d+$',  # pure numbers
    r'^AbstractLaw_.*',  # abstract law lemmas
    r'^.*_.*\.lean$',  # names with underscores (variants)
    r'^.*\.lean$',  # generic .lean files (keep core ones)
]

# ----------------------------------------------------------------------
def extract_basename(line: str) -> str:
    """Extract the basename from a full path (last component after '/')."""
    parts = line.strip().split('/')
    return parts[-1] if parts else ""

def normalize_name(name: str) -> str:
    """Normalize name by removing .lean extension and making lowercase."""
    name = name.lower()
    if name.endswith('.lean'):
        name = name[:-5]  # remove .lean
    return name

def is_junk(name: str) -> bool:
    """Check if a name matches any junk pattern."""
    name_lc = name.lower()
    for pattern in JUNK_PATTERNS:
        if re.match(pattern, name_lc):
            return True
    return False

def is_core_machine(name: str) -> bool:
    """Check if the name is a core machine type."""
    name_lc = name.lower()
    for core in CORE_MACHINES:
        if core in name_lc:
            return True
    return False

def main():
    print("Processing all_lean_locate.txt.gz...")
    name_counter = Counter()
    total_lines = 0
    
    # Read gzipped file
    with gzip.open(INPUT_GZ, 'rt', encoding='utf-8') as f:
        for line in f:
            total_lines += 1
            basename = extract_basename(line)
            if not basename:
                continue
            normalized = normalize_name(basename)
            name_counter[normalized] += 1
    
    print(f"Processed {total_lines} lines, found {len(name_counter)} unique names")
    
    # Categorize names
    categories = defaultdict(Counter)
    for name, count in name_counter.items():
        category = "Core" if is_core_machine(name) else ("Junk" if is_junk(name) else "Other")
        categories[category][name] += 1
    
    # Build statistics
    stats = {
        'total_unique_names': len(name_counter),
        'core_machine_count': sum(cnt for name, cnt in name_counter.items() if is_core_machine(name)),
        'junk_count': sum(cnt for name, cnt in name_counter.items() if is_junk(name)),
        'other_count': sum(cnt for name, cnt in name_counter.items() if not is_core_machine(name) and not is_junk(name)),
        'top_core_machines': name_counter.most_common(15),
        'junk_patterns': {}
    }
    
    # Identify junk patterns
    for pattern in JUNK_PATTERNS:
        matched = sum(cnt for name, cnt in name_counter.items() if re.match(pattern, name))
        if matched > 0:
            stats['junk_patterns'][pattern] = matched
    
    # Determine what to keep
    keep_names = set()
    delete_names = set()
    review_names = set()
    
    for name, count in name_counter.items():
        if is_core_machine(name):
            keep_names.add(name)
        elif is_junk(name):
            delete_names.add(name)
        else:
            # For other names, keep the most frequent variant
            # Look for variants (e.g., Machine.lean, Machine_2.lean)
            variants = [n for n in name_counter if n.startswith(name) and n != name]
            if variants:
                # Keep the most frequent variant
                best_variant = max(variants, key=lambda n: name_counter[n])
                keep_names.add(best_variant)
                for v in variants:
                    if v != best_variant:
                        delete_names.add(v)
            else:
                # Single name, keep it
                keep_names.add(name)
    
    # Write cleaned list
    with open(CLEANED_LIST, 'w', encoding='utf-8') as f:
        for name in sorted(keep_names):
            f.write(f"{name}.lean\n")
    
    # Write stats
    with open(STATS_FILE, 'w', encoding='utf-8') as f:
        f.write(f"Total unique names: {stats['total_unique_names']}\n")
        f.write(f"Core machine names kept: {stats['core_machine_count']}\n")
        f.write(f"Junk names to delete: {stats['junk_count']}\n")
        f.write(f"Other names reviewed: {stats['other_count']}\n")
        f.write(f"Top core machines:\n")
        for name, cnt in stats['top_core_machines']:
            f.write(f"  {name}: {cnt}\n")
        f.write("\nJunk patterns found:\n")
        for pattern, cnt in stats['junk_patterns'].items():
            f.write(f"  {pattern}: {cnt}\n")
    
    print(f"Cleaned list written to {CLEANED_LIST}")
    print(f"Stats written to {STATS_FILE}")
    print("\n=== SUMMARY ===")
    print(f"Total unique names: {stats['total_unique_names']}")
    print(f"Core machine names (kept): {stats['core_machine_count']}")
    print(f"Junk names (to delete): {stats['junk_count']}")
    print(f"Other names (to review): {stats['other_count']}")
    print(f"\nCore machines to keep: {len(CORE_MACHINES)}")
    print("Next steps:")
    print("1. Review cleaned_names.txt for any missing core machines")
    print("2. Verify that junk patterns are correctly identified")
    print("3. Use plocate locate to find physical locations of the kept files")
    print("4. Proceed with git mirrors and worktree setup")

if __name__ == "__main__":
    main()
