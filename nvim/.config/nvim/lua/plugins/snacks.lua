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
