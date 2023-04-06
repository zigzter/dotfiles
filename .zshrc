# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# History date stamp 
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/opt/homebrew/bin:$PATH"

# Aliases
alias vim=nvim
alias gs='git status'
alias glo='git log --continue'
alias gn='git checkout -b'
alias gc='git checkout'
alias rbc='git rebase --continue'
alias tma='tmux attach -t'
alias cat=bat

source ~/.sbkeys

# Easier git branch search
bs() {
  git branch --list | grep $1
}

editorlink() {
  cd pikasso
  npm unlink @btag/bt-text-editor
  cd ../bt-text-editor
  npm unlink
  npm link ../pikasso/node_modules/react
  npm link
  cd ../pikasso
  npm link @btag/bt-text-editor
}

linkwebapp() {
  npm run build
  cp -a dist ../bt-member-site/node_modules/@btag/$1
  if [ $? -ne 0 ]; then
    echo "Error copying dist folder"
  else
    echo "Copied dist to webapp's node_modules/@btag/"$1
  fi
}

tmn() {
  name=""
  webapp=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -w|--webapp)
        webapp=true
        shift
        ;;
      *)
        name="$1"
        shift
        ;;
    esac
  done

  tmux new -c ~/projects -d # navigate to projects folder, detach session
  if [[ $name =~ [A-Z]+-[0-9]+ ]]; then # if name matches Jira ticket
    tmux rename $name # not done inline to prevent tmux appending a number
    tmux renamew 'code'
    tmux new-window -n 'servers' -c ~/projects
    tmux new-window -n 'git' -c ~/projects
    if [ "$webapp" = true ]; then
      tmux new-window -n 'webapp' -c ~/projects/bt-member-site
      tmux split-window -h -c ~/projects/bt-member-site
      tmux send-keys -t 1 "nvm use 12; npm run start-api" Enter
      tmux send-keys -t 2 "nvm use 12; npm run start-web" Enter
    fi
    tmux select-window -t 'code'
    tmux attach -t $name
  else
    tmux rename $name
    tmux renamew 'dev'
    tmux attach -t $name
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
