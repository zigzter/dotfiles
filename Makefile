MACHINE := $(shell hostnamectl hostname)
COMMON := nvim tmux zsh bat btop fastfetch kitty ohmyposh

# Machine is my laptop
ifeq ($(MACHINE), MADVILLAIN)
    CONFIGS = dunst hypr swaylock systemd waybar wofi
# Machine is my desktop
else ifeq ($(MACHINE), DANGERDOOM)
else
    $(error Unknown machine type)
endif

FINAL := $(COMMON) $(CONFIGS)

all:
	stow -v $(FINAL)

delete:
	stow -v --delete */
