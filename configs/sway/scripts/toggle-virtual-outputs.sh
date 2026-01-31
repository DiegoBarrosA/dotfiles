#!/usr/bin/env bash
#
# Toggle virtual outputs HEADLESS-1 and HEADLESS-2 in Sway WM
# Creates outputs if they don't exist, then toggles their enabled/disabled state
#

OUTPUT1="HEADLESS-1"
OUTPUT2="HEADLESS-2"
MODE="1920x1080"
POS1="0,0"
POS2="1920,0"
IMMERSED_APPIMAGE="$HOME/.local/bin/Immersed-x86_64.AppImage"

# Check if an output exists
output_exists() {
    local output_name="$1"
    swaymsg -t get_outputs | jq -r '.[].name' | grep -qx "$output_name"
}

# Check if an output is active (enabled)
output_is_active() {
    local output_name="$1"
    local active=$(swaymsg -t get_outputs | jq -r --arg name "$output_name" '.[] | select(.name == $name) | .active')
    [ "$active" = "true" ]
}

# Create an output if it doesn't exist
create_output_if_needed() {
    local output_name="$1"
    if ! output_exists "$output_name"; then
        echo "Creating output: $output_name"
        swaymsg create_output "$output_name"
        # Small delay to allow Sway to detect the new output
        sleep 0.2
    fi
}

# Find Immersed AppImage (check common locations and patterns)
find_immersed_appimage() {
    # Check the configured path first
    if [ -f "$IMMERSED_APPIMAGE" ]; then
        echo "$IMMERSED_APPIMAGE"
        return 0
    fi
    
    # Try to find any Immersed AppImage in ~/.local/bin
    local found=$(find "$HOME/.local/bin" -name "Immersed*.AppImage" -type f 2>/dev/null | head -1)
    if [ -n "$found" ]; then
        echo "$found"
        return 0
    fi
    
    return 1
}

# Check if Immersed is running
immersed_is_running() {
    pgrep -x "Immersed" >/dev/null 2>&1 || pgrep -f "Immersed.*AppImage" >/dev/null 2>&1
}

# Kill Immersed process
kill_immersed() {
    if immersed_is_running; then
        echo "Stopping Immersed..."
        pkill -x "Immersed" 2>/dev/null || pkill -f "Immersed.*AppImage" 2>/dev/null
        # Wait a moment for process to terminate
        sleep 0.5
        echo "Immersed stopped"
    fi
}

# Start Immersed AppImage
start_immersed() {
    local appimage_path=$(find_immersed_appimage)
    if [ -z "$appimage_path" ]; then
        echo "Warning: Immersed AppImage not found. Skipping Immersed startup."
        echo "  Expected location: $IMMERSED_APPIMAGE"
        return 1
    fi
    
    if immersed_is_running; then
        echo "Immersed is already running"
        return 0
    fi
    
    echo "Starting Immersed..."
    "$appimage_path" >/dev/null 2>&1 &
    sleep 1
    if immersed_is_running; then
        echo "Immersed started"
        return 0
    else
        echo "Warning: Failed to start Immersed"
        return 1
    fi
}

# Enable and configure both outputs
enable_outputs() {
    echo "Enabling virtual outputs..."
    
    # Create outputs if they don't exist
    create_output_if_needed "$OUTPUT1"
    create_output_if_needed "$OUTPUT2"
    
    # Configure HEADLESS-1: mode, position, then enable
    swaymsg output "$OUTPUT1" mode "$MODE"
    swaymsg output "$OUTPUT1" position "$POS1"
    swaymsg output "$OUTPUT1" enable
    
    # Configure HEADLESS-2: mode, position, then enable
    swaymsg output "$OUTPUT2" mode "$MODE"
    swaymsg output "$OUTPUT2" position "$POS2"
    swaymsg output "$OUTPUT2" enable
    
    echo "Virtual outputs enabled:"
    echo "  $OUTPUT1 at position $POS1 with mode $MODE"
    echo "  $OUTPUT2 at position $POS2 with mode $MODE"
    
    # Start Immersed after enabling outputs
    start_immersed
}

# Disable both outputs
disable_outputs() {
    echo "Disabling virtual outputs..."
    
    # Kill Immersed before disabling outputs
    kill_immersed
    
    if output_exists "$OUTPUT1"; then
        swaymsg output "$OUTPUT1" disable
    fi
    
    if output_exists "$OUTPUT2"; then
        swaymsg output "$OUTPUT2" disable
    fi
    
    echo "Virtual outputs disabled"
}

# Main toggle logic
toggle_outputs() {
    # Check if at least one output exists and is active
    # If either output exists and is active, we should disable; otherwise enable
    local should_disable=false
    
    if output_exists "$OUTPUT1" && output_is_active "$OUTPUT1"; then
        should_disable=true
    elif output_exists "$OUTPUT2" && output_is_active "$OUTPUT2"; then
        should_disable=true
    fi
    
    # If either output is active, disable both; otherwise enable both
    if [ "$should_disable" = true ]; then
        disable_outputs
    else
        enable_outputs
    fi
}

# Run the toggle
toggle_outputs
