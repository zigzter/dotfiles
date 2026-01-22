-- LSP
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lspconfig = require("lspconfig")
    local blink = require("blink.cmp")
    local map = vim.keymap
    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      if client.name == "jsonls" or client.name == "eslint" then
        client.server_capabilities.documentFormattingProvider = false
      end
    end
    local capabilities = blink.get_lsp_capabilities()

    vim.diagnostic.config({
      underline = false,
      signs = {
        active = true,
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN]  = "",
          [vim.diagnostic.severity.HINT]  = "󰟃",
          [vim.diagnostic.severity.INFO]  = "",
        },
      },
      virtual_text = true,
      float = {
        border = "single",
        format = function(diagnostic)
          -- Safely handle missing fields
          local source = diagnostic.source or "unknown"
          local code = ""
          if diagnostic.code then
            code = diagnostic.code
          elseif diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code then
            code = diagnostic.user_data.lsp.code
          end

          if code ~= "" then
            return string.format("%s (%s) [%s]", diagnostic.message, source, code)
          else
            return string.format("%s (%s)", diagnostic.message, source)
          end
        end,
      },
    })

    vim.lsp.enable('dockerls')
    vim.lsp.config('ts_ls', {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' }
    })
    vim.lsp.enable('ts_ls')
    vim.lsp.enable('cssls')
    -- vim.lsp.enable('eslint')
    vim.lsp.enable('eslint', { on_attach = on_attach, capabilities = capabilities })
    vim.lsp.enable('gopls')
    vim.lsp.enable('pyright')
    vim.lsp.enable('html')
    vim.lsp.enable('jsonls')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('rubocop')
    vim.lsp.enable('ruby_lsp')
    vim.lsp.enable('omnisharp')
    vim.lsp.config('vue_ls', {
      on_attach = on_attach,
      capabilities = capabilities,
      init_options = {
        typescript = {
          tsdk = vim.fn.expand('~/.nvm/versions/node/v18.20.6/lib/node_modules/typescript/lib/')
        }
      }
    })
    vim.lsp.enable('vue_ls')
  end,
}
