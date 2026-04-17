#!/bin/bash
set -e

MACHINE=$(hostname)
CURRENT_USER=$(whoami)
NERD_FONTS_VERSION="v3.2.0"

PKGS_BASE=(
    git stow openssh which
    man-db man-pages
    zsh tmux neovim fzf ripgrep bat btop lsd fastfetch
    nodejs postgresql-libs
    firefox
    docker docker-compose
    upower power-profiles-daemon
    ttf-font-awesome noto-fonts noto-fonts-emoji
    v4l-utils obsidian loupe vlc
)

PKGS_HYPRLAND=(
    hyprland waybar hyprpaper hyprlock
    qt5-wayland qt6-wayland qt6-svg qt6-declarative
    mako
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

install_yay() {
    if command -v yay &>/dev/null; then
        echo "yay already installed, skipping..."
        return
    fi
    git clone https://aur.archlinux.org/yay.git "$HOME/yay"
    cd "$HOME/yay"
    makepkg -si --noconfirm
    cd "$HOME"
    rm -rf "$HOME/yay"
}

install_packages() {
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm --needed \
        "${PKGS_BASE[@]}" \
        "${PKGS_HYPRLAND[@]}" \
        "${PKGS_AUDIO[@]}" \
        "${PKGS_WAYLAND_UTILS[@]}" \
        "${PKGS_BLUETOOTH[@]}" \
        "${PKGS_FILES[@]}"
    yay -S --noconfirm ghostty oh-my-posh rofi-wayland swayosd beekeeper-studio-bin discord spotify
}

install_gpu_drivers() {
    if [[ "$MACHINE" == "DANGERDOOM" ]]; then
        sudo pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings
    elif [[ "$MACHINE" == "MADVILLAIN" ]]; then
        sudo pacman -S --noconfirm --needed mesa vulkan-intel intel-media-driver
    fi
}

install_fonts() {
    local tmp_dir
    tmp_dir=$(mktemp -d)
    mkdir -p "$HOME/.local/share/fonts"
    curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/JetBrainsMono.zip" \
        -o "$tmp_dir/JetBrainsMono.zip"
    unzip "$tmp_dir/JetBrainsMono.zip" -d "$tmp_dir/jetbrains"
    mv "$tmp_dir/jetbrains/"*.ttf "$HOME/.local/share/fonts/"
    rm -rf "$tmp_dir"
    fc-cache -fv
}

setup_docker() {
    sudo usermod -aG docker "$CURRENT_USER"
    sudo systemctl enable --now docker
}

setup_bluetooth() {
    sudo systemctl enable --now bluetooth
}

setup_power() {
    sudo systemctl enable --now power-profiles-daemon
    if [[ "$MACHINE" == "MADVILLAIN" ]]; then
        sudo pacman -S --noconfirm --needed brightnessctl
    fi
}

setup_sddm() {
    sudo systemctl enable sddm
}

setup_zsh() {
    chsh -s "$(which zsh)" "$CURRENT_USER"
}

setup_rvm() {
    gpg2 --keyserver keyserver.ubuntu.com --recv-keys \
        409B6B1796C275462A1703113804BB82D39DC0E3 \
        7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    # shellcheck source=/dev/null
    source "$HOME/.rvm/scripts/rvm"
}

# Work-specific — remove if not needed
# Kept in ~/mysql for rebuilds after library updates
setup_mysql() {
    git clone https://aur.archlinux.org/mysql.git "$HOME/mysql"
    cd "$HOME/mysql"
    makepkg -si --noconfirm
    cd "$HOME"
}

main() {
    echo "Starting bootstrap for $MACHINE..."
    install_yay
    install_packages
    install_gpu_drivers
    install_fonts
    setup_docker
    setup_bluetooth
    setup_power
    setup_sddm
    setup_zsh
    setup_rvm
    setup_mysql
    echo "Bootstrap complete. Reboot before running stow."
}

main
