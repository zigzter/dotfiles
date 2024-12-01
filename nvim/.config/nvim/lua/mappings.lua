local builtin = require("telescope.builtin")
local harpoon = require("harpoon")

vim.g.mapleader = " "

local function nmap(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc }) end

-- Quickfix
nmap("<leader>j", "<cmd>cnext<CR>zz", "Next in quickfix list")
nmap("<leader>k", "<cmd>cprev<CR>zz", "Previous in quickfix list")

-- Telescope
nmap("<leader>sf", builtin.find_files, "[S]earch [F]iles")
nmap("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
nmap("<leader>sg", builtin.live_grep, "[S]earch by [G]rep")
nmap("<leader>sb", builtin.buffers, "[S]earch [B]uffers")
nmap("<leader>sh", builtin.help_tags, "[S]earch [H]elp")
nmap("<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
nmap("<leader>ss", builtin.lsp_document_symbols, "[S]ocument [S]ymbols")
nmap("<leader>lr", builtin.lsp_references, "[L]ist LSP [R]eferences")
nmap("<leader>sc", builtin.git_commits, "[S]earch [C]ommits")
nmap("<leader>gc", builtin.git_status, "[G]it [C]hanges")

-- Vim Fugitive
nmap("<leader>gs", ":Git<cr>", "[G]it [S]tatus")
nmap("<leader>gb", ":Git blame<cr>", "[G]it [B]lame")
nmap("<leader>gd", ":Gvdiffsplit<cr>", "[G]it [D]iff")
nmap("<leader>gl", ":Git log<cr>", "[G]it [L]og")
nmap("<leader>ga", ":Git add %<cr>", "[G]it [A]dd")
nmap("<leader>gc", ":tab Git commit -v<cr>", "[G]it [C]ommit")
nmap("<leader>gp", ":Git push<cr>", "[G]it [P]ush")

-- Harpoon
nmap("<leader>a", function() harpoon:list():append() end)
nmap("<leader>v", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
nmap("<leader>q", function() harpoon:list():select(1) end)
nmap("<leader>w", function() harpoon:list():select(2) end)
nmap("<leader>e", function() harpoon:list():select(3) end)
nmap("<leader>r", function() harpoon:list():select(4) end)
nmap("<leader>t", function() harpoon:list():select(5) end)
