---
name: "nginx-control-tiles"
description: "Nginx administration via DASL control tiles. Scans nginx configs, extracts server blocks, locations, proxy_pass directives, and ports into DASL tiles. Generates per-domain, per-proxy, per-port, and integration tiles from live nginx state. Cross-references with /etc/services port registry. Use when managing nginx configuration, migrating nginx to nix/git, or auditing the nginx proxy topology."
---

# Nginx Control Tiles

> Nginx topology → DASL control tiles (domains, proxies, ports, logs, PIDs).
> Pipeline: locate → stat → search2pipe → extract → tile.

## When to Use

- Scanning nginx topology into control tiles
- Extracting proxy_pass → upstream port mappings
- Cross-referencing nginx proxies with /etc/services
- Generating a discovery list from live nginx config
- Auditing which backends are reachable through nginx
- Migrating nginx config to git/nix (system-manager)

## Toolchain

```bash
# Full pipeline: locate → stat → search2pipe → extract → tile
cd /mnt/data1/dasl-tiles-rust-review
bash scripts/nginx-corpus-pipeline.sh A,B,C,D,E

# Individual phases
bash scripts/nginx-corpus-pipeline.sh A         # locate + stat
bash scripts/nginx-corpus-pipeline.sh B         # search2pipe project grouping
bash scripts/nginx-corpus-pipeline.sh C         # extract configs
bash scripts/nginx-corpus-pipeline.sh D         # generate tiles
bash scripts/nginx-corpus-pipeline.sh E         # diff corpus vs live

# Ingest /etc/services port registry
python3 scripts/ingest-etc-services.py

# Quick scan (56 tiles from live nginx)
bash scripts/scan-nginx-tiles.sh tiles.d/
```

## Output

Tiles are written to `tiles.d/`:

| Prefix | Count | Content |
|--------|-------|---------|
| `nginx-process` | 1 | Master PID + worker PIDs |
| `nginx-port-*` | 4 | Listening ports (80, 443, 3080, 8080) |
| `nginx-domain-*` | 5 | Server blocks with server_name |
| `nginx-proxy-*` | 44 | Every location → upstream mapping |
| `nginx-logs` | 1 | access.log + error.log |
| `nginx-integration` | 1 | Topology graph (links all tiles) |
| `etc-services` | 1 | /etc/services registry |
| `service-*` | 18 | Monster CFT service entries |

## Cross-References

- `/etc/nginx/sites-available/` — 11 configs (2 active, 9 backup/historical)
- `/etc/nginx/locations.d/` — 10 modular location includes
- `/etc/services` — 388 entries, 26 Monster CFT + 6 newly registered ports
- `~/projects/nginx-generator/` — Rust project for nginx config generation
- `~/projects/nora/` — per-project deploy pattern (`flake.nix` + `nora-system-manager.nix` + `deploy.sh`)
- `~/projects/system-manager/all-services.nix` — central shared services (nagios-tile, deploy-tile, /pastebin/, /zombie-cft/)

## Deployment Architecture (per-project, not pastebin)

```
~/projects/<name>/
├── flake.nix                   # crane build + system-manager config
├── <name>-system-manager.nix   # systemd unit + nginx proxy
└── deploy.sh                   # nix build → sudo activate → diagnose
```

Each service deploys independently. Cross-cutting shared configs live in
`~/projects/system-manager/all-services.nix`. No more `~/pastebin` monolith.

## Live Dashboard

- **Port Registry**: `https://solana.solfunmeme.com/tile/ports/` — 26 ports, live scan
  → `curl -s https://solana.solfunmeme.com/tile/ports/api/ports | jq '.[] | select(.listening)'`

## Related Skills

- [[skills/port-registry]] — Live port map dashboard
- [[skills/dasl-tiles]] — DASL tile system
- [[skills/dasl-tiles-publication]] — Tile publishing protocol
- [[skills/search2pipe-ingest]] — locate → extract pipeline
- [[skills/nix]] — Nix/system-manager deployment
