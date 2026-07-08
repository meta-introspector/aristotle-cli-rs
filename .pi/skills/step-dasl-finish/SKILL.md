---
name: step-dasl-finish
description: >-
  Rebuild flakes, update DASL planner + GOAP planner.
  Phase 4 of the self-improvement cycle after merge.
  Bridges the data pipeline into the OODA loop.
---

# Step: dasl-finish — Rebuild Flakes & Update Planners

Part of the self-improvement pipeline after `split` + `merge`.
Triggers the OODA planners to decide what to do next.

## Command

```bash
aristotle-manager dasl-finish
```

## What it does

1. **Download** — Check for any remaining projects
2. **Merge** — Ensure unified declaration pool is current
3. **Rebuild flakes** — Fix paths in generated flake.nix files
4. **Update DASL planner** — `~/dasl-planning/dasl-planner refresh`
5. **Update GOAP planner** — `~/dasl-planning/.../dasl-planner`

## Planner Integration

### DASL planner (`~/dasl-planning/dasl-planner`)
- Scans project metadata
- Tracks what's been processed vs pending
- Called with `refresh` to update state

### GOAP planner (`~/dasl-planning/plan-mappings/goap/.../dasl-planner`)
- Goal-Oriented Action Planning
- Proves atoms about what needs to be done
- Outputs pending tasks for the OODA loop

## Key Code

In `src/main.rs` around line 3074:
```rust
// Step 4: Update planner
Command::new("bash").arg("-c")
    .arg("cd ~/dasl-planning && ./dasl-planner refresh")
// Also update GOAP planner
Command::new("/home/mdupont/dasl-planning/.../dasl-planner")
```

## Related Skills

- [[self-improve-pipeline]] — Full cycle overview
- [[step-diagonalize]] — Next step in cycle
- [[step-split-merge]] — Previous step in cycle
