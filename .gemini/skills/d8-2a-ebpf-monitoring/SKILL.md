---
name: d8-2a-ebpf-monitoring
description: >-
  Monitor CPU register values for 0xD8 0x2A (CBOR tag 42 / CID signature) occurrences
  using eBPF kprobe probes. Includes per-service PID-filtered streams, JSONL output,
  MCP tile lens server, and deployment via system-manager + nginx. Use when debugging
  DAG-CBOR implementations, detecting CBOR tag 42 patterns in running processes, or
  integrating eBPF monitoring into DASL tiles.
---

# D8 2A eBPF Monitoring — Register-Level CBOR Tag Detection

## Architecture

```
┌────────────┐    ┌──────────────┐    ┌──────────────┐    ┌────────────┐
│ d8_2a.bpf  │───▶│ d8_2a_loader │───▶│ /dev/shm/    │───▶│ tile-server│
│ kprobes    │    │ (Rust/aya)   │    │ d8-2a-mon/   │    │ :18090     │
│ perf array │    │ JSONL output │    │ hits.jsonl   │    │ axum HTTP  │
└────────────┘    └──────┬───────┘    └──────┬───────┘    └─────┬──────┘
                         │                   │                   │
                    Unix socket        895K+ lines         ┌─────▼──────┐
                    control API        per-service         │ mcp-tile-  │
                                       PID filter          │ server     │
                                       stream.rs           │ stdio MCP  │
                                                           └────────────┘
```

## Components

### 1. eBPF Program (`d8_2a.bpf.c` / `d8_2a.bpf.rs`)
- Probes: kprobe/kretprobe on key kernel functions
- Maps: REG_COUNTS (2-bit truncated histogram), PID_FILTER, HITS perf array
- Detection: triggers when CPU register values contain `0xD8 0x2A` pattern
- Framework: **aya-ebpf** (Rust), NOT libbpf-cargo

### 2. Userspace Loader (`d8_2a_loader`)
- Attaches eBPF programs, reads perf events
- Writes JSONL to `/dev/shm/d8-2a-monitoring/hits.jsonl`
- Unix socket control API for PID filter management
- Wrapper mode for single-process profiling

### 3. Tile Server (`tile-server` → :18090)
- Serves eBPF data as HTTP tiles
- Per-service streams filtered by PID (`/stream/:service`)
- All standard tile endpoints (menu, webview, admin, ring, da51, nginx)

### 4. MCP Server (`mcp-tile-server`)
- 10 MCP tools exposing all tiles as "lenses"
- stdio JSON-RPC 2.0 transport
- Auto-discovers tiles from tile-server

## Commands

```bash
# Build eBPF program
cd /mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/aya-nix
cargo build --target bpfel-unknown-none --release -p d8_2a_monitor

# Build userspace loader
cargo build --release -p d8_2a_loader

# Run profiler (requires root)
sudo ./target/release/d8_2a_loader ./target/bpfel-unknown-none/release/libd8_2a_monitor.so

# Deploy tile-server + MCP server
cd /mnt/data1/time-2026/05-may/31/n0x-pi/tasks/kilocode-d8-2a-monitoring/dasl-tiles-rust
bash deploy.sh

# Test endpoints
curl http://127.0.0.1:18090/health
curl http://127.0.0.1:18090/streams
curl http://127.0.0.1:18090/stream/nginx
```

## Endpoints (tile-server :18090)

| Endpoint | Description |
|----------|-------------|
| `/health` | Health check |
| `/streams` | All services with PID/hit stats |
| `/stream/:service` | Per-service live HTML stream |
| `/tile/ebpf/d8-2a/hits` | Raw hits (base64 JSONL) |
| `/tile/ebpf/d8-2a/diagnostic` | BPF maps, can_run, kernel compat |
| `/tile/ebpf/d8-2a/status` | Service status |
| `/menu` | HTML main menu |
| `/webview` | Tile gallery |
| `/admin` | DA51 admin panel |
| `/ring` | Round-robin tile ringbuffer |

## Per-Service Streams

The `StreamRegistry` in `src/stream.rs` discovers services via `systemctl`+`pgrep`,
tracks PIDs, and filters the global `hits.jsonl` by PID set. Six services monitored:

- nginx (49 PIDs)
- dasl-tiles-rust (1 PID)
- d8-2a-monitor (1 PID)
- kant-pastebin (1 PID)
- ssh (2 PIDs)
- systemd-journald (1 PID)

## MCP Tools

| Tool | Args | Returns |
|------|------|---------|
| `dasl_tile_list` | none | ALL discoverable tiles |
| `dasl_tile_view` | `tile_path` | Any tile by path |
| `dasl_tile_json` | `tile_path` | Structured tile data |
| `dasl_list_services` | none | Services with PID/hit stats |
| `dasl_get_hits` | `service` | Per-service hit summary |
| `dasl_get_hits_count` | none | Total hits count |
| `dasl_get_diagnostic` | none | eBPF diagnostic |
| `dasl_get_nginx_errors` | `limit` | Nginx error log |
| `dasl_get_nginx_access` | `limit` | Nginx access log |
| `dasl_health` | none | Health check |

## Files

| Path | Purpose |
|------|---------|
| `aya-nix/d8_2a/src/bpf/` | eBPF program source |
| `aya-nix/d8_2a_loader/src/` | Userspace loader |
| `dasl-tiles-rust/src/server.rs` | HTTP tile server |
| `dasl-tiles-rust/src/stream.rs` | Per-service PID filter |
| `dasl-tiles-rust/src/bin/mcp-tile-server.rs` | MCP server |
| `dasl-tiles-rust/deploy.sh` | Reusable deploy script |
| `dasl-tiles-rust/nginx-tile-route.sh` | Nginx route management |
