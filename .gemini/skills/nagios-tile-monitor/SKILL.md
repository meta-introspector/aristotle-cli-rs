---
name: "nagios-tile-monitor"
description: "Nagios-style DASL tile health monitor (port 8800). Diagnose, start, develop, use. infra — monitoring"
---

# 🟩 Nagios Tile Monitor
**Port:** 8800 | **URL:** https://solana.solfunmeme.com/tile/nagios/

## Diagnose
```bash
systemctl status nagios-tile-monitor
curl http://127.0.0.1:8800/health
```

## Start
```bash
sudo systemctl restart nagios-tile-monitor
```

## Develop
```bash
vim ~/DOCS/nagios-tile-server.py
python3 ~/DOCS/nagios-tile-server.py --port 8899 &  # test
```

## Use
- https://solana.solfunmeme.com/tile/nagios/
- `curl http://127.0.0.1:8800/api/status`
