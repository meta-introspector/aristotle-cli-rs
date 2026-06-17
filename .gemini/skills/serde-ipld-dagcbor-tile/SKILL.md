---
name: "serde-ipld-dagcbor-tile"
description: "🔧 serde_ipld_dagcbor — DAG-CBOR Codec tile (port 18007) — diagnose, start, develop, and use. harness"
---

# 🔧 serde_ipld_dagcbor — DAG-CBOR Codec

**Port:** 18007 | **Health:** http://127.0.0.1:18007/health | **Category:** harness

## Diagnose

```bash
# Is it running?
systemctl is-active serde-ipld-dagcbor-tile 2>/dev/null || ss -tlnp "sport = :18007"
curl -s --max-time 2 http://127.0.0.1:18007/health

# Check logs
journalctl -u serde-ipld-dagcbor-tile --no-pager -n 20
tail -f ~/log/serde-ipld-dagcbor-tile.log 2>/dev/null

# Port check
ss -tlnp "sport = :18007"
```

## Start

```bash
# Via system-manager (recommended)
sudo systemctl restart serde-ipld-dagcbor-tile

# Manual (if no systemd unit)
cd ~/dasl/dasl-testing
nohup ./target/release/service > /tmp/serde-ipld-dagcbor-tile.log 2>&1 &
```

## Develop

```bash
# Build
cd ~/dasl/dasl-testing/harnesses/ipld-dagcbor-tile 2>/dev/null || cd ~/dasl
cargo build --release

# Test locally
curl http://127.0.0.1:18007/health
```

## Use

```bash
# Health check
curl http://127.0.0.1:18007/health

# Decode CBOR (harness tiles)
curl -X POST http://127.0.0.1:18007/decode \
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
