vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.rnu = false

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

local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa: " .. esc .. "la, " .. esc .. "pl")

-- Save when focus is lost
vim.api.nvim_create_autocmd({ "FocusLost" }, {
    desc = "autosave",
    pattern = "*",
    command = "silent! update",
})

-- Create scratchpad
function new_scratch()
    vim.api.nvim_command("vsplit")
    -- Create scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    -- Set current window to use the new buffer
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    -- Set scratch buffer properties
    vim.opt_local.buftype = "nofile"
    vim.opt_local.bufhidden = "hide"
    vim.opt_local.swapfile = false
end

vim.keymap.set("n", "Ns", new_scratch, { noremap = true, silent = true, desc = "Open [N]ew [s]cratchpad" })

-- set 50 and 72 char limit columns on gitcommits
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function() vim.opt_local.colorcolumn = "50,72" end,
})

require("lazy").setup("plugins")

-- Relies on Lazy module imports, so has to come after Lazy
require("mappings")
