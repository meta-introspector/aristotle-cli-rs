# Aristotle Manager — Agent Guide

## Project Overview

Rust CLI (`aristotle-manager`) that orchestrates the full Aristotle → Lean → Nix pipeline:
polling the Aristotle API, downloading Lean4 results, splitting declarations into
per-declaration flakes, and generating DASL-compatible indexes.

## Key Paths

- `src/main.rs` — All CLI commands (poll, download, build, split, split-all, decl-table, merge, refresh, index)
- `src/index.rs` — DASL blocks.json indexer
- `src/notebooklm.rs` — NotebookLM text generator
- `src/tests.rs` — Integration tests
- `splitter-engine/` — Lean project hosting SplitDecls.lean + MicroLean.lean
- `split-lean-project.sh` — Shell driver for Lean splitter
- `split-aristotle-project.sh` — Shell driver for Aristotle project splitting

## Build & Run

```bash
cargo build --release
cargo run --release -- <command>
```

## Splitting Pipeline

Python `static_split.py` has been replaced by Rust+Lean:
- **Rust driver** (`cmd_split`, `cmd_split_all`) discovers projects and invokes the Lean splitter
- **Lean splitter** (`SplitDecls.lean`) uses the Environment API for exact dependency tracking
- **Makefile targets** (`make split`, `make split-all`) go through the Rust binary

## Skills

- `aristotle-manager` — Full CLI reference, commands, architecture, data flow
- `aristotle-splitter` — Lean declaration splitter (kernel API + static regex modes)
- `micro-lean-ffi` — FFI extraction meta-system with verified polyglot emitters

## Conventions

- All split targets go through `cargo run --release -- split` (not Python)
- Lean toolchain: v4.28.0 (splitter-engine), v4.29.1 (lean-split-decls standalone)
- Nix flake uses local nixpkgs + nora for Rust toolchain
- API key via `ARISTOTLE_API_KEY` env or `configure set`
