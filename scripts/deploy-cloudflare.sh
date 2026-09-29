#!/usr/bin/env bash
set -euo pipefail

# Deploy through the systemd/sops credential path.  Never source or print the
# credential file; the Node helper reads it in-process and emits only metadata.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${GUI2PROOF_RUNTIME_ENV:-/run/gui2proof/cloudflare.env}"
NODE_BIN="${NODE_BIN:-node}"

if [[ ! -r "$ENV_FILE" ]]; then
  echo "Cloudflare runtime credentials are unavailable: $ENV_FILE" >&2
  echo "Start gui2proof.service so systemd can decrypt the sops vault." >&2
  exit 1
fi

export GUI2PROOF_RUNTIME_ENV="$ENV_FILE"
export WRANGLER_BIN="${WRANGLER_BIN:-$ROOT/wrangler}"

case "${1:-deploy}" in
  deploy)
    exec "$NODE_BIN" "$ROOT/scripts/deploy-aristo-pages.mjs"
    ;;
  record)
    export GUI2PROOF_REAL_DEPLOY=1
    exec "$NODE_BIN" "$ROOT/gui2lean4/capture-proof.mjs"
    ;;
  *)
    echo "usage: $0 [deploy|record]" >&2
    exit 2
    ;;
esac
