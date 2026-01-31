#!/bin/bash
# Legacy script - now calls the toggle-virtual-outputs.sh script
# This maintains backward compatibility while using the proper Sway implementation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOGGLE_SCRIPT="$SCRIPT_DIR/toggle-virtual-outputs.sh"

if [ ! -f "$TOGGLE_SCRIPT" ]; then
    echo "Error: toggle-virtual-outputs.sh not found at $TOGGLE_SCRIPT" >&2
    echo "Please deploy the script using Ansible or copy it manually." >&2
    exit 1
fi

exec "$TOGGLE_SCRIPT"
