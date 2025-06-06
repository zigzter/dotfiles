-- UI plugin for messages, cmdline, and popupmenu
return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        {
            "MunifTanjim/nui.nvim",
            -- problem with winborder on latest commit
            commit = "8d3bce9764e627b62b07424e0df77f680d47ffdb"
        },
    },
    opts = {
        lsp = {
            hover = {
                enabled = true,
            },
            signature = {
                enabled = true,
            },
            messages = {
                enabled = true,
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                -- ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            command_palette = true,
            long_message_to_split = true,
            lsp_doc_border = true,
        },
        routes = {
            {
                view = "notify",
                filter = { event = "msg_showmode" },
            },
        },
        views = {
            cmdline_popup = {
                position = {
                    row = "50%",
                    col = "50%",
                },
                size = {
                    width = 90,
                    height = "auto",
                },
            },
        },
    },
}
