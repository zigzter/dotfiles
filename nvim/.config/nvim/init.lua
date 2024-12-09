vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.rnu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.updatetime = 50

vim.opt.scrolloff = 5

vim.opt.laststatus = 0

-- lazy.nvim setup

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Save when focus is lost
vim.api.nvim_create_autocmd({ "FocusLost" }, {
    desc = "autosave",
    pattern = "*",
    command = "silent! update",
})

-- set 50 and 72 char limit columns on gitcommits
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function() vim.opt_local.colorcolumn = "50,72" end,
})

require("lazy").setup("plugins")

vim.cmd.colorscheme("catppuccin")

-- Relies on Lazy module imports, so has to come after Lazy
require("mappings")
