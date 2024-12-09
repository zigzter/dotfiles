-- LSP
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_lsp = require("cmp_nvim_lsp")
        local map = vim.keymap
        local opts = { noremap = true, silent = true }
        local on_attach = function(client, bufnr)
            opts.buffer = bufnr
            opts.desc = "[s]earch [r]eferences"
            map.set("n", "<leader>sr", "<cmd>Telescope lsp_references<CR>", opts)

            opts.desc = "[g]o to [d]efinition"
            map.set("n", "gd", vim.lsp.buf.definition, opts)

            opts.desc = "Show line diagnostics"
            map.set("n", "<leader>d", vim.diagnostic.open_float, opts)

            opts.desc = "Show [b]uffer [d]iagnostics"
            map.set("n", "<leader>bd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

            opts.desc = "Show [a]ll buffer [d]iagnostics"
            map.set("n", "<leader>ad", "<cmd>Telescope diagnostics<CR>", opts)

            opts.desc = "Show documentation of what is under cursor"
            map.set("n", "K", vim.lsp.buf.hover, opts)

            opts.desc = "Smart rename"
            map.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

            opts.desc = "Go to previous diagnostic line"
            map.set("n", "[d", vim.diagnostic.goto_prev, opts)

            opts.desc = "Go to next diagnostic line"
            map.set("n", "]d", vim.diagnostic.goto_next, opts)

            opts.desc = "Restart LSP"
            map.set("n", "<leader>rs", ":LspRestart<CR>", opts)
        end
        local capabilities = cmp_lsp.default_capabilities()

        local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = "󰋼 " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        lspconfig.dockerls.setup({
            capabilities = capabilities,
        })
        lspconfig.ts_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                implicitProjectConfiguration = { checkJs = true },
            },
            single_file_support = false,
            root_dir = lspconfig.util.root_pattern("package.json"),
        })
        lspconfig.cssls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
        lspconfig.eslint.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
        lspconfig.gopls.setup({
            capabilities = capabilities,
            cmd = { "gopls", "--remote=auto" },
            on_attach = on_attach,
        })
        lspconfig.pyright.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
        lspconfig.html.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
        lspconfig.jsonls.setup({
            capabilities = capabilities,
        })
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then return end
                end

                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                    runtime = {
                        version = "LuaJIT",
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                    },
                })
            end,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    format = {
                        enable = false,
                    },
                },
            },
        })
        lspconfig.rubocop.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
        lspconfig.ruby_lsp.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
        lspconfig.omnisharp.setup({
            cmd = { "omnisharp" },
            root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln"),
            capabilities = capabilities,
            on_attach = on_attach,
        })
        lspconfig.denols.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        })
        lspconfig.vuels.setup({
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
