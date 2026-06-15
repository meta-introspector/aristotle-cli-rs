---
name: tile-testing
description: >-
  How to test DASL tiles — health checks, API validation, nginx proxy testing,
  CI/CD dry-run verification, and common failure diagnosis.
---

# Tile Testing — How to Test DASL Tiles

**Validate tiles before and after deploy.**

## Quick Test Suite

```bash
# 1. Health — every tile must return 200
for port in 8800 8810 8090 8095 18142 18143 18007 18009 18011 8081; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "http://127.0.0.1:$port/health")
  [ "$code" = "200" ] && echo "🟢 :$port" || echo "🔴 :$port (HTTP $code)"
done

# 2. API — data endpoints return valid JSON
curl -s http://127.0.0.1:8800/api/status | python3 -m json.tool | head -10
curl -s http://127.0.0.1:8810/api/tiles | python3 -c "import json,sys; print(f'{len(json.load(sys.stdin))} tiles')"

# 3. Nginx — proxy passes through
for loc in /tile/nagios/ /tile/deploy/ /pastebin/ /tile/diagonalize/ /zombie-cft/; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 "http://127.0.0.1${loc}")
  [ "$code" = "200" ] && echo "🟢 nginx ${loc}" || echo "🔴 nginx ${loc} (HTTP $code)"
done

# 4. HTTPS — public URLs accessible
for loc in /tile/nagios/ /tile/deploy/ /pastebin/; do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "https://solana.solfunmeme.com${loc}")
  [ "$code" = "200" ] && echo "🟢 https://solana.solfunmeme.com$loc" || echo "🔴 $loc (HTTP $code)"
done

# 5. Shmem — data integrity
letta-ipld-memory stats
letta-ipld-memory exists tiles/qa-team-tile && echo "qa-team-tile ✓"
```

## Integration Tests

```bash
# Deploy tile: can it list and deploy?
TILES=$(curl -s http://127.0.0.1:8810/api/tiles | python3 -c "import json,sys; print(len(json.load(sys.stdin)))")
[ "$TILES" -gt 5 ] && echo "✓ Deploy tile tracks $TILES tiles" || echo "✗ Only $TILES tiles"

# Nagios: does API return all tiles?
STATUS=$(curl -s http://127.0.0.1:8800/api/status | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['total'])")
[ "$STATUS" -gt 10 ] && echo "✓ Nagios tracks $STATUS tiles" || echo "✗ Only $STATUS tiles"

# Nagios HTML: does dashboard render?
curl -s http://127.0.0.1:8800/ | grep -q '<title>' && echo "✓ Nagios HTML renders" || echo "✗ HTML broken"
```

## Test a New Tile Before Registration

```bash
# Start locally
python3 my-tile-server.py --port 8999 &

# Test endpoints
curl http://127.0.0.1:8999/health        # must return 200
curl http://127.0.0.1:8999/api/data      # must return valid JSON

# Test with invalid input
curl -X POST http://127.0.0.1:8999/api/run/ingest -d '{}'  # should handle gracefully

# Kill test server
kill %1
```

## CI/CD Test (for system-manager)

```bash
# Dry-run build (no deploy)
nix build /etc/system-manager#systemConfigs.all-services --no-link 2>&1

# Check systemd unit syntax
systemd-analyze verify /etc/systemd/system/my-new-tile.service

# Nginx config test
nginx -t
```

## Common Test Failures

| Failure | Cause | Fix |
|---------|-------|-----|
| HTTP 000 | Port not listening | Start server or deploy |
| HTTP 404 | Wrong path | Check endpoint definition |
| HTTP 502 | Backend down | Check systemd status |
| JSON parse error | Malformed response | Check server code |
| Nginx 404 | Location block missing | Add to all-services.nix |
| systemd failed | Service crashed | Check journalctl logs |
