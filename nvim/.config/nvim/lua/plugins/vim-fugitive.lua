return {
    'tpope/vim-fugitive',
    config = function()
        vim.keymap.set("n", "<leader>gs", ":Git<cr>", { desc = "[G]it [S]tatus", silent = true })
        vim.keymap.set("n", "<leader>gb", ":Git blame<cr>", { desc = "[G]it [B]lame", silent = true })
        vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<cr>", { desc = "[G]it [D]iff", silent = true })
        vim.keymap.set("n", "<leader>gl", ":Git log<cr>", { desc = "[G]it [L]og", silent = true })
        vim.keymap.set("n", "<leader>ga", ":Git add %<cr>", { desc = "[G]it [A]dd", silent = true })
        vim.keymap.set("n", "<leader>gc", ":tab Git commit -v<cr>", { desc = "[G]it [C]ommit", silent = true })
        vim.keymap.set("n", "<leader>gp", ":Git push<cr>", { desc = "[G]it [P]ush", silent = true })
    end
}
