return {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  config = function()
    local dropbar_api = require("dropbar.api")
    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

    local function sync_winbar_bg()
      local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
      for _, group in ipairs({ "WinBar", "WinBarNC" }) do
        local hl = vim.api.nvim_get_hl(0, { name = group })
        hl.bg = normal_bg
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
    sync_winbar_bg()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = sync_winbar_bg })
  end,
}
