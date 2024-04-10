#!/bin/bash

# This script is a WIP and probably doesn't work atm
# Reminder: Make sure to download NetworkManager and setup network during Arch install
# Also, install git and setup

echo "Updating system and installing packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel zsh unzip base

# Install Yay
echo "Installing Yay..."
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~

# Install microcode
if grep -q "Intel" /proc/cpuinfo; then
    sudo pacman -S intel-ucode --noconfirm
elif grep -q "AMD"; then
    sudo pacman -S amd-ucode --noconfirm
fi
# Regen grub config to incorporate microcode
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Install Hyprland & Waybar
sudo pacman -S hyprland waybar hyprpaper kitty qt5-wayland qt6-wayland --noconfirm

# Install more things
sudo pacman -S --noconfirm openssh lspci dunst which firefox man-db man-pages \
    xclip bat btop pipewire pavucontrol ttf-font-awesome tmux ripgrep swaylock nodejs \
    stow qt6-svg qt6-declarative fastfetch postgresql-libs lsd

yay -S neovim-git sddm-git

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
curl -fLo https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip
unzip ~/Downloads/JetBrainsMono.zip -d ~/Downloads/jetbrains
mv ~/Downloads/jetbrains/* ~/.local/share/fonts/
fc-cache -fv

# Set up Docker
sudo pacman -S docker docker-compose --noconfirm
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

# Set up RVM
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
