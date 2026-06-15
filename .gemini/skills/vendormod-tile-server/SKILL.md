---
name: vendormod-tile-server
description: >-
  Vendormod tile server (port 8765) — modules, refactor, badges.
  vendormod — dashboard
---

# 📦 Vendormod Tile Server
**Port:** 8765 | **URL:** https://solana.solfunmeme.com/tile/vendormod/
**Log:** `~/log/vendormod-tile.log`

## Diagnose
```bash
systemctl status vendormod-tile-server
tail -20 ~/log/vendormod-tile.log
curl http://127.0.0.1:8765/health
```

## Start
```bash
sudo systemctl restart vendormod-tile-server
```

## Develop
```bash
vim ~/DOCS/vendormod-tile-server.py
vim ~/DOCS/vendormod-dashboard.html
```

## Use
- https://solana.solfunmeme.com/tile/vendormod/
- `/api/modules`, `/api/refactor`, `/api/dasl-badges`, `/api/search?q=<term>`

## Build Memory IDE
The server also serves the Build Memory IDE at `/build`:
- https://solana.solfunmeme.com/tile/vendormod/build
- 4 tabs: timeline, errors, knowledge, projects
- See [[skills/build-memory-ide]] for details
