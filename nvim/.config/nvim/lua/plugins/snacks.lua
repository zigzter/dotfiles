-- A collection of QoL plugins
return {
    "folke/snacks.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    priority = 1000,
    lazy = false,
    opts = {
        dashboard = {},
        bigfile = {},
        notifier = {},
        picker = {
            sources = {
                files = {
                    hidden = true,
                    exclude = { "node_modules", "*.png", ".git" },
                },
                grep = {
                    hidden = true,
                    exclude = { "node_modules", "*.png", ".git" },
                },
            },
        },
        indent = {
            indent = {
                enabled = false,
                only_current = true,
                only_scope = true,
                hl = "SnacksIndentInactive",
            },
            scope = {
                hl = "SnacksIndentActive",
                only_current = true,
            },
        },
    },
}
