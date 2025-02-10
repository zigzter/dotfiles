return {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
        require("themery").setup({
            themes = {
                {
                    name = "Light",
                    colorscheme = "gruvbox-material",
                    before = [[
                        set background=light
                    ]]
                },
                {
                    name = "Dark",
                    colorscheme = "gruvbox-material",
                    before = [[
                        set background=dark
                    ]]
                }
            }
        })
    end
}
