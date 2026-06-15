---
name: commands
description: >-
  Create and edit slash commands for the agent. Use when the user
  asks to add a custom /command, command shortcut, or scoped
  conversation-backed command.
---

# Commands — Slash Command Authoring

Create and edit agent slash commands. Commands are user-invoked via
`/command-name` and can trigger prompts, run logic, or fork
conversations.

---

## When to Use

- "Add a /command for X"
- "Create a shortcut for this workflow"
- "Make a command that works while the agent is busy"

## Command Types

| Type | When to Use | Example |
|------|-------------|---------|
| Simple prompt | Inject a system prompt | `/tigerbeetle` loads coding standard |
| Command with logic | Run UI logic on invocation | `/comment` opens editor |
| Skill-backed | Delegates to a skill | `/skill:vox` runs the vox pipeline |
| Busy-safe | Works while agent is busy | Side-question command with fork |

## Creating a Command

Commands are defined in extensions. See `extensions` skill for the
full extension API.

### Simple prompt command

```ts
export default function activate(letta) {
  const disposers = [];

  if (letta.capabilities.commands) {
    disposers.push(letta.commands.register({
      name: "my-command",
      description: "What this command does",
      handler: (ctx) => {
        return {
          type: "prompt",
          prompt: "Instructions to inject when this command is used"
        };
      }
    }));
  }

  return () => disposers.forEach(d => d());
}
```

### Command with conversation fork

```ts
disposers.push(letta.commands.register({
  name: "side-question",
  description: "Ask a question while the agent is busy",
  runWhenBusy: true,
  handler: (ctx) => {
    const forked = ctx.conversation.fork();
    forked.sendMessageStream([{
      role: "user",
      content: ctx.args
    }]);
    return { type: "handled" };
  }
}));
```

## Command Registration

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Command name (appears as `/name`) |
| `description` | Yes | What the command does |
| `handler` | Yes | Function returning command result |
| `runWhenBusy` | No | Allow while agent is processing (default: false) |

## Command Result Types

| Type | When | Description |
|------|------|-------------|
| `prompt` | Default | Injects a prompt into the conversation |
| `handled` | Busy commands | Agent handles it independently |

## n0x-pi Commands

The existing commands in `.dotagents/commands/`:

| Command | Purpose |
|---------|---------|
| `/brainstorm` | Guided brainstorming, one question per turn |
| `/brilliance` | Push changes until reviewer has nothing to flag |
| `/grill-me` | Depth-first interrogation, no hand-waves |
| `/grill-with-docs` | Grill-me + ubiquitous language + ADRs |
| `/tigerbeetle` | The coding standard, loaded explicitly |

## Guardrails

- Command names must be valid identifiers (lowercase, hyphens)
- Don't override built-in commands unless intentional
- Keep command descriptions short and actionable
- Busy commands must return `handled`, not `prompt`
- Test commands after creation — broken commands can block the agent

## Related

- `extensions` — full extension API including tools, events, panels
- `statusline` — statusline-specific extensions
- `skill-author` — for creating skills that commands can invoke
