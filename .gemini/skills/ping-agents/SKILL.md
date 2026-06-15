---
name: ping-agents
description: >-
  Health-check all installed LLM coding agent CLIs. Verify binaries exist,
  versions are current, and auth is working. Use when onboarding a new
  machine, after a nix update, or to see which agents are available.
---

# Ping Agents — LLM CLI Health Check

Verify that all installed LLM coding agent CLIs are available, up-to-date,
and authenticated. Quick diagnostic for "which agents can I use right now?"

---

## When to Use

- "Which agents are installed?"
- "Is my setup working?"
- "After a nix update, check everything still works"
- "Onboarding a new machine"

## Full Ping

Run all checks:

```bash
echo "=== LLM Agent CLI Health Check ==="
echo ""

# --- Binary checks ---

for cmd in pi claude codex gemini cursor-agent goose opencode \
           jules junie kilocode qoder rtk crush droid amp \
           happy-coder cubic forge grok mistral-vibe nanocoder \
           openclaw openfang parallel-cli picoclaw reasonix \
           zeroclaw claw-code ccusage ccstatusline; do
  if command -v "$cmd" &>/dev/null; then
    version=$("$cmd" --version 2>/dev/null || "$cmd" version 2>/dev/null || echo "?")
    echo "OK    $cmd  $version"
  else
    echo "MISS  $cmd"
  fi
done

echo ""
echo "=== Auth checks ==="

# Claude Code
if [ -f ~/.claude.json ]; then
  echo "OK    claude-code  auth file exists"
else
  echo "MISS  claude-code  no ~/.claude.json"
fi

# Codex
if [ -f ~/.codex/auth.json ]; then
  has_key=$(python3 -c "import json; d=json.load(open('$HOME/.codex/auth.json')); print('yes' if d.get('OPENAI_API_KEY') else 'no')" 2>/dev/null)
  echo "OK    codex  auth file exists, key=$has_key"
else
  echo "MISS  codex  no ~/.codex/auth.json"
fi

# Gemini CLI
if [ -f ~/.gemini/oauth_creds.json ]; then
  echo "OK    gemini-cli  OAuth creds exist"
else
  echo "MISS  gemini-cli  no ~/.gemini/oauth_creds.json"
fi

# DeepSeek
if [ -f ~/.config/deepseek/settings.toml ]; then
  echo "OK    deepseek  config exists"
else
  echo "MISS  deepseek  no ~/.config/deepseek/settings.toml"
fi

# Cursor
if [ -f ~/.config/cursor/auth.json ]; then
  echo "OK    cursor-agent  auth file exists"
else
  echo "MISS  cursor-agent  no ~/.config/cursor/auth.json"
fi

# Goose
if [ -f ~/.config/goose/secrets.yaml ]; then
  echo "OK    goose-cli  secrets file exists"
else
  echo "MISS  goose-cli  no ~/.config/goose/secrets.yaml"
fi

# Env var keys
for var in ANTHROPIC_API_KEY OPENAI_API_KEY GEMINI_API_KEY DEEPSEEK_API_KEY \
           GROQ_API_KEY XAI_API_KEY MISTRAL_API_KEY LETTA_API_KEY \
           CURSOR_API_KEY; do
  if [ -n "${!var:-}" ]; then
    echo "OK    env:$var"
  else
    echo "MISS  env:$var"
  fi
done
```

## Quick Ping

Just check the agents you use most:

```bash
for cmd in pi claude codex gemini; do
  if command -v "$cmd" &>/dev/null; then
    echo "OK  $cmd  $($cmd --version 2>/dev/null)"
  else
    echo "MISS  $cmd"
  fi
done
```

## Nix Package Ping

Check which agents are available via nix:

```bash
# From llm-agents.nix
cd /mnt/data1/time-2026/04-april/08/llm-agents.nix
for pkg in pi claude-code codex gemini-cli cursor-agent goose-cli \
          opencode jules junie kilocode-cli qoder-cli crush droid \
          amp cubic forge grok mistral-vibe nanocoder openclaw \
          openfang parallel-cli picoclaw reasonix zeroclaw claw-code; do
  if nix eval .#packages.x86_64-linux.$pkg --apply 'x: x.meta.description or ""' 2>/dev/null | grep -q .; then
    echo "OK  $pkg"
  else
    echo "FAIL  $pkg"
  fi
done
```

## Output Format

| Status | Meaning |
|--------|---------|
| `OK` | Binary found, version reported |
| `MISS` | Binary not in PATH or config file missing |
| `FAIL` | Nix package evaluation failed |
| `WARN` | Binary exists but auth may be expired |

## Guardrails

- NEVER print API keys — only check existence (yes/no)
- Version commands vary (`--version`, `version`, `-V`) — try all
- Some agents need a TTY for version — redirect stderr
- Nix eval is slow — use `--no-link` builds for accuracy
- OAuth tokens expire — file existence doesn't guarantee working auth
- For full auth testing, use `auth-registry test <provider>`

## Related

- `auth-registry` — for testing actual API connectivity
- `nix-build` — for verifying flake packages build
- `dotagents` — for deploying configs to new agents
