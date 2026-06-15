---
name: cargo-vendormod-troubleshooting
description: Diagnose and recover from cargo-vendormod failures. Use when tests fail, builds error, zkperf errors, git submodules break, flakes are invalid, or LLM error pipelines misfire.
---

# Cargo-Vendormod Troubleshooting

## Symptom Matrix

| Symptom | Likely Cause | Fix |
|---|---|---|
| `modified: ... (untracked content)` | Submodule has local changes | Commit or add `.gitignore` in submodule |
| `'path' does not have a commit checked out` | Submodule not initialized | `git submodule update --init --recursive` |
| `Too Many Requests` from Solana mirror | Mirror crate rate limit | Use `crates.io` or local mirror instead |
| `cargo generate-lockfile` fails | Network or bad manifest | Run with `--offline` or fix manifest |
| Flake build fails | Missing crate2nix output | Re-run `processing crates ... --generate-flakes` |
| zkperf binary missing | Tool not installed | Install `cargo-zkperf` or set `use_builtin` |
| Test `I/O` errors | Missing temp dirs | Ensure `target/` and `/tmp` writable |

## Diagnostic Commands

```bash
cargo test
cargo test --test dag_cbor_tests
git submodule status
nix flake check
```

## Recovery Steps

1. Re-run `cargo test --test <module>` to reproduce.
2. Check `logs/` and `.pipelight/`.
3. Restore with `git restore <path>` or revert to last green commit.
4. Rebuild flakes for affected crate only.

## LLM Error Pipeline

Use `cargo_vendormod::error_to_llm_pipeline` to convert errors to structured reports for model-assisted triage.
