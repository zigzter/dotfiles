# Global Claude Instructions

## Environment

- OS: Arch Linux
- Shell: zsh (zinit, oh-my-posh)
- WM: Hyprland
- Editor: Neovim (LSP, Telescope, vim-fugitive, nvim-dap)
- Terminal: Ghostty + tmux

## Available tools

- `rg` for search — prefer over `grep`
- `lsd` aliased as `ls`, `bat` aliased as `cat`
- `fzf`, `zoxide` for navigation
- `jq` for JSON

## Coding guidelines

- No comments unless the WHY is non-obvious (a hidden constraint, workaround, or surprising behaviour)
- No unnecessary abstractions — three similar lines beats a premature helper
- No boilerplate error handling for things that can't fail; only validate at system boundaries
- Trust the type system and framework; don't add defensive guards for internal code paths
- Prefer readability over conciseness

## Languages and tooling

### Lua (Neovim config)
Format with StyLua (`stylua.toml` in the dotfiles repo):
- `indent_type = "Spaces"`
- `collapse_simple_statement = "Always"`

### Ruby
RVM manages versions.

### JavaScript / TypeScript
NVM manages Node versions.

### Python
pyenv manages versions.

## Git

- Short, descriptive commit messages
- Rebase local branches rather than creating merge commits
- Stage specific files rather than `git add -A`
