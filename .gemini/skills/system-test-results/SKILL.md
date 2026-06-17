---
name: "system-test-results"
description: "System integration test results for DASL tile infrastructure — live service status, known issues, deploy commands, and vendormod metrics. Updated 2026-06-14 with system-manager flake deployment status."
---

# System Test Results — DASL Tile Infrastructure

**Date:** 2026-06-14  **Test:** Post-reboot service status

## Summary

| Status | Count | Detail |
|--------|-------|--------|
| 🟢 SYSTEM-MANAGER | 8 | Python tiles + existing binaries in flake.nix, build passing |
| 🟢 UP (raw) | 4 | nagios, deploy, vendormod, port-registry (python3) |
| 🟡 PENDING | 3 | Rust services: serde-dagcbor, n0-dasl, libipld (need vendoring) |
| 🔴 DOWN | 2 | pastebin /health (404), diagonalize /health (404) |

## Live Services (post-reboot)

| Service | systemd | Port | Build | Status |
|---------|---------|------|-------|--------|
| nagios-tile-monitor | 🟡 raw python | 8800 | ✅ nix build .#nagios-tile | 🟢 200 |
| deploy-tile | 🟡 raw python | 8810 | ✅ nix build .#deploy-tile | 🟢 200 |
| vendormod-tile | 🟡 raw python | 8765 | ✅ nix build .#vendormod-tile | 🟢 200 |
| port-registry-tile | 🟡 raw python | 8820 | ✅ nix build .#port-tile | 🟢 200 |
| zombie-cft-tile | 🟡 raw binary | 8095 | binary exists | 🟢 200 |
| ipld-car-shmem | 🟢 systemd | @socket | deployment | ✅ 187K blocks |
| nora | 🟢 systemd | 4000 | system-manager | 🟢 serving |
| kant-pastebin | 🟢 systemd | 8090 | system-manager | 🟢 200 |
| serde-ipld-dagcbor | 🔴 not built | 18007 | ⏳ nora vendoring | — |
| n0-dasl | 🔴 not built | 18009 | ⏳ nora vendoring | — |
| libipld | 🟡 flake ready | 18011 | ✅ vendored (46MB) | ⏳ deploy |
| qa-team-tile | 🔴 not built | 18142 | ⏳ binary from dasl-testing | — |
| fuzz-team-tile | 🟡 flake ready | 18143 | ✅ nix build .#fuzz-tile | ⏳ deploy |
| diagonalize | 🔴 not built | 8082 | ⏳ python server | — |

## System-Manager Flake (NEW)

```bash
# Location: ~/dasl-planning/
# Flake: flake.nix + dasl-testing-system-manager.nix
# Build: nix build .#systemConfigs.all-services --no-link
# Deploy: sudo $(nix build .#systemConfigs.all-services --print-out-paths)/bin/activate

# Individual packages
nix build ~/dasl-planning#nagios-tile
nix build ~/dasl-planning#deploy-tile
nix build ~/dasl-planning#vendormod-tile
nix build ~/dasl-planning#port-tile
nix build ~/dasl-planning#fuzz-tile
```

### Working (8 services)
Python tiles are nix-built from vendored scripts. Services and nginx
locations defined declaratively. One `activate` command deploys all.

### Pending (3 Rust services)
serde-ipld-dagcbor, n0-dasl, libipld need crate vendoring for pure
sandbox build. Currently fail with "failed to query replaced source
registry crates-io". Blocked by crates.io 403.

libipld has a working flake with 46MB vendored deps at
`~/dasl/dasl-testing/harnesses/libipld/flake.nix` but uses
`manveru/nixpkgs` fork — needs updating to standard nixpkgs.

## Known Issues

### 1. crates.io 403 — Pure Eval Blocker
Nix sandbox blocks network access. Cargo deps must be:
- **Vendored** (cargoVendorDir pattern) — works pure
- **Nora** (preBuild .cargo/config.toml) — needs --impure
- **crates.io** — 403, doesn't work at all

### 2. Multi-Output nixpkgs Packages
`environment.systemPackages` with `curl`, `jq` etc. fails with:
"requires non-existent output 'bin'". Avoid or use explicit paths.

### 3. builtins.path Strips Vendor
`builtins.path { path = ./.; }` filters via .gitignore. Use `src = ./.;`
when vendor/ must be included in the build source.

### 4. Pastebin /health Returns 404
Service active on 8090 but `/health` endpoint not implemented.

### 5. Diagonalize /health Returns 404
Python3 process on 8082 but `/health` missing. Server needs update.

### 6. Harness Tiles Run as Raw Processes
Python tiles run as raw binaries without systemd units. Fix ready:
`~/dasl-planning/dasl-testing-system-manager.nix` — just needs activation.

## Deploy Commands

```bash
# Full deploy (system-manager flake — NEW)
sudo $(nix build ~/dasl-planning#systemConfigs.all-services --print-out-paths)/bin/activate

# Legacy deploy (pastebin flake)
sudo -E ~/.nix-profile/bin/nix run github:numtide/system-manager -- switch \
  --flake /etc/system-manager#all-services

# Quick health check
bash ~/DOCS/diagnostic.sh

# Check all tiles
bash ~/DOCS/check-tiles.sh
```

## Tile URLs

| Tile | URL | Status |
|------|-----|--------|
| Nagios | http://127.0.0.1:8800/ | 🟢 |
| Deploy | http://127.0.0.1:8810/ | 🟢 |
| Vendormod | http://127.0.0.1:8765/ | 🟢 |
| Port | http://127.0.0.1:8820/ | 🟢 |
| Pastebin | https://solana.solfunmeme.com/pastebin/ | 🟢 |

## Vendormod Status

| Metric | Value |
|--------|-------|
| main.rs | 646 lines |
| utils.rs | 1093 lines (26 items, 6 sections) |
| cargo check | ✅ passes |
| Git | committed, pushed to refactor-main |
| Shmem | 28 items published |

## Skills Update (2026-06-14)

All 134 skills consolidated in `~/dotagents/skills/` as single source of truth.
Deployed to `~/.pi/agent/skills/` via `dotagents deploy`.
