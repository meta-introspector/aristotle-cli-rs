---
name: d8-2a-per-service-streams
description: >-
  Per-service eBPF hit streams filtered by PID from the D8-2A profiler.
  Discovers services via systemctl+pgrep, tracks PID sets, and filters the
  global hits.jsonl to provide per-service views. 6 services monitored:
  nginx, dasl-tiles-rust, d8-2a-monitor, kant-pastebin, ssh, systemd-journald.
  Use when debugging service-specific CBOR tag 42 detection or integrating
  eBPF monitoring into per-service dashboards.
---

# D8-2A Per-Service eBPF Streams

Per-service PID-filtered streams from the global D8-2A eBPF profiler.

## How It Works

```
hits.jsonl (global, 895K+ lines)
  │
  │  StreamRegistry (src/stream.rs)
  │  ┌──────────────────────────────────┐
  │  │ 1. discover_services()           │
  │  │    systemctl + pgrep → PIDs      │
  │  │                                  │
  │  │ 2. For each /stream/:service:    │
  │  │    read hits.jsonl incrementally  │
  │  │    filter by PID set             │
  │  │    return stats + HTML view      │
  │  └──────────────────────────────────┘
  │
  ▼
Per-service streams:
  /stream/nginx            → 49 PIDs, live HTML view
  /stream/dasl-tiles-rust  → 1 PID
  /stream/d8-2a-monitor    → 1 PID
  /stream/kant-pastebin    → 1 PID
  /stream/ssh              → 2 PIDs
  /stream/systemd-journald → 1 PID
```

## Endpoints

| Endpoint | Returns |
|----------|---------|
| `/streams` | JSON: `{"services":[...], "streams":[{name, pids, hit_count, last_position}]}` |
| `/stream/:service` | HTML: auto-refresh page with per-service eBPF hits |

## Test

```bash
# List all streams
curl http://127.0.0.1:18090/streams

# View nginx stream
curl http://127.0.0.1:18090/stream/nginx

# View profiler's own stream
curl http://127.0.0.1:18090/stream/d8-2a-monitor
```

## Route Fix

axum 0.7.9 requires **colon-prefix** path parameters, not brace syntax:
- ❌ `/stream/{service}` → 404 Not Found
- ✅ `/stream/:service` → 200 OK

## Nginx

```nginx
location ^~ /streams {
    proxy_pass http://127.0.0.1:18090/streams;
}
location ^~ /stream/ {
    proxy_pass http://127.0.0.1:18090/stream/;
}
```

## MCP Tool

Use `dasl_get_hits` with the `service` argument to query per-service data via MCP:

```bash
echo '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"dasl_get_hits","arguments":{"service":"nginx"}}}' \
  | mcp-tile-server
```

## Source

`dasl-tiles-rust/src/stream.rs` — `StreamRegistry` struct
`dasl-tiles-rust/src/server.rs` — `/stream/:service` and `/streams` handlers
