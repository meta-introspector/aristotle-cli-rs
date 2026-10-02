#!/usr/bin/env bash
# gokujo-discover-task.sh - Discover and rank Aristo projects by size for gokujo deployment
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${SCRIPT_DIR}/.."
OUTPUT_DIR="/mnt/data1/time-2026/05-may/07/arist/output-final_aristotle"
LOG_FILE="${SCRIPT_DIR}/logs/discovery.log"

mkdir -p "${LOG_DIR:-${SCRIPT_DIR}/logs}"

log() { echo -e "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] INFO: $1" | tee -a "$LOG_FILE"; }

discover_projects() {
  log "Discovering Aristotle projects in ${OUTPUT_DIR}..."
  
  local sorted_projects=()
  
  for dir in "${OUTPUT_DIR}"/*_aristotle "${OUTPUT_DIR}"/*_deployed; do
    if [ -d "$dir" ]; then
      local name=$(basename "$dir")
      local size=$(du -sb "$dir" 2>/dev/null | cut -f1)
      local size_human=$(du -sh "$dir" 2>/dev/null | cut -f1)
      local uuid=$(echo "$name" | grep -oE '^[0-9a-f-]{36}')
      local suffix=$(echo "$name" | sed "s/${uuid}_//")
      
      local ptype="unknown"
      [ -d "$dir/webapp" ] && ptype="web-app"
      [ -d "$dir/RequestProject" ] && ptype="theorem-prover"
      [ -f "$dir/PASS1_STATUS.md" ] && ptype="research-manager"
      
      sorted_projects+=("${size}|${name}|${uuid}|${suffix}|${ptype}|${size_human}")
    fi
  done
  
  # Sort by size (largest first)
  IFS=$'\n' sorted=($(printf '%s\n' "${sorted_projects[@]}" | sort -t'|' -k1 -nr)); unset IFS
  
  printf "%-5s %-12s %-10s %-45s %-20s\n" "Rank" "UUID" "Type" "Directory" "Size"
  printf "%-5s %-12s %-10s %-45s %-20s\n" "----" "----" "----" "--------" "----"
  
  local rank=1
  for project in "${sorted[@]}"; do
    IFS='|' read -r size_bytes name uuid suffix ptype size <<< "$project"
    printf "%-5s %-12s %-10s %-45s %-20s\n" "$rank" "${uuid:0:12}..." "$ptype" "$name" "$size"
    ((rank++))
  done
  
  echo "" > "${SCRIPT_DIR}/logs/discovery_results.txt"
  printf '%s\n' "${sorted[@]}" >> "${SCRIPT_DIR}/logs/discovery_results.txt"
  log "Discovery complete: ${#sorted[@]} projects found"
}

run_all() {
  log "Starting discovery..."
  discover_projects
  log "Discovery complete"
}

case "${1:-rank}" in
  rank) discover_projects ;;
  run) run_all ;;
  *) echo "Usage: $0 [rank|run]" ;;
esac
