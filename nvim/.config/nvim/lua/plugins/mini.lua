-- A collection of QoL plugins
return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        local hipatterns = require("mini.hipatterns")
        require("mini.animate").setup()
        require("mini.basics").setup()
        require("mini.comment").setup()
        require("mini.pairs").setup()
        require("mini.ai").setup()
        require("mini.hipatterns").setup({
            highlighters = {
                fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
                -- Highlight hex color strings (`#rrggbb`) using that color
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })
        require("mini.diff").setup({
            mappings = {
                goto_prev = "[c",
                goto_next = "]c",
            },
        })
        require("mini.clue").setup({
            triggers = {
                -- Leader triggers
                { mode = "n", keys = "<Leader>" },
                { mode = "x", keys = "<Leader>" },
                -- Built-in completion
                { mode = "i", keys = "<C-x>" },
                -- `g` key
                { mode = "n", keys = "g" },
                { mode = "x", keys = "g" },
                -- Marks
                { mode = "n", keys = "'" },
                { mode = "n", keys = "`" },
                { mode = "x", keys = "'" },
                { mode = "x", keys = "`" },
                -- Registers
                { mode = "n", keys = '"' },
                { mode = "x", keys = '"' },
                { mode = "i", keys = "<C-r>" },
                { mode = "c", keys = "<C-r>" },
                -- Window commands
                { mode = "n", keys = "<C-w>" },
                -- `z` key
                { mode = "n", keys = "z" },
                { mode = "x", keys = "z" },
            },
        })
        require("mini.surround").setup({
            mappings = {
                add = "<M-a>", -- Add surrounding in Normal and Vsual modes
                delete = "<M-d>", -- Delete surroundng
                replace = "<M-r>", -- Replace surrounding
            },
        })
    end,
}
