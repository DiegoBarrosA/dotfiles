#!/bin/bash
# Screenshot menu using fuzzel, grim, and slurp
# Requires: grim, slurp, wl-copy, fuzzel, jq

OPTIONS="󰹑 Full Screen (clipboard)
󰩭 Selection (clipboard)
󰆞 Window (clipboard)
󰋩 Full Screen (save)
󰩭 Selection (save)
 Cancel"

CHOICE=$(echo -e "$OPTIONS" | fuzzel --dmenu --prompt "Screenshot: ")

SCREENSHOT_DIR="${HOME}/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILENAME="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

case "$CHOICE" in
    *"Full Screen (clipboard)"*)
        grim - | wl-copy
        notify-send "Screenshot" "Full screen copied to clipboard"
        ;;
    *"Selection (clipboard)"*)
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot" "Selection copied to clipboard"
        ;;
    *"Window (clipboard)"*)
        grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | wl-copy
        notify-send "Screenshot" "Window copied to clipboard"
        ;;
    *"Full Screen (save)"*)
        grim "$FILENAME"
        notify-send "Screenshot" "Saved to $FILENAME"
        ;;
    *"Selection (save)"*)
        grim -g "$(slurp)" "$FILENAME"
        notify-send "Screenshot" "Saved to $FILENAME"
        ;;
esac
