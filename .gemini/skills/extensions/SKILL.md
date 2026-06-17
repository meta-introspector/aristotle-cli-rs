---
name: "extensions"
description: "Create and edit agent extensions — tools, slash commands, lifecycle events, panels, status values. Use when adding a tool the agent can call, a slash command, or reacting to app events."
---

# Extensions — Agent Capabilities

Create and edit agent extensions. Extensions add composable capabilities
through extension APIs — not by importing app internals.

---

## When to Use

- "Add a tool the agent can call"
- "Create a slash command"
- "React to a lifecycle event"
- "Add a panel or status value"

## Choose the Right Capability

| User wants | Build |
|------------|-------|
| Agent autonomously calls a local capability | Extension tool |
| User invokes `/foo` for a prompt or UI logic | Extension command |
| Slash command represents a reusable workflow | Skill + thin extension command |
| Command works while agent is busy | Command with `runWhenBusy: true` + `ctx.conversation.fork()` |
| Show transient output above input | Panel (usually from a command) |
| Show small persistent state | Status value |
| React to lifecycle or transform turns | Event |
| Change the bottom statusline | Use `statusline` skill, not this one |

**Default to a tool** when the model should decide when to use it.
**Default to a command** when the human explicitly invokes it.

## The Extension Boundary

Per the TigerBeetle philosophy: maintain a strict, single-threaded
control plane. Extensions exist to modify the harness event loop. All
external I/O and operational logic must be pushed to the execution
plane (Bash scripts).

**The Litmus Test:**
If a workflow can be expressed as a Bash script and invoked via the
native `bash` tool, writing a TypeScript extension for it is an
architectural failure.

See `agent/lattice.md` for the full 3-criteria test for when an
extension is justified.

## Core Extension Shape

```ts
export default function activate(letta) {
  const disposers = [];

  if (letta.capabilities.tools) {
    disposers.push(letta.tools.register(/* ... */));
  }

  if (letta.capabilities.commands) {
    disposers.push(letta.commands.register(/* ... */));
  }

  return () => {
    for (const dispose of disposers.reverse()) dispose();
  };
}
```

## Capability Guards

```ts
letta.capabilities.tools
letta.capabilities.commands
letta.capabilities.events.lifecycle
letta.capabilities.events.tools
letta.capabilities.events.turns
letta.capabilities.ui.panels
letta.capabilities.ui.statusValues
letta.capabilities.ui.customStatuslineRenderer
```

## Scoped API Model

- In commands/events: use `ctx.conversation` for conversation operations
- `ctx.conversation.getHistory()` — recent messages
- `ctx.conversation.fork()` — independent/background model work
- `forked.sendMessageStream([...])` — stream from a fork
- In tools: `ctx.conversation.getHistory()` when context needed
- Use `letta.client` only for server-specific API calls
- Do NOT import `@/backend`, `@/cli`, or other internals

## Rules

- Global trusted code only — no project extensions
- Do not assume extra npm packages are available
- No surprising side effects on startup
- Keep user-facing output short and intentional
- Prefer Node/Bun standard APIs for local work
- For shell execution, prefer `execFile`/`spawn` over shell strings
- For `runWhenBusy: true`, return `handled` — not `prompt`
- Treat `turn_start` as powerful trusted code: keep transforms narrow

## Pre-flight Checklist

- [ ] Extension has one clear owner/file, no mixed features
- [ ] Command/tool IDs valid, no collisions with built-ins
- [ ] Tool descriptions explain when the model should call them
- [ ] JSON schemas are object schemas with useful descriptions
- [ ] Optional UI/event APIs are capability-guarded
- [ ] Timers, intervals, panels cleaned up in disposer
- [ ] Busy commands return `{ type: "handled" }` quickly
- [ ] Conversation work uses `ctx.conversation`, not app internals
- [ ] Local shell/file work scoped to `ctx.cwd`
- [ ] Errors shown to user are short and actionable

## Guardrails

- Only create extensions that pass the lattice.md 3-criteria test
- If a Bash script can do it, don't write an extension
- Always return disposers for cleanup
- Test with `letta --no-extensions` if an extension breaks startup

## Related

- `commands` — for slash command specifics
- `statusline` — for statusline extensions
- `agent/lattice.md` — the extension boundary decision matrix
