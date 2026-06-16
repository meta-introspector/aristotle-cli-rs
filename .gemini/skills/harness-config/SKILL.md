---
name: "harness-config"
description: "Modify the agent harness: permissions, lifecycle hooks, tool availability, model/context settings, schedules, and deterministic runtime configuration. Use when changing how the agent runs, not what it knows."
---

# Harness Config — Runtime Configuration

Modify deterministic harness behavior: permissions, hooks, tool
availability, model, context window, name, description, and schedules.

Use this for changes that should be **enforced by the runtime** around
the agent — not for changes to what the agent knows or how it reasons
(those go in memory blocks).

---

## When to Use

- "Change the model to opus"
- "Add a permission rule for Bash"
- "Set up a pre-tool hook"
- "Disable the web search tool"
- "Increase the context window"
- "Change the agent name or description"

## Memory vs. Harness

| Change Type | Where |
|-------------|-------|
| What the agent knows (preferences, projects, conventions) | Memory blocks |
| How the agent reasons (identity, style, principles) | Memory blocks |
| What the agent is allowed to do (permissions, tool access) | Harness config |
| What happens before/after tool calls (hooks) | Harness config |
| Model, context window, name, description | Harness config |
| Schedules (crons) | Harness config |

## Configuration File

The harness config lives at `~/.letta/agents/<agent-id>/config.json`:

```json
{
  "model": "anthropic/claude-sonnet-4-20250514",
  "context_window": 140000,
  "name": "my-agent",
  "description": "A coding agent",
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit"],
    "deny": ["WebSearch"]
  },
  "hooks": {
    "pre_tool_call": [],
    "post_tool_call": []
  }
}
```

## Permissions

### Allow/Deny Rules

```json
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"],
    "deny": ["WebSearch"],
    "ask": ["Bash:sudo", "Bash:rm -rf"]
  }
}
```

- **allow**: Tools the agent can use without asking
- **deny**: Tools the agent cannot use at all
- **ask**: Tool patterns that require user approval

### Common Permission Patterns

```json
// Read-only agent
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep"],
    "deny": ["Bash", "Write", "Edit"]
  }
}

// Safe coding agent (no destructive bash)
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"],
    "ask": ["Bash:rm", "Bash:sudo", "Bash:git push", "Bash:git push --force"]
  }
}
```

## Lifecycle Hooks

Hooks run before or after tool calls, prompts, compaction, and session
events. They provide deterministic checks and side effects.

### Pre-tool hook

```json
{
  "hooks": {
    "pre_tool_call": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Checking bash command safety...' >&2"
          }
        ]
      }
    ]
  }
}
```

### Post-tool hook

```json
{
  "hooks": {
    "post_tool_call": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "nixfmt ${LETTA_FILE_PATH} 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

## Model and Context Settings

```json
{
  "model": "anthropic/claude-sonnet-4-20250514",
  "context_window": 140000
}
```

Available models (depends on API key availability):

| Model | Provider | Notes |
|-------|----------|-------|
| `anthropic/claude-sonnet-4-20250514` | Anthropic | Default, fast |
| `anthropic/claude-opus-4-20250514` | Anthropic | Best reasoning |
| `openai/gpt-5.4` | OpenAI | Fast general-purpose |
| `openai/gpt-5.3-codex` | OpenAI | Best for coding |
| `google/gemini-2.5-pro` | Google | Free tier available |
| `deepseek/deepseek-chat` | DeepSeek | Budget option |

## Tool Availability

```json
{
  "tools": {
    "enabled": ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "WebSearch"],
    "disabled": []
  }
}
```

## Schedules (Crons)

See `cron` skill for full details. Quick reference:

```bash
letta cron add --name "check" --description "desc" --prompt "msg" --every 2h
letta cron list
letta cron delete <task-id>
```

## Guardrails

- Permission changes take effect immediately — test after modifying
- Hooks that fail block the tool call — ensure hooks are robust
- Never set `deny: ["Bash"]` on a coding agent — it can't function
- Model changes may require different API keys — check `auth-registry`
- Context window changes affect compaction behavior — larger = more memory, higher cost
- Always backup config before major changes

## Related

- `cron` — scheduled task management
- `auth-registry` — API key management for model providers
- `ping-agents` — check which agent CLIs are available
