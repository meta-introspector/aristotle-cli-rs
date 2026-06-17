---
name: "dashlm-documentation"
description: "Documentation and examples for the shared-memory index system including usage guide, systemd service, plugin integration, and GPU examples."
---

# dashlm docs + examples

## Steps

1. Create `DOCS/dashlm-index/index.md`:
   - Architecture overview.
   - Prerequisites (Rust, CUDA optional, Nix).
   - Step-by-step: `make index-build`, `make index-show`, `make index-gpu-prep`.
   - systemd enable/start (`sudo make index-service-enable && sudo make index-service-start`).
   - zos-server plugin query examples (curl over unix socket).
   - Minimal rustc-plugin example using zos-server plugin `execute` function.
   - GPU usage example (gpu_query.cu + `/dev/shm/gpu_index_<hash>.bin`).
   - Troubleshooting (segment not found, permissions, rebuild loops).
2. Add `examples/dashlm_plugin_example.rs` showing minimal plugin using index via zos-server.
3. Verify docs build via `make help`; ensure example compiles.

## Source files

- `DOCS/dashlm-index/index.md`
- `examples/dashlm_plugin_example.rs`
