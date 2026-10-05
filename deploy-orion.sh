#!/usr/bin/env bash
# deploy-orion.sh - Deploy Aristotle project to Cloudflare Pages as "orion"
#
# Usage: ./deploy-orion.sh [PROJECT_ID] [--latest] [--dry-run] [--build]
#   PROJECT_ID    Specific project UUID to deploy (default: 17da0589-2bfc-44c4-8169-dbdb61676da2)
#   --latest      Fetch latest completed project from Aristotle API
#   --dry-run     Show what would happen; do not deploy to Cloudflare
#   --build       Force rebuild deployment bundle
#
# Version: 1.1
#   - Added --latest flag to auto-fetch newest result
#   - Added version history comments
#   - Improved dry-run output
#
# Example:
#   ./deploy-orion.sh                    # deploy hardcoded project
#   ./deploy-orion.sh --latest           # deploy newest result
#   ./deploy-orion.sh UUID --build       # deploy specific project with fresh bundle
#
set -euo pipefail

# Configuration
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
RESULTS_DIR="${BASE_DIR}/output-final_aristotle"
CLI="${BASE_DIR}/target/release/aristotle-manager"
SOPS_REGISTRY="/mnt/data1/kant/pastebin/.sops/registry.sops.yaml"
AGE_KEY_FILE="/home/mdupont/.config/sops/age/keys.txt"
DEFAULT_PROJECT_ID="17da0589-2bfc-44c4-8169-dbdb61676da2"
PROJECT_NAME="orion"

# Parse arguments
PROJECT_ID="${DEFAULT_PROJECT_ID}"
USE_LATEST=0
DRY_RUN=0
FORCE_BUILD=0

