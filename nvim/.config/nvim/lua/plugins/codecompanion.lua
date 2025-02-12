return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        strategies = {
            chat = {
                adapter = "anthropic"
            },
            inline = {
                adapter = "anthropic"
            },
        },
        adapters = {
            ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    name = "qwen2.5-coder:14b",
                })
            end,
        }
    }
}
