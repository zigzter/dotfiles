MACHINE := $(shell hostname 2>/dev/null || hostnamectl hostname 2>/dev/null)
COMMON := nvim tmux zsh bat btop fastfetch ghostty ohmyposh git wallpapers rofi swaync

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
