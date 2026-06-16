---
name: "nix-flakes"
description: "Creates reproducible builds, manages flake inputs, defines devShells, and builds packages with flake.nix. Includes Rust build patterns (cargoVendorDir, cargoLock), Python packaging, and system-manager systemConfigs. All inputs use git+file:/// per agent/foundation.md."
---

# Nix Flakes — Project Management

Modern Nix project management with hermeticity through `flake.lock`.
Every dependency locked to a specific revision for reproducibility.
All inputs follow the n0x-pi git store invariant.

---

## When to Use

- "Initialize a new Nix project"
- "Update flake inputs"
- "Build a flake package"
- "Set up a devShell"
- "Define system-manager service configs"

## Project Setup

```bash
nix flake init
nix flake new hello -t templates#hello
```

Manage dependencies:

```bash
nix flake update               # Update all inputs
nix flake update nixpkgs        # Update specific input
nix flake lock                  # Lock missing entries without updating
```

## Building & Running

```bash
nix build .                     # Build default package (committed)
nix build .#packageName         # Build specific output
nix run .                       # Run default app
nix run .#appName               # Run specific app
```

For remote flakes (from git store):

```bash
nix build git+file:///mnt/data1/git/github.com/<owner>/<repo>.git
```

For system-manager configs:

```bash
nix build .#systemConfigs.all-services --no-link
sudo $(nix build .#systemConfigs.all-services --print-out-paths)/bin/activate
```

With network access (e.g. nora registry):

```bash
nix build .#systemConfigs.all-services --no-link --impure
```

---

## Rust Package Patterns

### Pattern A: Vendored deps (pure eval, no network)

Use when crate deps are vendored in `vendor/`:

```nix
pkgs.rustPlatform.buildRustPackage {
  pname = "my-crate";
  version = "0.1.0";
  src = ./.;
  cargoVendorDir = "vendor";    # Uses pre-vendored deps, no network
  cargoBuildFlags = [ "--bin service" ];
  doCheck = false;
}
```

**Caveat:** `builtins.path { path = ./.; }` strips files matching .gitignore
(including `vendor/` if gitignored). Use raw `src = ./.;` when vendor must
be included, or confirm `vendor/` is tracked by git.

**Example:** `~/dasl/dasl-testing/harnesses/libipld/flake.nix` — 46MB vendored
deps, builds purely in sandbox.

### Pattern B: CargoLock with nora registry (needs --impure)

Use when deps are NOT vendored but nora is available:

```nix
pkgs.rustPlatform.buildRustPackage {
  pname = "my-crate";
  version = "0.1.0";
  src = ./harnesses/my_crate;
  cargoLock = { lockFile = ./harnesses/my_crate/Cargo.lock; };
  cargoBuildFlags = [ "--bin service" ];
  doCheck = false;

  preBuild = ''
    mkdir -p .cargo
    cat > .cargo/config.toml << 'NORA_EOF'
    [source.crates-io]
    replace-with = "nora"

    [source.nora]
    registry = "http://127.0.0.1:4000/cargo/index"
    NORA_EOF
  '';
}
```

**Must use `--impure`** — nix sandbox blocks network by default.

### Pattern C: CargoLock (online, fetches from crates.io)

Only works when crates.io is reachable (not behind 403 proxy):

```nix
pkgs.rustPlatform.buildRustPackage {
  pname = "my-crate";
  version = "0.1.0";
  src = ./.;
  cargoLock = { lockFile = ./Cargo.lock; };
}
```

**Avoid** in DASL ecosystem — crates.io returns 403.

---

## Python Package Pattern

Simple script packaging (no build system needed):

```nix
pkgs.stdenvNoCC.mkDerivation {
  pname = "my-script";
  version = "0.1.0";
  src = ./script.py;
  dontUnpack = true;           # File is a script, not archive
  buildInputs = [ pkgs.python3 ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${pname}
    chmod +x $out/bin/${pname}
    # Patch shebang if missing
    if ! head -1 $out/bin/${pname} | grep -q '^#!'; then
      sed -i '1i#!/usr/bin/env python3' $out/bin/${pname}
    fi
  '';
}
```

---

## System-Manager Config Pattern

Define deployable systemd services in a flake:

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
      # Packages
      packages.${system}.default = pkgs.hello;

      # System-manager configs
      systemConfigs.all-services = system-manager.lib.makeSystemConfig {
        modules = [
          ./system-manager-config.nix
          { nixpkgs.hostPlatform = system; }
        ];
        specialArgs = {
          inherit self;
          # Pass nix-built packages as extra args
          myService = self.packages.${system}.myService;
        };
      };
    };
}
```

---

## Input Patterns

### Bare mirror (git+file://)

```nix
inputs = {
  nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=master";
  my-repo = {
    url = "git+file:///home/mdupont/git/github.com/meta-introspector/my-repo.git?ref=main";
    flake = false;  # non-flake repo
  };
};
```

### Following nixpkgs (share a single nixpkgs revision)

```nix
my-input = {
  url = "git+file:///...";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

---

## Inspecting Flakes

```bash
nix flake show .                 # List all outputs
nix flake metadata .             # See inputs and revisions
nix eval .#packages.x86_64-linux.default.name
```

---

## Development Environments

```bash
nix develop . --command make build
nix develop . --command env       # Check the environment
```

The `--command` flag is required in headless environments.

---

## Best Practices

- Always commit `flake.lock` for reproducibility
- `src = ./.;` keeps vendor dir (not stripped by gitignore)
- Prefer `cargoVendorDir` over `cargoLock` for pure sandbox builds
- All inputs use `git+file:///mnt/data1/git/` — never `github:`
- Hardcode `system = "x86_64-linux"` — no `eachDefaultSystem`
- Mirror repos to bare git before referencing in flakes
- Use `--impure` only when services need local network (nora, etc.)
- Avoid `environment.systemPackages` in system-manager configs (multi-output nixpkgs issue)

## Guardrails

- Never use `github:` URLs — always `git+file:///`
- Never use `flake-utils.lib.eachDefaultSystem` — system lock
- `nix build` must succeed before committing
- Dirty tree warnings mean uncommitted changes — commit first
- `builtins.path` filters via .gitignore — prefer `src = ./.;`

## Related

- `nix` — full Nix ecosystem guide
- `nix-build` — flake verification, diagnostics, vendoring
- `system-manager` — service patterns, mkService helpers
- `dasl-testing` — harness build patterns
- `agent/foundation.md` — the full vendoring philosophy
