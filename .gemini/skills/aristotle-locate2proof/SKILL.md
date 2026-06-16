---
name: "aristotle-locate2proof"
description: "Extracts Lean declarations from locate results into a unified per-declaration structure with Nix flakes, enabling minimal recompilation and dependency graph analysis."
---

# aristotle-locate2proof — Lean Declaration Extractor from Locate Results

**Location:** `/mnt/data1/time-2026/05-may/07/arist/dasl-verification/`
**Source:** `/home/mdupont/projects/lean-split-tool/`

## What It Does

This skill takes a list of Lean file paths (from `locate` commands or file crawlers) and converts them into a unified per-declaration structure with Nix flakes, enabling minimal recompilation.

## Purpose

When you have multiple Lean 4 projects/repos containing Hecke-related code and want to:
- Unify them into a single compilation target
- Generate Nix flakes for each declaration for minimal recompilation
- Enable parallel builds
- Create a dependency graph for analysis

Use **locate2proof**. It bridges file-based indexing and declaration-based modularization.

## Usage

### Basic

```lean
/lean4:prove
  locatenames into a unified per-declaration structure with Nix flakes

Input: 
- `locate-results.txt` : Text file with .lean file paths (one per line)
  OR
- Any directory with the file paths mixed with other files

Output:
- `./locate2proof-output/`: One .lean file per declaration
- `.lean` per module, ready for modular building
```

/lean4:prove
  locatenames into a unified per-declaration structure with Nix flakes

Input: 
- `locate-results.txt` : Text file with .lean file paths (one per line)
  OR
- Any directory with the file paths mixed with other files

Output:
- `./locate2proof-output/`: One .lean file per declaration
- `.lean` per module, ready for modular building
```

## Input Format

### Option A: `locate-results.txt`
```text
/mnt/data1/git/github.com/chboishabba/monster/MonsterLean/HeckeProof.lean
/mnt/data1/git/github.com/chboishabba/monster/monster-shards/shard-02/lean4/verify/mf_hecke_cc.lean
/opt/compiler/tests/incremental/unchecked_dirty_clean.rs
```

### Option B: Scandirectory
```lean
lake env lean locate2proof.lean --scan /path/to/scan
```

## Output Format

```text
./locate2proof-output/
├── RequestProject/
│   ├── UmbralHeckeOperators/
│   │   ├── decl-001.lean
│   │   ├── decl-002.lean
│   │   └── flake.nix
│   ├── HeckeSharding/
│   │   ├── decl-001.lean
│   │   └── flake.nix
├── lakefile.toml
└── dag.json
```

## Command Line

```bash
# Process files from locate
cd /home/mdupont/projects/lean-split-tool

# Basic usage (uses default paths)
lake exe locate2proof

# Scan a directory instead of using locate results
lake exe locate2proof --scan /mnt/data1/git/github.com/meta-introspector/monster/

# Specific input and output
lake exe locate2proof --input-dir /path/to/locate/results/ --output-dir /path/to/split/output/

# Process specific modules only
lake exe locate2proof RequestProject.UmbralHeckeOperators RequestProject.HeckeSharding
```

## Example Workflow

```lean
1. Generate locate results
   find /path/to/hecke/files -name "*.lean" > locate-results.txt

2. Process with locate2proof
   lake exe locate2proof --input-dir ./ --output-dir ./hecke-split/
   
   # or use the existing hecke index
   lake exe locate2proof --scan /mnt/data1/git/github.com/meta-introspector/monster/

3. Build the split project
   cd hecke-split
   lake build
```

## Integration with DASL

The output can be used by:
- [[aristotle-splitter]]: Further split declarations into individual files
- [[aristotle-dasl-subgraph]]: Extract DASL/IPLD/CBOR relevant terms for subgraph analysis
- Lean LSP: For auto-completion and navigation in the merged codebase

## Features

- ✓ Reads locate results or scans directories
- ✓ Preserves file structure in output
- ✓ Generates Nix flakes per declaration
- ✓ Creates lakefile.toml automatically
- ✓ Outputs dependency graph (dag.json)
- ✓ Copies all .lean files to output for compilation

## Key Files

- [`locate2proof.lean`](file:///home/mdupont/projects/lean-split-tool/locate2proof.lean) — Main plugin
- [`SplitDecls.lean`](file:///home/mdupont/projects/lean-split-tool/SplitDecls.lean) — Declaration extraction engine
- [`AristotleSplit.lean`](file:///home/mdupont/projects/lean-split-tool/AristotleSplit.lean) — Project splitter

## Status

🔧 **New skill** — Created as part of DASL automation toolkit
⚠️ **Require Fill প্রথম proof**: Merged file pulls you require
- 1,687 `sorry` statments to fill
- needs accessền couperte ressources

Call `/lean4:checkpoint` before any modification.
Requires [[aristotle-dasl-subgraph]] dragonfly-develkok

## Dependencies

- [[lean4]] : Lean 4 compiler
- [[aristotle-splitter]] : Declaration splitter  
- [[nix]] : Flakes pulled β

## See Also

- [[aristotle-dasl-subgraph]]: DASL term filter and subgraph extractor
- [[aristotle-mathlib-split]]: The 5,790-declaration DASL pool
- [[aristotle-j-invariant]]: j-invariant prime stratification

You have α

## Examples

```lean
# Use locate-results.txt
/home/mdupont/projects/lean-split-tool/lake exe locate2proof --input-dir /mnt/data1/time-2026--output-dir /mnt/data1/locate2proof

# Scandirectory instead  
./lake exe locate2proof /mnt/data1/git/github.com/meta-introspector/monster/
```
