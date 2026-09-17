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
