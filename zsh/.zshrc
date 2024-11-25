# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit ice from"gh-r" as"command" pick"oh-my-posh"
zinit light JanDeDobbeleer/oh-my-posh
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# There's probably a better way to do this
alias oh-my-posh="$HOME/.local/share/zinit/plugins/JanDeDobbeleer---oh-my-posh/posh-linux-amd64"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"

autoload -U compinit && compinit

# Aliases
alias vim=nvim
alias gs='git status'
alias glo='git log --graph --all --oneline'
alias gn='git checkout -b'
alias gc='git checkout'
alias rbc='git rebase --continue'
alias gcv='git commit -v'
alias tma='tmux attach -t'
alias ls='lsd'
alias la='ls -lah'
alias cat=bat
alias vim=nvim
alias ff=fastfetch
alias se='SUDO_EDITOR=nvim sudoedit'
alias syu='sudo pacman -Syu'
alias pacclean='sudo paccache -rk 2'

# Get top 5 size offenders
sizing() {
    du -hs $1 | sort -rh | head -5
}

# Easier git branch search
bs() {
  git branch --list | grep $1
}

# Docker exec
de() {
    id=$(docker ps -a | grep $1 | cut -d ' ' -f 1)
    docker exec $id $2
}

# Docker interactive exec
dei() {
    id=$(docker ps -a | grep $1 | cut -d ' ' -f 1)
    docker exec -it $id /bin/bash
}

export EDITOR="nvim"
export VISUAL="nvim"

bindkey '^R' history-incremental-search-backward

export HISTFILE="$HOME/.zhistory"       # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd $realpath'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:/bin/rg:/opt/cuda/bin/nvcc:$HOME/projects/break-check:/usr/local/go/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
   eval "$(pyenv init -)" 
fi
eval "$(fzf --zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
