return {
    "vim-test/vim-test",
    config = function()
        vim.g["test#typescript#denotest#options"] = "--allow-read"
        vim.g["test#javascript#denotest#options"] = "--allow-read"
    end,
}
