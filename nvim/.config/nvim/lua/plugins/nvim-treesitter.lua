-- Treesitter
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "lua",
                "typescript",
                "dockerfile",
                "go",
                "html",
                "javascript",
                "markdown_inline",
                "python",
                "ruby",
                "vim",
                "diff",
                "vue",
                "json",
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        })
    end,
}
