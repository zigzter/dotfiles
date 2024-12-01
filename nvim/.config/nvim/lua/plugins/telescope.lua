return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        telescope.setup({
            defaults = {
                file_ignore_patterns = {
                    ".png",
                    "node_modules",
                    ".git/",
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
                live_grep = {
                    additional_args = function(opts) return { "--hidden" } end,
                },
            },
        })
        vim.keymap.set(
            "n",
            "<leader>/",
            function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end,
            { desc = "[/] Fuzzily search in current buffer" }
        )
        vim.keymap.set(
            "n",
            "<leader>sn",
            function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end,
            { desc = "[S]earch [N]eovim config" }
        )
    end,
}
