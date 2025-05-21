-- Formatting
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", "eslint_d", stop_after_first = true },
        typescript = { "prettierd", "prettier", "eslint_d", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettier" },
        vue = { "prettierd", "prettier" },
        go = { "gofumpt" },
        lua = { "stylua" },
        css = { "prettier" },
        md = { "mdformat" },
        ruby = { "rubocop" },
      },
      format_after_save = {
        timeout_ms = 500,
        lsp_format = "fallback"
      }
    })
  end
}
