return { 'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup({
            theme = 'doom',
            packages = { enable = true },
            config = {
                header = {
                    '',
                    '███████╗██╗░██████╗░██╗░░░██╗██╗███╗░░░███╗',
                    '╚════██║██║██╔════╝░██║░░░██║██║████╗░████║',
                    '░░███╔═╝██║██║░░██╗░╚██╗░██╔╝██║██╔████╔██║',
                    '██╔══╝░░██║██║░░╚██╗░╚████╔╝░██║██║╚██╔╝██║',
                    '███████╗██║╚██████╔╝░░╚██╔╝░░██║██║░╚═╝░██║',
                    '╚══════╝╚═╝░╚═════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝',
                    '',
                },
                center = {
                    {
                        icon = '󰱼 ',
                        icon_hl = 'DashboardIcon',
                        desc = 'Find file',
                        desc_hl = 'DashboardDesc',
                        key = '<leader>sf',
                        key_hl = 'DashboardKey',
                        key_format = ' [%s]',
                        action = 'Telescope find_files',
                    },
                    {
                        icon = '󱎸 ',
                        icon_hl = 'DashboardIcon',
                        desc = 'Live grep',
                        desc_hl = 'DashboardDesc',
                        key = '<leader>sg',
                        key_hl = 'DashboardKey',
                        key_format = ' [%s]',
                        action = 'Telescope live_grep',
                    },
                    {
                        icon = '󰙰 ',
                        icon_hl = 'DashboardIcon',
                        desc = 'Recent files',
                        desc_hl = 'DashboardDesc',
                        key = '<leader>sr',
                        key_hl = 'DashboardKey',
                        key_format = ' [%s]',
                        action = 'Telescope oldfiles',
                    },
                    {
                        icon = '󰆪 ',
                        icon_hl = 'DashboardIcon',
                        desc = 'Mason',
                        desc_hl = 'DashboardDesc',
                        key = 'M',
                        key_hl = 'DashboardKey',
                        key_format = ' [%s]',
                        action = 'Mason',
                    },
                    {
                        icon = ' ',
                        icon_hl = 'DashboardIcon',
                        desc = 'Lazy',
                        desc_hl = 'DashboardDesc',
                        key = '<leader>L',
                        key_hl = 'DashboardKey',
                        key_format = ' [%s]',
                        action = 'Lazy',
                    },
                    {
                        icon = '󰗼 ',
                        icon_hl = 'DashboardIcon',
                        desc = 'Exit',
                        desc_hl = 'DashboardDesc',
                        key = 'q',
                        key_hl = 'DashboardKey',
                        key_format = ' [%s]',
                        action = 'exit',
                    },
                },
            }
        })
    end,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
}
