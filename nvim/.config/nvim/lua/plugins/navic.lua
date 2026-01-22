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
          local bufnr = args.buf
          local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })

          -- For Vue files, prefer vue_ls over ts_ls for breadcrumbs
          if filetype == 'vue' and client.name == 'ts_ls' then
            -- Don't attach ts_ls to navic if we're in a Vue file
            return
          end

          require("nvim-navic").attach(client, bufnr)
        end
      end,
    })
  end
}
