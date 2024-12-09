-- Code action previewer
return {
    "aznhe21/actions-preview.nvim",
    config = function()
        vim.keymap.set(
            { "v", "n" },
            "<leader>sa",
            require("actions-preview").code_actions,
            { desc = "Code Actions preview" }
        )
    end,
}
