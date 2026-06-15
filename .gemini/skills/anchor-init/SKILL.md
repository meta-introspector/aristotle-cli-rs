---
name: anchor-init
description: >-
  Scaffolds anchor tag infrastructure and generates the initial master manifest
  map. Zero-dependency anchor tagging subsystem for codebase navigation.
  Use with "new" or "existing" project_type and a language_target
  (typescript, rust, python, lean).
---

# anchor-init — Anchor Tag Bootstrapper

Scaffolds a zero-dependency anchor tagging subsystem. For existing projects, parses directory structures to inject syntactical boundaries without breaking compiling code. For new projects, sets up the scaffolding so every new file is tagged from the start.

## Parameters

| Parameter | Values | Default |
|-----------|--------|---------|
| `project_type` | `new`, `existing` | `existing` |
| `language_target` | `typescript`, `rust`, `python`, `lean` | `typescript` |

## Anchor Token Format by Language

```
typescript  →  /** @anchor [id]\n * @tags [tags] */
rust        →  // @anchor [id]\n// @tags [tags]
python      →  # @anchor [id]\n# @tags [tags]
lean        →  /-- @anchor [id]\n    @tags [tags] -/
```

Allowed tag prefixes: `api`, `domain`, `infra`, `worker`, `ui`, `protocol`

---

## Execution Steps

Run these steps in order. Do not skip any step.

### Step 1 — Determine Project Root

If the user specified a path, use it. Otherwise use the current working directory. Call this `$PROJECT_ROOT`.

```bash
PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"
```

### Step 2 — Scaffold `.anchor/config.json`

Create the configuration at `$PROJECT_ROOT/.anchor/config.json`:

```json
{
  "meta": {
    "version": "1.0.0",
    "engine": "harness-compiled"
  },
  "rules": {
    "token_identifier": "@anchor",
    "tag_identifier": "@tags",
    "enforce_on_commit": true,
    "max_lines_without_anchor": 150,
    "allowed_prefixes": ["api", "domain", "infra", "worker", "ui", "protocol"]
  },
  "exclude": [
    "**/node_modules/**",
    "**/.git/**",
    "**/target/**",
    "**/dist/**",
    "**/*.test.*",
    "**/*.spec.*"
  ]
}
```

Write it verbatim — do not modify the JSON structure.

### Step 3 — Inject AI Prompt Overlay

Check which AI instruction file exists at `$PROJECT_ROOT`. Look for (in priority order):

1. `CLAUDE.md`
2. `.claudecode.md`
3. `AGENTS.md`
4. `ai.md`

If none exist, create `CLAUDE.md`. If one exists, append to it (do not overwrite existing content). Add a `## ARCHITECTURAL ANCHOR PROTOCOL` section:

```markdown
## ARCHITECTURAL ANCHOR PROTOCOL

You are operating within an anchor-mapped repository.

### Rules of Engagement
1. Before planning any refactor, modification, deletion, or exploration, you MUST read `.anchor/anchor-manifest.json`.
2. Do not rely on semantic search or loose grepping. Match the user intent to the closest surface keys within the manifest array.
3. If your code changes touch multiple services, you must trace the references via matching anchor IDs.
4. When writing new functions, modules, or services, you are strictly required to pre-pend an anchor token block matching the language specification.

### Anchor Token Format
- **typescript/js**: `/** @anchor [id] */\n/** @tags [comma,separated,tags] */`
- **rust**: `// @anchor [id]\n// @tags [comma,separated,tags]`
- **python**: `# @anchor [id]\n# @tags [comma,separated,tags]`
- **lean**: `/-- @anchor [id]\n    @tags [comma,separated,tags] -/`
```

### Step 4 — Deploy Manifest Generator

Create `$PROJECT_ROOT/.anchor/generate_manifest.py`. This is the runtime engine that crawls the workspace and indexes all anchor tokens.

Write this exact script:

```python
#!/usr/bin/env python3
"""Anchor manifest generator — indexes @anchor tokens across the workspace."""
import os
import json
import re
from pathlib import Path


def load_config():
    config_path = Path(".anchor/config.json")
    if not config_path.exists():
        print("ERROR: .anchor/config.json not found. Run anchor-init first.")
        raise SystemExit(1)
    with open(config_path, "r") as f:
        return json.load(f)


def find_project_root():
    """Walk up from cwd until we find .anchor/config.json."""
    current = Path.cwd()
    for parent in [current, *current.parents]:
        if (parent / ".anchor" / "config.json").exists():
            return parent
    return current


