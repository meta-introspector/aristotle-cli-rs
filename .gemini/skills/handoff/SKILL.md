---
name: "handoff"
description: "Write a handoff document summarising the current conversation so a fresh agent can continue the work. Saves to the OS temporary directory. Use when wrapping up a session, handing off to another agent/colleague, or when asked to \"write a handoff\" or \"summarise this session.\""
---

# Handoff

Generate a **handoff document** that captures the current conversation context so a fresh agent (or human) can pick up exactly where you left off.

Usage: `/skill:handoff [next-session focus]`

---

## Steps

### 1. Determine output location

Use the OS temporary directory. The file should be named so it's easy to find:

```
${TMPDIR:-/tmp}/handoff-<YYYY-MM-DD>-<HHMM>.md
```

If `$TMPDIR` is unset, use `/tmp`.  The timestamp is **local time**, 24-hour.

### 2. Gather context

**Conversation context** — your conversation history is already in context. Identify:
- What the user asked for (the top-level task)
- What's been done so far
- What's in progress (half-finished files, in-flight edits)
- What decisions were made and why
- What's blocked or needs clarification

**Artifacts** — scan the workspace for existing documents. Do NOT duplicate their content. Reference them instead:

| Artifact type | Where to look |
|---|---|
| PRDs / Specs | `.specify/specs/`, `docs/specs/`, `*.prd.md` |
| Implementation plans | `.specify/specs/*/IMPLEMENTATION_PLAN.md` |
| ADRs | `docs/adr/`, `adr/`, `decisions/` |
| Architecture docs | `docs/architecture/`, `ARCHITECTURE.md` |
| Issues | `gh issue list`, `.github/issues/` |
| PRs / branches | `gh pr list`, `git branch -v` |
| Diffs / uncommitted work | `git diff --stat`, `git status --short` |
| Build artifacts | `dist/`, `build/`, `out/` |
| Diagrams | `~/.pi/diagrams/`, `docs/diagrams/` |
| Graph / knowledge graph | `graphify-out/` |

For each artifact found: note its path, a one-line description, but do NOT dump its contents. If the artifact doesn't exist, note that too — the next agent shouldn't waste time looking for it.

### 3. Redact sensitive information

Before writing, scan the conversation and workspace for sensitive data. **Redact** the following:

- API keys, tokens, secrets (any string matching `/sk-[a-zA-Z0-9]{20,}/`, `/ghp_[a-zA-Z0-9]{36}/`, or similar patterns)
- Passwords and connection strings
- Email addresses (replace with `[email redacted]`)
- Phone numbers
- Internal IP addresses (if the user asks you to)
- Any other PII the user asks you to protect

**How to redact**: replace with `[REDACTED: <type>]` (e.g. `[REDACTED: API key]`). Add a brief entry to the Redactions section so the reader knows what was removed and why.

### 4. Determine next-session focus

If the user passed arguments to `/skill:handoff`, those **are** the next session's focus. Use them verbatim as the Focus section.

If no arguments were given, infer the most likely next step from the conversation:
- What was the user about to do?
- What tasks were discussed but not yet started?
- What checkpoint is next (if using vox)?

If you cannot infer anything, use: `Continue from the state described above.`

### 5. Suggest skills

Look at the available skills (the `<available_skills>` block in your system prompt) and suggest which ones the next agent should invoke to pick up efficiently.

For each suggestion:
- The skill name
- Why it's relevant (1-2 sentences tied to the task)
- How to invoke it (e.g. `/skill:vox build <spec>`, `/skill:graphify .`)

Also suggest **non-skill actions**: test commands, git operations, files to read first.

### 6. Write the document

Write to the temp-file location from step 1. Use this structure:

```markdown
# Handoff — <brief topic>

**Date:** <YYYY-MM-DD HH:MM local>
**Project:** <directory name or project name>
**Next focus:** <one-line description from step 4>

---

## Summary

<3-5 sentences: what we were doing, why, what was accomplished>

---

## Current State

| What | Status |
|------|--------|
| <item> | ✅ Done / 🔄 In Progress / ⬜ Not Started / 🔴 Blocked |

---

## Key Decisions

- **<decision>**: <1-2 lines of rationale>
- ...

---

## Artifacts

| Artifact | Path | Description |
|----------|------|-------------|
| <type> | <path or URL> | <one line> |

If no artifacts exist: "No artifacts found in the workspace."

---

## Suggested Skills

| Skill | Relevance | Invocation |
|-------|-----------|------------|
| <name> | <why> | `<invocation>` |

Also consider:
- **Read first**: <files the next agent should read before doing anything>
- **Tests to run**: `<command>`
- **Git state**: <uncommitted changes, current branch, etc.>

---

## Open Questions / Blockers

- <question or blocker>
- (None if everything is clear)

---

## Redactions

| What | Why |
|------|-----|
| <description> | <reason> |
- (None if nothing was redacted)
```

### 7. Report to the user

After writing, tell the user:
- Full path to the handoff file
- File size
- Number of artifacts referenced
- Number of skills suggested
- Any redactions made

Example:
```
Handoff written to /tmp/handoff-2026-05-22-1430.md (2.1 KB)
  3 artifacts referenced
  2 skills suggested
  1 redaction (API key)
```

---

## Rules

- **Do not duplicate artifact content.** If `.specify/specs/auth/spec.md` exists, write "See `.specify/specs/auth/spec.md`" — don't paste the spec.
- **Do not invent information.** If you don't know something, say "unknown" or "not yet determined."
- **Keep it concise.** The handoff is a map, not a novel. The next agent will read the artifacts directly.
- **One handoff per invocation.** Do not chain multiple handoffs.
- **Always write to the temp directory.** Never save the handoff to the workspace unless the user explicitly asks you to (and warns about committing it).
