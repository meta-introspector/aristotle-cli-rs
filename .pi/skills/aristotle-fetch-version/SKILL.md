---
name: aristotle-fetch-version
description: >-
  Aristotle Manager fetch (incremental download with last_updated tracking)
  and version (git commit pipeline) commands. Use when debugging fetch not
  updating existing projects, or git commit errors in the versioning step.
---

# Aristotle Fetch & Version — Incremental Updates + Git Versioning

**Relevant files:** `src/fetch.rs`, `src/version.rs`

## Fetch (`src/fetch.rs`)

The `fetch` command polls the Aristotle API and downloads new/updated projects.

### How incremental update detection works

1. **Step 1 — Discover local state:** Reads `results_dir` for all `*_aristotle` dirs.
   For each, reads `aristotle_status.json` to extract the `last_updated` timestamp
   into a `HashMap<String, String>` (`local_updates`).

2. **Step 2 — Poll API:** For each project from the API:
   - **New** (`!existing.contains(id)` + `has_files`): added to download queue
   - **Existing**: compares API's `last_updated` with `local_updates.get(id)`:
     - Both valid → download if `api_updated > local_updated`
     - Either missing → download to be safe (handles legacy projects)

3. **Step 3 — Download:** Saves tar.gz, extracts, writes metadata + status
   (now includes `last_updated` and real `has_input` value).

4. **Step 4 — Version:** Calls `cmd_version` to git-commit new results.

### Key fields

| Field | Source | Stored in |
|-------|--------|-----------|
| `last_updated` | API project JSON | `aristotle_status.json` |
| `created_at` | API project JSON | `aristotle_status.json` |
| `has_input` | API project JSON | `aristotle_status.json` |
| `extracted_at` | download time | `aristotle_metadata.json` |

## Version (`src/version.rs`)

The `version` command copies each Aristotle project into a shared git repo
and creates one commit per project.

### How commit logic works

1. Read `aristotle_metadata.json` for `extracted_at` (commit date)
2. Read `aristotle_status.json` for `description` (commit message)
3. Copy files via `walkdir::WalkDir` with:
   - `max_depth(3)` — only 3 levels deep
   - `filter_entry` — excludes `.git` dirs and nested `*_aristotle` dirs
4. `git add <project_name>`
5. Check `git diff --cached --exit-code` — if no changes, skip gracefully
6. `git commit -m <msg> --date <extracted_at>` with `user.name=aristotle-manager`

### Common failure modes

| Error | Cause | Resolution |
|-------|-------|------------|
| "nothing to commit" | Project already committed with identical content | Handled: `diff --cached --exit-code` check skips before commit |
| Embedded git repo | Project contained `.git/` subdirectory | Handled: `filter_entry` excludes `.git` from walkdir copy |
| Bad `extracted_at` date | Missing or malformed timestamp in metadata | Falls through to git which prints error in stderr |

### Walkdir exclusions

```
filter_entry:
  - ".git"            → avoids embedded-repo warnings
  - "*_aristotle"     → avoids nested tar-extraction artifacts
```
