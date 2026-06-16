---
name: "auth-registry"
description: "Encrypted credential management via sops + age. All LLM API keys and OAuth tokens live in a single sops-encrypted secrets file. Decrypt, test, rotate, and re-encrypt. Use when setting up agents, rotating keys, or diagnosing auth failures."
---

# Auth Registry — sops-Encrypted Credential Management

All LLM agent credentials in one sops-encrypted file. Decrypt with age,
test connectivity, rotate keys, re-encrypt. No plaintext secrets on disk
outside of ephemeral shell sessions.

---

## When to Use

- "Is my DeepSeek key still working?"
- "Which agents can I use right now?"
- "Set up credentials for a new agent"
- "Rotate the Anthropic API key"
- "Add a new provider to the registry"

## Architecture

```
secrets/
├── .sops.yaml              ← sops config: which age key encrypts which files
├── keys.age                ← age keypair (NOT in git)
└── credentials.yaml.enc   ← sops-encrypted: all API keys + OAuth tokens

        │  sops --decrypt
        ▼

credentials.yaml (plaintext, never written to disk)
├── anthropic:
│     api_key: sk-ant-...
│   openai:
│     api_key: sk-...
│   deepseek:
│     api_key: sk-...
│   google:
│     api_key: AIza...
│   groq:
│     api_key: gsk_...
│   xai:
│     api_key: xai-...
│   mistral:
│     api_key: ...
│   letta:
│     api_key: ...
│   cursor:
│     api_key: ...
│   oauth:                   ← OAuth tokens (refresh + access)
│     claude-code:
│       refresh_token: ...
│     codex:
│       refresh_token: ...
│     gemini-cli:
│       refresh_token: ...
```

## Nix Setup

sops and age are provided via nixpkgs. Add to the root flake.nix or
per-task devShell:

```nix
# In flake.nix outputs
packages.${system}.default = pkgs.writeShellScriptBin "pi-task" ''
  export SOPS_AGE_KEY_FILE="''${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}"
  export PATH="${pkgs.lib.makeBinPath [ pkgs.sops pkgs.age ]}:$PATH"
  exec ${pi}/bin/pi "$@"
'';

devShells.${system}.default = pkgs.mkShell {
  buildInputs = [ pi pkgs.sops pkgs.age ] ++ runtimeTools;
  shellHook = ''
    export SOPS_AGE_KEY_FILE="''${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}"
  '';
};
```

For sops-nix (NixOS/home-manager integration):

```nix
# In flake.nix inputs
sops-nix.url = "git+file:///mnt/data1/git/github.com/Mic92/sops-nix.git";

# In NixOS configuration
imports = [ sops-nix.nixosModules.sops ];
sops.age.keyFile = "/home/<user>/.config/sops/age/keys.txt";
sops.secrets.anthropic_api_key = {
  sopsFile = ./secrets/credentials.yaml.enc;
  key = "anthropic/api_key";
};
```

## Commands

### `auth-registry init`

First-time setup — create the age key and sops config:

```bash
# 1. Generate age keypair (if not exists)
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt  # print public key

# 2. Create .sops.yaml in the project
cat > secrets/.sops.yaml <<EOF
keys:
  - &admin age:$(age-keygen -y ~/.config/sops/age/keys.txt)

creation_rules:
  - path_regex: credentials\.yaml\.enc$
    key_groups:
      - age:
        - *admin
EOF

# 3. Create plaintext credentials.yaml
cat > secrets/credentials.yaml <<EOF
anthropic:
  api_key: ""

openai:
  api_key: ""

deepseek:
  api_key: ""

google:
  api_key: ""

groq:
  api_key: ""

xiai:
  api_key: ""

mistral:
  api_key: ""

letta:
  api_key: ""

cursor:
  api_key: ""

oauth:
  claude-code:
    refresh_token: ""
  codex:
    refresh_token: ""
  gemini-cli:
    refresh_token: ""
EOF

# 4. Encrypt
sops --encrypt --in-place secrets/credentials.yaml

# 5. Move to encrypted form
mv secrets/credentials.yaml secrets/credentials.yaml.enc

# 6. Verify decryption works
sops --decrypt secrets/credentials.yaml.enc | head -5

# 7. Clean up plaintext (if it still exists)
rm -f secrets/credentials.yaml
```

