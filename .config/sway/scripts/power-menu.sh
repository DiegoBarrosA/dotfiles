#!/usr/bin/env bash
#
# Power menu using fuzzel
#

OPTIONS=" Lock\n Logout\n Suspend\n Reboot\n Shutdown"

CHOICE=$(echo -e "$OPTIONS" | fuzzel --dmenu --prompt "Power: ")

case "$CHOICE" in
    *"Lock")
        swaylock -f
        ;;
    *"Logout")
        swaymsg exit
        ;;
    *"Suspend")
        swaylock -f && systemctl suspend
        ;;
    *"Reboot")
        systemctl reboot
        ;;
    *"Shutdown")
        systemctl poweroff
        ;;
esac






