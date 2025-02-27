return {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "default",
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<CR>"] = { "select_and_accept", "fallback" },
            ["<C-space>"] = { function(cmp) cmp.show({ providers = { "snippets" } }) end },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        },
        completion = {
            list = { selection = { preselect = true, auto_insert = true } },
            accept = { auto_brackets = { enabled = true } },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
            },
            menu = {
                draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } } },
            },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            per_filetype = { "codecompanion" },
            min_keyword_length = function(ctx)
                -- only applies when typing a command, doesn't apply to arguments
                if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then return 3 end
                return 0
            end
        },
        signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
}
