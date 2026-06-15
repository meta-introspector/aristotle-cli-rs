---
name: nix-flakes
description: >-
  Creates reproducible builds, manages flake inputs, defines devShells,
  and builds packages with flake.nix. Use when initializing Nix projects,
  locking dependencies, or running nix build/develop commands. All inputs
  use git+file:/// per agent/foundation.md.
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

## Project Setup

```bash
nix flake init                    # Basic flake in current directory
nix flake new hello -t templates#hello  # From template
```

Manage dependencies:

```bash
nix flake update                  # Update all inputs in flake.lock
nix flake update nixpkgs          # Update specific input only
nix flake lock                    # Lock missing entries without updating
```

## Building & Running

For local flakes with uncommitted changes, use `path:` prefix or
`--impure`:

```bash
nix build .                       # Build default package (committed)
nix build .#packageName           # Build a specific output
nix run .                         # Run the default app
nix run .#appName                 # Run a specific app
```

For remote flakes (from the git store):

```bash
nix build git+file:///mnt/data1/git/github.com/<owner>/<repo>.git
```

## Development Environments

```bash
nix develop . --command make build
nix develop . --command env        # Check the environment
```

The `--command` flag is required in headless environments to avoid
interactive mode.

## Inspecting Flakes

```bash
nix flake show .                   # List all outputs
nix flake metadata .               # See inputs and revisions
nix eval .#packages.x86_64-linux.default.name  # Evaluate a specific output
```

## Basic Flake Structure (n0x-pi Pattern)

```nix
{
  description = "A basic flake";

  inputs = {
    # Git store invariant: never github:
    nixpkgs.url = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=master";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";  # Hardcoded per foundation.md
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.hello;

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ pkgs.git pkgs.vim ];
      };
    };
}
```

## Best Practices

- Always commit `flake.lock` for reproducibility
- Use `path:` prefix when building local flakes with uncommitted files
- Always use `--command` with `nix develop` in scripts and headless environments
- All inputs use `git+file:///mnt/data1/git/` — never `github:`
- Hardcode `system = "x86_64-linux"` — no `eachDefaultSystem`
- Mirror repos before first use

## Guardrails

- Never use `github:` URLs — always `git+file:///`
- Never use `flake-utils.lib.eachDefaultSystem` — system lock
- `nix build` must succeed before committing
- Dirty tree warnings mean uncommitted changes — commit first

## Related

- `nix` — full Nix ecosystem guide with references
- `nix-build` — flake verification, diagnostics, vendoring
- `agent/foundation.md` — the full vendoring philosophy
