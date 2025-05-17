-- Formatting
return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                vue = { "prettier" },
                go = { "gofumpt" },
                lua = { "stylua" },
                css = { "prettier" },
                md = { "mdformat" },
                ruby = { "rubocop" },
            },
            format_after_save = {
                lsp_fallback = true,
                async = true,
                timeout_ms = 2000,
            },
        })

        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            conform.format({ async = true, lsp_format = "fallback", range = range })
        end, { range = true })
    end,
}