def generate_manifest():
    cfg = load_config()
    token = cfg["rules"]["token_identifier"]
    tag_token = cfg["rules"]["tag_identifier"]
    exclude_patterns = cfg.get("exclude", [])

    root = find_project_root()
    manifest = {"surfaces": {}, "meta": {"generated_from": str(root)}}

    # Supported extensions
    ext_map = {
        ".ts": "typescript", ".tsx": "typescript",
        ".js": "typescript", ".jsx": "typescript",
        ".rs": "rust",
        ".py": "python",
        ".lean": "lean",
    }

    for path in root.rglob("*"):
        if not path.is_file():
            continue
        if path.suffix not in ext_map:
            continue

        rel = str(path.relative_to(root))

        # Check exclusions
        excluded = False
        for pat in exclude_patterns:
            # Simple glob matching
            if path.match(pat) or path.match(f"**/{pat}"):
                excluded = True
                break
        if excluded:
            continue

        try:
            content = path.read_text(encoding="utf-8", errors="replace")
        except Exception:
            continue

        # Find all @anchor tokens (language-agnostic pattern)
        anchors = re.findall(
            r"@anchor\s+([a-zA-Z0-9:\-_]+)",
            content
        )

        for anchor in anchors:
            # Find associated @tags on nearby line
            tags_match = re.search(
                r"@tags\s+([a-zA-Z0-9:,\-_ ]+)",
                content
            )
            tags = (
                [t.strip() for t in tags_match.group(1).split(",")]
                if tags_match
                else []
            )

            if anchor not in manifest["surfaces"]:
                manifest["surfaces"][anchor] = {
                    "locations": [],
                    "tags": tags,
                }

            if rel not in manifest["surfaces"][anchor]["locations"]:
                manifest["surfaces"][anchor]["locations"].append(rel)

    # Write manifest
    manifest_path = root / ".anchor" / "anchor-manifest.json"
    with open(manifest_path, "w") as f:
        json.dump(manifest, f, indent=2)

    total_anchors = len(manifest["surfaces"])
    total_locations = sum(
        len(v["locations"]) for v in manifest["surfaces"].values()
    )
    print(
        f"Manifest generated: {total_anchors} anchors, "
        f"{total_locations} file locations"
    )
    return manifest


if __name__ == "__main__":
    generate_manifest()
```

Make it executable:
```bash
chmod +x .anchor/generate_manifest.py
```

### Step 5 — Inject Anchor Tokens (Existing Projects Only)

If `project_type` is `existing`, scan source files and inject anchor tokens where they are missing. This is the critical step that maps an existing codebase.

#### 5a — Determine comment syntax from `language_target`

```
typescript  →  /** @anchor [id]\n * @tags [tags] */
rust        →  // @anchor [id]\n// @tags [tags]
python      →  # @anchor [id]\n# @tags [tags]
lean        →  /-- @anchor [id]\n    @tags [tags] -/
```

#### 5b — Scan for files to annotate

```bash
# Find top-level source files and directories (excluding config exclusions)
# Derive anchor IDs from file/module names
```

For each file found, read the file and determine:

1. **Does it already have an `@anchor` token?** If yes, skip.
2. **What is the appropriate anchor ID?** Derive from:
   - Module/export name (e.g., `UserService` → `domain:user-service`)
   - File name stem (e.g., `auth_middleware.py` → `api:auth-middleware`)
   - Directory path (e.g., `src/infra/db.ts` → `infra:db`)
3. **What tags apply?** Map directory or module role to allowed prefixes. Use heuristics:
   - `src/api/` or `routes/` → `["api"]`
   - `src/domain/` or `models/` → `["domain"]`
   - `src/infra/` or `db/`, `config/` → `["infra"]`
   - `src/workers/` or `jobs/` → `["worker"]`
   - `src/ui/` or `components/`, `pages/` → `["ui"]`
   - `src/protocol/` or `types/`, `interfaces/` → `["protocol"]`

#### 5c — Inject the anchor token

Prepend the anchor block **after any shebang line but before imports/exports**. For example, a Python file:

```python
#!/usr/bin/env python3
# @anchor domain:user-service
# @tags domain, api

import os
...
```

A TypeScript file:

```typescript
/**
 * @anchor api:auth-middleware
 * @tags api, infra
 */

import { Request, Response } from "express";
...
```

#### 5d — Stop if annotation would break anything

Do not inject anchors into files that:
- Are shebang scripts where the shebang must be exactly line 1
- Have minified or single-line content
- Are binary files
- Match any exclude pattern from `config.json`

### Step 6 — Generate Initial Manifest

Run the manifest generator to produce the first `anchor-manifest.json`:

```bash
python3 .anchor/generate_manifest.py
```

### Step 7 — Report

Print a summary:

```
anchor-init complete — {$PROJECT_ROOT}

  Config:       .anchor/config.json
  Manifest:     .anchor/anchor-manifest.json
  Generator:    .anchor/generate_manifest.py
  AI Overlay:   {$AI_FILE} (created/appended)
  Anchors:      {N} files annotated
  Total:        {M} anchors across {K} files
```

Then remind the user:

> "Anchor infrastructure is active. The pre-commit hook (anchor-verify) must be installed separately. Run `anchor-verify` to deploy the hook and validate your first commit."
