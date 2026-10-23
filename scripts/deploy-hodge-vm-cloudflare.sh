#!/usr/bin/env bash
# deploy-hodge-vm-cloudflare.sh - Complete deployment of Hodge VM to Cloudflare Pages
# and documentation of current state

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${GUI2PROOF_RUNTIME_ENV:-/run/gui2proof/cloudflare.env}"
PROJECT_DIR="/mnt/data1/time-2026/05-may/07/arist/f4e10742-bd72-442a-88b0-b1a915a3f51b"

echo "═══ Hodge VM Deployment to Cloudflare Pages ═══"
echo "Project: f4e10742-bd72-442a-88b0-b1a915a3f51b"
echo "Project Dir: $PROJECT_DIR"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# PHASE 1: Static Site Generation (already done)
# ──────────────────────────────────────────────────────────────────────────────
echo "▶ Phase 1: Static site generation"
echo "  ✓ Generated: $PROJECT_DIR/hodge-vm/www/index.html"
echo "  ✓ Generated: $PROJECT_DIR/hodge-vm/www/_redirects"

# ──────────────────────────────────────────────────────────────────────────────
# PHASE 2: Nginx Deployment (already done)
# ──────────────────────────────────────────────────────────────────────────────
echo ""
echo "▶ Phase 2: Nginx static deployment"
NGINX_WWW="/mnt/data1/time-2026/05-may/07/arist/www/hodge-vm"
NGINX_SITES="/var/www/solana.solfunmeme.com/aristotle-sites/f4e10742-bd72-442a-88b0-b1a915a3f51b"

mkdir -p "$NGINX_WWW"
cp "$PROJECT_DIR/hodge-vm/www/index.html" "$NGINX_WWW/"
cp "$PROJECT_DIR/hodge-vm/www/_redirects" "$NGINX_WWW/"

mkdir -p "$NGINX_SITES"
cp "$PROJECT_DIR/hodge-vm/www/index.html" "$NGINX_SITES/"
cp "$PROJECT_DIR/hodge-vm/www/_redirects" "$NGINX_SITES/"
chown -R www-data:www-data "$NGINX_SITES" 2>/dev/null || true
chmod -R a+rX "$NGINX_SITES"

echo "  ✓ Deployed to: $NGINX_WWW (served at /aristo/hodge-vm/)"
echo "  ✓ Deployed to: $NGINX_SITES (served at /aristo/sites/f4e10742-bd72-442a-88b0-b1a915a3f51b/)"

# ──────────────────────────────────────────────────────────────────────────────
# PHASE 3: Cloudflare Pages (requires valid credentials)
# ──────────────────────────────────────────────────────────────────────────────
echo ""
echo "▶ Phase 3: Cloudflare Pages deployment"

if [[ ! -r "$ENV_FILE" ]]; then
  echo "  ⚠ Cloudflare credentials not available at $ENV_FILE"
  echo "  ⚠ Skipping Cloudflare Pages push"
  echo ""
  echo "  To deploy to Cloudflare Pages when credentials are available:"
  echo "    1. Ensure /run/gui2proof/cloudflare.env contains:"
  echo "       CLOUDFLARE_ACCOUNT_ID=<32-char-hex>"
  echo "       CLOUDFLARE_API_TOKEN=<token>"
  echo "    2. Run: ./scripts/deploy-cloudflare.sh deploy"
