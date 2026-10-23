#!/usr/bin/env python3
"""
Name Classifier and De-Duplication Tool

This tool processes the massive list of Lean file names from:
  - /mnt/data1/time-2026/05-may/07/arist/names.txt
  - /home/mdupont/projects/arist/all_lean_locate.txt.gz
  
It:
1. Extracts machine categories (SBFMachine, StackMachine, UniversalMachine, etc.)
2. Identifies junk / noise entries (UUID prefixes, AbstractLaw_Machine.*, numeric suffixes)
3. Suggests deletions (keep canonical versions, delete variants)
4. Outputs a categorized CSV with statistics

The core Machine types found are:
- SBFMachine (97 occurrences) - main candidate to keep
- StackMachine (89 occurrences) - main candidate to keep  
- Machine (168 occurrences) - generic machine, keep
- UniversalMachine (165 occurrences) - keep
- SoftMachine (37 occurrences) - keep
- ProjectiveLine*/AffineFour* (65 occurrences) - keep
- Mini2Machine (27 occurrences) - keep
- ZiskMachine*/ZiskMachineFull (61 occurrences) - keep
- OodaMachine (22 occurrences) - keep
- Meta-candidates for deletion: AbstractLaw_*, UUID_*, numeric suffixes, unique .lean files

Expected deletions: >80% (about 1000 files) to reduce to core machine types.
"""

import gzip
import re
import csv
import sys
import os
from collections import defaultdict, Counter
from pathlib import Path

# ----------------------------------------------------------------------
# CONFIGURATION
# ----------------------------------------------------------------------
INPUT_FILES = [
    "/mnt/data1/time-2026/05-may/07/arist/names.txt",
    # "/home/mdupont/projects/arist/all_lean_locate.txt.gz",  # add back if available
]

OUTPUT_DIR = Path("/mnt/data1/time-2026/05-may/07/arist")
OUTPUT_CSV = OUTPUT_DIR / "name_classification.csv"
OUTPUT_STATS = OUTPUT_DIR / "name_classification_stats.txt"

# Regex patterns for different line formats
# Format 1: "count name.lean" (e.g., "102 SBFMachine.lean")
LINE_FORMAT1_RE = re.compile(r'^\s*(\d+)\s+([^\s]+\.lean)$')
# Format 2: "UUID_prefix_name.lean" (e.g., "01cf5ff3-cc71-4aef-8b74-1644d23da7de_RequestProject_Wasm_Machine.lean")
LINE_FORMAT2_RE = re.compile(r'^\s*[^\s]+_(.+)$')

# Core machine categories (these are likely the essential machine implementations)
CORE_MACHINES = {
    "SBFMachine", "StackMachine", "SoftMachine", "Mini2Machine",
    "ZiskMachine", "ZiskMachineFull", "OodaMachine", "MachineTranslatable",
    "VonNeumannIASMachine", "WumpusMachine", "VoteMachine", "TycoonMachine",
    "TournamentMachine", "QbertMachine", "OracleMachine", "MemeMachine",
    "MarketMachine", "LordMachine", "InvadersMachine", "HyperspaceMachine",
    "FrontierMachine", "FlightMachine", "DashMachine", "UniversalMachine",
    "UniversalMachineMain", "UniversalMachineTeachingSet", "UniversalMachineDistinct",
    "UniversalGroupMachine", "ProjectiveLine32Machine", "ProjectiveLine27Machine",
    "MoreTransitiveMachines", "MoreLargeMachines", "MathieuBigMachines",
    "EvenMoreTransitiveMachines", "AffineFourMachine",
    "Machine", "MachineFull", "server_variant_Machine"
}

# Categories to consider for deletion (junk patterns)
JUNK_PATTERNS = [
    r'^\d+$',  # pure numbers (e.g., "1.lean")
    r'^AbstractLaw_Machine_.*',  # abstract law lemmas
    r'^AbstractLaw_.*',  # any AbstractLaw
    r'^\d+\.lean$',  # numbered files
    r'^[0-9]+_',  # UUID prefix (already stripped by format2)
    r'_\d+$',  # trailing numbers
    r'^ProjectiveLine\d+$',  # single projective lines
    r'^Line\d+$',
    r'^act\.lean$',  # special functions
    r'^spec\.lean$',
    r'^run\.lean$',
    r'^noConfusion\.lean$',
    r'^noConfusionType\.lean$',
    r'^spec\.lean$',
    r'^run\.lean$',
]

# ----------------------------------------------------------------------
# UTILITY FUNCTIONS
# ----------------------------------------------------------------------
def extract_uuid_prefix(line: str) -> str:
    """Extract UUID prefix from a line like '01cf5ff3-cc71-4aef-8b74-1644d23da7de_RequestProject_Wasm_Machine.lean'"""
    return line.split('_')[0] if '_' in line else None

def clean_filename(filename: str) -> str:
    """Remove UUID prefix if present and return just the actual filename."""
    if '_' in filename:
        return filename.split('_', 1)[1]
    return filename

def categorize_file(filename: str) -> str:
    """Categorize based on the filename components."""
    base_name = clean_filename(filename)
    
    # Check if it's a core machine
    for core in CORE_MACHINES:
        if core in base_name:
            return "Core"
    
    # Check if it's a variant (server_variant_*, __variants__)
    if 'server_variant_' in base_name or '__variants__' in base_name:
        return "Variant"
    
    # Check if it's a duplicate/meta file
    if any(re.match(pattern, base_name) for pattern in JUNK_PATTERNS):
        return "Junk"
    
    # Check if it looks like a generated lemma
    if re.match(r'^.*\d+\.lean$', base_name) or re.match(r'^.*_[a-zA-Z]*$', base_name):
        return "Generated"
    
    return "Other"

