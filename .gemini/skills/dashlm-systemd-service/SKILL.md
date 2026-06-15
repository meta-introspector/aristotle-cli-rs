---
name: dashlm-systemd-service
description: Implement systemd service dashlm-index@.service and server binary dashlm_index_server for long-running shared-index management.
---

# dashlm_index_server + systemd unit

## Steps

1. Create `src/bin/dashlm_index_server.rs`.
2. Dependencies:
   - `dashlm_shared_index = { path = "./dashlm_shared_index" }`
   - `tokio = { version = "1.38", features = ["full"] }`
   - `nix = "0.28"`
   - `clap = "4.5"`
   - `sd-notify = "0.3"`
3. CLI: `--index-name`, `--index-size`, `--project-root`, `--standby-timeout <SECS>`.
4. Logic:
   - Open/create shared index.
   - If empty (magic missing or value_heap_used == 0), run builder.
   - `sd_notify::notify("READY=1")`.
   - Unix-socket listener at `/run/dashlm_index_<hash>.ctl`.
   - Loop: wait for `b"R"` (rebuild) or timeout. Rebuild: create new segment, run builder, atomic swap.
   - Handle SIGTERM/SIGINT for cleanup.
5. Unit test with temp memfd for rebuild flow.
6. Write systemd unit:
   - Type=notify, ExecStart, Restart=on-failure, WantedBy=multi-user.target.

## Source files

- `src/bin/dashlm_index_server.rs`
- systemd unit file template
