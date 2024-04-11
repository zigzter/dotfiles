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
			opts.desc = "Show LSP references"
			map.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

			opts.desc = "[g]o to [d]efinition"
			map.set("n", "gd", vim.lsp.buf.definition, opts)

			opts.desc = "Show line diagnostics"
			map.set("n", "<leader>d", vim.diagnostic.open_float, opts)

			opts.desc = "Show buffer diagnostics"
			map.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

			opts.desc = "Show all buffer diagnostics"
			map.set("n", "<leader>aD", "<cmd>Telescope diagnostics<CR>", opts)

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
		lspconfig.tsserver.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				implicitProjectConfiguration = { checkJs = true },
			},
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
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
		lspconfig.rubocop.setup({
			capabilities = capabilities,
		})
	end,
}
