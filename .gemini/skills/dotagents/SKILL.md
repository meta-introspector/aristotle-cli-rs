---
name: "dotagents"
description: "Deploy and sync agent configuration (prompts, skills, instructions, MCP servers) across 22+ AI coding agents from a single .dotagents/ source of truth. Use when setting up or updating agent configs, adding prompts/skills/commands, deploying to pi/claude/cursor/gemini/codex, or managing team agent configuration."
---

# dotagents — Agent Configuration Manager

Deploy prompts, skills, instructions, and MCP server configs to multiple AI coding
agents from a single `.dotagents/` directory. Write once, render everywhere via
Handlebars templates.

**Binary:** `dotagents` (Rust, v0.1.2)
**Location:** `/mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/packages/agents/dotagents/`
**Repository:** https://github.com/soorya-u/dotagents

---

## Architecture

```
.dotagents/                     ← single source of truth (committed)
├── config.toml                 ← features + providers to deploy to
├── local.config.toml           ← personal overrides (gitignored)
├── .env                        ← secrets: {{ env.* }}
├── INSTRUCTIONS.md             ← agent system instructions
├── mcp.jsonc                   ← MCP server definitions
├── commands/                   ← slash commands
│   └── review.md
└── skills/                     ← agent skills
    └── my-skill/SKILL.md

        │  dotagents deploy
        ▼

.claude/commands/review.md      ← rendered per provider
.pi/skills/my-skill/SKILL.md
.pi/prompts/review.md
.cursor/rules/review.md
```

---

## Supported Providers (22)

| Provider | Features supported |
|----------|-------------------|
| **pi** | prompts, skills, agent-ignore |
| **claude** | commands, instructions, mcp, skills |
| **codex** | commands, instructions, mcp, skills |
| **cursor** | commands, instructions, mcp, skills, agent-ignore |
| **copilot** | commands, instructions, mcp, skills |
| **gemini** | commands, instructions, mcp, skills, agent-ignore |
| **opencode** | commands, instructions, mcp, skills, agent-ignore |
| **qwen** | commands, mcp, skills, agent-ignore |
| **kilocode** | commands, instructions, mcp, skills, agent-ignore |
| amp | commands, instructions, mcp, skills |
| auggie | commands, instructions, mcp, skills, agent-ignore |
| autohand | instructions, mcp, skills, agent-ignore |
| cline | commands, instructions, skills, agent-ignore |
| deepagents | instructions, mcp, skills |
| factory-droid | commands, instructions, mcp, skills |
| goose | commands, instructions, mcp, skills, agent-ignore |
| junie | commands, instructions, mcp, skills, agent-ignore |
| kimi | instructions, mcp, skills |
| mistral-vibe | instructions, mcp, skills |
| qoder-cli | commands, instructions, mcp, skills |

Full template registry: `public/v1/templates/registry.json`

---

## Commands

### `dotagents init`

Scaffold `.dotagents/` with interactive wizard:

```bash
dotagents init                    # interactive mode
dotagents init --template default # specific template
dotagents init --targets pi,claude  # limit providers
dotagents init --features commands,skills  # limit features
dotagents init --ci               # non-interactive, for CI
```

### `dotagents deploy`

Render and write all provider config files:

```bash
dotagents deploy                  # deploy everything
dotagents deploy --dry-run        # preview without writing
dotagents deploy --offline        # skip remote template fetch
dotagents deploy /path/to/project           # deploy to specific path
dotagents deploy --env-file .env.production    # custom env file
```

### `dotagents skills`

Manage skills in `.dotagents/skills/`:

```bash
dotagents skills add <name> [--model-invoke off|auto]
dotagents skills rm <name>
dotagents skills ls
```

### `dotagents commands`

Manage commands in `.dotagents/commands/`:

```bash
dotagents commands add --title "Review PR" review
dotagents commands rm review
dotagents commands ls
```

### `dotagents config`

Inspect configuration:

```bash
dotagents config                  # show resolved config
dotagents config --local          # show local overrides
```

### `dotagents providers`

List available providers:

```bash
dotagents providers ls            # list from registry
dotagents providers ls --installed  # providers with config
```

### `dotagents undeploy`

Remove deployed files:

```bash
dotagents undeploy                # remove all deployed files
dotagents undeploy --dry-run      # preview removals
```

---

## Pi Integration

dotagents deploys to pi by writing to `.pi/prompts/` and `.pi/skills/`:

