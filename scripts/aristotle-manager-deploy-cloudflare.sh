#!/usr/bin/env bash
# ============================================================================
# aristotle-manager deploy cloudflare — Generalized Cloudflare deployment
#
# Usage:
#   aristotle-manager deploy cloudflare <PROJECT_UUID> [--project-name NAME]
#   aristotle-manager deploy cloudflare <PROJECT_UUID> --pages        # Pages only
#   aristotle-manager deploy cloudflare <PROJECT_UUID> --worker       # Worker only
#   aristotle-manager deploy cloudflare <PROJECT_UUID> --dry-run      # Show plan
#
# Deploys a single aristotle project to Cloudflare Workers/Pages using the
# project's generated static site, Edge Worker, or both.
#
# Credentials are decrypted on demand via SOPS from the tracker vault.
# ============================================================================
set -euo pipefail

ARIST_ROOT="${ARIST_ROOT:-/home/mdupont/projects/arist}"
VAULT_DIR="${VAULT_DIR:-/etc/tracker-vault/secrets}"
AGE_KEY_FILE="${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}"

PROJECT_UUID="${1:-}"
shift || true

if [[ -z "$PROJECT_UUID" ]]; then
  echo "Usage: aristotle-manager deploy cloudflare <PROJECT_UUID> [--pages|--worker|--dry-run]" >&2
  exit 1
fi

# ── Parse flags ──────────────────────────────────────────────────────────────
DEPLOY_PAGES=true
DEPLOY_WORKER=true
DRY_RUN=false
PROJECT_NAME_OVERRIDE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --pages)      DEPLOY_WORKER=false ;;
    --worker)     DEPLOY_PAGES=false ;;
    --dry-run)    DRY_RUN=true ;;
    --project-name) PROJECT_NAME_OVERRIDE="$2"; shift ;;
    --help|-h)
      echo "Usage: aristotle-manager deploy cloudflare <UUID> [--pages] [--worker] [--dry-run] [--project-name NAME]"
      exit 0 ;;
    *) echo "Unknown flag: $1" >&2; exit 2 ;;
  esac
  shift
done

PROJECT_DIR="$ARIST_ROOT/$PROJECT_UUID"
if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: project directory not found: $PROJECT_DIR" >&2
  exit 1
fi

# ── Credential decryption (SOPS) ─────────────────────────────────────────────
get_cf_creds() {
  local token="" acct=""
  local token_file="$VAULT_DIR/cloudflare-pages-token.enc.json"
  local acct_file="$VAULT_DIR/cloudflare-account-0-id.enc.json"
  local worker_token_file="$VAULT_DIR/cloudflare-account-0-token.enc.json"

  token=""
  acct=""
  
  # Try SOPS vault first
  if command -v sops >/dev/null 2>&1 && [ -f "$AGE_KEY_FILE" ]; then
    token="$(sops -d "$token_file" 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin).get("value",""))' 2>/dev/null || true)"
    acct="$(sops -d "$acct_file" 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin).get("value",""))' 2>/dev/null || true)"
  fi
  
  # Fallback to GUI2PROOF runtime env
  if [ -z "$token" ] && [ -r "${ENV_FILE:-/run/gui2proof/cloudflare.env}" ]; then
    set -a; source "${ENV_FILE:-/run/gui2proof/cloudflare.env}" 2>/dev/null || true; set +a
    token="${CLOUDFLARE_API_TOKEN:-}"
    acct="${CLOUDFLARE_ACCOUNT_ID:-}"
  fi
  
  # Fallback to GUI2PROOF runtime env (second source)
  if [ -z "$token" ] && [ -r "${GUI2PROOF_RUNTIME_ENV:-/run/gui2proof/cloudflare.env}" ]; then
    set -a; source "${GUI2PROOF_RUNTIME_ENV:-/run/gui2proof/cloudflare.env}" 2>/dev/null || true; set +a
    token="${CLOUDFLARE_API_TOKEN:-}"
    acct="${CLOUDFLARE_ACCOUNT_ID:-}"
  fi

  echo "TOKEN=$token"
  echo "ACCT=$acct"
}

# ── Helper: validate credentials ─────────────────────────────────────────────
validate_creds() {
  local token="$1" acct="$2"
  if [[ ! "$acct" =~ ^[0-9a-f]{32}$ ]]; then
    echo "ERROR: invalid Cloudflare account ID (need 32-char hex): $acct" >&2
    return 1
  fi
  if [[ -z "$token" ]] || [[ "$token" == placeholder* ]]; then
    echo "ERROR: invalid CF_API_TOKEN (placeholder or empty)" >&2
    return 1
  fi
  return 0
}

# ── Determine project name ───────────────────────────────────────────────────
if [ -n "$PROJECT_NAME_OVERRIDE" ]; then
  PNAME="$PROJECT_NAME_OVERRIDE"
else
  PNAME="$(echo "$PROJECT_UUID" | cut -c1-12)"
fi

