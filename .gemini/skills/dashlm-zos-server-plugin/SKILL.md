---
name: dashlm-zos-server-plugin
description: Create zos-server plugin dashlm-index exposing HTTP/Unix-socket API for querying the shared index.
---

# dashlm-index zos-server plugin

## Steps

1. Under `~/zos-server/plugins`, create `dashlm-index/`.
2. `Cargo.toml` workspace member deps:
   - `dashlm_shared_index = { path = ".../cargo-vendormod/dashlm_shared_index" }`
   - `serde`, `serde_json`, `tokio = { version = "1.38", features = ["full"] }`, `hyper = "1.0"`, `tokio-unix = "0.3"`
3. `src/lib.rs` export `execute(command: &str, args: &[String]) -> Result<serde_json::Value, String>`:
   - `openapi` / `schema` -> static stubs
   - `file <path>` -> SipHash, open shared index, get, bincode deserialize, return JSON or null
   - `stats` -> zone_distribution, cpu/gpu accesses -> JSON
   - `reload` -> send `b"R"` to `/run/dashlm_index_<hash>.ctl`
4. Add to zos-server workspace members and implement `zos_server_plugin::Plugin` trait adapter.
5. Integration test: start zos-server, issue request, verify reply.

## Source files

- `~/zos-server/plugins/dashlm-index/Cargo.toml`
- `~/zos-server/plugins/dashlm-index/src/lib.rs`
