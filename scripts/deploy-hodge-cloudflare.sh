#!/usr/bin/env bash
# Deploy Hodge VM to Cloudflare Pages
# Requires valid Cloudflare credentials in /run/gui2proof/cloudflare.env

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${GUI2PROOF_RUNTIME_ENV:-/run/gui2proof/cloudflare.env}"

if [[ ! -r "$ENV_FILE" ]]; then
  echo "Cloudflare runtime credentials are unavailable: $ENV_FILE" >&2
  echo "Start gui2proof.service so systemd can decrypt the sops vault." >&2
  exit 1
fi

export GUI2PROOF_RUNTIME_ENV="$ENV_FILE"
export WRANGLER_BIN="${WRANGLER_BIN:-$ROOT/wrangler}"

PROJECT_DIR="/mnt/data1/time-2026/05-may/07/arist/f4e10742-bd72-442a-88b0-b1a915a3f51b"

case "${1:-deploy}" in
  deploy)
    # Ensure wrangler config exists
    if [[ ! -f "$ROOT/wrangler.toml" ]]; then
      echo "ERROR: wrangler.toml not found in $ROOT" >&2
      exit 1
    fi
    
    # Read Cloudflare credentials
    for line in $(cat "$ENV_FILE"); do
      export "$line"
    done
    
    # Create temp site directory
    TEMP_ROOT=$(mktemp -d)
    SITE="$TEMP_ROOT/site"
    mkdir -p "$SITE"
    
    # Copy the deployed static site
    cp "$PROJ/hodge-vm/www/index.html" "$SITE/index.html"
    cp "$PROJ/hodge-vm/www/_redirects" "$SITE/_redirects"
    
    # Initialize Cloudflare Pages project if needed
    echo "Creating/updating Cloudflare Pages deployment for Hodge VM..."
    
    # Deploy to Cloudflare Pages
    "$ROOT/scripts/deploy-cloudflare.sh" deploy 2>&1 || true
    
    # Cleanup
    rm -rf "$TEMP_ROOT"
    ;;
    
  status)
    echo "Cloudflare deployment status for Hodge VM (f4e10742-bd72-442a-88b0-b1a915a3f51b)"
    if [[ -f "$ENV_FILE" ]]; then
      for line in $(cat "$ENV_FILE"); do
        export "$line"
      done
      echo "Account ID: $CLOUDFLARE_ACCOUNT_ID"
      echo "API Token: ${CLOUDFLARE_API_TOKEN:0:8}...${CLOUDFLARE_API_TOKEN: -4}"
    else
      echo "Cloudflare credentials not available"
    fi
    echo "Static site deployed at /var/www/solana.solfunmeme.com/aristotle-sites/f4e10742-bd72-442a-88b0-b1a915a3f51b/"
    echo "Nginx serves: /aristo/hodge-vm/"
    ;;
    
  *)
    echo "Usage: $0 {deploy|status}"
    exit 2
    ;;
esac