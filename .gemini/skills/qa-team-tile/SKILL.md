---
name: qa-team-tile
description: >-
  🧪 QA Team — Aggregator tile (port 18142) — diagnose, start, develop, and use.
  aggregator
---

# 🧪 QA Team — Aggregator

**Port:** 18142 | **Health:** http://127.0.0.1:18142/health | **Category:** aggregator

## Diagnose

```bash
# Is it running?
systemctl is-active qa-team-tile 2>/dev/null || ss -tlnp "sport = :18142"
curl -s --max-time 2 http://127.0.0.1:18142/health

# Check logs
journalctl -u qa-team-tile --no-pager -n 20
tail -f ~/log/qa-team-tile.log 2>/dev/null

# Port check
ss -tlnp "sport = :18142"
```

## Start

```bash
# Via system-manager (recommended)
sudo systemctl restart qa-team-tile

# Manual (if no systemd unit)
cd ~/dasl/dasl-testing
nohup ./target/release/service > /tmp/qa-team-tile.log 2>&1 &
```

## Develop

```bash
# Build
cd ~/dasl/dasl-testing/harnesses/team-tile 2>/dev/null || cd ~/dasl
cargo build --release

# Test locally
curl http://127.0.0.1:18142/health
```

## Use

```bash
# Health check
curl http://127.0.0.1:18142/health

# Decode CBOR (harness tiles)
curl -X POST http://127.0.0.1:18142/decode \
  -H "Content-Type: application/json" \
  -d '{"cbor":"74657374"}'

# View in nagios dashboard
open https://solana.solfunmeme.com/tile/nagios/
```

## Related
- [[skills/dasl-testing]] — Cross-implementation fuzzing harness
- [[skills/dasl-tile-guide]] — Tile schema & deployment
- [[skills/tile-usage]] — How to use tiles daily
- [[skills/tile-testing]] — Test suite
