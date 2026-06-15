---
name: build-memory-ide
description: >-
  Build Memory IDE — de-duplicated build errors as IPLD memory objects.
  Every build output becomes a content-addressed CID. Errors de-duplicated
  across runs and projects. Build history timeline + error knowledge base.
  Use when tracking build errors, linking fixes, or analyzing build history.
---

# 🏗️ Build Memory IDE

**URL:** https://solana.solfunmeme.com/tile/vendormod/build
**Source:** `~/DOCS/build-memory-tile.html`
**Spec:** `~/DOCS/BUILD_MEMORY_SPEC.md`

## Concept

```
cargo build error → fingerprint (normalize) → CID
Same error next time → same CID → already known → link to fix
```

Every build output (success, error, warning) becomes a first-class IPLD
memory object. Build logs are content-addressed and de-duplicated across
runs. Errors link to their fixes.

## 4 Tab Views

| Tab | Shows |
|-----|-------|
| 📅 Timeline | Build history — 🟢/🔴, duration, errors linked to fixes |
| 🔴 Errors | Unique errors de-duplicated — fixed ✅ with commit + fix |
| 🧠 Knowledge | Cross-project error KB — CID fingerprints, occurrence counts |
| 📦 Projects | All projects with build stats (pass/fail/errors) |

## Features

- **Error Fingerprinting** — strip specifics, SHA-256 → CID
- **De-Duplication** — same error across runs = same CID
- **Cross-Project** — error-004 seen 47 times across 8 projects
- **Fix Linking** — error CID → commit that fixed it
- **Build History** — timeline of every build run

## Deploy

```bash
bash ~/DOCS/build-memory-deploy.sh
```

## Diagnose

```bash
curl https://solana.solfunmeme.com/tile/vendormod/build | grep '<title>'
systemctl status vendormod-tile-server
tail -f ~/log/vendormod-tile.log
```

## Related
- [[skills/vendormod-tile-server]] — backend server
- [[skills/tile-runtime]] — universal app-to-tile wrapper
- [[skills/deploy-tile]] — deploy from web
- [[skills/nagios-tile-monitor]] — health monitoring
