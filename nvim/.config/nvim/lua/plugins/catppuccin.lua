-- Theme
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            integrations = {
                dashboard = true,
                harpoon = true,
                leap = true,
                mason = true,
                mini = {
                    enabled = true,
                },
                noice = true,
                telescope = {
                    enabled = true,
                },
                treesitter = true,
            },
        })
        local colors = require("catppuccin.palettes").get_palette()
        vim.api.nvim_set_hl(0, "SnacksIndentInactive", { fg = colors.surface0 })
        vim.api.nvim_set_hl(0, "SnacksIndentActive", { fg = colors.text })
    end,
}
