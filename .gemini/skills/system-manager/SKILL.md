---
name: system-manager
description: Common issues and solutions for Nix system-manager deployment — symlink problems, activation errors, and tmpfiles.d configuration fixes.
---

# system-manager Skills

## Common Issues and Solutions

### Symlink Problems
When using path inputs with symlinks (e.g., `dasl-tiles-rust`):
```bash
# Error: access to absolute path is forbidden in pure evaluation mode
nix flake check --impure
```

### CLI Syntax for tile-server
Use short flags, not subcommand syntax:
```bash
# WRONG:
tile-server serve --domain example.com --port 8080

# CORRECT:
tile-server -d example.com -p 8080
```

### Nginx Location Placement
Locations MUST be inside `virtualHosts` block:
```nix
services.nginx.virtualHosts."${domain}" = {
  locations."/path/" = {
    proxyPass = "http://127.0.0.1:PORT/endpoint/";
    extraConfig = 'proxy_set_header Host $host;';
  };
};
```

### Checking Nix Syntax
```bash
nix-instantiate --parse file.nix >/dev/null && echo "OK" || echo "Error"
```

### Deploying
```bash
nix run github:numtide/system-manager -- switch --flake .#config-name
```

### Restarting Services After Deploy
```bash
sudo systemctl restart dasl-tile-server
```

### Testing Endpoints
```bash
curl https://domain.com/dashboard/ebpf
curl https://domain.com/tile/ebpf/d8-2a/status
```