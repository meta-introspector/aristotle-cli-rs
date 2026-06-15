---
name: system-blueprint
description: >-
  Complete DASL system blueprint — 11-dimension lifecycle for every package
  (git mirror, worktree, branch, skill, nora pkg, nix flake, system-manager,
  nginx proxy, tile GUI, admin tile, documentation). Maps 12+ packages with
  current status. Use when auditing package completeness or planning new tiles.
---

# System Blueprint

Full document: `~/projects/dotagents/SYSTEM_BLUEPRINT.md`

## 11 Dimensions (every package)

```
1. Git bare mirror    → /mnt/data1/git/.../repo.git
2. Worktree           → git worktree add ../repo <branch>
3. Branch             → vendor-deps (cargo vendor + cargoVendorDir)
4. Skill              → ~/projects/dotagents/skills/<name>/SKILL.md
5. Nora pkg           → nora:// on :4000
6. Nix flake          → flake.nix with cargoVendorDir
7. System-manager     → systemd service definition
8. Nginx proxy        → solana.solfunmeme.com/tile/<name>/
9. Tile GUI           → Interactive HTML + JSON API
10. Admin tile         → /admin/status, warm triggers, cache
11. Documentation      → DOCS/, plan.org, dotagents/
```

## Package Status (12 mapped)

| Package | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---------|---|---|---|---|---|---|---|---|---|---|----|----|
| ipld-car-shmem | ✅ | ✅ | ✅ | ✅ | 📋 | ✅ | ✅ | — | 📋 | 📋 | ✅ |
| diagonalize-tile | ✅ | ✅ | ✅ | ✅ | — | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| nginx | — | — | — | 📋 | — | 📋 | ✅ | ✅ | 📋 | 📋 | ✅ |
| ipld-core | ✅ | ✅ | 📋 | ✅ | 📋 | 📋 | — | — | 📋 | — | 🔧 |
| serde-ipld-dagcbor | ✅ | ✅ | 📋 | ✅ | 📋 | 📋 | — | — | ✅ | — | ✅ |
| cargo-vendormod | ✅ | ✅ | 🔧 | 🔧 | 📋 | 📋 | ✅ | — | 📋 | ✅ | ✅ |
| go-ipld-prime | ✅ | ✅ | — | 📋 | — | 📋 | — | — | 📋 | — | 🔧 |
| sparql-gui | 📋 | ✅ | 🔧 | ✅ | — | 📋 | 📋 | 📋 | 📋 | 📋 | 🔧 |
| nora | 📋 | ✅ | 🔧 | ✅ | ✅ | ✅ | ✅ | ✅ | 📋 | 📋 | ✅ |
| dasl-tiles-rust | 📋 | ✅ | 🔧 | ✅ | 📋 | 📋 | — | — | ✅ | — | ✅ |
| pastebin | ✅ | ✅ | 🔧 | ✅ | — | ✅ | ✅ | ✅ | ✅ | 📋 | ✅ |

## Priority

Immediate: sparql-gui (needs 6/11), nora monitor (needs 3/11)
Next: ipld-core, serde-ipld-dagcbor vendor-deps
Later: all 50+ Rust flakes
