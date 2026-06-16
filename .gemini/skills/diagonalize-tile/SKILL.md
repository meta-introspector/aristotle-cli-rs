---
name: "diagonalize-tile"
description: "Diagonalize IPLD block tree viewer (port 8082). Diagnose, start, develop, use. data — visualization"
---

# 📂 Diagonalize Tile
**Port:** 8082 | **URL:** https://solana.solfunmeme.com/tile/diagonalize/

## Diagnose
```bash
curl http://127.0.0.1:8082/health
systemctl status diagonalize-tile
```

## Start
```bash
sudo systemctl restart diagonalize-tile
```

## Develop
```bash
cd ~/dasl/ipld-car-ipc-shmem-linux/tasks/diagonalize/tile-server
vim server.py
```

## Use
- https://solana.solfunmeme.com/tile/diagonalize/
- `/api/tree`, `/api/flat`, `/api/pivot?by=category`
