---
name: diff-review
description: Generate a visual HTML diff review — before/after architecture comparison with code review analysis, KPI dashboard, Mermaid diagrams, and structured Good/Bad/Ugly/Questions. Self-contained HTML file. Use for reviewing branches, commits, PRs, or working tree changes.
---

# Diff Review

Generate a **visual HTML diff review** — before/after architecture comparison with code review analysis. Single self-contained HTML file.

Usage: `/skill:diff-review <target>` where `<target>` is a branch, commit, PR number, range, or empty for `main`.

## Scope detection

Interpret the target argument:
- Branch name (`main`, `develop`): working tree vs that branch
- Commit hash: `git show <hash>`
- `HEAD`: uncommitted only (`git diff` + `git diff --staged`)
- PR number (`#42`): `gh pr diff 42`
- Range (`abc123..def456`): diff between two commits
- Empty: default to `main`

## Data gathering (do this first)

- `git diff --stat <ref>` — file-level overview
- `git diff --name-status <ref> --` — new/modified/deleted (separate src vs tests)
- Line counts: compare key files between `<ref>` and working tree
- New public surface: grep added lines for exported symbols (adapt to language: `export`/`function`/`class` for TS, `pub fn`/`pub struct` for Rust, `def`/`class` for Python)
- Feature inventory: grep for new keybindings, config fields, event types, message types
- Read all changed files in full
- Check `CHANGELOG.md` for an entry, `README.md` / `docs/*.md` for needed updates
- Reconstruct decision rationale: mine this conversation for approaches discussed and rejected; check progress docs / plan files; for committed changes, read commit messages

## Verification checkpoint (mandatory before HTML)

Produce a structured fact sheet of every claim you will present:
- Every quantitative figure (line counts, file counts, function counts, test counts)
- Every function/type/module name you reference
- Every behavior description (before vs after)
- Cite source for each: git command output or `file:line`

Verify against the code. Anything unverifiable → mark as uncertain, not fact. **The fact sheet is your source of truth during HTML generation.** Do not deviate.

## Page structure

1. **Executive summary** — lead with the *intuition*: why these changes exist, what problem, what insight. Then factual scope. Hero depth (large type, accent-tinted bg, generous padding).
2. **KPI dashboard** — lines added/removed, files, modules, tests. Include housekeeping: CHANGELOG updated? (green/red badge) docs need updates? (green/yellow/red).
3. **Module architecture** — Mermaid dependency graph of current state. Wrap in `.mermaid-wrap` with zoom controls (+/−/reset, Ctrl+scroll, click-drag pan).
4. **Major feature comparisons** — side-by-side before/after panels. `min-width: 0` on grid/flex children, `overflow-wrap: break-word` on panels.
5. **Flow diagrams** — Mermaid flowchart/sequence/state for new lifecycle/pipeline patterns. Same zoom controls.
6. **File map** — full tree, color-coded new/modified/deleted. `<details>` collapsed by default if many sections.
7. **Test coverage** — before/after test file counts, what's covered.
8. **Code review — Good / Bad / Ugly / Questions**
   - **Good**: solid choices, improvements, clean patterns
   - **Bad**: bugs, regressions, missing error handling
   - **Ugly**: tech debt, maintainability concerns, things that work now but bite later
   - **Questions**: needs author clarification
   - Cards with green/red/amber/blue left-border accents. Reference `file:line`. If empty, say "None found" — don't omit the section.
9. **Decision log** — for each significant design choice:
   - **Decision**: one-line summary
   - **Rationale**: why — constraints, trade-offs
   - **Alternatives considered**: rejected options
   - **Confidence**: high (sourced from conversation/docs, green border) / medium (inferred from code, blue border, labeled "inferred") / low (not recoverable, amber border + warning "document before committing")
10. **Re-entry context** — note from present-you to future-you. Compact, collapsible.
    - **Key invariants**: assumptions not enforced by types/tests
    - **Non-obvious coupling**: connections invisible from imports
    - **Gotchas**: edge cases, ordering dependencies, implicit contracts
    - **Don't forget**: follow-up work needed

Visual hierarchy: sections 1-3 dominate the viewport (hero depth). Sections 6+ are reference material — lighter, compact, collapsible.

Diff color language throughout: red removed/before, green added/after, yellow modified, blue neutral.

Responsive section navigation. Write to `~/.pi/diagrams/` (create if absent) and open in browser.
