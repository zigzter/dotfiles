-- The GOAT
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    config = function()
        local telescope = require("telescope")
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
            extensions = {
                fzf = {},
            },
        })
        telescope.load_extension("fzf")
    end,
}
