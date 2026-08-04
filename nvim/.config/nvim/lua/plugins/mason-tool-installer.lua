-- Auto-installs LSP servers and formatters via Mason on fresh setups
return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
        ensure_installed = {
            -- LSP servers
            "dockerfile-language-server",
            "css-lsp",
            "html-lsp",
            "json-lsp",
            "lua-language-server",
            "gopls",
            "pyright",
            "vue-language-server",
            "eslint-lsp",
            -- Formatters
            "eslint_d",
            "prettierd",
            "prettier",
            "gofumpt",
            "stylua",
            "mdformat",
        },
    },
}
