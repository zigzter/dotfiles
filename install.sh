#!/bin/bash

# This script is a WIP and probably doesn't work atm
# Reminder: Make sure to download NetworkManager and setup network during Arch install
# Also, install git and setup

echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install Yay
echo "Installing Yay..."
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~

# Install Hyprland & Waybar
sudo pacman -S --noconfirm hyprland waybar hyprpaper kitty qt5-wayland qt6-wayland

# Install more things
sudo pacman -S --noconfirm openssh pciutils dunst which firefox man-db man-pages \
    xclip bat btop pipewire pavucontrol ttf-font-awesome tmux ripgrep swaylock nodejs \
    stow qt6-svg qt6-declarative fastfetch postgresql-libs lsd neovim

yay -S sddm-git

# Detect and install GPU drivers
GPU=$(lspci | grep -E "VGA|3D")

if echo "$GPU" | grep -qi "NVIDIA"; then
    echo "NVIDIA GPU detected. Check the Wiki to proced: https://wiki.archlinux.org/title/NVIDIA"
elif echo "$GPU" | grep -qi "AMD"; then
    echo "AMD GPU detected. Installing AMD drivers..."
    sudo pacman -S --noconfirm xf86-video-amdgpu vulkan-radeon
elif echo "$GPU" | grep -qi "Intel"; then
    echo "Intel GPU detected. Installing Intel drivers..."
    sudo pacman -S --noconfirm mesa
else
    echo "No specific GPU detected, or GPU not recognized."
fi

# TODO: detect laptop and setup brightness

# Install fonts
echo "Downloading and installing fonts..."
mkdir -p ~/.local/share/fonts
mkdir -p ~/Downloads/jetbrains
cd ~/Downloads/jetbrains
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d jetbrains
mv ~/Downloads/jetbrains/* ~/.local/share/fonts/
cd ~
fc-cache -fv

# Set up Docker
sudo pacman -S --noconfirm docker docker-compose
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

# Set up RVM
gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
