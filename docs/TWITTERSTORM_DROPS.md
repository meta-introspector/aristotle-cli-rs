# Twitterstorm Drops Processing Guide

This document explains how to fetch, download, and process the latest Twitterstorm Aristotle drops.

## Quick Reference

```bash
# 1. Check status of twitterstorm projects
make check-twitterstorm

# 2. Fetch all new twitterstorm drops (incremental)
make fetch-twitterstorm

# 3. Download a specific project result
make download-twitterstorm PROJECT_ID=<id>

# 4. Build and test the Lean project
cd /path/to/project
lake exe cache get
lake build
lake exe RequestProject
```

## Step-by-Step Process

### 1. Check Twitterstorm Project Status

Use the aristotle-manager CLI to check projects on the twitterstorm account:

```bash
cd ~/projects/arist
# Using Makefile target (recommended)
make check-twitterstorm

# OR direct CLI command
ARISTOTLE_API_KEY_FILE=/home/mdupont/.config/aristotle-manager/keys/twitterstorm.key \
  ./target/release/aristotle-manager check --account twitterstorm --limit 30
```

This shows:
- Project ID
- Status (QUEUED/IN_PROGRESS/DONE/FAILED)
- Name/Description
- Creation/Update timestamps
- Local build status (.lean files, sorries, flakes)

### 2. Fetch Latest Twitterstorm Drops

To fetch any new or updated projects from the twitterstorm account:

```bash
# Using Makefile
make fetch-twitterstorm

# OR direct CLI (uses your twitterstorm API key)
ARISTOTLE_API_KEY_FILE=/home/mdupont/.config/aristotle-manager/keys/twitterstorm.key \
  ./target/release/aristotle-manager fetch --account twitterstorm
```

Options:
- `--recent-days N` - Only check projects from last N days (default: 7)
- `--limit N` - Limit number of projects to check
- `-j <parallel>` - Number of parallel downloads (default: 2)

### 3. Download Twitterstorm Project Results

Once a project shows status `DONE` and `has_files=true`, download its results:

```bash
# Download specific project by ID
ARISTOTLE_API_KEY_FILE=/home/mdupont/.config/aristotle-manager/keys/twitterstorm.key \
  ./target/release/aristotle-manager download-result <PROJECT_ID> \
  --account twitterstorm \
  --output-dir /mnt/data1/aristotle-results/latest-twitterstorm/
```

Using Makefile:
```bash
make download-twitterstorm PROJECT_ID=14b370a6-8c7b-42a4-9e19-cbdbfa49452b
```

This will:
1. Download the `output-final.tar.gz` from Aristotle
2. Extract it to the specified output directory
3. Show a summary of what was downloaded

### 4. Build and Test the Lean Project

Twitterstorm drops contain Lean 4 + Mathlib projects. To build:

```bash
# Navigate to the extracted project
cd /mnt/data1/aristotle-results/latest-twitterstorm/<PROJECT_ID>_aristotle/<INNER_PROJECT>_aristotle/

# Get Mathlib dependencies (optional but recommended)
lake exe cache get

# Build the project
lake build

# Run the main executable to verify axioms
lake exe RequestProject
```

Expected output:
- No errors during `lake build`
- `#print axioms` shows only standard Lean/Mathlib axioms (`propext`, `Classical.choice`, `Quot.sound`)
- No `sorry` or `admit` in any .lean files

## Current Twitterstorm Project Structure

As of the latest fetch, the twitterstorm account contains these notable projects:

