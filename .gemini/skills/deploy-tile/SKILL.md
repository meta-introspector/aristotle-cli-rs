---
name: "deploy-tile"
description: "Web-based system-manager deploy panel (port 8810). Deploy any tile from browser. infra — deployment"
---

# 🎮 Deploy Tile
**Port:** 8810 | **URL:** https://solana.solfunmeme.com/tile/deploy/

## Diagnose
```bash
systemctl status deploy-tile
curl http://127.0.0.1:8810/health
```

## Start
```bash
sudo systemctl restart deploy-tile
```

## Develop
```bash
vim ~/DOCS/deploy-tile-server.py  # Edit TILES list
sudo systemctl restart deploy-tile
```

## Use
- https://solana.solfunmeme.com/tile/deploy/
- Click a tile → see status + deploy button
