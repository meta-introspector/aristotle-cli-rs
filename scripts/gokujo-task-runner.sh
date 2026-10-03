#!/usr/bin/env bash
# gokujo-task-runner.sh - Task runner for gokujo deployment with SOPS credentials and real-time monitoring
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${SCRIPT_DIR}/.."
OUTPUT_DIR="/mnt/data1/time-2026/05-may/07/arist/output-final_aristotle"
LOG_DIR="${SCRIPT_DIR}/logs"
TASK_LOG="${LOG_DIR}/task_runner.log"
CREDENTIALS_FILE="/run/gui2proof/cloudflare.env"

mkdir -p "${LOG_DIR}"

log() { echo -e "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] TASK-RUNNER: $1" | tee -a "$TASK_LOG"; }

# Initialize task status if not exists
[ ! -f "${LOG_DIR}/task_status.json" ] && cat > "${LOG_DIR}/task_status.json" << 'JSON'
{
  "running": false,
  "current_task": null,
  "queue_length": 0,
  "completed_tasks": [],
  "failed_tasks": [],
  "start_time": null,
  "last_update": null
}
JSON

load_credentials() {
  [ ! -f "$CREDENTIALS_FILE" ] && { log_err "SOPS credentials not found"; return 1; }
  # shellcheck disable=SC1091
  source "$CREDENTIALS_FILE"
  [ -z "${CLOUDFLARE_ACCOUNT_ID:-}" ] && { log_err "Missing CLOUDFLARE_ACCOUNT_ID"; return 1; }
  [ -z "${CLOUDFLARE_API_TOKEN:-}" ] && { log_err "Missing CLOUDFLARE_API_TOKEN"; return 1; }
  log "Loaded Cloudflare credentials"
}

get_project_info() {
  local uuid="$1"
  [ ! -f "${SCRIPT_DIR}/logs/discovery_results.txt" ] && { log_err "Discovery not run"; return 1; }
  while IFS='|' read -r size_bytes name proj_uuid suffix ptype size_h; do
    [ "$proj_uuid" = "$uuid" ] && { echo "$uuid|$name|$ptype"; return 0; }
  done < "${SCRIPT_DIR}/logs/discovery_results.txt"
  log_err "Project not found: $uuid"
  return 1
}

run_project() {
  local uuid="$1"
  local name="$2"
  log "Starting deployment: $uuid ($name)"
  local start_time=$(date +%s)
  node "${SCRIPT_DIR}/aristo-deploy-gokujo.js" deploy "$uuid" 2>&1 | tee -a "$TASK_LOG"
  local end_time=$(date +%s)
  local duration=$((end_time - start_time))
  log "Completed: $uuid in ${duration}s"
}

run_all() {
  load_credentials
  "${SCRIPT_DIR}/gokujo-discover-task.sh" rank >/dev/null 2>&1
  log "Starting batch deployment..."
  while IFS='|' read -r size_bytes name uuid suffix ptype size_h; do
    run_project "$uuid" "$name"
  done < "${SCRIPT_DIR}/logs/discovery_results.txt"
  log "Batch deployment complete"
}

case "${1:-help}" in
  --help|-h)
    cat << 'EOF'
Usage: ./gokujo-task-runner.sh [--run-all|--run-project <uuid>]

Options:
  --run-all     Run all projects ranked by size
  --run-project <uuid>  Run a specific project
  --status      Show task runner status

Examples:
  ./gokujo-task-runner.sh --run-all
  ./gokujo-task-runner.sh --run-project 0f9b0981-1dc9-4321-a46b-53e3cc6ee6e3
EOF
    ;;
  --run-all) run_all ;;
  --run-project)
    [ -z "${2:-}" ] && { echo "Error: UUID required"; exit 1; }
    load_credentials
    local info
    info=$(get_project_info "$2") || exit 1
    run_project "$2" "${info#*|}"
    ;;
  --status) cat "${LOG_DIR}/task_status.json" ;;
  *) echo "Usage: $0 [--help|--run-all|--run-project|--status]" ;;
esac
