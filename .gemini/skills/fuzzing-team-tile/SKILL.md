---
name: "fuzzing-team-tile"
description: "🐛 Fuzzing Team — Coverage tile (port 18143) — diagnose, start, develop, and use. aggregator"
---

# 🐛 Fuzzing Team — Coverage

**Port:** 18143 | **Health:** http://127.0.0.1:18143/health | **Category:** aggregator

## Diagnose

```bash
# Is it running?
systemctl is-active fuzzing-team-tile 2>/dev/null || ss -tlnp "sport = :18143"
curl -s --max-time 2 http://127.0.0.1:18143/health

# Check logs
journalctl -u fuzzing-team-tile --no-pager -n 20
tail -f ~/log/fuzzing-team-tile.log 2>/dev/null

# Port check
ss -tlnp "sport = :18143"
```

## Start

```bash
# Via system-manager (recommended)
sudo systemctl restart fuzzing-team-tile

# Manual (if no systemd unit)
cd ~/dasl/dasl-testing
nohup ./target/release/service > /tmp/fuzzing-team-tile.log 2>&1 &
```

## Develop

```bash
# Build
cd ~/dasl/dasl-testing/harnesses/team-tile 2>/dev/null || cd ~/dasl
cargo build --release

# Test locally
curl http://127.0.0.1:18143/health
```

## Use

```bash
# Health check
curl http://127.0.0.1:18143/health

# Decode CBOR (harness tiles)
curl -X POST http://127.0.0.1:18143/decode \
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
