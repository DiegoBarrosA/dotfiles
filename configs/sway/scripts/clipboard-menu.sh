#!/bin/bash
# Clipboard history menu using fuzzel and cliphist
# Requires: cliphist, wl-clipboard, fuzzel

cliphist list | fuzzel --dmenu --prompt "Clipboard: " | cliphist decode | wl-copy
