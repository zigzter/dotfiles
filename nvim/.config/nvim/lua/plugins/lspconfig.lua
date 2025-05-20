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
      virtual_text = false,
      float = {
        border = "single",
        format = function(diagnostic)
          return string.format(
            "%s (%s) [%s]",
            diagnostic.message,
            diagnostic.source,
            diagnostic.code or diagnostic.user_data.lsp.code
          )
        end,
      },
    })

    vim.lsp.enable('dockerls', { capabilities = capabilities })
    vim.lsp.enable('ts_ls', {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        implicitProjectConfiguration = { checkJs = true },
      },
      single_file_support = true,
      root_dir = lspconfig.util.root_pattern("package.json"),
    })
    vim.lsp.enable('cssls', { on_attach = on_attach, capabilities = capabilities })
    vim.lsp.enable('eslint', { on_attach = on_attach, capabilities = capabilities })
    vim.lsp.enable('gopls', {
      capabilities = capabilities,
      cmd = { "gopls", "--remote=auto" },
      on_attach = on_attach,
    })
    vim.lsp.enable('pyright', { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable('html', { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable('jsonls', { capabilities = capabilities })
    vim.lsp.enable('lua_ls', {
      capabilities = capabilities,
      on_init = function(client)
        client.server_capabilities.semanticTokensProvider = nil

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
              path ~= vim.fn.stdpath("config")
              and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
          then
            return
          end
        end

        client.config.settings = client.config.settings or {}
        client.config.settings.Lua = client.config.settings.Lua or {}
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            checkThirdParty = false,
            library = {
              "$VIMRUNTIME",
              "$XDG_DATA_HOME/nvim/lazy",
              "${3rd}/luv/library",
            },
          },
        })
      end,
    })
    vim.lsp.enable('rubocop', { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable('ruby_lsp', { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable('omnisharp', {
      cmd = { "omnisharp" },
      root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln"),
      capabilities = capabilities,
      on_attach = on_attach,
    })
    -- lspconfig.denols.setup({
    --     capabilities = capabilities,
    --     on_attach = on_attach,
    --     root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    -- })
    vim.lsp.enable('vuels', {
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = {
        config = {
          vetur = {
            ignoreProjectWarning = true,
          },
        },
      },
    })
  end,
}
