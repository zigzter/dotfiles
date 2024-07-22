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
                    additional_args = function(opts)
                        return { "--hidden" }
                    end
                }
            },
        })
        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "[/] Fuzzily search in current buffer" })
        vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
        vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
        vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
        vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "[S]ocument [S]ymbols" })
        vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "[L]ist LSP [R]eferences" })
        vim.keymap.set("n", "<leader>sc", builtin.git_commits, { desc = "[S]earch [C]ommits" })
        vim.keymap.set("n", "<leader>gc", builtin.git_status, { desc = "[G]it [C]hanges" })
        vim.keymap.set("n", "<leader>sn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[S]earch [N]eovim config" })
    end,
}
