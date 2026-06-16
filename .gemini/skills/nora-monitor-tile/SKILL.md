---
name: "nora-monitor-tile"
description: "Nora package registry monitoring tile. Nora serves 13 registry protocols (cargo, docker, npm, pypi, maven, go, nuget, gems, pub, conan, terraform, ansible, raw) on :4000. Use when monitoring Nora health, checking cached crate counts, or debugging registry proxy issues."
---

# nora-monitor-tile — Nora Registry Monitor

**Project:** `/home/mdupont/projects/nora`
**Status:** Running (pid 740031, tmux window 16)
**Port:** 4000
**Tile kind:** `http-tile`

## Endpoints

```bash
# Health check
curl http://127.0.0.1:4000/health

# Cargo index config
curl http://127.0.0.1:4000/cargo/index/config.json

# API status
curl http://127.0.0.1:4000/api/v1/status
```

## 13 Registry Protocols

Nora serves these protocols on a single HTTP port:

| Protocol | Status | Path |
|----------|--------|------|
| cargo | ✅ enabled | `/cargo/index/` |
| docker | disabled | `/v2/` |
| npm | disabled | `/npm/` |
| pypi | disabled | `/pypi/` |
| maven | disabled | `/maven/` |
| go | disabled | `/go/` |
| nuget | disabled | `/nuget/` |
| gems | disabled | `/gems/` |
| pub/dart | disabled | `/pub/` |
| conan | disabled | `/conan/` |
| terraform | disabled | `/terraform/` |
| ansible | disabled | `/ansible/` |
| raw | disabled | `/raw/` |

## Tile Registration

```bash
letta-ipld-memory put "tiles/nora-monitor-tile" "Nora Registry Monitor" < tile-defs/nora-monitor-tile.json
```

## Admin Plane Integration

Nora is already listed in the admin panel at `/admin/`. Add to SERVICES in
`admin.py` to enable automatic monitoring.

## Vector Space Basis

Nora corresponds to basis vector `e₁` (crates.io/getnora.io) in the
tech vector space model.
