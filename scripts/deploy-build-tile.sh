#!/usr/bin/env bash
# Deploy the aristotle-builds nginx tile via system-manager.
# Pattern follows ~/pastebin/deploy.sh.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SYSTEM_MANAGER_DIR="${SYSTEM_MANAGER_DIR:-$HOME/projects/system-manager}"
FLAKE="${SM_FLAKE:-git+file://$SYSTEM_MANAGER_DIR?ref=main#systemConfigs.all-services}"

LOG_DIR="$SCRIPT_DIR/logs"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
LOG_FILE="$LOG_DIR/deploy-$TIMESTAMP.log"
mkdir -p "$LOG_DIR"

log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*" | tee -a "$LOG_FILE"; }
run_sudo() { if [ "${EUID}" -eq 0 ]; then "$@"; else sudo "$@"; fi; }

log "=== Aristotle build-tile deploy started ==="
log "Flake: $FLAKE"

# 1. Verify the tile content exists (published by `aristotle-manager publish`).
WEBROOT=/mnt/data1/lake-cache/www/aristotle-builds
[ -f "$WEBROOT/index.html" ] || { log "ERROR: $WEBROOT/index.html missing — run publish first"; exit 1; }
chmod -R a+rX "$WEBROOT"
log "Tile content OK at $WEBROOT"

# 2. Commit the nginx config change in system-manager.
cd "$SYSTEM_MANAGER_DIR"
git add nginx/static.conf
git commit -m "deploy: add /aristotle-builds/ tile (signed build reports)" || true
log "system-manager config committed: $(git rev-parse HEAD)"

# 3. Build + activate the system-manager config.
SM_STORE_PATH="$(nix build --impure "$FLAKE" --no-link --json 2>>"$LOG_FILE" | jq -r '.[0].outputs.out')"
log "Built: $SM_STORE_PATH"

[ -x "$SM_STORE_PATH/bin/activate" ] || { log "ERROR: activate script missing"; exit 1; }

log "Activating system-manager config..."
run_sudo "$SM_STORE_PATH/bin/activate" >>"$LOG_FILE" 2>&1
log "Activation OK"
run_sudo systemctl daemon-reload

# 4. Reload nginx.
run_sudo systemctl reload nginx >>"$LOG_FILE" 2>&1 || run_sudo systemctl restart nginx >>"$LOG_FILE" 2>&1 || log "WARNING: nginx reload failed"

# 5. Verify.
sleep 2
if curl -sk https://127.0.0.1/aristotle-builds/ | grep -q "Aristotle Project Builds"; then
  log "VERIFIED: https://solana.solfunmeme.com/aristotle-builds/ serves the tile"
else
  log "WARNING: tile not reachable yet — check nginx logs"
fi

log "=== Deploy complete ==="
