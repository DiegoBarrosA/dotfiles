# Dotfiles

Ansible-managed dotfiles for reproducible desktop environments on Ubuntu 24.04 LTS.

## Overview

A modern Sway-based Wayland desktop environment optimized for laptop usage, featuring:

- **Sway** - Tiling Wayland compositor
- **Waybar** - Status bar with power profiles, backlight, network
- **Alacritty** - Terminal with daemon-client model for low memory
- **Firefox** - Browser via Flatpak with Cascade theme
- **Fuzzel** - Application launcher
- **Mako** - Notification daemon
- **Swaylock** - Screen locker

**Integrated with Nix** for CLI tools (fish, helix, zellij, bat, etc.)

All configs use the **Material Darker** theme for consistent styling.

## Architecture

```
Nix (home-manager)           Ansible (this repo)
─────────────────            ───────────────────
CLI/TUI tools only           GUI + System config

├── Shell (fish)             ├── Alacritty terminal
├── Editor (helix)           ├── Firefox (Flatpak)
├── Git, starship            ├── Sway/Waybar configs
├── Modern CLI (bat, fd)     ├── Display management
├── TUI apps (yazi, btm)     ├── VPN/Networking
└── Sway helpers (swayr)     └── System optimization
```

## Prerequisites

- Ubuntu 24.04 LTS (or compatible Debian-based distro)
- Ansible (`sudo apt install ansible`)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/DiegoBarrosA/dotfiles.git ~/dotfiles
cd ~/dotfiles/ansible

# Run the full setup (installs everything)
ansible-playbook -i inventory.yml playbook.yml --ask-become-pass

# Run specific components:
ansible-playbook -i inventory.yml playbook.yml --tags packages --ask-become-pass
ansible-playbook -i inventory.yml playbook.yml --tags config
ansible-playbook -i inventory.yml playbook.yml --tags nix
```

## Features

### Laptop Optimizations
- **zram** - Compressed swap in RAM
- **sysctl tuning** - Optimized for SSD and laptop usage
- **thermald** - Thermal management (Intel CPUs)
- **power-profiles-daemon** - Power profile switching
- **wlsunset** - Blue light filter

### Multi-VPN Support
- systemd-resolved with split-horizon DNS
- Tailscale + work VPN coexistence
- No DNS conflicts between VPNs

### Desktop Features
- **kanshi** - Automatic display profile switching
- **Bluetooth** - blueman GUI manager
- **Clipboard** - cliphist with fuzzel integration
- **Screenshots** - grim/slurp with menu
- **Screen recording** - wf-recorder

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `$mod+Return` | Terminal (Alacritty) |
| `$mod+Space` | Application launcher |
| `$mod+f` | Firefox |
| `$mod+e` | File manager |
| `$mod+v` | Clipboard history |
| `$mod+Shift+n` | Network manager (nmtui) |
| `$mod+Shift+b` | Bluetooth manager |
| `$mod+Shift+d` | Display settings |
| `$mod+Print` | Screenshot menu |
| `$mod+Shift+r` | Screen recording |
| `$mod+Escape` | Lock screen |
| `$mod+Shift+e` | Power menu |

## Repository Structure

```
dotfiles/
├── ansible/
│   ├── playbook.yml          # Main deployment playbook
│   ├── inventory.yml         # Host definitions
│   ├── flatpaks.yml          # Flatpak app list
│   └── roles/
│       ├── nix/              # Nix + home-manager
│       ├── packages/         # System packages
│       ├── system-optimization/  # zram, sysctl
│       ├── networking/       # NetworkManager, VPN
│       ├── alacritty/        # Terminal
│       ├── firefox/          # Browser + Cascade theme
│       ├── flatpaks/         # Flatpak management
│       ├── sway/             # Window manager
│       ├── waybar/           # Status bar
│       └── ...
├── configs/
│   ├── sway/                 # Sway config + scripts
│   ├── waybar/               # Waybar configs
│   ├── kanshi/               # Display profiles
│   └── ...
└── themes/
    └── material-darker.yml   # Theme colors
```

## Nix Integration

CLI tools are managed via [nix-config](https://github.com/DiegoBarrosA/nix-config):

```bash
# After Ansible deployment, Nix is installed automatically
# CLI tools available: fish, helix, bat, fd, ripgrep, fzf, yazi, zellij, etc.

# Update CLI tools:
cd ~/nix-config
home-manager switch --flake .#rubi
```

## Adding Flatpak Apps

Edit `ansible/flatpaks.yml`:

```yaml
flatpaks:
  browsers:
    - org.mozilla.firefox
  communication:
    - com.slack.Slack
  media:
    - org.videolan.VLC
```

Then run:
```bash
ansible-playbook -i inventory.yml playbook.yml --tags flatpaks
```

## Customization

### Theme Colors
Edit `themes/material-darker.yml` to customize colors.

### Display Profiles
Edit `configs/kanshi/config` for your monitor setup.

### Per-Machine Variables
Create `ansible/host_vars/your-hostname.yml` for machine-specific settings.

## Troubleshooting

### VPN DNS Issues
```bash
# Check DNS routing
resolvectl status

# Debug queries
resolvectl query example.com
```

### Display Issues
```bash
# List outputs
swaymsg -t get_outputs

# Check kanshi profiles
kanshi
```

### Nix Issues
```bash
# Rebuild home-manager
home-manager switch --flake ~/nix-config#rubi --show-trace
```

## License

MIT
