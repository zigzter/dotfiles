-- A collection of QoL plugins
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
                add = "<M-a>", -- Add surrounding in Normal and Vsual modes
                delete = "<M-d>", -- Delete surroundng
                replace = "<M-r>", -- Replace surrounding
            },
        })
    end,
}