| Feature | Template | Target |
|---------|----------|--------|
| Prompt template | `templates/pi/command.hbs` | `.pi/prompts/<name>.md` |
| Skill | `templates/pi/skill.hbs` | `.pi/skills/<name>/SKILL.md` |
| Agent ignore | `templates/pi/agent-ignore.hbs` | `.piignore` |

**Pi prompt template output:**
```markdown
---
description: <from command>
---
<command content>
```

**Pi skill template output:**
```markdown
---
name: <skill.name>
description: <skill.description>
---
<skill content>
```

### Workflow with n0x-pi

1. Create commands/skills in `.dotagents/`
2. Run `dotagents deploy` — renders to `.pi/prompts/` and `.pi/skills/`
3. `nix run .#pi` picks up the deployed config via `PI_CODING_AGENT_DIR`

For task flakes, you can run dotagents inside the task directory to populate
its prompts/ and skills/ from the central `.dotagents/` source.

---

## Configuration Format

### `.dotagents/config.toml`

```toml
features = ["commands", "skills"]
targets  = ["pi", "claude", "cursor"]

[variables]
project_name = "n0x-pi"
project_description = "pi coding agent, re-forged"

[providers.pi.skills]
template = "https://dotagents.soorya-u.dev/v1/templates/pi/skill.hbs"
target   = "{{ dir.workspace }}/.pi/skills/{{ skill.name }}/SKILL.md"

[providers.pi.commands]
template = "https://dotagents.soorya-u.dev/v1/templates/pi/command.hbs"
target   = "{{ dir.workspace }}/.pi/prompts/{{ command.name }}.md"
```

### Template Variables

| Variable | Source | Example |
|----------|--------|---------|
| `{{ var.* }}` | `[variables]` in config.toml | `{{ var.project_name }}` |
| `{{ env.* }}` | `.dotagents/.env` | `{{ env.ANTHROPIC_API_KEY }}` |
| `{{ dir.workspace }}` | Current project root | `/home/user/project` |
| `{{ dir.application }}` | dotagents config dir | `~/.config/dotagents` |
| `{{ command.name }}` | Command filename (no ext) | `review` |
| `{{ command.title }}` | Command title metadata | `Review PR` |
| `{{ command.description }}` | Command description | `Review this PR` |
| `{{ command.content }}` | Full markdown body | content of review.md |
| `{{ skill.name }}` | Skill directory name | `my-skill` |
| `{{ skill.content }}` | SKILL.md body | skill markdown |
| `{{ skill.metadata }}` | Skill frontmatter map | `{ key: value }` |

---

## Team Workflow

`config.toml` is committed — the team's canonical agent setup.

`local.config.toml` (gitignored by default) lets each developer:
- Add personal providers without touching shared config
- Disable features they don't use
- Override paths for their machine

```toml
# local.config.toml (personal, not committed)
targets = []  # disable all shared targets

[providers.mytool.commands]
template = "{{ dir.application }}/templates/mytool/command.hbs"
target   = "{{ dir.workspace }}/.mytool/{{ command.name }}.md"
```

---

## Building (for nix vendoring)

```bash
# Build the binary
cd /mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/packages/agents/dotagents
cargo build --release

# Or via nix (future: vendored into n0x-pi vendor/dotagents/)
nix build .#dotagents

# Run tests
cargo test
cargo test --test integration
```

### Vendoring into n0x-pi

Follow the vendoring recipe from `agent/foundation.md`:

1. **Read** `Cargo.toml` — identify crate deps for nora vendoring
2. **Copy** source to `vendor/dotagents/`
3. **Create** `vendor/dotagents/package.nix` — self-contained buildRustPackage
4. **Wire** into `flake.nix`: `dotagents = pkgs.callPackage ./vendor/dotagents/package.nix { };`
5. **Build**: `nix build .#dotagents`

---

## Quickstart for n0x-pi

```bash
# 1. Initialize dotagents for this project
dotagents init --targets pi --features commands,skills

# 2. Add commands from existing prompts
cp tasks/nix-foundation/prompts/tigerbeetle.md .dotagents/commands/tigerbeetle.md

# 3. Deploy to pi
dotagents deploy

# 4. pi will now discover tigerbeetle as /tigerbeetle prompt
```

---

## References

- Source: `/mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/packages/agents/dotagents/`
- Registry: `public/v1/templates/registry.json`
- Pi templates: `public/v1/templates/pi/`
- OpenSpec changes: `openspec/changes/archive/`
- Upstream: https://github.com/soorya-u/dotagents