| Project ID | Status | Date | Description |
|------------|--------|------|-------------|
| `14b370a6-8c7b-42a4-9e19-cbdbfa49452b` | DONE | 2026-09-19 | Small Lean 4 + Mathlib project with machine-checked bounds |
| `50dd95e0-403a-4713-8f10-45f48715bd5c` | DONE | 2026-09-13 | Model the pricing.md registry |
| `a9dd29c5-a8b5-4281-a91a-a75dfa4adeed` | DONE | 2026-09-12 | (Unnamed) |
| `d4081a85-0cc3-4eef-9065-1db9ed56d316` | DONE | 2026-09-12 | Twitter tracker project with Lean formalization |
| `7ba9326b-951b-4d42-8bd3-a4f9fd4f7a59` | DONE | 2026-09-12 | (Unnamed) |
| `3a8443b1-0e97-4fd4-ada9-b2b02e0335a4` | DONE | 2026-09-11 | Merge and continue Twitter tracker formalization |
| `9818aa9f-c2ea-4067-aebd-6b7f928c0abd` | DONE | 2026-09-10 | (Unnamed) |
| `a4f39bfc-f2f6-426d-a098-5c7c5edfda41` | DONE | 2026-09-10 | (Unnamed) |

### Latest Project Details (14b370a6-...)

**Project:** Bounded market-observation scheduler  
**Files:** 6 .lean files  
**Build:** Clean build with Mathlib v4.28.0  
**Properties verified:**
1. Capacity necessity: `2*N ≤ B*C`
2. Deadline bound: `N ≤ B*(1+(T-delta)/D)`  
3. Constructive ideal schedule: 3 coins per group, 40000ms cadence
4. Evidence-time safety: Counterexample to usability composition

**Location:** `/mnt/data1/aristotle-results/latest-twitterstorm/14b370a6-8c7b-42a4-9e19-cbdbfa49452b_aristotle/`

**Lean files:**
- `RequestProject/Basic.lean` - Timestamp/receipt model
- `RequestProject/Capacity.lean` - Property 1 proofs
- `RequestProject/Deadline.lean` - Property 2 proofs  
- `RequestProject/Schedule.lean` - Property 3 proofs
- `RequestProject/Evidence.lean` - Property 4 proofs
- `RequestProject/Main.lean` - Axiom verification

## Automation Scripts

Several helper scripts exist in the aristotle-manager project:

```bash
# Process latest twitterstorm drops end-to-end
~/projects/arist/scripts/aristo-pull.sh

# Check and download latest twitterstorm project
~/projects/arist/scripts/aristo-twitterstorm.sh

# Build all twitterstorm projects
~/projects/arist/scripts/aristo-twitterstorm-build.sh
```

## Troubleshooting

### "No such file or directory" errors
- Ensure you're using the correct path: `/mnt/data1/time-2026/05-may/07/arist/`
- The binary is at: `/mnt/data1/time-2026/05-may/07/arist/target/release/aristotle-manager`

### Authentication errors
- Verify your twitterstorm.key exists: `ls -la ~/.config/aristotle-manager/keys/twitterstorm.key`
- Key should be a 49-character string starting with `arstl_`
- Test with: `ARISTOTLE_API_KEY_FILE=~/.config/aristotle-manager/keys/twitterstorm.key ./target/release/aristotle-manager configure show`

### Build fails
- Run `lake exe cache get` first to fetch Mathlib dependencies
- Ensure you have ~2GB free space for Mathlib oleans
- Check lake-toolchain: `cat lean-toolchain` should show `leanprover/lean4:v4.28.0`

### No new projects found
- The fetch command is incremental - it only checks for updates since last fetch
- Use `--recent-days 30` to check a wider window
- Projects may be processing under a different account name

## Related Documentation

- [`USAGE.md`](USAGE.md) - General aristotle-manager usage
- [`Makefile`](Makefile) - Available make targets
- [`plan.md`](plan.md) - Migration status from shell scripts to Rust
- [`API_KEY_DISCOVERY.md`](API_KEY_DISCOVERY.md) - How API keys are resolved

## Contact

For issues with the aristotle-manager tool itself, consult the source code in:
- `~/projects/arist/src/main.rs` - Rust CLI implementation
- `~/projects/arist/scripts/` - Legacy shell scripts