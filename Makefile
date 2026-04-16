MACHINE := $(shell hostname 2>/dev/null || hostnamectl hostname 2>/dev/null)
COMMON := nvim tmux zsh bat btop fastfetch ghostty ohmyposh git

ifeq ($(MACHINE), MADVILLAIN)
    CONFIGS = mako hypr hyprlock waybar rofi
else ifeq ($(MACHINE), DANGERDOOM)
    CONFIGS = mako hypr hyprlock waybar rofi
else
    $(error Unknown machine type: $(MACHINE))
endif

FINAL := $(COMMON) $(CONFIGS)

all:
	stow -v $(FINAL)

delete:
	stow -v --delete $(FINAL)
