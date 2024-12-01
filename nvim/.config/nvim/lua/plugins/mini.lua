return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        require("mini.animate").setup()
        require("mini.basics").setup()
        require("mini.comment").setup()
        require("mini.pairs").setup()
        require("mini.ai").setup()
        require("mini.surround").setup({
            mappings = {
                add = "msa", -- Add surrounding in Normal and Vsual modes
                delete = "msd", -- Delete surroundng
                find = "msf", -- Find surrounding (to the right)
                find_left = "msF", -- Find surrounding (to the left)
                highlight = "msh", -- Highlight surrounding
                replace = "msr", -- Replace surrounding
            },
        })
    end,
}
