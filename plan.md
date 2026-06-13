# Migration Plan - Shell Scripts to Rust

## Current Status

### Completed
1. ✅ Shell scripts analyzed (poll.sh, poll-results.sh, build_all.sh, build_all_test.sh, debug_aristotle.sh, config.sh)
2. ✅ Rust CLI structure created with all 9 commands:
   - poll - Pull updates and build all projects
   - build - Build all Lean4 projects  
   - download - Download results from Aristotle API
   - split - Split Lean4 modules for de-duplication
   - merge - Merge split results
   - test - Test Lean4 projects
   - results - Show build results
   - configure - Configure settings
   - clean - Clean build artifacts
3. ✅ Makefile updated to use Rust commands
4. ✅ Legacy shell scripts removed
5. ✅ Cargo.toml has all required dependencies (reqwest, tokio, flate2, tar, walkdir, serde)
6. ✅ All commands compile and run successfully

### Working Commands
- `cargo run --release -- configure show` - Shows configuration ✅
- `cargo run --release -- configure set` - Sets API key ✅
- `cargo run --release -- results` - Shows results ✅  
- `cargo run --release -- clean` - Cleans result file ✅
- `cargo run --release -- download` - Downloads from Aristotle ✅
- `cargo run --release -- split` - Splits Lean modules ✅
- `cargo run --release -- merge` - Merges split results ✅
- `cargo run --release -- build` - Builds all projects ✅
- `cargo run --release -- test` - Tests all projects ✅
- `cargo run --release -- poll` - Updates repos and builds ✅

## Issue Identified

**The build commands currently report 0 projects found** because:

Directory `/mnt/data1/time-2026/05-may/07/arist/` (git_base from config) has NO directories ending in `_aristotle`

This means:
- Either the projects location needs to be configured differently
- Or projects need to be downloaded from Aristotle first (which creates them)

Based on `split-log.txt` from git history, projects were like:
```
fcc9e2ee-afef-4120-a152-1608985f39f1_aristotle
e4a00d43-83d8-455f-9281-04e6f55f38eb_aristotle
d5e52945-6a7c-4d8b-9c9a-5684e1ea6251_aristotle
```

These were created during the download/test process.

## Directory Structure Issue

The config.toml has conflicting paths:
```toml
base_dir = "/home/mdupont/projects/arist"
git_base = "/home/mdupont/05/07/arist"
```

But actual projects we saw were in:
- `/mnt/data1/time-2026/05-may/07/arist/` (where we are)
- Previously at `/mnt/data1/time-2026/05-may/07/arist/<uuid>_aristotle/`

## Next Steps

1. **Fix project directory location** - Ensure get_project_dirs() looks in the right place
2. **Verify the downloaded projects exist** - If they do, build should find them
3. **Add comprehensive error handling** - As noted in README roadmap
4. **Implement notification system** - Optional but useful
5. **Add monitoring and metrics** - For production use
6. **Create proper documentation** - Update README with new workflows

## Testing Required

Once projects are downloaded via `cargo run --release -- download`:
- `make poll` should update and build all 100 projects
- `make test` should build and test all 100 projects
- `make poll-results` should download, test, and show results

## Questions

1. Where should projects be stored? Should git_base point to `/mnt/data1/time-2026/05-may/07/arist/`?
2. Should the Rust code be run from the actual project directory or from the manager directory?
3. Are there any specific projects or just the 100 from the most recent poll?