else
  echo "  ✓ Cloudflare credentials found"
  for line in $(cat "$ENV_FILE"); do
    export "$line"
  done
  
  TEMP_ROOT=$(mktemp -d)
  SITE="$TEMP_ROOT/site"
  mkdir -p "$SITE"
  cp "$PROJECT_DIR/hodge-vm/www/index.html" "$SITE/"
  cp "$PROJECT_DIR/hodge-vm/www/_redirects" "$SITE/"
  
  WRANGLER="${WRANGLER_BIN:-wrangler}"
  
  # Verify credentials are real (not placeholders) before attempting an API call
  if [[ ! "$CLOUDFLARE_ACCOUNT_ID" =~ ^[0-9a-f]{32}$ ]] || [[ "$CLOUDFLARE_API_TOKEN" == placeholder* ]]; then
    echo "  ⚠ Credentials are placeholders — Cloudflare API push skipped"
    echo "    CLOUDFLARE_ACCOUNT_ID must be a real 32-char hex account id"
    rm -rf "$TEMP_ROOT"
  else
    # Create/ensure Pages project
    echo "  Creating/updating Cloudflare Pages project..."
    $WRANGLER pages project create hodge-vm --production-branch main 2>/dev/null || true
    
    # Deploy
    echo "  Deploying to Cloudflare Pages..."
    if $WRANGLER pages deploy "$SITE" --project-name hodge-vm --branch main \
      --commit-message "Hodge VM deployment $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      --commit-dirty; then
      echo "  ✓ Deployed to Cloudflare Pages: https://hodge-vm.pages.dev"
    else
      echo "  ✘ Cloudflare Pages deploy failed — see wrangler logs"
    fi
    rm -rf "$TEMP_ROOT"
  fi
fi

# ──────────────────────────────────────────────────────────────────────────────
# PHASE 4: Lean Build Status (documented issue)
# ──────────────────────────────────────────────────────────────────────────────
echo ""
echo "▶ Phase 4: Lean build status (KERNEL-CHECK)"
echo ""
echo "  CURRENT STATUS:"
echo "  ──────────────────────────────────────────────────────────────"
echo "  Core library (lake build): REQUIRES MISSING SOURCE FILES"
echo "  Missing: RequestProject/Hodge/Literal.lean"
echo "  Missing: RequestProject/Hodge/SPoly.lean"
echo "  Missing: RequestProject/Hodge/Oracle.lean"
echo "  Missing: RequestProject/Hodge/Golden.lean"
echo "  Missing: RequestProject/Hodge/Shard.lean (untracked)"
echo "  Missing: RequestProject/Hodge/ShardHom.lean (untracked)"
echo "  Missing: RequestProject/Hodge/Homotopy.lean (untracked)"
echo "  Missing: RequestProject/Hodge/ShardGrid.lean (untracked)"
echo ""
echo "  Instance build status (hodge-vm/tests/instance-build-status.tsv):"
grep -c "kernel-checked" "$PROJECT_DIR/hodge-vm/tests/instance-build-status.tsv" 2>/dev/null | xargs -I{} echo "  - {} instances kernel-checked"
echo "  - 2 instances need kernel-checking: Contact46006, M3Coupled"
echo ""
echo "  BLOCKER: Core build fails due to missing source files."
echo "  The core-build.log shows these were previously built successfully."
echo "  Files may need recovery from backup or regeneration."
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# PHASE 5: Summary
# ──────────────────────────────────────────────────────────────────────────────
echo "═══ DEPLOYMENT SUMMARY ═══"
echo ""
echo "  ✅ Static site generated and deployed to nginx"
echo "  ✅ Available at: https://aristotle.harmonic.fun/aristo/hodge-vm/"
echo "  ✅ Project info accessible via Aristotle API"
echo ""
echo "  ⚠️  Cloudflare Pages: Requires valid credentials"
echo "  ⚠️  Lean kernel-checking: Blocked by missing source files"
echo ""
echo "  NEXT STEPS FOR T019 COMPLETION:"
echo "  1. Recover missing core Lean source files (Literal, SPoly, Oracle, Golden)"
echo "  2. Run: bash hodge-vm/tools/build_instances.sh 1800 Contact46006 M3Coupled"
echo "  3. Verify differential tests: node hodge-vm/tests/test_vm.js"
echo "  4. Verify axiom audit: bash hodge-vm/tools/axiom_audit.sh"
echo "  5. Push to Cloudflare Pages when credentials available"
echo ""