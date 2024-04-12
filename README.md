# My dotfiles

Requires `stow`. Only tested on Arch Linux (btw).

1. Clone repo
2. CD in, and run `stow .`

Some features:
- Window manager: `hyprland`
- Status bar: `waybar`
- Logout menu: `wlogout`
- Terminal: `kitty`
- Launcher: `wofi`
- Editor: `neovim` (btw)

## Install process
[Install Arch](https://wiki.archlinux.org/title/Installation_guide)
- When running the `pacstrap` command, add `${amd | intel}-ucode`, `networkmanager`, `base-devel`
- Once chrooted into install, enable NetworkManager with `systemctl enable --now NetworkManager.service`
Run `install.sh`
