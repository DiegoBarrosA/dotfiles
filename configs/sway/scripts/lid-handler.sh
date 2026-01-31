#!/bin/bash
# Intelligent lid switch handler for Sway
# Don't suspend if external monitor is connected

# Check for external monitors (anything that's not eDP-1)
EXTERNAL_MONITORS=$(swaymsg -t get_outputs | jq -r '.[] | select(.name != "eDP-1" and .active == true) | .name')

if [ -n "$EXTERNAL_MONITORS" ]; then
    # External monitor connected - just lock, don't suspend
    swaylock -f
    # Optionally disable internal display
    # swaymsg output eDP-1 disable
else
    # No external monitor - lock and suspend
    swaylock -f && systemctl suspend
fi
