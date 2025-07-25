-- Breadcrumbs builder
return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  event = "BufReadPre",
  opts = {
    highlight = false
  },
  config = function(_, opts)
    require("nvim-navic").setup(opts)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("NavicAttach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- Ensure the client supports document symbols, as navic relies on this
        if client and client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, args.buf)
        end
      end,
    })
  end
}