### `auth-registry status`

Check which credentials exist in the encrypted store:

```bash
# Decrypt to stdout (ephemeral — never written to disk)
sops --decrypt secrets/credentials.yaml.enc | \
  yq '.[] | keys' | sort -u

# Check which keys are non-empty
sops --decrypt secrets/credentials.yaml.enc | \
  yq 'to_entries | .[] | select(.value.api_key != "" and .value.api_key != null) | .key'

# Check which OAuth tokens exist
sops --decrypt secrets/credentials.yaml.enc | \
  yq '.oauth | to_entries | .[] | select(.value.refresh_token != "" and .value.refresh_token != null) | .key'

# Verify the age key is accessible
test -f "$SOPS_AGE_KEY_FILE" && echo "OK  age key at $SOPS_AGE_KEY_FILE" || echo "MISS  age key"
```

### `auth-registry set <provider> <key>`

Add or update a credential:

```bash
# Set an API key
sops --set '["anthropic"]["api_key"] "'"sk-ant-..."'  secrets/credentials.yaml.enc

# Set a DeepSeek key
sops --set '["deepseek"]["api_key"] "'"sk-..."'  secrets/credentials.yaml.enc

# Verify
sops --decrypt secrets/credentials.yaml.enc | yq '.anthropic.api_key' | sed 's/\(.\{8\}\).*/\1****/'
```

### `auth-registry test <provider>`

Test connectivity using the decrypted key:

```bash
# Decrypt key into a temp variable (never written to disk)
KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.anthropic.api_key')

# Anthropic
curl -s -o /dev/null -w "%{http_code}" \
  -H "x-api-key: $KEY" \
  -H "anthropic-version: 2023-06-01" \
  https://api.anthropic.com/v1/messages \
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":1,"messages":[{"role":"user","content":"hi"}]}'

# OpenAI
KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.openai.api_key')
curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer $KEY" \
  https://api.openai.com/v1/models

# DeepSeek
KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.deepseek.api_key')
curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer $KEY" \
  https://api.deepseek.com/models

# Google Gemini
KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.google.api_key')
curl -s -o /dev/null -w "%{http_code}" \
  "https://generativelanguage.googleapis.com/v1beta/models?key=$KEY"

# Groq
KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.groq.api_key')
curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer $KEY" \
  https://api.groq.com/openai/v1/models

# xAI
KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.xiai.api_key')
curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer $KEY" \
  https://api.x.ai/v1/models

# Mistral
KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.mistral.api_key')
curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer $KEY" \
  https://api.mistral.ai/v1/models

# Always unset after use
unset KEY
```

Expected: HTTP 200 = working, 401 = bad key, 429 = rate limited but key valid.

### `auth-registry test-all`

Test all providers at once:

```bash
CREDS=$(sops --decrypt secrets/credentials.yaml.enc)

for provider in anthropic openai deepseek google groq xiai mistral; do
  KEY=$(echo "$CREDS" | yq ".$provider.api_key")
  if [ -z "$KEY" ] || [ "$KEY" = "null" ]; then
    echo "SKIP  $provider  (no key)"
    continue
  fi
  # ... (per-provider curl as above)
  echo "$HTTP_CODE  $provider"
done

unset CREDS KEY
```

### `auth-registry rotate <provider>`

Key rotation with sops:

1. Generate new key at the provider's dashboard
2. `auth-registry set <provider> <new-key>`
3. `auth-registry test <provider>` — verify new key works
4. Revoke the old key at the provider's dashboard
5. Commit the updated `credentials.yaml.enc`

### `auth-registry env <provider>`

Export a decrypted key as an env var for the current shell:

```bash
# For use in wrapper scripts or devShells
export ANTHROPIC_API_KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.anthropic.api_key')
export OPENAI_API_KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.openai.api_key')
export DEEPSEEK_API_KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.deepseek.api_key')
export GEMINI_API_KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.google.api_key')
export GROQ_API_KEY=$(sops --decrypt secrets/credentials.yaml.enc | yq '.groq.api_key')
```

