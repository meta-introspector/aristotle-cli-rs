---
name: "search2pipe-ingest"
description: "Filesystem corpus ingestion pipeline: locate → stat → parquet → project grouping → CI/CD pipeline generation. Uses plocate, locate_stat_cache, and search2pipe binaries to turn filesystem searches into DASL tiles, pipelight TOML, and FRACTRAN-encoded workflows. Use when building a file corpus, extracting configs from the filesystem, or generating CI pipelines from project discovery."
---

# Search2Pipe Ingest

> locate → stat → parquet → project grouping → CI pipelines → tiles.
> Monster Group FRACTRAN encoding: primes 2=check 3=test 5=build 7=verify 11=deploy 13=witness.

## When to Use

- Building a file corpus from locate results
- Extracting nginx configs from the filesystem
- Discovering projects (Cargo.toml, flake.nix, package.json) from file lists
- Generating CI/CD pipelines (pipelight, pipelite, cuirass, ZOS)
- Cross-referencing filesystem state with live configs

## Tools

| Binary | Path | Purpose |
|--------|------|---------|
| `plocate` | `/usr/bin/plocate` | Fast filename search |
| `locate_stat_cache` | `/mnt/data1/nix/vendor/tmux/target/release/locate_stat_cache` | plocate → batch stat → parquet |
| `search2pipe` | `/mnt/data1/nix/vendor/tmux/target/release/search2pipe` | stat → project grouping → CI pipelines |

## Pipeline

```bash
# Stats + parquet
locate_stat_cache nginx --cache /tmp/nginx.parquet --sort mtime

# Project grouping + pipeline generation
search2pipe nginx --format all --out /tmp/pipelines
# Output: {project}.pipelight.toml + .pipelite.yaml + .cuirass.scm + .zos-workflow.json

# Full corpus → tile pipeline
bash scripts/nginx-corpus-pipeline.sh A,B,C,D,E
```

## Parquet Schema

| Field | Type | Description |
|-------|------|-------------|
| inode | UInt64 | Inode number |
| dev | UInt64 | Device ID |
| size | UInt64 | File size (bytes) |
| mtime | Int64 | Modification time (epoch) |
| atime | Int64 | Access time |
| ctime | Int64 | Change time |
| mode | UInt32 | Permission bits |
| nlink | UInt64 | Hard link count |
| uid | UInt32 | Owner UID |
| path | Utf8 | Full path |

Compression: ZSTD. Can mmap to `/dev/shm/`.

## Project Detection

search2pipe walks up from each file looking for:
- `Cargo.toml` → rust
- `flake.nix` → nix
- `package.json` → node
- `pyproject.toml` / `setup.py` → python
- `Makefile` → generic
- `.el` → elisp

## Related Skills

- [[skills/nginx-control-tiles]] — Nginx topology → control tiles
- [[skills/dasl-tiles]] — DASL tile system
- [[skills/dasl-testing]] — Cross-implementation fuzzing
