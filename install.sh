#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Usage: source this script, then call a function."
    echo ""
    echo "  source install.sh"
    echo "  main                # full bootstrap"
    echo "  setup_secureboot    # Secure Boot setup only"
    exit 1
fi

MACHINE=$(hostnamectl hostname)
CURRENT_USER=$(whoami)
NERD_FONTS_VERSION="v3.2.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# audit/ and sddm/ aren't stow packages — they install to /etc and /usr/share, not
# $HOME — so their files turn up in one of three places depending on how the script
# got here: beside it in a clone, in a clone elsewhere while the script was curled
# to $HOME on its own (reinstall guide §11), or flattened into $HOME root by a stray
# `stow audit` / `stow sddm`, which drops the package's contents rather than the
# package itself.
find_asset() {
    local rel="$1" candidate
    for candidate in "$SCRIPT_DIR/$rel" "$HOME/dotfiles/$rel" "$HOME/${rel##*/}"; do
        if [[ -e "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return
        fi
    done
    echo "ERROR: could not locate $rel. Looked beside the script ($SCRIPT_DIR), in \$HOME/dotfiles, and in \$HOME." >&2
    return 1
}

PKGS_BASE=(
    git stow openssh which
    man-db man-pages networkmanager-dmenu
    zsh tmux neovim fzf ripgrep bat btop lsd fastfetch
    nodejs postgresql-libs
    python python-pip python-virtualenv
    firefox unzip jq zoxide
    docker docker-compose
    upower power-profiles-daemon
    ttf-font-awesome noto-fonts noto-fonts-emoji
    v4l-utils obsidian loupe vlc
)

PKGS_HYPRLAND=(
    hyprland waybar hyprpaper hyprlock hypridle
    qt5-wayland qt6-wayland qt6-svg qt6-declarative
    swaync
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-user-dirs
    polkit polkit-gnome
    nwg-look qt5ct qt6ct
    network-manager-applet wf-recorder dex sddm
)

PKGS_AUDIO=(
    pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol
)

PKGS_WAYLAND_UTILS=(
    wl-clipboard cliphist
    grim slurp
    playerctl
)

PKGS_BLUETOOTH=(
    bluez bluez-utils blueman
)

PKGS_FILES=(
    thunar gvfs gvfs-smb
)

install_yay() (
    set -e
    if command -v yay &>/dev/null; then
        echo "yay already installed, skipping..."
        return
    fi
    git clone https://aur.archlinux.org/yay.git "$HOME/yay"
    cd "$HOME/yay"
    makepkg -si --noconfirm
    cd "$HOME"
    rm -rf "$HOME/yay"
)

install_base_packages() (
    set -e
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm --needed "${PKGS_BASE[@]}"
)

install_packages() (
    set -e
    sudo pacman -S --noconfirm --needed \
        "${PKGS_HYPRLAND[@]}" \
        "${PKGS_AUDIO[@]}" \
        "${PKGS_WAYLAND_UTILS[@]}" \
        "${PKGS_BLUETOOTH[@]}" \
        "${PKGS_FILES[@]}"
    yay -S --noconfirm ghostty oh-my-posh rofi-wayland swayosd datagrip datagrip-jre discord spotify
)

install_microcode() (
    set -e
    # the bootloader entry needs a matching `initrd /<vendor>-ucode.img` line too, that's written at install time, not from here
    if [[ "$MACHINE" == "DANGERDOOM" ]]; then
        sudo pacman -S --noconfirm --needed amd-ucode
    elif [[ "$MACHINE" == "MADVILLAIN" ]]; then
        sudo pacman -S --noconfirm --needed intel-ucode
    fi
)

install_gpu_drivers() (
    set -e
    if [[ "$MACHINE" == "DANGERDOOM" ]]; then
        sudo pacman -S --noconfirm --needed nvidia-open-dkms nvidia-utils dkms \
            linux-headers linux-lts-headers
    elif [[ "$MACHINE" == "MADVILLAIN" ]]; then
        sudo pacman -S --noconfirm --needed mesa vulkan-intel intel-media-driver
    fi
)

install_fonts() (
    set -e
    local tmp_dir
    tmp_dir=$(mktemp -d)
    mkdir -p "$HOME/.local/share/fonts"
    curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/JetBrainsMono.zip" \
        -o "$tmp_dir/JetBrainsMono.zip"
    unzip "$tmp_dir/JetBrainsMono.zip" -d "$tmp_dir/jetbrains"
    mv "$tmp_dir/jetbrains/"*.ttf "$HOME/.local/share/fonts/"
    rm -rf "$tmp_dir"
    fc-cache -fv
)

setup_docker() (
    set -e
    sudo usermod -aG docker "$CURRENT_USER"
    sudo systemctl enable --now docker
)

setup_bluetooth() (
    set -e
    sudo systemctl enable --now bluetooth
)

setup_power() (
    set -e
    sudo systemctl enable --now power-profiles-daemon
    if [[ "$MACHINE" == "MADVILLAIN" ]]; then
        sudo pacman -S --noconfirm --needed brightnessctl
    fi
)

setup_pacman() (
    set -e
    sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
    sudo sed -i 's/^#MAKEFLAGS=.*/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf
)

setup_sddm() (
    set -e
    sudo systemctl enable sddm
)

setup_sddm_theme() (
    set -e
    local theme
    theme=$(find_asset sddm/gruvbox-material)
    # -L because a stowed tree is symlinks all the way down; a plain -r would copy
    # links pointing back into $HOME, which sddm can't read as the sddm user
    sudo cp -rL "$theme" /usr/share/sddm/themes/gruvbox-material
    sudo chown -R root:root /usr/share/sddm/themes/gruvbox-material
    sudo chmod -R a+rX /usr/share/sddm/themes/gruvbox-material
    sudo mkdir -p /etc/sddm.conf.d
    printf '[Theme]\nCurrent=gruvbox-material\n' | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null
)

setup_zsh() (
    set -e
    sudo usermod -s "$(which zsh)" "$CURRENT_USER"
)

setup_nvm() (
    set -e
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    source "$NVM_DIR/nvm.sh"
    nvm install --lts
)

setup_rvm() (
    set -e
    gpg2 --keyserver keyserver.ubuntu.com --recv-keys \
        409B6B1796C275462A1703113804BB82D39DC0E3 \
        7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    # shellcheck source=/dev/null
    source "$HOME/.rvm/scripts/rvm"
)

setup_mysql() (
    set -e
    gpg --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C
    git clone https://aur.archlinux.org/mysql.git "$HOME/mysql"
    cd "$HOME/mysql"
    makepkg -si --noconfirm
    cd "$HOME"
    sudo mysqld --initialize --user=mysql
    sudo systemctl enable --now mysqld
    sudo mysql_secure_installation
)

setup_tmux() (
    set -e
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
)

setup_secureboot() (
    set -e
    [[ "$MACHINE" != "DANGERDOOM" ]] && return
    sudo pacman -S --noconfirm --needed sbctl
    # Key enrollment requires Secure Boot Setup Mode — clear keys in UEFI firmware first
    if ! sudo sbctl status | grep -q "Setup Mode.*Enabled"; then
        echo "WARNING: Secure Boot Setup Mode is not active."
        echo "Enter UEFI firmware settings, clear existing Secure Boot keys to enable Setup Mode, then re-run."
        return 1
    fi
    sudo sbctl create-keys
    # --microsoft retains Microsoft's keys so Windows 11 can still boot
    sudo sbctl enroll-keys --microsoft
    # -s saves paths to sbctl's DB so the pacman hook re-signs on kernel/bootloader updates
    # systemd-boot installs itself twice: its own path plus the removable-media
    # fallback the firmware uses when no NVRAM entry matches. Both need signing.
    sudo sbctl sign -s /boot/EFI/systemd/systemd-bootx64.efi
    sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
    sudo sbctl sign -s /boot/vmlinuz-linux
    sudo sbctl sign -s /boot/vmlinuz-linux-lts
    # Show any unsigned binaries that still need attention
    sudo sbctl verify
)

# `snapper create-config` insists on creating the .snapshots subvolume itself and
# fails outright when one is already mounted there, which is true of any layout
# that pre-creates @snapshots. Fall back to the config template in that case.
snapper_ensure_config() {
    local name="$1" subvol="$2" cfg="/etc/snapper/configs/$1"
    if [[ -f "$cfg" ]]; then
        # a config aimed at the wrong subvolume is worse than no config at all: it
        # reads as coverage while snapshotting something else entirely.
        # greps run under sudo: create-config writes these 0640 root:root, so an
        # unprivileged read fails and would look identical to a wrong subvolume
        if ! sudo grep -qx "SUBVOLUME=\"$subvol\"" "$cfg"; then
            echo "ERROR: $cfg does not point at $subvol:" >&2
            sudo grep '^SUBVOLUME=' "$cfg" >&2
            # not `snapper -c $name delete-config` — that would delete the .snapshots
            # subvolume belonging to whatever it currently points at
            echo "Remove $cfg by hand, then re-run." >&2
            return 1
        fi
    elif [[ -e "${subvol%/}/.snapshots" ]]; then
        sudo cp /usr/share/snapper/config-templates/default "$cfg"
        sudo sed -i "s|^SUBVOLUME=.*|SUBVOLUME=\"$subvol\"|" "$cfg"
    else
        sudo snapper -c "$name" create-config "$subvol"
    fi
}

setup_snapper() (
    set -e
    sudo pacman -S --noconfirm --needed snapper snap-pac
    snapper_ensure_config root /
    snapper_ensure_config home /home
    sudo snapper -c root set-config \
        TIMELINE_CREATE=yes \
        TIMELINE_CLEANUP=yes \
        TIMELINE_MIN_AGE=1800 \
        TIMELINE_LIMIT_HOURLY=5 \
        TIMELINE_LIMIT_DAILY=7 \
        TIMELINE_LIMIT_WEEKLY=0 \
        TIMELINE_LIMIT_MONTHLY=0 \
        TIMELINE_LIMIT_YEARLY=0 \
        NUMBER_LIMIT=20
    # /home churns far harder than / (build output, node_modules), and snap-pac
    # only snapshots root, so home leans on the timeline rather than NUMBER limits
    sudo snapper -c home set-config \
        TIMELINE_CREATE=yes \
        TIMELINE_CLEANUP=yes \
        TIMELINE_MIN_AGE=1800 \
        TIMELINE_LIMIT_HOURLY=10 \
        TIMELINE_LIMIT_DAILY=7 \
        TIMELINE_LIMIT_WEEKLY=4 \
        TIMELINE_LIMIT_MONTHLY=3 \
        TIMELINE_LIMIT_YEARLY=0 \
        NUMBER_LIMIT=10 \
        ALLOW_USERS="$CURRENT_USER" \
        SYNC_ACL=yes
    # written whole rather than appended: on a fresh install this file is empty, so
    # appending "home" would silently leave root unregistered
    printf 'SNAPPER_CONFIGS="root home"\n' | sudo tee /etc/conf.d/snapper > /dev/null
    sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer
    # recovery is btrfs subvolume set-default <id-of-@snapshots/N/snapshot> /
    # then reboot, and set-default back to @ to undo. /home needs no bootloader
    # involvement at all: restore from /home/.snapshots/N/snapshot while booted.
)

# auditctl aborts the entire load when a watched path is absent, so rules naming
# a path this machine doesn't have (the cron dirs without cronie, say) are dropped
# rather than allowed to take the whole ruleset down with them.
render_audit_rules() {
    local rules
    rules=$(find_asset audit/10-hardening.rules) || return 1
    sed "s|__HOME__|$HOME|g" "$rules" | while IFS= read -r line; do
        case "$line" in
            ''|'#'*) printf '%s\n' "$line"; continue ;;
        esac
        target="${line##*-F dir=}"
        [ "$target" = "$line" ] && target="${line##*-F path=}"
        [ "$target" = "$line" ] && { printf '%s\n' "$line"; continue; }
        target="${target%% *}"
        if [ -e "$target" ]; then
            printf '%s\n' "$line"
        else
            echo "skipping audit rule, path absent: $target" >&2
        fi
    done
}

setup_audit() (
    set -e
    sudo pacman -S --noconfirm --needed audit
    sudo mkdir -p /etc/audit/rules.d
    # pre-10- naming from an earlier setup; leaving it would double-load the rules
    sudo rm -f /etc/audit/rules.d/hardening.rules
    # staged rather than piped straight into tee: in a pipeline the exit status is
    # tee's, so a missing source file would install an empty ruleset and report success
    local staged
    staged=$(mktemp)
    render_audit_rules > "$staged"
    sudo install -m 600 "$staged" /etc/audit/rules.d/10-hardening.rules
    rm -f "$staged"
    sudo systemctl enable --now auditd
    # augenrules compiles rules.d/*.rules into the live ruleset; needed here
    # because auditd only runs it itself at service start
    sudo augenrules --load
)

harden() (
    set -e
    local faildelay_line='auth optional pam_faildelay.so delay=4000000'
    grep -qxF "$faildelay_line" /etc/pam.d/system-login || \
        echo "$faildelay_line" | sudo tee -a /etc/pam.d/system-login > /dev/null
    echo 'PermitRootLogin no' | sudo tee /etc/ssh/sshd_config.d/20-deny_root.conf > /dev/null
    sudo pacman -S --noconfirm --needed ufw
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw enable
    sudo systemctl enable --now ufw
)

main() (
    set -e
    echo "Starting bootstrap for $MACHINE..."
    setup_pacman
    install_base_packages
    install_yay
    install_packages
    install_microcode
    install_gpu_drivers
    install_fonts
    setup_docker
    setup_bluetooth
    setup_power
    setup_sddm
    setup_sddm_theme
    setup_zsh
    setup_rvm
    setup_mysql
    setup_nvm
    setup_tmux
    setup_snapper
    setup_audit
    harden
    echo "Bootstrap complete. Reboot before running stow."
)
