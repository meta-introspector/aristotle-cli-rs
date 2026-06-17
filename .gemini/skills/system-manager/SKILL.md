---
name: "system-manager"
description: "Common issues and solutions for Nix system-manager deployment — symlink problems, activation errors, service patterns, nginx locations, and nixpkgs multi-output workarounds."
---

# system-manager — DASL Service Deployment

Deploy DASL services as systemd units via Nix system-manager. One flake,
one activation command, all services managed declaratively.

---

## Service Patterns

### Python tile server service

```nix
mkPythonService = { name, package, port, binName, user ? "dasl" }:
  {
    enable = true;
    description = "DASL ${name} tile server";
    after = [ "network.target" ];
    wantedBy = [ "system-manager.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${package}/bin/${binName} --port ${toString port}";
      Restart = "always";
      RestartSec = "10s";
      User = user;
      Group = user;
      StandardOutput = "journal";
      StandardError = "journal";
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };
```

### Binary service (existing executable)

```nix
mkBinaryService = { name, binaryPath, port, user ? "dasl", workDir ? null }:
  let wd = if workDir != null then { WorkingDirectory = workDir; } else {};
  in {
    enable = true;
    description = "DASL ${name}";
    after = [ "network.target" ];
    wantedBy = [ "system-manager.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${binaryPath} --port ${toString port}";
      Restart = "always";
      RestartSec = "5s";
      User = user;
      Group = user;
    } // wd;
  };
```

### Optional services (conditional via lib.mkIf)

Use `lib.mkIf` to skip services when their package is null:

```nix
systemd.services.dasl-nagios-tile =
  lib.mkIf (nagios-tile != null)
    (mkPythonService { ... });
```

### Directory setup (oneshot before services)

```nix
systemd.services.dasl-dir = {
  enable = true;
  description = "Create DASL service directories";
  before = [ "dasl-nagios-tile.service" ];
  wantedBy = [ "system-manager.target" ];
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
  };
  script = ''
    mkdir -p /var/lib/dasl
    chown -R dasl:dasl /var/lib/dasl
  '';
};
```

### DASL user/group

```nix
users.users.dasl = {
  isSystemUser = true;
  group = "dasl";
  home = "/var/lib/dasl";
  createHome = true;
  description = "DASL testing services user";
};
users.groups.dasl = {};
```

---

## Nginx Location Helper

```nix
mkLocation = path: port: {
  proxyPass = "http://127.0.0.1:${toString port}/";
  proxyWebsockets = true;
  extraConfig = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_read_timeout 120s;
  '';
};

# Usage:
services.nginx.virtualHosts."solana.solfunmeme.com" = {
  locations."/tile/nagios/" = mkLocation "nagios" 8800;
  locations."/tile/deploy/" = mkLocation "deploy" 8810;
};
```

---

## Flake Structure

```nix
{
  inputs = {
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=master";
    system-manager = {
      url = "git+file:///mnt/data1/git/github.com/numtide/system-manager.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, system-manager }:
    let system = "x86_64-linux";
    in {
      systemConfigs.all-services = system-manager.lib.makeSystemConfig {
        modules = [ ./system-manager-config.nix { nixpkgs.hostPlatform = system; } ];
        specialArgs = {
          inherit self;
          # Pass nix-built packages as args
          inherit nagios-tile deploy-tile;
        };
      };
    };
}
```

---

## Deploying

```bash
# Build and activate
sudo $(nix build .#systemConfigs.all-services --print-out-paths)/bin/activate

# With impure (if services need local network, e.g. nora)
sudo $(nix build .#systemConfigs.all-services --print-out-paths --impure)/bin/activate
```

---

## Common Issues

### Multi-output nixpkgs packages

`systemPackages` with `curl`, `jq`, `python3` can fail with:

```
derivation requires non-existent output 'bin' from input derivation
```

**Fix:** Avoid `environment.systemPackages` in system-manager configs.
Instead, use full package paths directly in `ExecStart` or pass packages
as flake inputs.

### Symlink Problems

When using path inputs with symlinks:
```bash
nix flake check --impure
```

### Nginx Location Placement

Locations MUST be inside `virtualHosts` block:
```nix
services.nginx.virtualHosts."${domain}" = {
  locations."/path/" = { proxyPass = "http://127.0.0.1:PORT/"; };
};
```

### Checking Nix Syntax
```bash
nix-instantiate --parse file.nix >/dev/null && echo "OK" || echo "Error"
```

### Restarting Services After Deploy
```bash
sudo systemctl restart dasl-tile-server
```

### Testing Endpoints
```bash
curl https://solana.solfunmeme.com/tile/nagios/
curl http://127.0.0.1:8800/
```

---

## Full Example: ~/dasl-planning/

See `~/dasl-planning/dasl-testing-system-manager.nix` for a complete working
example with 8 services (Python tiles, binary services, nginx locations).

Deploy: `sudo $(nix build ~/dasl-planning#systemConfigs.all-services --print-out-paths)/bin/activate`
