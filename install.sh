#!/bin/bash

# This script is a WIP and probably doesn't work atm
# Reminder: Make sure to download NetworkManager and setup network during Arch install

echo "Updating system and installing packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel git zsh unzip

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
sudo pacman -S hyprland waybar --noconfirm

# Install more things
sudo pacman -S openssh

# TODO: detect GPU and install relevant drivers

# TODO: detect laptop and setup brightness

# Install fonts
echo "Downloading and installing fonts..."
mkdir -p ~/.local/share/fonts
mkdir -p ~/Downloads/jetbrains
curl -fLo https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip
unzip ~/Downloads/JetBrainsMono.zip -d ~/Downloads/jetbrains
mv ~/Downloads/jetbrains/* ~/.local/share/fonts/
fc-cache -fv
