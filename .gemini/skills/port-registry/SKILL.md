---
name: "port-registry"
description: "Monster CFT port registry tile — live port scan dashboard at /tile/ports/. Cross-references /etc/services with nginx proxy map and live ss port checks. 26 ports tracked (Monster, ZOS, CICADA, Kant, Quickwit, Forgejo, NORA, DASL, IPLD, headless, FRACTRAN). Use when checking which services are up, finding port assignments, or diagnosing service health."
---

# Port Registry Tile

> Live Monster CFT port map at `https://solana.solfunmeme.com/tile/ports/`
> 26 ports · /etc/services × nginx proxy map × live `ss` scan.

## Quick Reference

| Endpoint | Method | Returns |
|----------|--------|---------|
| `/tile/ports/` | GET | HTML dashboard (dark theme, port grid, auto-refresh) |
| `/tile/ports/api/ports` | GET | JSON array of all 26 ports with status |
| `/tile/ports/api/health` | GET | `{"status":"UP","total":26,"up":N}` |
| `/tile/ports/api/skills` | GET | All 87 dotagent skills (JSON) — filter with `?agent=pi` |
| `/tile/ports/api/skill/<name>` | GET | Full content of a single skill markdown |

## When to Use

- **"What port is X on?"** — Check the JSON or look at the dashboard
- **"Is service Y running?"** — Live `ss` scan shows listening status
- **"Is this proxied through nginx?"** — nginx column shows proxy status
- **"What upstream backs /some/path?"** — Shows nginx paths per port
- **Before registering a new service** — Check port isn't already taken
- **Before adding to /etc/services** — Verify it's not already there

## How to query from code/scripts

```bash
# Health
curl -s https://solana.solfunmeme.com/tile/ports/api/health | jq .

# All ports
curl -s https://solana.solfunmeme.com/tile/ports/api/ports | jq '.[] | {port, name, listening, nginx_proxied}'

# Find a specific service
curl -s https://solana.solfunmeme.com/tile/ports/api/ports | jq '.[] | select(.name=="nora")'

# Which ports are DOWN?
curl -s https://solana.solfunmeme.com/tile/ports/api/ports | jq '.[] | select(.listening==false) | {port, name}'

# Count UP
curl -s https://solana.solfunmeme.com/tile/ports/api/health | jq .up
```

## Agent Skills API

Agents can discover and load skills via HTTP:

```bash
# List all skills
curl -s https://solana.solfunmeme.com/tile/ports/api/skills | jq '.skills[].name'

# Filter by agent
curl -s "https://solana.solfunmeme.com/tile/ports/api/skills?agent=pi" | jq '.skills[] | {name, headline}'

# Load a specific skill's full content
curl -s https://solana.solfunmeme.com/tile/ports/api/skill/port-registry | jq '{name, size, content}'

# Load the nginx-control-tiles skill
curl -s https://solana.solfunmeme.com/tile/ports/api/skill/nginx-control-tiles
```

Currently serves **87 skills** from `~/projects/dotagents/skills/`. Each skill
returns its full SKILL.md content, front matter, headline, and preview.

## Port assignments (complete)

| Port | Service | In /etc/services | Nginx path |
|------|---------|:---:|------------|
| 3000 | forgejo | ✅ | `/forgejo/` |
| 4000 | nora | ✅ | `/nora/` |
| 7280 | quickwit-http | ✅ | `/quickwit/` |
| 7281 | quickwit-grpc | ✅ | — |
| 7282 | quickwit-file | ✅ | — |
| 8072 | monster-api | ✅ | — |
| 8080 | monster-file-mgr | ✅ | — |
| 8081 | zos-server | ✅ | `/` (main) |
| 8088 | dasl-tile-server | ✅ | — |
| 8090 | kant-pastebin | ✅ | `/pastebin/` |
| 8091 | monster-voa-training | ✅ | — |
| 8092 | zos-pipeline | ✅ | — |
| 8093 | emacs-search | ✅ | — |
| 8094 | zos-noc-manager | ✅ | — |
| 8095 | zos-noc-manager (web) | ✅ | `/zombie-cft/` |
| 8096 | zos-plugin-registry | ✅ | — |
| 8097 | zos-github-manager | ✅ | — |
| 8107 | fractran-vm | ✅ | — |
| 8150 | door-cicada71 | ✅ | `/cicada71/` |
| 8151 | door-eco-fractran | ✅ | — |
| 8156 | door-monster-bbs | ✅ | — |
| 8800 | nagios-tile | — | `/tile/nagios/` |
| 8810 | deploy-tile | — | `/tile/deploy/` |
| 8820 | port-registry | — | `/tile/ports/` |
| 9500 | headless-browser | ✅ | — |
| 9501 | headless-tor | ✅ | — |

## Registering a new port

```bash
# 1. Add to /etc/services
sudo tee -a /etc/services << 'END'
my-service  9999/tcp  # My Service Description
END

# 2. Regenerate tiles
python3 /mnt/data1/dasl-tiles-rust-review/scripts/ingest-etc-services.py

# 3. Verify on dashboard
curl -s https://solana.solfunmeme.com/tile/ports/api/ports | jq '.[] | select(.port==9999)'
```

## Server details

- **Binary**: `~/DOCS/port-registry-tile-server.py`
- **Systemd**: `port-registry-tile.service` (via system-manager `all-services.nix`)
- **Port**: 8820 (internal, nginx proxies `/tile/ports/` → `:8820`)
- **Nginx config**: `/etc/nginx/locations.d/port-registry.conf`
- **Tile TOML**: `tiles.d/port-registry.toml`

## Related Skills

- [[skills/nginx-control-tiles]] — Nginx topology → control tiles
- [[skills/search2pipe-ingest]] — locate → extract pipeline
- [[skills/dasl-tiles]] — DASL tile system
- [[skills/nora-monitor-tile]] — NORA registry monitoring