def parse_line(line: str) -> tuple:
    """Parse a line and return (original_line, file_path, category, suggestion)."""
    line = line.strip()
    if not line:
        return None
    
    # Try Format 1: "count name.lean"
    m1 = LINE_FORMAT1_RE.match(line)
    if m1:
        count, name = m1.groups()
        file_path = f"{count} {name}"
        category = categorize_file(name)
        suggestion = get_suggestion(category, name)
        return (line, file_path, category, suggestion)
    
    # Try Format 2: "UUID_name.lean"
    m2 = LINE_FORMAT2_RE.match(line)
    if m2:
        full_name = m2.group(1)
        # Extract original count if available
        count = line.split()[0] if line.split()[0].isdigit() else "1"
        file_path = f"{count} {full_name}"
        category = categorize_file(full_name)
        suggestion = get_suggestion(category, full_name)
        return (line, file_path, category, suggestion)
    
    # No match - treat as junk
    return (line, line, "Junk", "manual_review")

def get_suggestion(category: str, filename: str) -> str:
    """Get deletion suggestion based on category and filename."""
    if category == "Core":
        return "keep"
    elif category == "Variant":
        return "maybe_delete"
    elif category == "Junk":
        return "delete"
    elif category == "Generated":
        return "likely_delete"
    elif category == "Other":
        # For other files, be conservative
        return "review"
    else:
        return "review"

def format_stats(stats: dict) -> str:
    """Format stats dictionary into a readable string."""
    output = []
    output.append("=== NAME CLASSIFICATION STATISTICS ===")
    output.append(f"Total files processed: {stats['total_files']}")
    output.append(f"Unique file names: {stats['unique_names']}")
    output.append(f"Core machines to keep: {stats['core_count']}")
    output.append(f"Variants to maybe delete: {stats['variant_count']}")
    output.append(f"Junk files to delete: {stats['junk_count']}")
    output.append(f"Generated files to likely delete: {stats['generated_count']}")
    output.append(f"Other files to review: {stats['other_count']}")
    output.append("\n=== TOP 20 CORE MACHINES ===")
    for machine, count in stats['top_core_machines']:
        output.append(f"{machine}: {count}")
    output.append("\n=== JUNK PATTERNS FOUND ===")
    for pattern_name, count in stats['junk_patterns'].items():
        output.append(f"{pattern_name}: {count}")
    return "\n".join(output)

# ----------------------------------------------------------------------
# MAIN FUNCTION
# ----------------------------------------------------------------------
def main():
    print("=== NAME CLASSIFIER AND DE-DUPLICATION TOOL ===\n")
    
    # Read and parse all input files
    all_records = []
    total_lines = 0
    
    for input_file in INPUT_FILES:
        if not os.path.exists(input_file):
            print(f"WARNING: Input file not found: {input_file}")
            continue
            
        print(f"Processing {input_file}...")
        if input_file.endswith('.gz'):
            f = gzip.open(input_file, 'rt', encoding='utf-8')
        else:
            f = open(input_file, 'r', encoding='utf-8')
        
        lines = f.readlines()
        f.close()
        total_lines += len(lines)
        
        for line in lines:
            if line.strip():
                record = parse_line(line)
                if record:
                    all_records.append(record)
    
    print(f"Total lines processed: {total_lines}")
    print(f"Records created: {len(all_records)}")
    
    # Analyse statistics
    unique_names = set()
    cat_counter = Counter()
    junk_patterns = Counter()
    core_machines = Counter()
    
    for original_line, file_path, category, suggestion in all_records:
        unique_names.add(file_path)
        cat_counter[category] += 1
        
        # Track junk patterns
        if category == "Junk":
            for pattern in JUNK_PATTERNS:
                if re.match(pattern, file_path.split()[-1]):
                    junk_patterns[pattern] += 1
                    break
        
        # Track core machines for detailed stats
        if category == "Core":
            # Extract the base machine name (before .lean)
            base_name = file_path.split()[-1].replace('.lean', '')
            core_machines[base_name] += 1
    
    # Build statistics dictionary
    stats = {
        'total_files': len(all_records),
        'unique_names': len(unique_names),
        'core_count': cat_counter.get('Core', 0),
        'variant_count': cat_counter.get('Variant', 0),
        'junk_count': cat_counter.get('Junk', 0),
        'generated_count': cat_counter.get('Generated', 0),
        'other_count': cat_counter.get('Other', 0),
        'top_core_machines': core_machines.most_common(20),
        'junk_patterns': dict(junk_patterns),
    }
    
    # Write CSV output
    print(f"Writing classification to {OUTPUT_CSV}")
    with open(OUTPUT_CSV, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['original_line', 'file_path', 'category', 'suggestion'])
        for record in all_records:
            writer.writerow(record)
    
    # Write stats output
    print(f"Writing stats to {OUTPUT_STATS}")
    with open(OUTPUT_STATS, 'w', encoding='utf-8') as f:
        f.write(format_stats(stats))
    
    # Print summary
    print("\n=== SUMMARY ===")
    print(f"Total files to analyze: {stats['total_files']}")
    print(f"Unique file names: {stats['unique_names']}")
    print(f"\nDeletion recommendations:")
    print(f"  - Delete {stats['junk_count']} junk files")
    print(f"  - Delete {stats['generated_count']} generated files")
    print(f"  - Review {stats['other_count']} other files")
    print(f"\nKeep {stats['core_count']} core machine files")
    print(f"Maybe keep {stats['variant_count']} variant files")
    
    print(f"\nOutput files:")
    print(f"  - CSV: {OUTPUT_CSV}")
    print(f"  - Stats: {OUTPUT_STATS}")
    
    # Return statistics for programmatic use
    return stats

if __name__ == "__main__":
    stats = main()
