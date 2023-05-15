require("telescope").load_extension "file_browser"

vim.cmd('let g:material_terminal_italics = 1')
vim.cmd("let g:material_theme_style = 'default-community'")
vim.cmd('colorscheme material')

vim.cmd('imap <silent><script><expr> <C-c> copilot#Accept("")')
vim.cmd("let g:copilot_no_tab_map = v:true")
-- vim.cmd("g:copilot_assume_mapped = v:true")
vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser",
  { noremap = true }
)

