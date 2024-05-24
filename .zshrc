# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias vim=nvim
alias gs='git status'
alias glo='git log --oneline'
alias gn='git checkout -b'
alias gc='git checkout'
alias rbc='git rebase --continue'
alias tma='tmux attach -t'
alias ls='lsd'
alias la='ls -lah'
alias cat=bat
alias vim=nvim
alias ff=fastfetch
alias se='SUDO_EDITOR=nvim sudoedit'

bindkey '^R' history-incremental-search-backward

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

export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
setopt HIST_SAVE_NO_DUPS

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:/bin/rg:/opt/cuda/bin/nvcc"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
