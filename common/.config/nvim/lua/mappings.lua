vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>L', [[:Lazy<CR>]], { noremap = true })
vim.keymap.set('n', '<leader>j', "<cmd>cnext<CR>zz", { desc = "Forward quickfix list", noremap = true })
vim.keymap.set('n', '<leader>k', "<cmd>cprev<CR>zz", { desc = "Backward quickfix list", noremap = true })
