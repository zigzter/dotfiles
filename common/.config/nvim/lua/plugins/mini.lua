return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        require('mini.animate').setup()
        require('mini.basics').setup()
        require('mini.comment').setup()
        require('mini.pairs').setup()
        require('mini.surround').setup({
            mappings = {
                add = 'msa', -- Add surrounding in Normal and Visual modes
                delete = 'msd', -- Delete surrounding
                find = 'msf', -- Find surrounding (to the right)
                find_left = 'msF', -- Find surrounding (to the left)
                highlight = 'msh', -- Highlight surrounding
                replace = 'msr', -- Replace surrounding
                update_n_lines = 'msn', -- Update `n_lines`
            },
        })
    end
}
