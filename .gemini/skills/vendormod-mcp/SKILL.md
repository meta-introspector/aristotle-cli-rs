---
name: vendormod-mcp
description: >-
  MCP server and CLI tools for DASL vendormod workflows — compile-to-shmem,
  crate normalization, flake.nix generation, and DASL index registration.
  Includes pi extension integration and NORA registry config.
---

# Vendormod MCP — Cargo Vendor Workflow Server

MCP server and CLI tools for DASL vendormod workflows — compile-to-shmem,
crate normalization, flake.nix generation, and DASL index registration.

## Binary: `cargo-vendormod-mcp`

Model Context Protocol (MCP) server over stdio. Exposes 5 tools:

| Tool | Description |
|------|-------------|
| `compile_to_shmem` | Compile crate → IPLD CAR shmem + vendormod workflows |
| `normalize_cargo_toml` | Sort deps, ensure `[package]` fields |
| `generate_flake_nix` | Generate `flake.nix` with `buildRustPackage` |
| `scan_crates` | Find all `Cargo.toml` files in directory tree |
| `dasl_index` | Register crate in DASL `grep_rs.txt` index |

### Running

```bash
# Build
cd /mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod
cargo build --bin cargo-vendormod-mcp

# Run (stdio transport)
./target/debug/cargo-vendormod-mcp
```

### Protocol

JSON-RPC 2.0 over stdin/stdout. Protocol version `2024-11-05`.

```bash
# Test
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}' | cargo-vendormod-mcp
echo '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' | cargo-vendormod-mcp
```

## Binary: `compile-to-shmem`

Standalone CLI for compiling a Rust crate to IPLD CAR shared memory.

```bash
./target/debug/compile-to-shmem --crate-path /path/to/crate
./target/debug/compile-to-shmem --crate-path . --skip-build --dry-run
./target/debug/compile-to-shmem --workflow normalize,nix
```

### Options

| Flag | Default | Description |
|------|---------|-------------|
| `--crate-path` | `.` | Path to crate directory |
| `--skip-build` | false | Skip `cargo build` |
| `--workflow` | `all` | Workflows: `normalize,nix,workspace,dasl-index,all` |
| `--output-dir` | `./vendormod-output` | Output directory |
| `--shmem-socket` | `@ipld_car_shmem` | IPLD shmem Unix socket |
| `--dry-run` | false | Show plan without executing |
| `-v, --verbose` | false | Verbose output |

## NORA Registry Integration

All crate dependencies resolve through NORA at `http://127.0.0.1:4000/cargo/`.

### `.cargo/config.toml`

```toml
[source.crates-io]
replace-with = "nora"

[source.nora]
registry = "sparse+http://127.0.0.1:4000/cargo/index/"

[patch.crates-io]
ipld-car-ipc-shmem-linux = { path = "/home/mdupont/dasl/ipld-car-ipc-shmem-linux" }
```

### NORA Health

```bash
curl http://127.0.0.1:4000/health
# {"status":"healthy","version":"0.9.2",...,"registries":{"cargo":"ok"}}
```

## Locations

| Resource | Path |
|----------|------|
| vendormod root | `/mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/` |
| MCP server | `src/bin/mcp_server.rs` |
| compile-to-shmem | `src/bin/compile_to_shmem.rs` |
| NORA cargo config | `.cargo/config.toml` |
| NORA storage | `/mnt/data1/nora/storage/cargo/` |
| IPLD shmem | `/home/mdupont/dasl/ipld-car-ipc-shmem-linux/` |

## Pi Integration

### Via custom tool extension

Create `~/.pi/agent/extensions/vendormod.ts`:

```typescript
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { spawnSync } from "node:child_process";

const BIN = "/mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/target/debug/cargo-vendormod-mcp";

// Directly invoke the vendormod binary for compile-to-shmem
function compileToShmem(args: { crate_path?: string; workflow?: string; dry_run?: boolean }) {
  const { status, stdout, stderr } = spawnSync(
    "/mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/target/debug/compile-to-shmem",
    [
      "--crate-path", args.crate_path ?? ".",
      "--workflow", args.workflow ?? "all",
      ...(args.dry_run ? ["--dry-run"] : []),
    ],
    { timeout: 300_000, encoding: "utf-8" }
  );
  return `${stdout}\n${stderr}` + (status !== 0 ? `\nEXIT: ${status}` : "");
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "vendormod_compile_to_shmem",
    label: "Compile to Shmem",
    description: "Compile a Rust crate, push artifacts to IPLD CAR shared memory, and apply vendormod workflows (normalize, nix, workspace, dasl-index).",
    promptSnippet: "Vendormod: compile crate to IPLD CAR shmem with workflows",
    parameters: Type.Object({
      crate_path: Type.Optional(Type.String({ description: "Path to crate directory" })),
      workflow: Type.Optional(Type.String({ description: "Workflows: normalize,nix,workspace,dasl-index,all" })),
      dry_run: Type.Optional(Type.Boolean({ description: "Show plan without executing" })),
    }),
    async execute(_toolCallId, params) {
      const result = compileToShmem(params);
      return {
        content: [{ type: "text", text: result }],
        details: {},
      };
    },
  });

  pi.registerTool({
    name: "vendormod_normalize",
    label: "Normalize Cargo.toml",
    description: "Sort dependencies alphabetically in Cargo.toml and ensure required [package] fields exist.",
    parameters: Type.Object({
      crate_path: Type.String({ description: "Path to crate directory containing Cargo.toml" }),
    }),
    async execute(_toolCallId, params) {
      const result = compileToShmem({ crate_path: params.crate_path, workflow: "normalize" });
      return { content: [{ type: "text", text: result }], details: {} };
    },
  });

  pi.registerTool({
    name: "vendormod_generate_flake",
    label: "Generate flake.nix",
    description: "Generate a flake.nix for a Rust crate with buildRustPackage and devShell.",
    parameters: Type.Object({
      crate_path: Type.String({ description: "Path to crate directory" }),
    }),
    async execute(_toolCallId, params) {
      const result = compileToShmem({ crate_path: params.crate_path, workflow: "nix" });
      return { content: [{ type: "text", text: result }], details: {} };
    },
  });

  pi.registerTool({
    name: "vendormod_dasl_index",
    label: "DASL Index Register",
    description: "Register a crate in the DASL grep_rs.txt index for cross-referencing.",
    parameters: Type.Object({
      crate_path: Type.String({ description: "Path to crate directory" }),
    }),
    async execute(_toolCallId, params) {
      const result = compileToShmem({ crate_path: params.crate_path, workflow: "dasl-index" });
      return { content: [{ type: "text", text: result }], details: {} };
    },
  });
}
```

Load with: `pi -e ~/.pi/agent/extensions/vendormod.ts`

### Via MCP (future)

When pi gains native MCP support, configure the server:

```
# ~/.pi/agent/settings.json
{
  "mcp": {
    "servers": {
      "vendormod": {
        "command": "cargo-vendormod-mcp",
        "args": []
      }
    }
  }
}
```

## Dependencies

- **NORA** (`http://127.0.0.1:4000`) — must be running via system-manager
- **IPLD CAR shmem server** (`@ipld_car_shmem`) — `sudo systemctl status ipld-car-shmem`
- **Nix** — for flake.nix generation
- **Cargo** — for build and metadata

## Session: 2026-06-12

Created compile-to-shmem binary (47MB), MCP server, and NORA config.
Fixed ipld-car-ipc-shmem-linux sophia_rs path deps → version="*" via NORA.
