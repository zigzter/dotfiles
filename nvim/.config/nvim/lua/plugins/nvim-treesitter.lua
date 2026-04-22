-- Treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
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
    })

    -- Manually starting
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
