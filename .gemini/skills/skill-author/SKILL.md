---
name: skill-author
description: >-
  Create and package agent skills. SKILL.md frontmatter, progressive
  disclosure, bundled resources (scripts/, references/, assets/).
  Use when creating a new skill or updating an existing one.
---

# Skill Author — Creating Effective Skills

Create and package skills for the n0x-pi agent. Skills are modular,
self-contained packages that extend the agent's capabilities with
specialized knowledge, workflows, and tools.

---

## When to Use

- "Create a skill for X"
- "Package this workflow as a skill"
- "Update the existing Y skill"

## Core Principles

### Concise is Key

The context window is a public good. Skills share it with everything
else. **The agent is already very capable.** Only add context it doesn't
already have. Challenge each piece: "Does this justify its token cost?"

Prefer concise examples over verbose explanations.

### Set Appropriate Degrees of Freedom

| Freedom Level | When to Use | Example |
|---------------|-------------|---------|
| High (text instructions) | Multiple approaches valid, context-dependent | "Choose the right deployment strategy" |
| Medium (pseudocode + params) | Preferred pattern exists, some variation OK | "Use this template with these variables" |
| Low (specific scripts) | Fragile operations, consistency critical | "Run this exact sequence of commands" |

### Progressive Disclosure

Three-level loading system:

1. **Metadata** (name + description) — always in context (~100 words)
2. **SKILL.md body** — when skill triggers (<500 lines)
3. **Bundled resources** — as needed (unlimited)

Keep SKILL.md body under 500 lines. Split content into separate files
when approaching this limit.

## Skill Anatomy

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
└── assets/           # Optional: templates, resources
```

### SKILL.md (required)

```yaml
---
name: skill-name
description: >-
  What the skill does AND when to use it. Include trigger keywords.
  Max 1024 characters.
---
```

**Name rules:**
- Gerund form: `processing-pdfs`, `analyzing-data` (not `pdf-processor`)
- Lowercase, numbers, hyphens only
- Must match directory name exactly
- Max 64 characters

**Description rules:**
- Third person: "Processes PDF files..." (not "I help process...")
- Include both what AND when
- Include trigger keywords
- Max 1024 characters

### Bundled Resources

**scripts/** — Executable code for tasks that need deterministic
reliability or are repeatedly rewritten. Must be tested before
committing.

**references/** — Documentation loaded as needed. Keeps SKILL.md lean.
For large files (>10k words), include grep search patterns in SKILL.md.

**assets/** — Files used in output (templates, icons, fonts). Not loaded
into context.

### What NOT to Include

- README.md, INSTALLATION_GUIDE.md, CHANGELOG.md
- Auxiliary documentation about the creation process
- Setup and testing procedures (those are for you, not the skill user)

## Progressive Disclosure Patterns

**Pattern 1: High-level guide with references**

```markdown
# PDF Processing

## Quick start
[code example]

## Advanced features
- Form filling: See references/forms.md
- API reference: See references/api.md
```

**Pattern 2: Domain-specific organization**

```
querying-bigquery/
├── SKILL.md (overview + navigation)
└── references/
    ├── finance.md
    ├── sales.md
    └── product.md
```

**Pattern 3: Conditional details**

```markdown
# DOCX Processing

## Creating documents
Use docx-js. See references/docx-js.md.

## For tracked changes
See references/redlining.md
```

## Skill Creation Process

1. **Understand** — gather concrete examples of how the skill will be used
2. **Plan** — identify reusable resources (scripts, references, assets)
3. **Create** — `mkdir -p agent/skills/<name>` and write SKILL.md
4. **Implement** — write scripts, references, assets
5. **Test** — actually run scripts to verify they work
6. **Register** — add to lattice.md index
7. **Sync** — copy to `.dotagents/skills/<name>/`

## n0x-pi Conventions

When creating skills for n0x-pi:

- All flake inputs use `git+file:///mnt/data1/git/` — never `github:`
- System is `x86_64-linux` — no `eachDefaultSystem`
- Reference `agent/foundation.md` for vendoring decisions
- Reference `agent/prompts/tigerbeetle.md` for coding standards
- Add guardrails section to every SKILL.md
- Add related skills section with cross-references
- Sync to `.dotagents/skills/` after creation

## Guardrails

- Keep SKILL.md under 500 lines — split to references/ if needed
- Test all scripts before committing
- No overlapping content between SKILL.md and reference files
- Reference files should be linked from SKILL.md with clear descriptions
- Avoid deeply nested references — keep one level deep from SKILL.md
- For files >100 lines, include a table of contents at the top

## Related

- `find-skills` — discover existing skills before creating new ones
- `mcp-bridge` — create skills from MCP servers
- `dotagents` — deploy skills to other agents
- `nix-build` — vendor skill dependencies into flakes
