---
name: "context-doctor"
description: "Identify and repair degradation in the agent's system prompt, skills, and lattice. Diagnose bloat, redundancy, poor progressive disclosure, and stale references. Use when the agent seems confused or forgetful."
---

# Context Doctor — Repair Degraded Context

The agent's context is what makes it effective across sessions. Over
time, context can degrade — bloat and poor structure erode the agent's
ability to follow instructions and remember the right things.

This skill identifies issues and repairs them.

---

## When to Use

- Agent seems confused about its own skills or conventions
- System prompt is bloated (over ~20K tokens)
- Skills have overlapping or contradictory instructions
- Lattice.md index is out of sync with actual skills
- Stale references to deleted or moved files

## Operating Procedure

### Step 1: Identify issues

Check these common problems:

#### System prompt bloat

The system prompt should be ~10% of context (15-20K tokens). Check:

```bash
letta memory tokens --format json --quiet
```

**Why detail matters (read before cutting anything):**
In-context detail does four things:
1. **Information** — the literal facts
2. **Attention anchoring** — makes topics feel important
3. **Semantic priming** — raises priors on codebase-specific patterns
4. **Reasoning templates** — past examples become heuristics

Compression preserves (1) but destroys (2), (3), (4). A compressed
prompt can make the agent measurably worse even though the facts are
"still there" in reference files.

**When to intervene**: Only if the system prompt is *meaningfully* over
target. At or near the target, leave it alone.

#### Lattice index drift

```bash
# Check if lattice.md matches actual skills
ls agent/skills/ | sort > /tmp/actual-skills.txt
grep '/skill:' agent/lattice.md | sed 's/.*`\/skill:\([^`]*\)`.*/\1/' | sort > /tmp/lattice-skills.txt
diff /tmp/actual-skills.txt /tmp/lattice-skills.txt
```

#### Skill redundancy

Skills should have non-overlapping descriptions and non-overlapping
content. Check:

```bash
# Find skills with similar descriptions
for f in agent/skills/*/SKILL.md; do
  echo "$(basename $(dirname $f)): $(head -4 $f | grep description | cut -d'>' -f2- | cut -c1-80)"
done | sort -k2 | uniq -f1 -D
```

#### Stale references

```bash
# Check [[path]] references that point to missing files
grep -r '\[\[' agent/ | sed 's/.*\[\[\([^]]*\)\]\].*/\1/' | while read ref; do
  test -e "$ref" || echo "BROKEN: $ref"
done
```

### Step 2: Implement fixes

Make **minimal** changes. If the system prompt is 1.5× the target, don't
cut it to half "for headroom." Cut until near the target, then stop.

Before moving on, verify:
- [ ] System prompt token budget reviewed
- [ ] Changes proportional to the problem
- [ ] Preserved detailed rationale, examples, and cross-references
- [ ] Preferred moving whole files or deleting stale sections over compressing
- [ ] No overlapping or redundant files remain
- [ ] All file descriptions are unique and accurate
- [ ] Moved-out knowledge has `[[path]]` references for discovery
- [ ] No semantic changes to persona or behavioral instructions
- [ ] Lattice.md index matches actual skills in `agent/skills/`
- [ ] `.dotagents/skills/` is in sync with `agent/skills/`

### Step 3: Commit and push

```bash
cd $MEMORY_DIR
git status
git add <specific files>
git commit --author="$AGENT_NAME <$AGENT_ID@letta.com>" -m "fix(doctor): <summary>"
git push
```

### Step 4: Tell the user

Report what issues you found, the fixes you made, and the commit.
Recommend running `/recompile` to apply changes to the current system
prompt.

## Guardrails

- Be conservative with system prompt edits — every edit risks removing
  content that was doing work you can't see
- Preserve persona-defining content and user preferences
- Maintain the existing distribution of detail across topics
- Don't ask the user about structural preferences — you understand your
  own context best
- Ask the user how they want you to behave, not how to organize files

## Related

- `skill-author` — for creating or updating skills
- `dotagents` — for syncing skills to `.dotagents/`
