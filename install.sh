#!/usr/bin/env bash
#
# Dotfiles installation script
# Creates symlinks from ~/.config to the dotfiles repository
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"

# Configs to link (relative to .config)
CONFIGS=(
    "fuzzel"
    "waybar"
    "sway"
    "swaylock"
    "mako"
    "gtk-3.0"
    "gtk-4.0"
    "ghostty"
)

info() {
    printf '\033[0;34m[INFO]\033[0m %s\n' "$1"
}

success() {
    printf '\033[0;32m[OK]\033[0m %s\n' "$1"
}

warn() {
    printf '\033[0;33m[WARN]\033[0m %s\n' "$1"
}

error() {
    printf '\033[0;31m[ERROR]\033[0m %s\n' "$1"
}

backup_and_link() {
    local config="$1"
    local source="${DOTFILES_DIR}/.config/${config}"
    local target="${CONFIG_DIR}/${config}"

    if [[ ! -e "$source" ]]; then
        error "Source does not exist: $source"
        return 1
    fi

    # If target is already a symlink pointing to our source, skip
    if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
        success "$config already linked"
        return 0
    fi

    # Backup existing config if it exists and is not a symlink
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Backing up existing $config to $backup"
        mv "$target" "$backup"
    fi

    # Create symlink
    ln -s "$source" "$target"
    success "Linked $config"
}

main() {
    info "Dotfiles directory: $DOTFILES_DIR"
    info "Config directory: $CONFIG_DIR"
    echo

    # Ensure .config exists
    mkdir -p "$CONFIG_DIR"

    for config in "${CONFIGS[@]}"; do
        backup_and_link "$config"
    done

    echo
    info "Installation complete!"
    info "Reload sway with \$mod+Shift+c to apply changes"
}

main "$@"

