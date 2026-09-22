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

## Code comments
Write as few comments as possible. Add a comment only if a reader cannot understand the code from the code itself.

- Add an inline comment only for a hidden constraint, a workaround, or surprising behaviour.
- Do not write a comment that repeats what the code does.
- Do not write a comment that justifies or sells the code ("so consumers never have to...", "to be safe", "for robustness").
- Do not use idioms or metaphors ("belt-and-suspenders", "just in case", "under the hood").
- Do not describe the change history ("now uses X", "changed from Y", "new approach").
- Write each comment in ASD-STE100 style: short sentences, active voice, present tense, simple words.
- Keep a comment to one line if possible. Use two lines at most for an inline comment.

JSDoc and docstrings:
- Say what the function or method does. Do not say why it exists or why the caller needs it.
- Start with a verb in the present tense ("Returns...", "Sets...", "Parses...").
- Keep the summary to one sentence. Add `@param` or `@returns` only if the name and type do not make them clear.

Example. Not this:
```js
// Belt-and-suspenders: reflect the incoming value once the choice list is live,
// so consumers never have to poke the selected label into the DOM by hand.
```
This (or no comment, if the code is clear):
```js
// Set the selected label after the options render.
```

## Coding guidelines
- No unnecessary abstractions - three similar lines beats a premature helper
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
