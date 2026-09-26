# aristotle-manager — Usage Guide

Rust CLI for the Aristotle API (https://aristotle.harmonic.fun/api/v3):
submit projects, ask questions, poll tasks, download results, manage
multiple accounts.

## Setup

```bash
# install (Nix)
nix profile install ~/projects/arist/aristotle-manager-flake

# configure accounts (keys stay in files, not config)
aristotle-manager configure set
aristotle-manager configure show
```

Accounts live in `config.toml` as `[[accounts]]` entries. Each has a name
and either an inline `api_key` or (preferred) `api_key_file`. Resolution
order: `--account NAME` → `default_account` → legacy single key
(`ARISTOTLE_API_KEY`).

```toml
default_account = "main"

[[accounts]]
name = "main"
api_key_file = "~/.config/aristotle-manager/keys/main.key"

[[accounts]]
name = "twitterstorm"
api_key_file = "~/.config/aristotle-manager/keys/twitterstorm.key"
```

## Core commands

### Submit a project

```bash
# submit a directory as tarball + prompt, wait for completion
aristotle-manager submit --project-dir ./myproject --wait "prove the lemma"

# attach extra artifacts (multipart, max 5 parts)
aristotle-manager submit --file results.tar.gz "review these results"
```

### Ask a running project

```bash
# inline if project is running, attached if stopped (auto-detected)
aristotle-manager ask <project-id> "what is the status of lemma X?"

# force modes
aristotle-manager ask <project-id> --inline "quick question"
aristotle-manager ask <project-id> --attach "here is a big file" --file data.json

# send files (batched 5 per request)
aristotle-manager ask <project-id> "review these" --dir ./proofs/
aristotle-manager ask <project-id> "check this" --file lemma42.lean

# multi-account
aristotle-manager ask --account twitterstorm <project-id> "status?"
```

### Ask with files (legacy explicit form)

```bash
aristotle-manager ask-with-files <project-id> "review the proofs" --files-dir ./split/
aristotle-manager ask-with-files <project-id> "check this" --file single.lean
```

### Poll and download

```bash
# status of all tasks on the default account
aristotle-manager check
aristotle-manager check <project-id>

# download one task result
aristotle-manager download-result <task-id> --output-dir ./out

# incremental fetch + download of new results
aristotle-manager fetch -j 4 --limit 10
aristotle-manager refresh -j 4        # download → split → decl-table
```

## Multi-account workflow

Two accounts (main, twitterstorm) give independent readings of the same
submission — divergence between them is the signal:

```bash
# check both accounts
aristotle-manager check --account main
aristotle-manager check --account twitterstorm

# submit the same bundle to both (see tracker scripts/aristo-dual-submit.sh
# for the full procedure with telemetry and completion watching)
aristotle-manager submit --account main --bundle repo.bundle "prompt"
aristotle-manager submit --account twitterstorm --bundle repo.bundle "prompt"
```

## DASL pipeline commands

```bash
aristotle-manager build --input-dir ./projects    # lake build all
aristotle-manager split --input-dir ./in --output-dir ./out
aristotle-manager split-all --output-dir ./out -j 4
aristotle-manager merge --input-dir ./split --output-dir ./merged
aristotle-manager decl-table --split-dir ./split --output table.json
aristotle-manager index --output blocks.json     # DASL blocks.json
aristotle-manager scan-index --index-dir ./idx --output-dir ./out
aristotle-manager notebooklm --project-dir ./proj
aristotle-manager pipeline -j 4                  # fetch→split→verify→version→merge
aristotle-manager replay --output-dir ./out      # chronological rebuild
aristotle-manager version --results-dir ./r --output-dir ./v
```

## Gokujo + shared lake-cache: build & deploy pipeline

The full toolchain-bootstrap → cache → build → sign → nginx pipeline is
managed by two cooperating tools:

| Tool | Role |
|------|------|
| `gokujo` (the **lean-worker**, a tiny signed Lean-compiled binary) | bootstrap lean, link the shared mathlib checkout, fetch prebuilt oleans, check proofs, write build-report tiles |
| `aristotle-manager` (the Rust CLI) | orchestrate all of the above, sign reports, publish to nginx via system-manager |

### One-time machine setup

```bash
# configure package managers + cache root on any OS (elan > nix > bundled gokujo)
aristotle-manager cache init            # creates /mnt/data1/lake-cache
aristotle-manager cache init --toolchain v4.28.0

# compile + sign the lean-worker (no deps beyond a bare lean)
aristotle-manager toolchain bootstrap
aristotle-manager sign sign ~/.cache/aristotle-manager/bin/gokujo
aristotle-manager sign verify ~/.cache/aristotle-manager/bin/gokujo
```

`cache init` writes `<root>/env.sh` (export `LEAN_SHARED_CACHE_ROOT`) and a
README with the workflow. Source it before building so every lake shares the
same lakedir.

### Build & deploy a downloaded project (never rebuild mathlib)

```bash
# newest downloaded project, built against the shared cache, report published
aristotle-manager publish                     # default: newest project
aristotle-manager publish <project-dir>       # explicit
aristotle-manager publish <dir1> <dir2> --limit 2
```

Per project the pipeline is:

1. hardlink sources into a build workspace under `/mnt/data1/aristotle-builds/<id>/`
2. `aristo cache link` — symlink every managed dependency (mathlib plus
   batteries/aesop/proofwidgets/Qq/importGraph/std) into the shared store
   (`<root>/lean-shared/mathlib/<toolchain>-<rev>` and
   `<root>/lean-shared/lake-packages/<name>/<toolchain>-<rev>`; two projects
   share a dependency only when both toolchain **and** rev match)
3. `lake exe cache get!` — fetch mathlib's prebuilt cloud oleans for the pinned
   rev; mathlib is **never** rebuilt from source
4. `lake build` against the shared cache
5. `gokujo scan` — proof gate (declarations + holes) using the signed lean-worker
6. package the cached mathlib oleans into the nix store
   (`nix store add-path`, content-addressed, no rebuild) — recorded in
   `mathlib-nix-store.txt` so downstream nix builds resolve `LEAN_PATH` from
   `/nix/store`
7. sign the build report (SSHSIG, namespace `aristotle-manager`) and publish
   `build-report.json` + `index.html` to the nginx static root

Flags: `--no-cache-exe` skips step 3 (risks a mathlib rebuild — avoid),
`--no-nix` skips step 6, `--web-root DIR` overrides the publish root
(default `/var/www/solana.solfunmeme.com/aristotle-builds`, staged at
`/mnt/data1/lake-cache/www/aristotle-builds`).

### The lean-worker directly

`gokujo` can do the same work standalone (this is what makes the pair
self-contained on a fresh OS — one binary, no package managers):

```bash
~/.cache/aristotle-manager/bin/gokujo cache <project>   # link store + lake exe cache get!
~/.cache/aristotle-manager/bin/gokujo deploy <project> -o ./tile   # cache+build+report tile
~/.cache/aristotle-manager/bin/gokujo debug <project>   # toolchain/cache/linkage report
~/.cache/aristotle-manager/bin/gokujo debug <project> --json
```

### Serve the tile (system-manager nginx)

```bash
~/arist/scripts/deploy-build-tile.sh    # commit nginx config, build + activate, reload
# then: https://solana.solfunmeme.com/aristotle-builds/
```

### Cleaning up previous runs (dedup + prune)

Build workspaces and fetched dependency packages are deduplicated into the
shared store; both commands are **dry-run by default**:

```bash
# Move real .lake/packages/<dep> checkouts into the shared store and symlink
# back (dedup); scans the builds root + results dir by default:
aristotle-manager cache dedup                     # show what would change
aristotle-manager cache dedup --execute           # commit
aristotle-manager cache dedup --root /mnt/data1/aristotle-results --execute

# Remove stale build workspaces (8-hex/UUID dirs under the builds root whose
# mtime AND creation time are both older than the cutoff):
aristotle-manager cache prune                     # list candidates + sizes
aristotle-manager cache prune --older-than-days 2 --execute

# Remove shared store entries nothing links to anymore:
aristotle-manager cache gc
```

Notes from the first real cleanup run (2026-09-25):

- 393 stale build workspaces (68-day-old `.build-done` markers) were pruned —
  workspace dirs are empty shells after their reports are published, so they
  reclaim almost nothing; the dedup is what saves disk.
- The two old workspaces each carried ~400 MB of real (non-symlinked)
  batteries/aesop/proofwidgets/Qq/importGraph copies. After dedup those live
  once under `lean-shared/lake-packages/` and every workspace symlinks them.
- 2,270 downloaded projects now link mathlib (+ managed deps) from the store;
  25 were skipped: 2 pin a different mathlib rev, the rest a different
  toolchain — no shared checkout exists for them and bulk dedup never clones.
  Use `aristo cache link <project>` (which clones, guarded by a 20G free-space
  check) if one of those needs building.
- `lake exe cache get!` writes mathlib oleans into the **shared** checkout (it
  is symlinked into the workspace), so the download+unpack cost is paid once
  per (toolchain, rev), not per project.

### Debugging a build

```bash
aristotle-manager cache status <project>    # shared-store linkage
~/.cache/aristotle-manager/bin/gokujo debug <project>   # full state dump
aristotle-manager sign verify <web-root>/<id>/build-report.json
```

## Task lifecycle

```
QUEUED → IN_PROGRESS (percent_complete 0..100) → COMPLETE
```

- `check` shows `agent_task_id`, `status`, `percent_complete`,
  `has_output_files`, `output_summary`.
- A project must be IDLE to accept a new submission — `check` first,
  or use the `--wait` flag on submit.
- Results: `download-result <task-id>` pulls `output-final.tar.gz`.

## Environment

- API base: `https://aristotle.harmonic.fun/api/v3`
- Keys: `~/.config/aristotle-manager/keys/<account>.key`
- Config: shared `config.toml` (see `configure show`)
- SPARQL store (separate service): `http://127.0.0.1:8088/api/sparql`,
  JSON body `{"query": "..."}`, header `X-API-Key`.