### `auth-registry deploy`

Write decrypted credentials to agent-specific config locations:

```bash
CREDS=$(sops --decrypt secrets/credentials.yaml.enc)

# DeepSeek → settings.toml
mkdir -p ~/.config/deepseek
cat > ~/.config/deepseek/settings.toml <<EOF
[provider]
api_key = "$(echo "$CREDS" | yq '.deepseek.api_key')"
EOF

# Goose → secrets.yaml
mkdir -p ~/.config/goose
cat > ~/.config/goose/secrets.yaml <<EOF
GROQ_API_KEY: "$(echo "$CREDS" | yq '.groq.api_key')"
EOF

# OpenCode → opencode.jsonc
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.jsonc <<EOF
{
  "provider": "anthropic",
  "apiKey": "$(echo "$CREDS" | yq '.anthropic.api_key')"
}
EOF

unset CREDS
```

### `auth-registry free-tier`

| Agent | Free Tier | Limits |
|-------|-----------|--------|
| Codex (OpenAI) | Yes | Rate limited, GPT-5.4-mini |
| Gemini CLI | Yes | Rate limited, Gemini 2.5 Pro |
| Cursor Agent | Yes | 2000 completions/month |
| Jules (Google) | Yes | Limited tasks/day |
| LocalGPT | Yes (local) | Hardware only |

## OAuth Tokens

OAuth tokens (Claude Code, Codex, Gemini CLI) require browser-based auth.
sops stores the refresh tokens; the CLIs handle access token rotation
automatically.

To capture an OAuth refresh token after browser auth:

```bash
# After running the agent's login command (e.g., claude login, codex auth),
# extract the refresh token from the agent's config and store it:

# Claude Code
REFRESH=$(python3 -c "import json; print(json.load(open('$HOME/.claude.json')).get('oauthAccount',{}).get('refreshToken',''))")
sops --set '["oauth"]["claude-code"]["refresh_token"] "'"$REFRESH"'"' secrets/credentials.yaml.enc

# Codex
REFRESH=$(python3 -c "import json; print(json.load(open('$HOME/.codex/auth.json')).get('refresh_token',''))")
sops --set '["oauth"]["codex"]["refresh_token"] "'"$REFRESH"'"' secrets/credentials.yaml.enc
```

To restore from sops to agent config:

```bash
# Restore Claude Code OAuth
REFRESH=$(sops --decrypt secrets/credentials.yaml.enc | yq '.oauth.claude-code.refresh_token')
python3 -c "
import json
with open('$HOME/.claude.json', 'r+') as f:
    d = json.load(f)
    d.setdefault('oauthAccount', {})['refreshToken'] = '$REFRESH'
    f.seek(0)
    json.dump(d, f, indent=2)
    f.truncate()
"
unset REFRESH
```

## sops-nix Integration

For NixOS machines, use sops-nix to inject secrets as systemd environment
files or templated configs:

```nix
# In the NixOS host configuration
sops.secrets.anthropic_api_key = {
  sopsFile = ./secrets/credentials.yaml.enc;
  key = "anthropic/api_key";
  mode = "0400";
};

# Reference in a systemd service
systemd.services.kant-pastebin = {
  environment.ANTHROPIC_API_KEY = config.sops.placeholder.anthropic_api_key;
};
```

## Guardrails

- NEVER write decrypted credentials to disk — always pipe through stdout
- NEVER commit `credentials.yaml` (plaintext) to git — only `credentials.yaml.enc`
- NEVER commit the age private key (`keys.txt`) to git
- The age key at `~/.config/sops/age/keys.txt` must be backed up offline
- Always `unset KEY` after testing to avoid leaking into shell history
- `.sops.yaml` IS committed — it contains the public key, not the private key
- sops encrypted files are safe to commit — values are AES-256-GCM encrypted
- For CI: use `SOPS_AGE_KEY` env var with the private key (from GitHub Actions secret)
- Test with minimal requests (1 token) to avoid burning quota

## Related

- `dotagents` — deploy decrypted credentials to agent configs
- `nix-build` — for vendoring sops/age into flake devShells
- `ping-agents` — for checking agent binary health (not auth)
