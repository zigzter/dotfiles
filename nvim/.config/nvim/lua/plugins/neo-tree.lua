-- File browser
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        source_selector = {
            winbar = true,
        },
        popup_border_style = "rounded",
        filesystem = {
            use_libuv_file_watcher = true,
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                    "node_modules",
                },
                never_show = {
                    ".DS_Store",
                    "thumbs.db",
                },
            },
        },
    },
}
