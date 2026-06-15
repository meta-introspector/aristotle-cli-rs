---
name: ebpf-system-manager-deploy
description: >-
  Deploy a Nix-built eBPF program as a systemd service via system-manager.
  Use when you need to take a crane-built eBPF binary and run it persistently
  as a root systemd service managed by system-manager. Covers the full pipeline:
  git mirror → crane build → system-manager config → activate.
---

# eBPF system-manager deploy pattern

Full pipeline for deploying a Nix-built eBPF monitor as a persistent systemd service.

## File structure

```
monitoring-task/
├── flake.nix                  # crane build + system-manager config
├── system-manager-config.nix  # systemd unit referencing self.packages
└── deploy.sh                  # nix build → sudo activate → status
```

## flake.nix pattern

```nix
inputs = {
  nixpkgs.url        = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=master";
  crane.url          = "git+file:///mnt/data1/git/github.com/ipetkov/crane.git";
  flake-utils.url    = "git+file:///mnt/data1/git/github.com/numtide/flake-utils";
  system-manager.url = "git+file:///mnt/data1/git/github.com/numtide/system-manager.git";
  my-src = {
    url   = "git+file:///home/mdupont/git/github.com/OWNER/REPO.git?dir=SUBDIR";
    flake = false;
  };
};

outputs = { self, nixpkgs, crane, system-manager, my-src, ... }:
  let
    pkg = craneLib.buildPackage { src = my-src; ... };
  in {
    packages.${system} = { default = pkg; inherit pkg; };

    systemConfigs."my-service" = system-manager.lib.makeSystemConfig {
      modules = [ ./system-manager-config.nix { nixpkgs.hostPlatform = system; } ];
      specialArgs = { inherit self; };
    };
  };
```

## system-manager-config.nix pattern

```nix
{ config, lib, pkgs, self, ... }:
let pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.pkg;
in {
  config.systemd.services.my-service = {
    enable = true;
    wantedBy = [ "system-manager.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkg}/bin/my-binary";
      Restart = "on-failure";
      User = "root";   # eBPF requires root
    };
  };
}
```

## Deploy commands

```bash
# Build
STORE=$(nix build .#systemConfigs.my-service --no-link --print-out-paths)

# Activate (installs unit files + starts service)
sudo $STORE/bin/activate

# Verify
systemctl status my-service
journalctl -u my-service -f
```

## Source mirror pattern (gitplan.org)

All flake inputs must use `git+file:///mnt/data1/git/<host>/<owner>/<repo>.git`:

```bash
# Create mirror
git clone --mirror https://github.com/OWNER/REPO.git \
  ~/git/github.com/OWNER/REPO.git

# Push local work to mirror
git remote add local ~/git/github.com/OWNER/REPO.git
git push local HEAD:main
```

## Reference implementation

- Source: `aya-nix/d8_2a/` (crane + libbpf-rs eBPF)
- Task: `/mnt/data1/time-2026/05-may/31/n0x-pi/tasks/kilocode-d8-2a-monitoring/`
- Docs: `~/DOCS/d8-2a-ebpf-systemd-deploy.md`
- Skill: `d8-2a-crane-libbpf` (build details)