while [[ $# -gt 0 ]]; do
    case $1 in
        --latest)
            USE_LATEST=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --build)
            FORCE_BUILD=1
            shift
            ;;
        --help)
            echo "Usage: $0 [PROJECT_ID] [--latest] [--dry-run] [--build]"
            echo "  Deploy Aristotle project to Cloudflare Pages as 'orion'"
            echo ""
            echo "Arguments:"
            echo "  PROJECT_ID    Specific project UUID to deploy (default: ${DEFAULT_PROJECT_ID})"
            echo "  --latest      Fetch latest completed project from Aristotle API"
            echo "  --dry-run     Show what would happen; do not deploy to Cloudflare"
            echo "  --build       Force rebuild deployment bundle"
            exit 0
            ;;
        *)
            if [[ $1 =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
                PROJECT_ID=$1
                shift
            else
                echo "ERROR: Invalid argument '$1' (use --help for usage)"
                exit 1
            fi
            ;;
    esac
done

echo "=== Deploying Aristotle project as '${PROJECT_NAME}' ==="
echo "  Project ID: ${PROJECT_ID}"
echo "  Latest flag: ${USE_LATEST}"
echo "  Dry run: ${DRY_RUN}"
echo "  Force build: ${FORCE_BUILD}"

# Get Cloudflare credentials from SOPS
if [ ! -f "${SOPS_REGISTRY}" ]; then
    echo "ERROR: SOPS registry not found at ${SOPS_REGISTRY}"
    exit 1
fi
export SOPS_AGE_KEY_FILE="${AGE_KEY_FILE}"
CLOUDFLARE_ACCOUNT_ID=$(sops -d "${SOPS_REGISTRY}" 2>/dev/null | grep '^CLOUDFLARE_ACCOUNT_ID:' | cut -d' ' -f2)
CLOUDFLARE_API_TOKEN=$(sops -d "${SOPS_REGISTRY}" 2>/dev/null | grep '^CLOUDFLARE_API_TOKEN:' | cut -d' ' -f2)

if [ -z "${CLOUDFLARE_ACCOUNT_ID}" ] || [ -z "${CLOUDFLARE_API_TOKEN}" ]; then
    echo "ERROR: Failed to extract credentials from SOPS registry"
    exit 1
fi

# If --latest flag is set, fetch the latest project ID
if [ "${USE_LATEST}" = "1" ]; then
    echo "[0/4] Fetching latest completed project from Aristotle API..."
    if [ ! -x "${CLI}" ]; then
        echo "ERROR: aristotle-manager binary not found. Run 'cargo build --release' first."
        exit 1
    fi
    # Use poll command with verbose to get project list, then extract most recent
    PROJECT_ID=$("${CLI}" poll --verbose --limit 1 2>/dev/null | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1)
    if [ -z "${PROJECT_ID}" ]; then
        echo "WARNING: Could not determine latest project from poll output, falling back to download-result with limit"
        # Alternative: get list of results and pick the most recent by timestamp
        "${CLI}" download --limit 1 --verbose 2>&1 | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1 || {
            echo "ERROR: Failed to get latest project ID"
            exit 1
        }
    fi
    echo "  Latest project ID: ${PROJECT_ID}"
fi

# Ensure project exists locally (download if needed)
DEPLOY_DIR="${RESULTS_DIR}/${PROJECT_ID}_deployed"
PROJECT_DIR="${RESULTS_DIR}/${PROJECT_ID}_aristotle/output-final_aristotle"

if [ ! -d "${PROJECT_DIR}" ] || [ "${FORCE_BUILD}" = "1" ]; then
    if [ ! -d "${PROJECT_DIR}" ]; then
        echo "[1/4] Downloading project from Aristotle API..."
    else
        echo "[1/4] Rebuilding project bundle (--build flag)..."
    fi
    
    if [ ! -x "${CLI}" ]; then
        echo "ERROR: aristotle-manager binary not found. Run 'cargo build --release' first."
        exit 1
    fi
    
    "${CLI}" deploy "${PROJECT_ID}" --output-dir "${RESULTS_DIR}"
    
    if [ ! -d "${PROJECT_DIR}" ]; then
        echo "ERROR: Failed to download/prepare project ${PROJECT_ID}"
        exit 1
    fi
else
    echo "[1/4] Using existing bundle: ${DEPLOY_DIR}"
    echo "[1/4] (skip — rerun with --build to force rebuild)"
fi

# Determine deploy path
if [ -d "${DEPLOY_DIR}/site" ]; then
    DEPLOY_PATH="${DEPLOY_DIR}/site"
    echo "[2/4] Using site/ subdirectory"
else
    DEPLOY_PATH="${DEPLOY_DIR}"
    echo "[2/4] Using root directory"
fi

# Dry run output
if [ "${DRY_RUN}" = "1" ]; then
    echo "[3/4] [DRY RUN] Would deploy to Cloudflare Pages:"
    echo "  Project: ${PROJECT_NAME}"
    echo "  Account ID: ${CLOUDFLARE_ACCOUNT_ID}"
    echo "  Deploy path: ${DEPLOY_PATH}"
    echo "  Wrangler command:"
    echo "    export CLOUDFLARE_ACCOUNT_ID=${CLOUDFLARE_ACCOUNT_ID}"
    echo "    export CLOUDFLARE_API_TOKEN=<hidden>"
    echo "    wrangler pages deploy ${DEPLOY_PATH} --project-name ${PROJECT_NAME} --commit-dirty=true"
    exit 0
fi

# Deploy to Cloudflare Pages
export CLOUDFLARE_ACCOUNT_ID
export CLOUDFLARE_API_TOKEN

echo "[3/4] Ensuring Cloudflare Pages project '${PROJECT_NAME}' exists..."
wrangler pages project create "${PROJECT_NAME}" --production-branch main 2>/dev/null || true

echo "[3/4] Deploying to Cloudflare Pages..."
wrangler pages deploy "${DEPLOY_PATH}" \
    --project-name "${PROJECT_NAME}" \
    --commit-dirty=true

echo "[4/4] Success!"
echo "   Project: ${PROJECT_NAME}"
echo "   Account: ${CLOUDFLARE_ACCOUNT_ID}"
echo "   Deployment alias: https://${PROJECT_NAME}.pages.dev"
echo "   Source: ${PROJECT_ID}"
echo "   Bundle: ${DEPLOY_PATH}"