---
name: nix
description: >-
  Comprehensive NixOS, Nix Flakes, Home Manager, and nix-darwin skill.
  Covers declarative system configuration, reproducible environments,
  package management, and cross-platform Nix workflows. All flake
  inputs use git+file:/// per agent/foundation.md. Activate for any
  Nix/NixOS/Flakes/Home-Manager/nix-darwin tasks.
---

# Nix Ecosystem Guide

Covers the full Nix ecosystem: NixOS, flakes, home-manager, nix-darwin.
All patterns follow the n0x-pi foundation: `git+file:///` inputs,
system-locked to `x86_64-linux`, vendor-not-reference.

---

## Core Philosophy

1. **Declarative over Imperative** — Describe desired state, not steps
2. **Reproducibility** — `flake.lock` pins exact versions
3. **Immutability** — Nix Store is read-only; same inputs = same outputs
4. **Rollback (NixOS)** — Every generation preserved; instant recovery

## Flake Structure (n0x-pi Pattern)

```nix
{
  description = "My Nix configuration";

  inputs = {
    # All inputs from the git store — never github:
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=master";

    home-manager = {
      url = "git+file:///mnt/data1/git/github.com/nix-community/home-manager.git";
      inputs.nixpkgs.follows = "nixpkgs";  # CRITICAL: avoid duplicate nixpkgs
    };

    nix-darwin = {
      url = "git+file:///mnt/data1/git/github.com/LnL/nix-darwin.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let
      system = "x86_64-linux";  # Hardcoded per foundation.md
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };

      darwinConfigurations.hostname = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin.nix ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [ /* ... */ ];
      };
    };
}
```

## Essential Patterns

### Input Management

```nix
inputs = {
  nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=master";
  unstable.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=nixos-unstable";

  # Use parent's nixpkgs to avoid downloading multiple versions
  home-manager.inputs.nixpkgs.follows = "nixpkgs";

  # Non-flake input
  private-config = {
    url = "git+file:///mnt/data1/git/github.com/user/config.git";
    flake = false;
  };
};
```

### Module System

```nix
{ config, pkgs, lib, ... }: {
  imports = [ ./hardware.nix ./services.nix ];

  options.myOption = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf config.myOption {
    # conditional configuration
  };
}
```

### Priority Control

```nix
{
  # lib.mkDefault (priority 1000) - base module defaults
  services.nginx.enable = lib.mkDefault true;

  # Direct assignment (priority 100) - normal config
  services.nginx.enable = true;

  # lib.mkForce (priority 50) - override everything
  services.nginx.enable = lib.mkForce false;
}
```

### Package Customization

```nix
{
  # Override function arguments
  pkgs.fcitx5-rime.override { rimeDataPkgs = [ ./custom-rime ]; }

  # Override derivation attributes
  pkgs.hello.overrideAttrs (old: { doCheck = false; })

  # Overlays (global modification)
  nixpkgs.overlays = [
    (final: prev: {
      myPackage = prev.myPackage.override { /* ... */ };
    })
  ];
}
```

## Platform-Specific

### NixOS

```bash
sudo nixos-rebuild switch --flake .#hostname
sudo nixos-rebuild boot --flake .#hostname    # apply on next boot
sudo nixos-rebuild test --flake .#hostname    # test without boot entry
```

### nix-darwin (macOS)

```bash
darwin-rebuild switch --flake .#hostname
# TouchID for sudo:
# security.pam.services.sudo_local.touchIdAuth = true;
```

### Home Manager

```nix
# As NixOS/Darwin module:
home-manager.useGlobalPkgs = true;
home-manager.useUserPackages = true;
home-manager.users.username = import ./home.nix;

# Standalone:
home-manager switch --flake .#username@hostname
```

## Commands Reference

| Task | Command |
|------|---------|
| Rebuild NixOS | `sudo nixos-rebuild switch --flake .#hostname` |
| Rebuild Darwin | `darwin-rebuild switch --flake .#hostname` |
| Dev shell | `nix develop` |
| Temp package | `nix shell nixpkgs#package` |
| Run package | `nix run nixpkgs#package` |
| Update all | `nix flake update` |
| Update one | `nix flake update nixpkgs` |
| GC old gens | `sudo nix-collect-garbage -d` |
| List gens | `nix profile history --profile /nix/var/nix/profiles/system` |
| Debug build | `nixos-rebuild switch --show-trace -L -v` |
| REPL | `nix repl` then `:lf .` to load flake |

## Common Gotchas

1. **Untracked files ignored** — `git add` before any flake command
2. **allowUnfree fails in devShells** — Use `nixpkgs-unfree` overlay or `~/.config/nixpkgs/config.nix`
3. **Duplicate input downloads** — Use `follows` to pin dependencies
4. **Python pip fails** — Use `venv`, `poetry2nix`, or containers
5. **Downloaded binaries fail** — Use FHS environment or `nix-ld`
6. **Merge conflicts in lists** — Use `lib.mkBefore`/`lib.mkAfter`
7. **Build from source unexpectedly** — Check if overlays invalidate cache

## Development Environments

```nix
devShells.x86_64-linux.default = pkgs.mkShell {
  packages = with pkgs; [ nodejs python3 rustc ];

  shellHook = ''
    echo "Dev environment ready"
    export MY_VAR="value"
  '';

  # For C libraries
  LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.openssl ];
};
```

### direnv Integration

```bash
# .envrc
use flake
# or for unfree: use flake --impure
```

## Debugging

```bash
# Verbose rebuild
nixos-rebuild switch --show-trace --print-build-logs --verbose

# Interactive REPL
nix repl
:lf .                    # load current flake
:e pkgs.hello           # open in editor
:b pkgs.hello           # build derivation
inputs.<TAB>            # explore inputs
```

## References

Detailed reference files in `agent/skills/nix/references/`:

- `references/nix-language.md` — Nix language syntax
- `references/flakes.md` — Flake inputs/outputs details
- `references/home-manager.md` — User environment management
- `references/nix-darwin.md` — macOS configuration
- `references/nixpkgs-advanced.md` — Overlays, overrides, callPackage
- `references/dev-environments.md` — Dev shells, direnv, FHS
- `references/best-practices.md` — Modularization, debugging, deployment
- `references/templates.md` — Ready-to-use flake.nix examples

## Guardrails

- All flake inputs use `git+file:///mnt/data1/git/` — never `github:`
- System is always `x86_64-linux` — no `eachDefaultSystem`
- Mirror repos before first use: `git clone --mirror <url> /mnt/data1/git/github.com/<owner>/<repo>.git`
- Follow `agent/foundation.md` for vendoring decisions
- `nix build` must succeed before committing

## Related

- `nix-build` — flake verification, diagnostics, vendoring
- `nix-flakes` — focused flake-specific patterns
- `agent/foundation.md` — the full vendoring philosophy
