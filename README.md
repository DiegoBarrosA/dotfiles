# Dotfiles

Ansible-managed dotfiles for reproducible desktop environments on Ubuntu.

## Overview

This repository contains configurations for a Sway-based desktop environment with:
- **Sway** - Tiling Wayland compositor
- **Waybar** - Status bar
- **Alacritty** - GPU-accelerated terminal
- **Fuzzel** - Application launcher
- **Mako** - Notification daemon
- **Swaylock** - Screen locker

All configs use the **Material Darker** theme for consistent styling.

## Prerequisites

- Ubuntu 22.04+ (or other Debian-based distro)
- Ansible (`sudo apt install ansible`)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles/ansible

# Run the full setup (installs packages + deploys configs)
ansible-playbook -i inventory.yml playbook.yml --ask-become-pass

# Or run with specific tags:
# Packages only
ansible-playbook -i inventory.yml playbook.yml --tags packages --ask-become-pass

# Configs only (no sudo needed)
ansible-playbook -i inventory.yml playbook.yml --tags config
```

## Repository Structure

```
dotfiles/
├── ansible/
│   ├── playbook.yml           # Main deployment playbook
│   ├── inventory.yml          # Host definitions
│   └── roles/
│       ├── packages/          # System package installation
│       ├── sway/              # Sway window manager
│       ├── waybar/            # Status bar
│       ├── alacritty/         # Terminal emulator
│       ├── mako/              # Notification daemon
│       ├── fuzzel/            # Application launcher
│       ├── swaylock/          # Screen locker
│       ├── gtk/               # GTK theming
│       └── fonts/             # Font installation
├── configs/                   # Static config files (for reference)
└── themes/
    └── material-darker.yml    # Theme color definitions
```

## Customization

### Changing the Theme

Edit `themes/material-darker.yml` to customize colors. The Ansible templates use these values to generate configs.

### Per-Machine Customization

Create host-specific variables in `ansible/host_vars/` to override defaults for specific machines.

## Manual Installation

If you prefer not to use Ansible, you can manually symlink configs:

```bash
# Example: symlink sway config
mkdir -p ~/.config/sway
ln -sf ~/dotfiles/configs/sway/config ~/.config/sway/config
```

## Integration with Nix

This dotfiles repo is designed to work alongside a Nix-based setup:

- **CLI tools** are managed via Nix home-manager (fish, helix, starship, etc.)
- **Desktop configs** are managed here via Ansible

This allows reproducible CLI environments across all machines (including NixOS) while maintaining portable desktop configs for Ubuntu work machines.

## License

MIT
