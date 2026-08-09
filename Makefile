# Never stow audit/, sddm/ or scripts/ — they have no .config/ layer because they
# target /etc, /usr/share and PATH, so stow would drop their contents loose into
# $HOME. install.sh owns them (setup_audit, setup_sddm_theme).
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