# ── Determine static site source ─────────────────────────────────────────────
STATIC_DIR=""
if [ -d "$PROJECT_DIR/www" ]; then
  STATIC_DIR="$PROJECT_DIR/www"
elif [ -d "$PROJECT_DIR/hodge-vm/www" ]; then
  STATIC_DIR="$PROJECT_DIR/hodge-vm/www"
elif [ -f "$PROJECT_DIR/create_static_site.py" ]; then
  echo "== Generating static site (create_static_site.py) =="
  if $DRY_RUN; then
    echo "  [DRY-RUN] Would run: python3 $PROJECT_DIR/create_static_site.py"
  else
    mkdir -p "$PROJECT_DIR/www"
    python3 "$PROJECT_DIR/create_static_site.py" \
      --output "$PROJECT_DIR/www" \
      --project-uuid "$PROJECT_UUID" 2>&1 | tail -5 || \
      python3 "$PROJECT_DIR/create_static_site.py" 2>&1 | tail -5
  fi
  STATIC_DIR="$PROJECT_DIR/www"
fi

# ── Detect Worker config ─────────────────────────────────────────────────────
WORKER_DIR=""
WORKER_NAME=""
WRANGLER_CFG=""
if [ -f "$PROJECT_DIR/minilean/edge/cloudflare/wrangler.toml" ]; then
  WORKER_DIR="$PROJECT_DIR/minilean/edge/cloudflare"
  WORKER_NAME="minilean-mlvm"
  WRANGLER_CFG="$WORKER_DIR/wrangler.toml"
elif [ -f "$PROJECT_DIR/hodge-vm/dist/wrangler-p2p.toml" ] && [ -f "$PROJECT_DIR/hodge-vm/dist/p2p-worker.mjs" ]; then
  WORKER_DIR="$PROJECT_DIR/hodge-vm/dist"
  WORKER_NAME="hodge-p2p"
  WRANGLER_CFG="$WORKER_DIR/wrangler-p2p.toml"
fi

# ── Print deployment plan ───────────────────────────────────────────────────
echo "=== AristotVM Manager — cloudflare deploy ==="
echo "Project UUID: $PROJECT_UUID"
echo "Project name: $PNAME"
echo "Static dir:   ${STATIC_DIR:-<none>}"
if [ -n "$WORKER_DIR" ]; then
  echo "Worker:       $WORKER_NAME ($WRANGLER_CFG)"
else
  echo "Worker:       <none detected>"
fi

if $DRY_RUN; then
  echo "=== DRY RUN — no changes will be made ==="
  exit 0
fi

# ── Decrypt credentials ─────────────────────────────────────────────────────
CREDS="$(get_cf_creds)"
CF_TOKEN="$(echo "$CREDS" | grep '^TOKEN=' | cut -d= -f2-)"
CF_ACCT="$(echo "$CREDS" | grep '^ACCT=' | cut -d= -f2-)"

if ! validate_creds "$CF_TOKEN" "$CF_ACCT"; then
  echo ""
  echo "To deploy when credentials are available:"
  echo "  1. Ensure SOPS age key at $AGE_KEY_FILE"
  echo "  2. Ensure vault files in $VAULT_DIR"
  echo "  3. Re-run this command"
  exit 1
fi

export CF_API_TOKEN="$CF_TOKEN"
export CLOUDFLARE_API_TOKEN="$CF_TOKEN"
export CF_ACCOUNT_ID="$CF_ACCT"
export CLOUDFLARE_ACCOUNT_ID="$CF_ACCT"

WRANGLER_BIN="${WRANGLER_BIN:-$(command -v wrangler || echo npx wrangler)}"

echo "=== Deploying to Cloudflare ==="

# ── Pages deploy ────────────────────────────────────────────────────────────
if $DEPLOY_PAGES && [ -n "$STATIC_DIR" ]; then
  echo "▶ Pages deploy: $STATIC_DIR → project=$PNAME"
  # Ensure project exists
  $WRANGLER_BIN pages project create "$PNAME" \
    --account-id "$CF_ACCT" 2>/dev/null || true

  if $WRANGLER_BIN pages deploy "$STATIC_DIR" \
    --project-name "$PNAME" \
    --commit-dirty \
    --commit-message "Aristotile-manager deploy $PNAME @ $(date -u +%H:%M:%S)"; then
    echo "  ✓ Pages deployed: https://$PNAME.pages.dev"
  else
    echo "  ✗ Pages deploy failed" >&2
  fi
fi

# ── Worker deploy ────────────────────────────────────────────────────────────
if $DEPLOY_WORKER && [ -n "$WORKER_DIR" ] && [ -n "$WRANGLER_CFG" ]; then
  echo "▶ Worker deploy: $WORKER_NAME"
  cd "$WORKER_DIR"
  if $WRANGLER_BIN deploy --config "$(basename "$WRANGLER_CFG")"; then
    echo "  ✓ Worker deployed: $WORKER_NAME"
  else
    echo "  ✗ Worker deploy failed" >&2
  fi
fi

echo ""
echo "=== Done ==="
