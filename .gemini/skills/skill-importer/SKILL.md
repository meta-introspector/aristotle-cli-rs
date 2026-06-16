---
name: "skill-importer"
description: "Import skills from all agent formats and regenerate unified forms. Use when adding new skills, syncing cross-agent docs, or normalizing existing skill files."
---

# Skill Importer

## Purpose

`src/bin/skill-importer.rs` is the single source of truth for skills. It:

1. Scans existing skill files from every agent format on disk.
2. Normalizes `name`, `description`, and body content.
3. Writes cross-agent exports under `skill-exports/`.

## Scan Roots

The tool scans these roots by default:

- `~/.kilocode/skills`
- `~/.claude/skills`
- `~/.agents/skills`
- `~/.opencode/skills`
- `./skills`
- `./packages/agents/dotagents/.dotagents/skills`
- `./packages/agents/dotagents/.opencode/skills`

## Usage

```bash
cargo run --bin skill-importer
```

## Outputs

| Path | Contents |
|------|----------|
| `skill-exports/kilo/*.md` | Kilo SKILL.md files |
| `skill-exports/claude/*.md` | Claude skill docs |
| `skill-exports/dotagents/*/SKILL.md` | Dotagents skill directories |
| `skill-exports/generic/*.md` | Plain markdown copies |
| `skill-exports/json/all-skills.json` | Machine-readable index |
| `skill-exports/manifest.md` | Human-readable manifest |

## Workflow

1. Add or edit skills in any existing location.
2. Run `cargo run --bin skill-importer`.
3. Review `skill-exports/`.
4. Commit the repo-local `skills/` and `skill-exports/` changes.

## Notes

- The tool treats any file named `SKILL.md` as a skill.
- It parses YAML front matter for `name` and `description`.
- Run it before committing so exports stay in sync.
