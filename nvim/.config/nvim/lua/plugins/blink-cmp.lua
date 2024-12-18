return {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = "v0.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'default',
            ["<C-k>"] = { 'select_prev', 'fallback' },
            ["<C-j>"] = { 'select_next', 'fallback' },
            ["<CR>"] = { "select_and_accept", "fallback" },
            ["<C-space>"] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
        },
        appearance = {
            nerd_font_variant = 'mono'
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        signature = { enabled = true }
    },
    opts_extend = { "sources.default" }
}
