local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    buffer_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) == 1
    end,
    screen_width = function(min_w)
        return function()
            return vim.o.columns > min_w
        end
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
    diff_mode = function()
        return vim.o.diff == true
    end,
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
        local lualine = require("lualine")
        local colors = require("colors.gruvbox-material")
        local config = {
            options = {
                component_separators = "",
                section_separators = "",
                globalstatus = true,
                always_divide_middle = true,
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                theme = "gruvbox-material"
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
        }
        local function insert_left(component)
            table.insert(config.sections.lualine_c, component)
        end

        local function insert_right(component)
            table.insert(config.sections.lualine_x, component)
        end

        insert_left({
            "mode",
            color = function()
                local mode_color = {
                    n = colors.blue,
                    i = colors.green,
                    v = colors.purple,
                    [''] = colors.blue,
                    V = colors.blue,
                    c = colors.purple,
                    no = colors.red,
                    s = colors.orange,
                    S = colors.orange,
                    [''] = colors.orange,
                    ic = colors.yellow,
                    R = colors.purple,
                    Rv = colors.purple,
                    cv = colors.red,
                    ce = colors.red,
                    r = colors.blue,
                    rm = colors.blue,
                    ['r?'] = colors.blue,
                    ['!'] = colors.red,
                    t = colors.red,
                }
                return { fg = mode_color[vim.fn.mode()] }
            end,
            padding = { right = 1, left = 1 },
        })
        insert_left({
            function()
                return vim.bo.modified and "" or ""
            end,
            color = { fg = colors.warn },
        })

        insert_right({
            "lsp_status",
            color = { fg = colors.info },
        })
        insert_right({
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " " },
            diagnostics_color = {
                color_error = { fg = colors.red },
                color_warn = { fg = colors.yellow },
                color_info = { fg = colors.blue },
            },
        })
        insert_right({
            "location",
            color = { fg = colors.surface },
            cond = conditions.buffer_not_empty,
        })
        lualine.setup(config)
    end
}
