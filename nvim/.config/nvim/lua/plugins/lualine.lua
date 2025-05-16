return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    opts = {
        options = {
            theme = "gruvbox-material",
            component_separators = "",
            section_separators = "",
            globalstatus = true,
            always_divide_middle = true,
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {
                {
                    "diagnostics",
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                },
                "filetype",
            },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
                {
                    "filename",
                    path = 1,
                    shorting_rule = "truncate_left",
                },
            },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
    },
}
