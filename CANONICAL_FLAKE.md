# Aristotle → DASL Canonical Flake Pipeline

End-to-end pipeline: fetch Aristotle projects → generate per-declaration
flake.nix files with resolved mathlib-split dependencies → buildable modules.

## Commands

### Single project
```bash
cd ~/projects/arist
cargo run --release -- canonical-flake \
  --input-dir /path/to/project/output-final_aristotle \
  --output-dir /tmp/flakes
```

### All projects
```bash
cargo run --release -- canonical-flake-all \
  --output-dir /tmp/all-flakes
```

### Custom mathlib path
```bash
cargo run --release -- canonical-flake-all \
  --mathlib-split /custom/mathlib-split
```

## Output Structure

```
all-flakes/
├── <project-uuid>/
│   ├── RequestProject/
│   │   ├── ShapeBott/      (.lean + flake.nix, 0 mathlib deps)
│   │   └── ...
│   └── ConsolidatedDasl/
│       ├── CarStorage/Init/ (.lean + flake.nix, 2 mathlib deps)
│       └── ...
```

## Building

```bash
nix build /tmp/all-flakes/<project>/RequestProject/ShapeBott#
```

## Stats (2026-06-24)

| Metric | Count |
|--------|-------|
| Downloaded projects | 94 |
| Projects with .lean files | 64 |
| Total per-module flakes | 4,674 |
| Mathlib imports resolved | 7,692 |
| Resolution rate | 100% |
| Build success (tested) | 61/61 |

## Pipeline Steps

1. `fetch` — download projects from Aristotle API
2. `canonical-flake-all` — split + resolve mathlib deps
3. `nix build` — per-module builds

## Dependencies

- `~/projects/lean-split-tool/mathlib-split/` — 13,716 mathlib modules (directory-level flakes)
- `~/git/github.com/numtide/flake-utils` — nix flake utilities
- `~/git/github.com/NixOS/nixpkgs` — nix packages

## Implementation

- `src/pipeline_steps.rs` — `cmd_canonical_flake`, `cmd_canonical_flake_all`
- `src/main.rs` — CLI definitions and dispatch
