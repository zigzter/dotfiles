# Never stow audit/, sddm/ or scripts/ — none has a .config/ layer, so stow drops
# their contents loose into $HOME rather than creating the directory. install.sh
# copies the first two into /etc and /usr/share (setup_audit, setup_sddm_theme);
# scripts/ is just run in place.
MACHINE := $(shell hostname 2>/dev/null || hostnamectl hostname 2>/dev/null)
COMMON := nvim tmux zsh bat btop fastfetch ghostty ohmyposh git wallpapers rofi swaync claude pacman

ifeq ($(MACHINE), MADVILLAIN)
    CONFIGS = hypr waybar
else ifeq ($(MACHINE), DANGERDOOM)
    CONFIGS = hypr waybar
else
    $(error Unknown machine type: $(MACHINE))
endif

FINAL := $(COMMON) $(CONFIGS)

all:
	stow -v $(FINAL)

delete:
	stow -v --delete $(FINAL)
