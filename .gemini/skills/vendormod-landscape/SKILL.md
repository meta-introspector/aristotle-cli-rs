---
name: "vendormod-landscape"
description: "Integration between vendormod refactoring and the broader DASL tile infrastructure — cross-references with existing tiles, overlapping work, action plans for nginx, shmem registration, and monitoring."
---

# Vendormod Landscape — Integration with DASL Tile System

**Date:** 2026-06-10
**Context:** Our vendormod refactoring (main.rs→utils.rs) now integrates with
the broader DASL tile infrastructure documented in ~/dotagents/

## What We Have

### Refactored vendormod (window 5 — refactor-main)
- main.rs 646 lines, utils.rs 1093 lines (26 items, 6 sections)
- cargo check passes, committed, pushed
- 28 items published to IPLD shmem

### Tile Infrastructure We Built
- Nagios tile monitor (:8800) — live health for 18 tiles
- Deploy tile (:8810) — web-based system-manager deploy
- all-services.nix — system-manager config for both
- check-tiles.sh, diagnostic.sh

## What Exists (from ~/dotagents/)

### Skills That Help Us

| Skill | How It Helps |
|-------|-------------|
| **nginx-control-tiles** | Solves our nginx location problem — `scripts/scan-nginx-tiles.sh` extracts configs into tiles |
| **dasl-tile-guide** | Canonical tile schema + deployment patterns |
| **system-manager** (.kilocode) | Correct nginx syntax, symlink fixes, CLI flags |
| **lsof-paths-tile** | Tracks open files per project — useful for vendormod monitoring |
| **nora-monitor-tile** | Pattern for monitoring tile (like our nagios) |
| **sparql-gui-tile** | Another tile we can reference |

### Overlapping Work (from WORK_QUEUE.md / TMUX_LANDSCAPE.md)

| Window | Project | Connection to Us |
|--------|---------|-----------------|
| 4 | diagonalize | Tile pattern we followed |
| 12 | dasl-tiles-publication | Publishing tiles — we need this for vendormod tiles |
| 11 | sparql-gui | Another tile to add to our nagios monitor |
| 16 | nora | Needs monitoring tile — extends our nagios pattern |

## Updated Action Plan

### Fix nginx (use nginx-control-tiles)
```bash
# Instead of manually adding locations, use the existing tooling:
cd /mnt/data1/dasl-tiles-rust-review
bash scripts/scan-nginx-tiles.sh tiles.d/
# → generates 56 tiles from live nginx config
# → shows exactly what's missing for /tile/nagios/ and /tile/deploy/
```

### Register vendormod tiles (use dasl-tile-guide pattern)
```bash
# Follow the canonical tile registration from dasl-tile-guide
letta-ipld-memory put "tiles/vendormod-control-tile" "Description" \
  < ~/DOCS/vendormod-control-tile-def.json
```

### Add our services to lsof-paths monitoring
```bash
# Track vendormod tile server file access
# Follow lsof-paths-tile pattern
```

### Cross-reference with existing tiles
Our nagios monitor (:8800) should also track:
- sparql-gui-tile (window 11)
- nora-monitor-tile (window 16)
- dasl-tiles-publication (window 12)

## System-Manager Correct Syntax

From the system-manager skill:
```nix
# CORRECT: locations INSIDE virtualHosts
services.nginx.virtualHosts."solana.solfunmeme.com" = {
  locations."/tile/nagios/" = {
    proxyPass = "http://127.0.0.1:8800/";
    extraConfig = ''proxy_set_header Host $host;'';
  };
};
```

Our all-services.nix already uses this pattern ✅

## Deploy Command (correct)

```bash
nix run github:numtide/system-manager -- switch --flake /etc/system-manager#all-services
```

Not: `system-manager switch` (needs full nix run path for sudo)

## Files to Cross-Reference

| Our File | Their File | Purpose |
|----------|-----------|---------|
| ~/DOCS/nagios-tile-server.py | dasl-tile-guide SKILL.md | Tile server pattern |
| ~/DOCS/all-services.nix | system-manager SKILL.md | Deployment syntax |
| ~/DOCS/check-tiles.sh | nginx-control-tiles scripts/ | Health checking |
| ~/DOCS/deploy-tile.html | dasl-tile-guide endpoints | Web dashboard |
