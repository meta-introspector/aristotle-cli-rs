---
name: system-test-results
description: >-
  System integration test results for DASL tile infrastructure — live service
  status, known issues, deploy commands, and vendormod metrics.
---

# System Test Results — DASL Tile Infrastructure

**Date:** 2026-06-10  **Test:** Full system integration test

## Summary

| Status | Count | Detail |
|--------|-------|--------|
| 🟢 UP | 10 | nagios, deploy, shmem, pastebin, 6 harness tiles |
| 🟡 DEGRADED | 2 | nginx (running but locations missing), deploy/api (python parse issue) |
| 🔴 DOWN | 2 | pastebin /health (404), diagonalize /health (404) |

## Live Services

| Service | systemd | Port | HTTP /health |
|---------|---------|------|-------------|
| nagios-tile-monitor | 🟢 active | 8800 | 🟢 200 |
| deploy-tile | 🟢 active | 8810 | 🟢 200 |
| ipld-car-shmem | 🟢 active | @socket | ✅ 187,865 blocks |
| kant-pastebin | 🟢 active | 8090 | 🔴 404 |
| qa-team-tile | (manual) | 18142 | 🟢 200 |
| fuzzing-team-tile | (manual) | 18143 | 🟢 200 |
| serde-ipld-dagcbor | (manual) | 18007 | 🟢 200 |
| n0-dasl | (manual) | 18009 | 🟢 200 |
| libipld | (manual) | 18011 | 🟢 200 |
| zombie-cft-tile-server | (manual) | 8095 | 🟢 200 |
| tile-server | (manual) | 8081 | 🟢 200 |
| diagonalize | (manual) | 8082 | 🔴 404 |
| kant-pastebin-beta | 🔴 failed | — | — |

## Known Issues

### 1. Nginx Location Blocks Missing
nginx is running (HTTP 200 on port 80) but `/tile/nagios/`, `/tile/deploy/`, `/pastebin/` return 404 locally.
**Fix:** `fix-nginx-tile-locations` task — add location blocks to `/etc/nginx/locations.d/`
**Nginx itself:** nginx.service in failed state because system-manager tried to manage it
but an existing nginx process was already bound to ports. The process IS running, just not
via systemd. system-manager will fix this on next clean deploy.
**Workaround:** `sudo nginx -s reload` if config was updated manually.

### 2. Pastebin /health Returns 404
Service is active on 8090 and serves paste content, but `/health` endpoint is not
implemented in the pastebin app code.
**Fix:** Add `/health` route to pastebin server code.

### 3. Diagonalize /health Returns 404
Python3 process listening on 8082 but `/health` endpoint missing.
**Fix:** Update `server.py` to include health endpoint, or restart via system-manager.

### 4. Harness Tiles Run as Raw Processes
QA, Fuzz, serde, n0-dasl, libipld, zombie-cft, tile-server all run as raw binaries
without systemd units. They survive reboots only if started manually.
**Fix:** `fix-nix-system-manager-sandbox` task — add systemd units for all harness tiles.

### 5. Deploy Tile API Python Parse
`/api/tiles` and `/api/status` return valid JSON but the inline python3 parser failed
during test — likely a pipe/buffer issue. The endpoints work when accessed directly
via curl or browser.

## Deploy Commands

```bash
# Full deploy (system-manager)
sudo -E ~/.nix-profile/bin/nix run github:numtide/system-manager -- switch \
  --flake /etc/system-manager#all-services

# Restart individual service
sudo systemctl restart nagios-tile-monitor
sudo systemctl restart deploy-tile

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
| Pastebin | https://solana.solfunmeme.com/pastebin/ | 🟢 |

## Vendormod Status

| Metric | Value |
|--------|-------|
| main.rs | 646 lines |
| utils.rs | 1093 lines (26 items, 6 sections) |
| cargo check | ✅ passes |
| Git | committed, pushed to refactor-main |
| Shmem | 28 items published |

## Next Task

Run `fix-nginx-tile-locations`:
```bash
cd ~/projects/dotagents/tasks/fix-nginx-tile-locations
cat GEMINI.md
```
