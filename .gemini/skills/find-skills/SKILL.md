---
name: find-skills
description: >-
  Discover and install agent skills from the open ecosystem. Use when
  the user asks "how do I do X", "find a skill for X", or wants to
  extend agent capabilities beyond what's in agent/skills/.
---

# Find Skills — Ecosystem Discovery

Discover and install skills from the open agent skills ecosystem. Use when
the user's need exceeds what's already in `agent/skills/`.

---

## When to Use

- "How do I do X" where X isn't covered by existing skills
- "Find a skill for X" or "is there a skill that can..."
- "Can you do X" where X is a specialized capability
- User wants to extend agent capabilities

## What is the Skills CLI?

`npx skills` is the package manager for the open agent skills ecosystem.

```bash
npx skills find [query]     # Search by keyword
npx skills add <package>     # Install from GitHub
npx skills check             # Check for updates
npx skills update            # Update all installed skills
```

Browse at: https://skills.sh/

## Steps

**1. Understand the need**

Identify:
- The domain (React, testing, design, deployment)
- The specific task (write tests, create animations, review PRs)
- Whether this is common enough that a skill likely exists

**2. Check the leaderboard first**

Before running a CLI search, check https://skills.sh/ — skills ranked
by total installs surface the most battle-tested options.

**3. Search for skills**

```bash
npx skills find react performance
npx skills find pr review
npx skills find changelog
```

**4. Verify quality before recommending**

Do NOT recommend a skill based solely on search results. Verify:

| Criterion | Threshold |
|-----------|-----------|
| Install count | Prefer 1K+. Caution under 100. |
| Source reputation | Official sources (`vercel-labs`, `anthropics`, `microsoft`) > unknown |
| GitHub stars | Repo with <100 stars = skeptical |

**5. Present options**

```
I found a skill: "react-best-practices" — React/Next.js performance
optimization from Vercel Engineering. (185K installs)

Install: npx skills add vercel-labs/agent-skills@react-best-practices
Learn more: https://skills.sh/vercel-labs/agent-skills/react-best-practices
```

**6. Install if approved**

```bash
npx skills add <owner/repo@skill> -g -y
```

`-g` installs globally (user-level), `-y` skips confirmation.

## After Installation

Once installed, the skill lives in `~/.vibe/skills/` (or equivalent).
To bring it into the n0x-pi workspace:

1. Copy the `SKILL.md` to `agent/skills/<name>/SKILL.md`
2. Translate any `github:` references to `git+file:///mnt/data1/git/` per `agent/foundation.md`
3. Add the skill to the lattice.md index
4. Sync to `.dotagents/skills/<name>/SKILL.md`

## Common Skill Categories

| Category | Example Queries |
|----------|----------------|
| Web Development | react, nextjs, typescript, css, tailwind |
| Testing | testing, jest, playwright, e2e |
| DevOps | deploy, docker, kubernetes, ci-cd |
| Documentation | docs, readme, changelog, api-docs |
| Code Quality | review, lint, refactor, best-practices |
| Design | ui, ux, design-system, accessibility |

## Guardrails

- Always verify quality (installs, source, stars) before recommending
- Never install skills without user approval
- Skills from the ecosystem may not follow n0x-pi conventions — translate them
- If no skill exists, offer to help directly or create one with `npx skills init`
- Installed skills are NOT in the n0x-pi lattice until explicitly added

## Related

- `nix-build` — for vendoring skill dependencies into flakes
- `dotagents` — for deploying installed skills to other agents
