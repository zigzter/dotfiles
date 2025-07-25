return {
  "sschleemilch/slimline.nvim",
  opts = {
    style = "fg",
    hl = {
      secondary = "Comment",
    },
    components = {
      left = {
        "mode",
        "path",
        function()
          local slimline_custom = require("custom.slimline_breadcrumbs")
          return slimline_custom.get_navic_breadcrumbs()
        end,
      },
      center = {},
      right = {
        "git",
        "diagnostics",
        "filetype_lsp",
        "progress",
        "recording",
      }
    },
    configs = {
      git = {
        hl = {
          primary = "Function",
        },
      },
    },
  },
}
