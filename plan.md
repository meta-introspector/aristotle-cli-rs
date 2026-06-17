# Migration Plan - Shell Scripts to Rust

## Current Status

### Completed
1. ✅ Shell scripts analyzed.
2. ✅ Rust CLI structure created with all 9 commands.
3. ✅ Makefile updated to use Rust commands.
4. ✅ Legacy shell scripts removed.
5. ✅ Cargo.toml has all required dependencies.
6. ✅ All commands compile and run.
7. ✅ Project discovery fixed: `build` command now finds projects.
8. ✅ `download` command successfully downloads projects from Aristotle.
9. ✅ `split-all` command successfully splits projects into per-declaration flakes.
10. ✅ `dedup-split.py` successfully deduplicates split results.
11. ✅ `build-dasl-module.py` successfully builds the canonical DASL module.
12. ✅ `build` command now accepts an `--input-dir` argument to build specific sets of projects.
13. ✅ Skills conflicts with `dotagents` have been resolved.
14. ✅ Documentation has been created in `dasl-planning-summary.md`.

### Working Commands
- `cargo run --release -- configure show` - Shows configuration ✅
- `cargo run --release -- configure set` - Sets API key ✅
- `cargo run --release -- results` - Shows results ✅  
- `cargo run --release -- clean` - Cleans result file ✅
- `cargo run --release -- download` - Downloads from Aristotle ✅
- `cargo run --release -- split-all` - Splits all Lean modules ✅
- `cargo run --release -- build --input-dir <dir>` - Builds projects in `<dir>` ✅

## Issues Identified

1.  **Build Timeouts:** The `build` command times out when building a large number of projects. This is expected due to the long build times of Lean projects.
2.  **Build Failures:** Some projects fail to build due to `git` errors when `lake` tries to clone `mathlib`. This could be a network issue or a git configuration problem in the environment.
3.  **Incomplete Downloads:** The `download` command sometimes fails with 404 or 429 errors, indicating server-side issues.

## Next Steps

1.  **Investigate build failures:** Debug the `git` errors to understand why `lake` is failing to clone `mathlib`.
2.  **Improve build command:** Add more granular control to the `build` command to build specific projects or categories of projects.
3.  **Improve error handling:** Add more robust error handling to the `download` and `build` commands to handle server-side issues and build failures gracefully.
4.  **Add monitoring and metrics:** For production use, add monitoring to track the success and failure rates of downloads and builds.
5.  **Create proper documentation:** Update the `README.md` with the new workflows for splitting and building the canonical DASL module.

## Tmux Session Overview

The following is a summary of the user's tmux sessions, captured at 2026-06-16 12:41:13.

- **Session 0, Window 0, Pane %0:**
    - **Path:** `/mnt/data1/kant/pastebin`
    - **Git Status:** `## main-clean...github/main-clean`, modified `crate-vendor-work`, `erdfa-clean`, `flake.nix`.
    - **Content:** Editing `flake.nix`.

- **Session 0, Window 1, Pane %16:**
    - **Path:** `/mnt/data1/time-2026/05-may/07/arist`
    - **Git Status:** `## main...upstream/main [ahead 12]`, modified `src/main.rs`.
    - **Content:** Gemini agent is running.

- **Session 0, Window 2, Pane %8:**
    - **Path:** `/mnt/data1/time-2026/05-may/07/arist`
    - **Git Status:** `## main...upstream/main [ahead 12]`, modified `src/main.rs`.
    - **Content:** Diff of `src/main.rs` is being viewed.

- **Session 0, Window 3, Pane %28:**
    - **Path:** `/mnt/data1/time-2026/03-march/17/erdfa-publish`
    - **Git Status:** `## kant-pastebin-nora-erdfa-publish...nix-linked/kant-pastebin-nora-erdfa-publish`
    - **Content:** User is trying to publish a crate, but is having issues with `cargo login` and `nix build`.

- **Session 0, Window 4, Pane %9:**
    - **Path:** `/home/mdupont/dasl-planning`
    - **Git Status:** `## main...origin/main [ahead 18]`
    - **Content:** User is debugging a `serde_ipld_dagcbor` service.

- **Session 0, Window 5, Pane %13:**
    - **Path:** `/mnt/data1/time-2026/05-may/15/forgecode`
    - **Git Status:** `## backup-split-work` with many modified files.
    - **Content:** Gemini agent is running.

- **Session 0, Window 6, Pane %12:**
    - **Path:** `/mnt/data1/time-2026/02-february/22/dasl/hecke`
    - **Git Status:** `## main` with many modified files.
    - **Content:** User is trying to build a Lean project with vendored dependencies.

- **Session 0, Window 7, Pane %19:**
    - **Path:** `/mnt/data1/time-2026/05-may/07/arist`
    - **Git Status:** `## main...upstream/main [ahead 12]`, modified `src/main.rs`.
    - **Content:** User is editing `locate2proof.lean`.

- **Session 0, Window 8, Pane %1:**
    - **Path:** `/mnt/data1/kant/pastebin`
    - **Git Status:** `## main-clean...github/main-clean` with modified files.
    - **Content:** User is working on the `kant-pastebin` project.

- **Session 0, Window 9, Pane %24:**
    - **Path:** `/mnt/data1/time-2026/05-may/31/n0x-pi/.dotagents/tasks/fix-nix-vendor-source`
    - **Content:** User is working on fixing nix vendor sources.

- **Session 0, Window 10, Pane %6:**
    - **Path:** `/home/mdupont/dasl-planning`
    - **Git Status:** `## main...origin/main [ahead 18]`
    - **Content:** User is editing `/home/mdupont/projects/nora/deploy.sh`.
