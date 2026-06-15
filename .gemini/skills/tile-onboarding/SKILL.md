---
name: tile-onboarding
description: >-
  How to create a new DASL tile, register it in IPLD shmem, and deploy it
  via system-manager + nginx. Covers JSON definition, server skeleton, shmem
  registration, systemd unit, and verification.
---

# Tile Onboarding — How to Register a New DASL Tile

**Create a new tile, register it in shmem, deploy it.**

## Step 1: Create Tile Definition

```json
{
  "id": "my-new-tile",
  "title": "🆕 My New Tile",
  "description": "What this tile does",
  "kind": "http-tile",
  "endpoint": "http://127.0.0.1:PORT",
  "port": 8900,
  "language": "Rust",
  "tags": ["my-tag", "tile"],
  "endpoints": [
    {"path": "/health", "method": "GET", "description": "Health check"},
    {"path": "/api/data", "method": "GET", "description": "Main API"}
  ],
  "version": "0.1.0",
  "depends_on": []
}
```

Save as `my-tile.json`.

## Step 2: Build the Tile Server

Minimal Python tile server:
```python
#!/usr/bin/env python3
import http.server, json, sys
PORT = int(sys.argv[2]) if len(sys.argv) > 2 else 8900

class H(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.send_json({"status":"ok","tile":"my-tile"})
        elif self.path == "/api/data":
            self.send_json({"data": [1,2,3]})
    def send_json(self, data):
        body = json.dumps(data).encode()
        self.send_response(200)
        self.send_header("Content-Type","application/json")
        self.send_header("Access-Control-Allow-Origin","*")
        self.send_header("Content-Length",str(len(body)))
        self.end_headers()
        self.wfile.write(body)

httpd = http.server.HTTPServer(("0.0.0.0", PORT), H)
print(f"Serving :{PORT}"); httpd.serve_forever()
```

## Step 3: Register in IPLD Shmem

```bash
LM=~/dasl/ipld-car-ipc-shmem-linux/target/release/letta-ipld-memory

$LM put "tiles/my-new-tile" "My new tile description" < my-tile.json
```

## Step 4: Deploy via system-manager

```nix
# Add to /etc/system-manager/all-services.nix:
systemd.services.my-new-tile = {
  enable = true;
  description = "My New Tile";
  after = [ "network.target" ];
  wantedBy = [ "system-manager.target" ];
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.python3}/bin/python3 /path/to/my-tile-server.py --port 8900";
    Restart = "always";
    RestartSec = "5";
  };
};

# Nginx:
services.nginx.virtualHosts."solana.solfunmeme.com".locations."/tile/my-tile/" = {
  proxyPass = "http://127.0.0.1:8900/";
  extraConfig = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    add_header Access-Control-Allow-Origin *;
  '';
};
```

Deploy:
```bash
sudo -E ~/.nix-profile/bin/nix run github:numtide/system-manager -- switch --flake /etc/system-manager#all-services
```

## Step 5: Verify

```bash
curl http://127.0.0.1:8900/health
curl https://solana.solfunmeme.com/tile/my-tile/health
check-tiles  # should list my-new-tile
```

## Step 6: Add to TUI (optional)

Add to check-tiles.sh TILES array:
```bash
TILES+=(my-new-tile)
```

## Template Files

Use existing tiles as templates:
- `~/DOCS/nagios-tile-server.py` — Python tile server pattern
- `~/DOCS/deploy-tile-server.py` — Deploy tile pattern
- `~/DOCS/nagios-tile.html` — Zero-dep HTML dashboard pattern
- `~/DOCS/tile-controller-def.json` — Tile definition template
