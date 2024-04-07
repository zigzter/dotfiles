source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.9
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias vim=nvim
alias gs='git status'
alias glo='git log --continue'
alias gn='git checkout -b'
alias gc='git checkout'
alias rbc='git rebase --continue'
alias tma='tmux attach -t'
alias cat=bat
alias vim=nvim

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

