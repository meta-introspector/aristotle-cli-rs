---
name: "nix-build"
description: "Verify Nix flake builds, check derivations, and diagnose build failures. Use when adding a new package, updating a dependency, or ensuring all flakes in the workspace still build."
---

# Nix Build — Flake Verification & Diagnostics

Verify that Nix flakes build, diagnose failures, and maintain build health
across the workspace. Follows the n0x-pi foundation.md principle: every flake
must build before committing.

---

## When to Use

- "Does this flake still build?"
- "All flakes are broken after nixpkgs update"
- "Add a new vendor package"
- "Check all task flakes build"

## Commands

### `nix-build check <flake-path>`

Build a single flake and report status:

```bash
# Build the default package
nix build <path># --no-link 2>&1

# Build a specific attribute
nix build <path>#<attr> --no-link 2>&1

# Check evaluation (no build)
nix eval <path>#packages.x86_64-linux --apply 'builtins.attrNames' 2>&1
```

### `nix-build check-all`

Verify every flake in the workspace:

```bash
# Root flake
nix build .#pi --no-link

# All task flakes
for task in tasks/*/; do
  echo "=== $task ==="
  nix build "$task" --no-link 2>&1 | tail -3
done
```

### `nix-build update <flake-path>`

Update flake inputs:

```bash
# Update all inputs
nix flake update <path>

# Update a specific input
nix flake lock <path> --update-input nixpkgs

# Check what changed
nix flake metadata <path> 2>&1
```

### `nix-build vendor <owner>/<repo>`

Vendor a new package into the workspace. Follows `agent/foundation.md`:

1. **Mirror the upstream repo:**

```bash
git clone --mirror https://github.com/<owner>/<repo>.git \
  /mnt/data1/git/github.com/<owner>/<repo>.git
```

2. **Create the vendor directory:**

```bash
mkdir -p vendor/<name>
```

3. **Write `vendor/<name>/package.nix`:**

Self-contained build. No framework-specific arguments. System-locked to
`x86_64-linux`. Use `git+file:///mnt/data1/git/` for all inputs.

For npm packages:
```nix
{
  lib,
  buildNpmPackage,
  fetchurl,
  runCommand,
}:
let
  versionData = lib.importJSON ./hashes.json;
  version = versionData.version;
  srcWithLock = runCommand "<name>-src-with-lock" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/<scoped-name>/-/<name>-${version}.tgz";
        hash = versionData.sourceHash;
      }
    } -C $out --strip-components=1
    rm -f $out/npm-shrinkwrap.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  npmDepsFetcherVersion = 2;
  inherit version;
  pname = "<name>";
  src = srcWithLock;
  npmDepsHash = versionData.npmDepsHash;
  makeCacheWritable = true;
  dontNpmBuild = true;
  meta = {
    description = "<description>";
    homepage = "https://github.com/<owner>/<repo>";
    license = lib.licenses.<license>;
    mainProgram = "<name>";
  };
}
```

4. **Create `hashes.json`:**

```json
{
  "version": "<version>",
  "sourceHash": "",
  "npmDepsHash": ""
}
```

5. **First build (will fail with hash mismatch — copy the expected hash):**

```bash
nix build .#<name> 2>&1 | grep "got.*sha256"
```

6. **Wire into `flake.nix`:**

```nix
<name> = pkgs.callPackage ./vendor/<name>/package.nix { };
```

7. **Verify:**

```bash
nix build .#<name> --no-link
```

### `nix-build diagnose <error>`

Common failure patterns and fixes:

| Error | Cause | Fix |
|-------|-------|-----|
| `hash mismatch` | hashes.json out of date | Update `sourceHash` or `npmDepsHash` with the expected value from the error |
| `attribute missing` | Flake output doesn't expose the attr | Check `flake.nix` outputs |
| `evaluation error` | Broken nix expression | Read the error line, fix the syntax |
| `fetchurl 404` | Version doesn't exist on npm | Check `npm view <name> versions` |
| `build failure` | Compilation error | Check `nix log` for details |
| `dirty tree` warning | Uncommitted changes | Commit the changes or use `--impure` |

## Guardrails

- `nix build .#<attr> --no-link` — never leave result symlinks in the project root
- All flake inputs use `git+file:///mnt/data1/git/` — never `github:`
- System is always `x86_64-linux` — no `eachDefaultSystem`
- `nix build` must succeed for every flake before committing
- When vendoring, remove framework-specific args (versionCheckHook, etc.)
- Hash mismatches on first build are expected — copy the `got:` hash

## Related

- `agent/foundation.md` — the full vendoring philosophy
- `dotagents` — for deploying agent configs after building
- `vox` — for spec-driven development of new packages
