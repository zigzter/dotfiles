-- Plugin manager for LSPs, linters and formatters
return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })
        mason_lspconfig.setup({
            ensure_installed = {
                "cssls",
                "ts_ls",
                "dockerls",
                "eslint",
                "gopls",
                "html",
                "jsonls",
                "lua_ls",
                "rubocop",
            },
            automatic_installation = true,
        })
    end,
}
