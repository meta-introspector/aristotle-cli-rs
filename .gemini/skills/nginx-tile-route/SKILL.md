---
name: "nginx-tile-route"
description: "Add, list, and reload nginx tile routes on solana.solfunmeme.com. Use when adding a new proxied path to the tile-server or any backend service. Never inline sed/edit nginx configs directly."
---

# nginx-tile-route — Manage nginx tile proxy routes

**Script:** `dasl-tiles-rust/nginx-tile-route.sh`

## Usage

```bash
# Add a route
bash nginx-tile-route.sh add <path> [port] [backend-path]

# List all routes
bash nginx-tile-route.sh list

# Reload nginx
bash nginx-tile-route.sh reload
```

## Examples

```bash
# Proxy /ring to tile-server
bash nginx-tile-route.sh add /ring 18090 /ring

# Proxy /api to a different backend
bash nginx-tile-route.sh add /api/v2 8090 /api

# See what's currently routed
bash nginx-tile-route.sh list
```

## Route format

Adds a `location ^~ <path>` block in `/etc/nginx/sites-enabled/solana.solfunmeme.com`:

```nginx
location ^~ /ring {
    proxy_pass http://127.0.0.1:18090/ring;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

## Config files

| File | Role |
|------|------|
| `/etc/nginx/sites-enabled/solana.solfunmeme.com` | Main vhost |
| `/etc/nginx/locations.d/tiles.conf` | `/tiles/` route |

## System-manager integration

The canonical nginx config lives in `/etc/system-manager/all-services.nix`.
Routes added via this script are for rapid iteration. For permanent
deployment, add the location to the system-manager nix config and run:

```bash
nix build --no-write-lock-file /etc/system-manager#systemConfigs.all-services
sudo system-manager activate --store-path <result>
```

## Related

- Skill: `dasl-tiles` — tile-server and routes
- Skill: `da51-orbifold-admin` — admin panel
- Skill: `ebpf-system-manager-deploy` — system-manager pattern
