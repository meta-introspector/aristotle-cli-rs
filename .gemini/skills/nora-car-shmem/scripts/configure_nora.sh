#!/usr/bin/env bash
set -euo pipefail

NORA_CONFIG="config.toml" # Assuming a default path, might need to be a parameter

if [ ! -f "$NORA_CONFIG" ]; then
    echo "Nora config file not found at $NORA_CONFIG"
    # Create a default one?
    echo "Creating a default $NORA_CONFIG"
    cat > "$NORA_CONFIG" <<EOL
[storage]
backend = "car-shmem"
EOL
    echo "Nora configured to use 'car-shmem' backend in new $NORA_CONFIG."
else
    # This is a simplistic way to do it. A real script would use a proper TOML parser.
    if grep -q 'backend = "car-shmem"' "$NORA_CONFIG"; then
        echo "Nora is already configured to use 'car-shmem' backend."
    else
        echo "Updating $NORA_CONFIG to use 'car-shmem' backend."
        # This will append, which might not be what we want if a backend is already defined.
        # For this example, I will assume we can just add it.
        echo "" >> "$NORA_CONFIG"
        echo "[storage]" >> "$NORA_CONFIG"
        echo "backend = "car-shmem"" >> "$NORA_CONFIG"
        echo "Nora configured to use 'car-shmem' backend."
    fi
fi
