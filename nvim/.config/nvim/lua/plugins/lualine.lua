-- Status line
local catppuccin = require("lualine.themes.catppuccin")
-- Copy the catppuccin theme and remove background colors
local clean_catppuccin = vim.tbl_deep_extend("force", {}, catppuccin)
for _, mode in pairs(clean_catppuccin) do
    for _, section in pairs(mode) do
        section.bg = nil
    end
end

local colors = require("catppuccin.palettes").get_palette()
local mode_colors = {
    n = colors.blue,
    i = colors.green,
    v = colors.mauve,
    V = colors.mauve,
    [""] = colors.mauve,
    R = colors.red,
    c = colors.peach,
    s = colors.sky,
    S = colors.sky,
    [""] = colors.sky,
    t = colors.teal,
}

local function get_mode_color()
    local mode = vim.fn.mode()
    return { fg = mode_colors[mode] or colors.overlay1 } -- Default to inactive if mode not matched
end

local function get_mode_text()
    local mode_names = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        [""] = "V-BLOCK",
        c = "COMMAND",
        R = "REPLACE",
        t = "TERMINAL",
    }
    return mode_names[vim.fn.mode()] or "UNKNOWN"
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    opts = {
        options = {
            theme = clean_catppuccin,
            component_separators = "",
            section_separators = "",
            globalstatus = true,
        },
        sections = {
            lualine_a = {
                {
                    get_mode_text,
                    color = get_mode_color,
                },
            },
            lualine_b = { { "filename", path = 0, color = { fg = colors.overlay1 } } },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { { "filetype", color = { fg = colors.overlay1 } } },
            lualine_z = {
                { "location", left_padding = 2, color = { fg = colors.sky } },
            },
        },
        tabline = {},
        extensions = {},
    },
}
