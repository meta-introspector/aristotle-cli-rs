---
name: libipld-tile
description: >-
  🔓 libipld — IPLD Core Impl tile (port 18011) — diagnose, start, develop, and use.
  harness
---

# 🔓 libipld — IPLD Core Impl

**Port:** 18011 | **Health:** http://127.0.0.1:18011/health | **Category:** harness

## Diagnose

```bash
# Is it running?
systemctl is-active libipld-tile 2>/dev/null || ss -tlnp "sport = :18011"
curl -s --max-time 2 http://127.0.0.1:18011/health

# Check logs
journalctl -u libipld-tile --no-pager -n 20
tail -f ~/log/libipld-tile.log 2>/dev/null

# Port check
ss -tlnp "sport = :18011"
```

## Start

```bash
# Via system-manager (recommended)
sudo systemctl restart libipld-tile

# Manual (if no systemd unit)
cd ~/dasl/dasl-testing
nohup ./target/release/service > /tmp/libipld-tile.log 2>&1 &
```

## Develop

```bash
# Build
cd ~/dasl/dasl-testing/harnesses/tile 2>/dev/null || cd ~/dasl
cargo build --release

# Test locally
curl http://127.0.0.1:18011/health
```

## Use

```bash
# Health check
curl http://127.0.0.1:18011/health

# Decode CBOR (harness tiles)
curl -X POST http://127.0.0.1:18011/decode \
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
