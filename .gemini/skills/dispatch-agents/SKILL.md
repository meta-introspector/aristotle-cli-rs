---
name: "dispatch-agents"
description: "Dispatch stateless coding agents (Claude Code, Codex, Gemini CLI) via Bash as sub-agents. Use when stuck, need a second opinion, or parallel research. They have no memory — provide all context. Background by default."
---

# Dispatch Agents — Stateless Sub-Agent Orchestration

Shell out to Claude Code (`claude`), Codex (`codex`), and Gemini CLI
(`gemini`) as stateless sub-agents. They have filesystem and tool access
but **zero memory** — every session starts from scratch.

**Default to `run_in_background: true`** so you can keep working while
they run. Check results later with `TaskOutput`.

---

## When to Use

- **Hard debugging** — looping on a problem, need fresh eyes
- **Second opinions** — validation before a risky change
- **Parallel research** — investigate multiple hypotheses simultaneously
- **Large-scope investigation** — tracing a flow across many files
- **Code review** — have another agent review your diff or plan

## When NOT to Dispatch

- Simple file reads, greps, or small edits — faster to do yourself
- Anything that takes less than ~3 minutes of direct work
- Tasks where you already know exactly what to do
- When context transfer would take longer than just doing the task

## The Mental Model

Sub-agents are brilliant interns that showed up today. **Give them
context, not a plan.** They won't know anything you don't tell them:

- **Specific task**: "Trace the request flow from the messages endpoint
  through to the LLM call, cite files and line numbers" — not "look
  into the auth system"
- **File paths and architecture**: Tell them exactly where to look
- **Preferences and constraints**: Code style, error handling patterns
- **What you've already tried**: Prevents rediscovering dead ends

## Choosing an Agent

| Agent | Model | Best For | Weakness |
|-------|-------|----------|----------|
| Codex | `gpt-5.3-codex` | Hardest debugging, complex tasks | Slow, compactions can destroy trajectories |
| Codex | `gpt-5.4` | Fast general-purpose | More silly errors than 5.3 |
| Claude Code | `opus` | Docs, refactors, open-ended tasks | Tends to over-generate ("slop") |
| Claude Code | `sonnet` | Fast coding, precise edits | Less reasoning depth than opus |
| Gemini CLI | `gemini-2.5-pro` | Free tier, multi-modal | Rate limited |

## Prompt Template

```
TASK: [one-sentence summary]

CONTEXT:
- Repo: [path]
- Key files: [list specific files and what they contain]
- Architecture: [brief relevant context]

WHAT TO DO:
[what you need done — be precise, but let them figure out the approach]

CONSTRAINTS:
- [any preferences, patterns to follow, things to avoid]
- [what you've already tried, if dispatching because stuck]

OUTPUT:
[what you want back — a diff, a list of files, a root cause analysis, etc.]
```

## Dispatch Patterns

### Parallel research

Run Claude Code and Codex simultaneously on the same question via
separate Bash calls in a single message (`run_in_background: true`).
Compare results for higher confidence.

### Background dispatch

```bash
# Claude Code — background, non-interactive
claude -p "YOUR PROMPT" --model opus --dangerously-skip-permissions &

# Codex — background, non-interactive
codex exec "YOUR PROMPT" -m gpt-5.3-codex --full-auto -C /path/to/repo &
```

### Code review

```bash
# Codex native review
codex review --uncommitted
codex exec review "Focus on error handling and edge cases" -m gpt-5.4 --full-auto

# Claude Code — pass the diff inline
claude -p "Review the following diff for correctness, edge cases, and missed error handling:\n\n$(git diff)" \
  --model opus --dangerously-skip-permissions
```

### Get outside feedback

Write your plan to a file, then ask a sub-agent to critique it:

```bash
claude -p "Read /tmp/my-plan.md and critique it. What am I missing? What could go wrong?" \
  --model opus --dangerously-skip-permissions
```

## CLI Reference

### Claude Code

```bash
claude -p "YOUR PROMPT" --model MODEL --dangerously-skip-permissions
```

| Flag | Purpose |
|------|---------|
| `-p` / `--print` | Non-interactive mode |
| `--dangerously-skip-permissions` | Skip approval prompts |
| `--model MODEL` | `sonnet`, `opus`, or full name |
| `--effort LEVEL` | `low`, `medium`, `high` |
| `--append-system-prompt "..."` | Inject additional instructions |
| `--allowedTools "Bash Edit Read"` | Restrict available tools |
| `--max-budget-usd N` | Cap spend |
| `--add-dir DIR` | Grant access to additional directories |
| `--output-format json` | Structured output with session_id, cost |

### Codex

```bash
codex exec "YOUR PROMPT" -m gpt-5.3-codex --full-auto
```

| Flag | Purpose |
|------|---------|
| `exec` | Non-interactive mode |
| `-m MODEL` | `gpt-5.3-codex`, `gpt-5.4`, `gpt-5.3-codex-spark` |
| `--full-auto` | Auto-approve all commands in sandbox |
| `-C DIR` | Set working directory |
| `--search` | Enable web search tool |
| `review` | Native code review |

### Gemini CLI

```bash
gemini -p "YOUR PROMPT"
```

Free tier, rate limited. Good for quick checks when other keys are exhausted.

## Session Management

### Session storage paths

| Agent | Path |
|-------|------|
| Claude Code | `~/.claude/projects/<encoded-path>/<session-id>.jsonl` |
| Codex | `~/.codex/sessions/<year>/<month>/<day>/rollout-*-<session-id>.jsonl` |

### Resuming sessions

```bash
# Claude Code
claude -r SESSION_ID -p "Follow up: now check if..."
claude -c -p "Also check..."                    # Continue most recent

# Codex
codex exec resume SESSION_ID "Follow up prompt"  # Non-interactive
codex resume SESSION_ID "Follow up prompt"       # Interactive
```

## Handling Failures

| Failure | Fix |
|---------|-----|
| Timeout | Shorter prompt, restrict tools with `--allowedTools`, switch agent |
| Garbage output | Prompt was too vague — rewrite with specific file paths |
| Stale approval (Claude) | `--dangerously-skip-permissions` |
| Compaction mid-task (Codex) | Break into smaller sequential sessions |
| Claude Code hangs on large repo | `--allowedTools "Read Grep Glob"` (no Bash) |

## Timeouts

| Task | Timeout |
|------|---------|
| Quick checks / reviews | 120000 (2 min) |
| Research / analysis | 300000 (5 min) |
| Implementation | 600000 (10 min) |

## Guardrails

- Always provide full context — sub-agents have zero memory
- Default to background dispatch — don't sit idle waiting
- Use `--max-budget-usd` on exploratory tasks to cap spend
- Never dispatch for tasks you can do in <3 minutes
- Verify sub-agent output before applying changes
- Test with `ping-agents` first if unsure which CLIs are available

## Related

- `ping-agents` — check which agent CLIs are available
- `auth-registry` — test API keys before dispatching
- `nuclear-review` — for reviewing sub-agent output quality
