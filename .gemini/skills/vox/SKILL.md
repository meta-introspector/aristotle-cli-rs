---
name: vox
description: >-
  Spec-driven development — gap analysis, task decomposition (plan),
  then TDD checkpoint execution (build). Two-step pipeline from spec
  to implemented code. Use when you have a spec and want structure:
  "/skill:vox plan <spec>" followed by repeated "/skill:vox build <spec>".
---

# Vox — Spec-Driven Development

Two modes: **plan** (gap analysis → task decomposition) and **build** (TDD checkpoint execution). They are always used in sequence on the same spec.

The first argument after the command selects the mode: `/skill:vox plan <spec>` or `/skill:vox build <spec>`.

---

## Plan Mode

Triggered by `/skill:vox plan <spec-name>`. No code is written.

### Steps

**0. Load the coding standard**
Before any code is planned or written, read and ingest the TigerBeetle
philosophy:

    cat ~/.pi/agent/prompts/tigerbeetle.md

All design decisions, task decomposition, and implementation must
conform to the standards in that file. When a trade-off arises,
prioritize safety over performance, simplicity over cleverness,
and determinism over convenience.

**1. Locate the spec**
- Look in `.specify/specs/<spec-name>/spec.md` first.
- Fall back to fuzzy match: `.specify/specs/*<spec-name>*/spec.md`.
- If multiple candidates, list them and ask which.
- If none exist, list available specs (`ls .specify/specs/`) and offer to create a new one from a template.

**2. Read context**
- The spec itself (every section).
- `.specify/memory/constitution.md` — project verification commands, tech stack, key files.
- Project `CLAUDE.md` / `AGENTS.md` for routing rules.
- Any rule files referenced for the affected components.

**3. Gap analysis**
For each functional requirement and acceptance criterion in the spec:
- Does the code already do this? (read the relevant files — don't guess)
- Partially? What's missing?
- Not at all? What's the touch surface?

Produce a table: requirement → current state → gap.

**4. Task decomposition**
Break the gaps into **vertical checkpoints** (NOT horizontal layers):
- Wrong: "all migrations" → "all endpoints" → "all UI"
- Right: CP-1 = one feature slice end-to-end, CP-2 = next slice end-to-end

Each checkpoint must be:
- Independently testable
- Independently committable
- Sized to ~1-3 hours of focused work
- Stated as a contract: "Given X, when Y, then Z, verified by `<command>`"

**5. Write the plan**
Write to `.specify/specs/<spec-name>/IMPLEMENTATION_PLAN.md` (create if absent). Structure:

```
# <spec-name> — Implementation Plan

## Current State Summary
<2-3 paragraphs of facts found in steps 2-3>

## Checkpoints
### CP-1: <name>
- **Touches**: <files>
- **Tasks**:
  1. <task with file path>
  2. <task with file path>
- **Verification**: `<command>` produces `<expected>`
- **Commit message**: `<type>: <subject>`

### CP-2: ...
```

**6. Risks & open questions**
- List unknowns that should be resolved before CP-1 starts.
- Flag any assumptions you made that the user should confirm.

**7. End with a one-line summary**
"Plan ready: N checkpoints, ~M hours total. Run `/skill:vox build <spec>` to start CP-1."

Do not write production code. Plan only.

---

## Build Mode

Triggered by `/skill:vox build <spec-name>`. Executes one checkpoint per invocation.

### Rules of engagement

- **One checkpoint per invocation.** Do not chain multiple CPs.
- **TDD: red → green → refactor.** Write the failing test first, watch it fail, then implement.
- **Verify before claiming done.** Run the checkpoint's verification command and quote the actual output.
- **No parallelism.** No subagent dispatch, no worktrees. Linear execution in this session.
- **Stop and surface** if you hit an unknown not covered by the plan — don't improvise scope.

### Steps

**0. Load the coding standard**
Before any code is planned or written, read and ingest the TigerBeetle
philosophy:

    cat ~/.pi/agent/prompts/tigerbeetle.md

All design decisions, task decomposition, and implementation must
conform to the standards in that file. When a trade-off arises,
prioritize safety over performance, simplicity over cleverness,
and determinism over convenience.

**1. Load context**
- `.specify/specs/<spec-name>/spec.md`
- `.specify/specs/<spec-name>/IMPLEMENTATION_PLAN.md`
- `.specify/memory/constitution.md`
- Project `CLAUDE.md` / rules files for affected components.

**2. Pick the next checkpoint**
- Read the plan. Find the first CP not marked complete.
- If all CPs are complete, say so and exit.
- Restate the chosen CP back to the user (name, touches, verification) — confirm before starting.

**3. Red — write the failing test first**
- Quote the failure output. This is the proof the test actually exercises behavior.

**4. Green — minimum code to pass**
- Smallest change that flips the test from red to green. No bonus features. No surrounding cleanup.
- Run the test. Quote the passing output.

**5. Refactor (only if needed)**
- If the green code is awkward, clean it up while tests stay green.
- Skip if the green code is already clean.

**6. Run the checkpoint verification**
- Execute the exact command from the plan's `Verification:` line.
- Quote the actual output. If it doesn't match expected, you are NOT done — go back to step 4.

**7. Run repo-wide gates**
Run the project's standard verification commands (from constitution.md or CLAUDE.md). Quote relevant output.

**8. Mark CP complete**
- Edit `IMPLEMENTATION_PLAN.md`: change `### CP-N: <name>` to `### CP-N: <name> ✅`
- Add a one-line note: `Completed YYYY-MM-DD by /skill:vox build`.

**9. Stop. Do not start the next CP.**
- Summarize what changed (files + lines).
- Suggest commit message from the plan.
- Tell the user: "CP-N done. Run `/skill:vox build <spec>` again for CP-(N+1)."

### Failure handling

- If a verification fails after a reasonable attempt, **stop and report**. Do not silently expand scope.
- If you discover the plan is wrong, stop and ask whether to update `IMPLEMENTATION_PLAN.md` before continuing.
- Never use `--no-verify` to bypass hooks.
