#!/usr/bin/env bash
#
# Launch an app on a specific workspace, or focus it if already running
# Usage: launch-or-focus.sh <app_id_or_class> <workspace> <launch_command>
#

APP_ID="$1"
WORKSPACE="$2"
shift 2
LAUNCH_CMD="$@"

# Use jq to properly check if window exists (checks both app_id and class)
WINDOW_EXISTS=$(swaymsg -t get_tree | jq -r ".. | objects | select(.app_id == \"$APP_ID\" or .class == \"$APP_ID\") | .id" | head -1)

if [ -n "$WINDOW_EXISTS" ]; then
    # Window exists - focus it (this also switches to its workspace)
    swaymsg "[app_id=\"$APP_ID\"] focus" 2>/dev/null || \
    swaymsg "[class=\"$APP_ID\"] focus" 2>/dev/null
else
    # Window doesn't exist - switch to workspace and launch
    swaymsg "workspace number $WORKSPACE"
    exec $LAUNCH_CMD
fi
