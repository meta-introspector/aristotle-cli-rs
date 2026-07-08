---
name: step-ooda-loop
description: >-
  OODA (Observe-Orient-Decide-Act) loop driver. Checks GOAP + DASL planners
  for pending tasks, decides next action, executes it. The meta-loop
  that coordinates the self-improvement pipeline.
---

# Step: OODA Loop — Observe-Orient-Decide-Act Driver

The meta-controller that decides what to do next by querying planners.

## Command

```bash
aristotle-manager next
```

## What it does

1. **Check GOAP planner** (`~/dasl-planning/.../dasl-planner`) for pending tasks
2. **Check DASL planner** (`~/dasl-planning/dasl-planner status`) for project state
3. If pending tasks exist → execute them
4. If nothing pending → report all projects processed

## The OODA Cycle mapped to pipeline steps

```
Observe ──→ fetch              (check API for new/updated projects)
   │
   ▼
Orient  ──→ split + merge      (extract declarations, understand structure)
   │
   ▼
Decide  ──→ dasl-finish        (update planners, let GOAP decide next action)
            diagonalize         (find minimal core, what needs fixing?)
   │
   ▼
Act     ──→ enrich             (build indexes, exports)
            repair              (apply SPARQL/GOAP fixes)
   │
   └──────→ back to Observe (next fetch cycle)
```

## Planner Locations

| Planner | Path | Role |
|---------|------|------|
| DASL | `~/dasl-planning/dasl-planner` | Project metadata, processing state |
| GOAP | `~/dasl-planning/plan-mappings/goap/.../dasl-planner` | Goal-oriented action planning |

## Key Code

In `src/main.rs` around line 5281 (`cmd_next`):
```rust
// 1. Check GOAP planner for pending tasks
let goap = Command::new("/home/mdupont/...dasl-planner").output();
// 2. Check DASL planner for project state
let plan = Command::new("~/dasl-planning/dasl-planner").args(["status"]);
// 3. Execute or report
```

## Related Skills

- [[self-improve-pipeline]] — Full cycle overview
- [[step-dasl-finish]] — Updates planners
- [[step-diagonalize]] — Self-application decision
