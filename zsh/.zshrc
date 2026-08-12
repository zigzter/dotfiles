# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# oh-my-posh is installed via yay (see install.sh), already on PATH
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
alias gwt='function _gwt() { git worktree add "$1" -b "$1" qa && cd "$1"; }; _gwt'
alias tma='tmux attach -t'
alias ls='lsd'
alias la='ls -lah'
alias cat=bat
alias ff=fastfetch
alias se='SUDO_EDITOR=nvim sudoedit'
alias syu='sudo pacman -Syu'
alias pacclean='sudo paccache -rk 2'
alias tmn='~/tmux-new.sh'
alias cc='claude'
alias ccu='claude update'
alias ccr='claude --resume'

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

# Add a safety check when running git restore without --staged
git() {
    if [ "$1" = "restore" ] && [ "$2" != "--staged" ] ; then
        echo "did you mean to pass --staged?"
        read -r i
        if [ "$i" = "no" ]; then
            command git $@
        fi
    else
        command git "$@"
    fi
}

# Run a command with $HOME masked by an empty tmpfs. Only the current project,
# the active nvm toolchain and npm's own config/cache are bound back in, so a
# malicious install script sees no ssh keys, no aws creds, no dotfiles — and no
# sibling repo either. The mask is a mount namespace, not a permission check, so
# it holds against anything the command spawns.
#
# The toolchain has to be bound explicitly: npm lives under ~/.nvm, which the
# mask would otherwise hide, and .npmrc with it — losing ignore-scripts=true and
# silently re-enabling the very lifecycle scripts this is meant to contain.
sandboxed() {
    if [ $# -eq 0 ]; then
        echo "usage: sandboxed <command> [args...]   (run in the project directory)" >&2
        return 2
    fi
    # `whence -p`, not `command -v`: there is an npm *function* below, and
    # `command -v npm` would return the string "npm" rather than a path, quietly
    # making node_root garbage. -p searches $PATH only, skipping functions/aliases.
    local node_root npm_bin
    npm_bin=$(whence -p npm) || { echo "sandboxed: npm not found on PATH" >&2; return 1; }
    node_root=${npm_bin:h:h}
    mkdir -p "$HOME/.npm"
    # -p flags must each be separate args; BindPaths takes a space-separated list
    systemd-run --user --pty --wait --collect --quiet --same-dir \
        -p ProtectHome=tmpfs \
        -p "BindPaths=$PWD $HOME/.npm" \
        -p "BindReadOnlyPaths=$node_root $HOME/.npmrc" \
        --setenv="PATH=$node_root/bin:/usr/bin:/bin" \
        "$@"
}

# Force the sandbox for any npm invocation, including ones the dispatch below
# lets through: `snpm run some-untrusted-script`.
snpm() { sandboxed "$(whence -p npm)" "$@"; }

# Sandbox by default, because remembering to type `snpm` is not a security model.
# Only the subcommands that execute third-party install hooks are wrapped: `npm
# run` is our own scripts and genuinely needs a real $HOME — start/db:migrate in
# pallet-services-api resolve AWS creds from ~/.aws through the SDK chain, and
# masking that turns a credential lookup into a baffling build failure.
# Same shape as the git() wrapper above: dispatch, else `command npm` passthrough.
# Escape hatch for a one-off unsandboxed install is `command npm install`.
npm() {
    case $1 in
        install|i|add|ci|update|up|rebuild)
            sandboxed "$(whence -p npm)" "$@"
            ;;
        audit)
            # plain `npm audit` only reads; `npm audit fix` installs
            if [ "$2" = "fix" ]; then
                sandboxed "$(whence -p npm)" "$@"
            else
                command npm "$@"
            fi
            ;;
        *)
            command npm "$@"
            ;;
    esac
}

export EDITOR="nvim"
export VISUAL="nvim"

bindkey '^R' history-incremental-search-backward
# emacs mode, allow terminal movement mappings like Ctrl+a/e to work in tmux
bindkey -e

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
export PATH="$PATH:$HOME/.rvm/bin:/bin:/opt/cuda/bin:$HOME/projects/break-check:$HOME/go/bin:$HOME/nvim-linux64/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.ebcli-virtual-env/executables"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
   eval "$(pyenv init -)" 
fi
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
command -v zoxide &>/dev/null && alias cd=z

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Lets Node resolve globally-installed packages (e.g. peer deps a project forgot to declare)
[ -n "$NVM_BIN" ] && export NODE_PATH="${NVM_BIN%/bin}/lib/node_modules"
export PATH="$HOME/.local/bin:$PATH"
