---
name: "dasl-tiles-mcp"
description: "MCP (Model Context Protocol) server for DASL Tiles monitoring. Exposes 10 tools including per-service eBPF streams, tile discovery \"lens\" layer, nginx log inspection, and health checks. Every tile is a lens — call any tile by path without per-tile code. Use when connecting DASL monitoring to MCP clients (pi, Claude Desktop, Continue)."
---

# DASL Tiles MCP Server — Every Tile is a Lens

MCP server for DASL Tiles eBPF monitoring. **10 tools** exposed via stdio JSON-RPC 2.0.

**Binary**: `dasl-tiles-rust/target/release/mcp-tile-server`  
**Prerequisite**: tile-server running on `http://127.0.0.1:18090`

## Lens Concept

Every DASL tile is a **lens** — a specific monitoring view into the system.
The MCP server auto-discovers tiles from the tile-server and exposes them
as callable tools. No per-tile code needed:

```
dasl_tile_list  →  discover ALL tiles (27+ harnesses, eBPF, DA51, nginx, ...)
dasl_tile_view  →  view ANY tile by path  (universal lens)
dasl_tile_json  →  structured data for ANY tile
```

## Quick Test

```bash
MCP=/mnt/data1/time-2026/05-may/31/n0x-pi/tasks/kilocode-d8-2a-monitoring/dasl-tiles-rust/target/release/mcp-tile-server

# Initialize session
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1"}}}' | $MCP

# List all 10 tools
echo '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' | $MCP

# Discover tiles
echo '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"dasl_tile_list","arguments":{}}}' | $MCP

# View any tile
echo '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"dasl_tile_view","arguments":{"tile_path":"ebpf/d8-2a/diagnostic"}}}' | $MCP

# Per-service eBPF hits
echo '{"jsonrpc":"2.0","id":5,"method":"tools/call","params":{"name":"dasl_get_hits","arguments":{"service":"nginx"}}}' | $MCP

# Nginx errors
echo '{"jsonrpc":"2.0","id":6,"method":"tools/call","params":{"name":"dasl_get_nginx_errors","arguments":{"limit":10}}}' | $MCP

# Health
echo '{"jsonrpc":"2.0","id":7,"method":"tools/call","params":{"name":"dasl_health","arguments":{}}}' | $MCP
```

## Tools Reference

### Lens Tools (auto-discover tiles)

| Tool | Args | Description |
|------|------|-------------|
| `dasl_tile_list` | — | List ALL discoverable tiles with paths, names, types |
| `dasl_tile_view` | `tile_path` | Render any tile (auto-detects JSON/HTML) |
| `dasl_tile_json` | `tile_path` | Extract structured data from any tile |

### eBPF Monitoring

| Tool | Args | Returns |
|------|------|---------|
| `dasl_list_services` | — | 6 services: nginx (49 PIDs), dasl-tiles-rust, d8-2a-monitor, kant-pastebin, ssh (2 PIDs), systemd-journald |
| `dasl_get_hits` | `service` | Hit count, tag rate per service |
| `dasl_get_hits_count` | — | Total lines in /dev/shm/d8-2a-monitoring/hits.jsonl |
| `dasl_get_diagnostic` | — | can_run status, BPF maps, perf events, kernel compat |

### Nginx Logs

| Tool | Args | Returns |
|------|------|---------|
| `dasl_get_nginx_errors` | `limit` (default 50) | Error log with severity (crit/error/warn/info) |
| `dasl_get_nginx_access` | `limit` (default 50) | Access log with HTTP status codes |

### Health

| Tool | Args | Returns |
|------|------|---------|
| `dasl_health` | — | `{"tile_server":{"status":"ok"}, "time":"..."}` |

## Tile Paths (discovered via dasl_tile_list)

```
ebpf/d8-2a/diagnostic    — BPF maps, can_run, kernel compat
ebpf/d8-2a/hits           — Raw hits.jsonl content
ebpf/d8-2a/status         — Service status
da51/orbifold             — Orbifold arrow matrix (71×59×47)²
da51/fold                 — Bott(8)/AZ(10) fold vectors
nginx/errors              — Error log (severity-coded)
nginx/access              — Access log (status-coded)
harness/health/summary    — Fuzz harness health
harness/fuzz/coverage     — Fuzz coverage stats
... (27+ fuzz harness tiles auto-discovered)
```

## Client Config

### pi

Pi doesn't have built-in MCP. Use the MCP server as a subprocess wrapper:

```bash
# In a pi task context, invoke tools via pipe:
echo '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"dasl_list_services","arguments":{}}}' \
  | /path/to/mcp-tile-server
```

### Claude Desktop / Continue / Other MCP Clients

```json
{
  "mcpServers": {
    "dasl-tiles": {
      "command": "/mnt/data1/time-2026/05-may/31/n0x-pi/tasks/kilocode-d8-2a-monitoring/dasl-tiles-rust/target/release/mcp-tile-server",
      "args": []
    }
  }
}
```

## Build & Deploy

```bash
cd /mnt/data1/time-2026/05-may/31/n0x-pi/tasks/kilocode-d8-2a-monitoring/dasl-tiles-rust

# Build MCP server
cargo build --release --bin mcp-tile-server

# Full deploy (tile-server + MCP + nginx + systemd)
bash deploy.sh
```

## Source

`dasl-tiles-rust/src/bin/mcp-tile-server.rs` — full source (v0.2.0, 10 tools + lens layer)
