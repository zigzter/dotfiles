# My dotfiles

Requires `stow`. Only tested on Arch Linux (btw). Split between my laptop and desktop setups.

1. Clone repo
2. CD in, and run `make` (If you're not me, you'll probably have to edit the Makefile with the appropriate machine names)


## Install process
[Install Arch](https://wiki.archlinux.org/title/Installation_guide)
- When running the `pacstrap` command, add `${amd | intel}-ucode`, `networkmanager`, `base-devel`
- Once chrooted into install, enable NetworkManager with `systemctl enable --now NetworkManager.service`
- Run `install.sh`
