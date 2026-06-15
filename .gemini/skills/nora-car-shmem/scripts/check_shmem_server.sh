#!/usr/bin/env bash
set -euo pipefail

if pgrep -f "ipld-car-shmem-server" > /dev/null; then
    echo "✅ ipld-car-shmem-server is running."
    dasl-shmem-client stats
else
    echo "❌ ipld-car-shmem-server is not running."
    echo "Please start it with 'ipld-car-shmem-server &'"
    exit 1
fi
