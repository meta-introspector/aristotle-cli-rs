---
name: mcp-bridge
description: >-
  Connect to MCP (Model Context Protocol) servers and create reusable
  skills from them. HTTP and stdio transports. Use when connecting to
  external tools via MCP, or when MCP servers are mentioned.
---

# MCP Bridge — Connect to MCP Servers

Connect to any MCP server (HTTP or stdio), explore its tools, and create
a dedicated skill for repeated use. MCP servers expose tools via
JSON-RPC.

---

## When to Use

- "Connect to the filesystem MCP server"
- "Use the GitHub MCP server"
- "Create a skill for this MCP tool"
- User mentions MCP or model context protocol

## What is MCP?

MCP (Model Context Protocol) is a standard for exposing tools to AI
agents. Servers provide tools via JSON-RPC over:

- **HTTP** — server running at a URL (e.g., `http://localhost:3001/mcp`)
- **stdio** — server runs as a subprocess via stdin/stdout

## Quick Start

### Step 1: Determine the transport type

Ask the user:
- Is it an HTTP server (has a URL)?
- Is it a stdio server (runs via `npx`, `node`, `python`)?

### Step 2: Test the connection

**For HTTP servers:**

```bash
# List tools
curl -s -X POST <url> \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":1}'

# With auth
curl -s -X POST <url> \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":1}'
```

**For stdio servers:**

```bash
# Start the server and list tools
echo '{"jsonrpc":"2.0","method":"tools/list","id":1}' | \
  npx -y @modelcontextprotocol/server-filesystem .
```

### Step 3: Explore available tools

```bash
# List all tools
# (use the tools/list method as above)

# Call a specific tool
curl -s -X POST <url> \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"<tool>","arguments":{"arg":"value"}},"id":2}'
```

## Creating a Dedicated Skill

When an MCP server will be used repeatedly, create a dedicated skill:

1. Create `agent/skills/<name>/SKILL.md`
2. Document the server's transport, URL/command, and available tools
3. Include example tool calls with expected inputs/outputs
4. Add auth requirements (env vars, headers)
5. Add to lattice.md index
6. Sync to `.dotagents/skills/<name>/`

### Simple skill (just SKILL.md)

For straightforward servers — document how to use the MCP server
directly.

### Rich skill (SKILL.md + scripts/)

For frequently-used servers — include convenience wrapper scripts
with defaults baked in.

## Common MCP Servers

| Server | Transport | Command/URL |
|--------|-----------|-------------|
| Filesystem | stdio | `npx -y @modelcontextprotocol/server-filesystem <path>` |
| GitHub | stdio | `npx -y @modelcontextprotocol/server-github` |
| Brave Search | stdio | `npx -y @modelcontextprotocol/server-brave-search` |
| Obsidian | HTTP | `http://localhost:3001/mcp` |

## Nix Integration

MCP servers that need Node.js should be available via nixpkgs or
vendored per `agent/foundation.md`:

```nix
# In devShell or runtimeTools
runtimeTools = with pkgs; [
  nodejs
  # MCP servers run via npx — nodejs must be in PATH
];
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Cannot connect (HTTP) | Check URL is correct and server is running |
| Cannot connect (stdio) | Check the command works when run directly in terminal |
| Authentication required | Add `--header "Authorization: Bearer KEY"` or `--env "API_KEY=xxx"` |
| Tool call fails | Use `tools/list` to see the expected input schema |
| npx not found | Ensure `nodejs` is in PATH via nix devShell |

## Guardrails

- Always inspect MCP server tools before calling them
- Never pass credentials in plaintext — use `auth-registry` (sops)
- MCP servers may have side effects — understand what tools do before calling
- HTTP servers may be remote — verify the URL is trusted
- stdio servers run locally — check the command for safety

## Related

- `auth-registry` — for storing API keys used by MCP servers
- `skill-author` — for creating the dedicated skill
- `nix-build` — for vendoring MCP server dependencies
