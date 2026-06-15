---
name: zombie-cft-tile
description: >-
  Zombie CFT Monster containment tile (port 8095). Diagnose, start, develop, use.
  atlas — CFT
---

# 🧟 Zombie CFT Tile

**Port:** 8095 | **Public:** https://solana.solfunmeme.com/zombie-cft/

## Diagnose
```bash
curl http://127.0.0.1:8095/health
ss -tlnp "sport = :8095"
```

## Start
```bash
cd ~/dasl/IMPL/zombie-cft
cargo run --release --bin zombie-cft-tile-server &
```

## Develop
```bash
cd ~/dasl/IMPL/zombie-cft
vim src/bin/zombie-cft-tile-server.rs
cargo build --release
```

## Use
- **Dashboard:** https://solana.solfunmeme.com/zombie-cft/
- **API:** `/health`, `/api/chamber`, `/api/tile`

## Related
- [[skills/da51-orbifold-admin]] — Orbifold administration
