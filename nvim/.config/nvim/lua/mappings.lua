local builtin = require("telescope.builtin")
local dap = require("dap")

local function nmap(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc }) end

-- Quickfix
nmap("<leader>j", "<cmd>cnext<CR>zz", "Next in quickfix list")
nmap("<leader>k", "<cmd>cprev<CR>zz", "Previous in quickfix list")

-- Telescope
nmap("<leader>sf", builtin.find_files, "[s]earch [f]iles")
nmap("<leader>sw", builtin.grep_string, "[s]earch current [w]ord")
nmap("<leader>sg", builtin.live_grep, "[s]earch by [g]rep")
nmap("<leader>sb", builtin.buffers, "[s]earch [b]uffers")
nmap("<leader>sh", builtin.help_tags, "[s]earch [h]elp")
nmap("<leader>sk", builtin.keymaps, "[s]earch [k]eymaps")
nmap("<leader>ss", builtin.lsp_document_symbols, "[s]earch [s]ymbols")
nmap("<leader>sr", builtin.lsp_references, "[s]earch lsp [r]eferences")
nmap("<leader>sl", builtin.resume, "[s]earch [l]ast")
nmap("<leader>sm", builtin.marks, "[s]earch [m]arks")
nmap("<leader>sq", builtin.quickfix, "[s]earch [q]uickfix")
nmap("<leader>sy", builtin.registers, "[s]earch [y]anks (registers)")
nmap("<leader>sc", builtin.git_bcommits, "[s]earch [c]ommits (current buffer)")
nmap("<leader>sd", builtin.git_status, "[s]earch [d]iff")
nmap("<leader>st", "<cmd>TodoTelescope<CR>", "[s]earch [t]odos")
nmap("<leader>/", builtin.current_buffer_fuzzy_find, "[/] Fuzzily search in current buffer")
nmap("<leader>sn", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, "[s]earch [n]eovim config")
nmap("<leader>ad", builtin.diagnostics, "Show [a]ll buffer [d]iagnostics")
nmap("<leader>bd", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show [b]uffer [d]iagnostics")

-- Vim Fugitive
nmap("<leader>gs", ":Git<cr>", "[g]it [s]tatus")
nmap("<leader>gb", ":Git blame<cr>", "[g]it [b]lame")
nmap("<leader>gd", ":Gvdiffsplit<cr>", "[g]it [d]iff")
nmap("<leader>gl", ":Git log -- %<cr>", "[g]it [l]og (current file)")
nmap("<leader>ga", ":Git add %<cr>", "[g]it [a]dd")
nmap("<leader>gc", ":tab Git commit -v<cr>", "[g]it [c]ommit")
nmap("<leader>gp", ":Git push<cr>", "[g]it [p]ush")
nmap("<leader>gr", ":Git restore %<cr>", "[g]it [r]estore")

-- Vim Test
nmap("<leader>tn", ":TestNearest<CR>", "[t]est [n]earest")
nmap("<leader>tf", ":TestFile<CR>", "[t]est [f]ile")
nmap("<leader>ts", ":TestSuite<CR>", "[t]est [s]uite")
nmap("<leader>tv", ":TestVisit<CR>", "[t]est [v]isit - opens last run test file")
nmap("<leader>tl", ":TestLast<CR>", "[t]est [l]ast")

-- DAP
nmap("<leader>dc", dap.continue, "[d]ebug [c]ontinue")
nmap("<leader>db", dap.toggle_breakpoint, "toggle [d]ebug [b]reakpoint")
nmap("<leader>dn", dap.step_over, "[d]ebug [n]ext (step over)")
nmap("<leader>di", dap.step_into, "[d]ebug [i]nto (step into)")
nmap("<leader>do", dap.step_out, "[d]ebug [o]ut (step out)")
nmap("<leader>dC", function() dap.clear_breakpoints() end, "[C]lear breakpoints")
nmap("<leader>de", function()
    dap.clear_breakpoints()
    dap.terminate()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
end, "[d]ebug [e]xit")

-- Neo-tree
nmap("<leader>fb", ":Neotree toggle float<CR>", "[f]ile [b]rowser (neo-tree)")

-- CodeCompanion
nmap("<leader>cc", ":CodeCompanionChat Toggle<CR>", "[c]odecompanion [c]hat")
nmap("<leader>ca", ":CodeCompanionActions<CR>", "[c]odecompanion [a]ctions")
vim.cmd([[cab cc CodeCompanion]]) -- Expand cc to CodeCompanion in the command line

-- Misc
nmap("<leader>co", ":only<CR>", "[c]lose [o]ther splits")
nmap("<leader>D", vim.diagnostic.open_float, "Show line diagnostics")
nmap("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic line")
nmap("]d", vim.diagnostic.goto_next, "Go to next diagnostic line")
nmap("K", vim.lsp.buf.hover, "Show documentation of what is under cursor")
nmap("gd", vim.lsp.buf.definition, "[g]o to [d]efinition")
nmap("<leader>rn", vim.lsp.buf.rename, "Smart rename")
nmap("<leader>rs", ":LspRestart<CR>", "Restart LSP")
nmap("-", ":lua MiniFiles.open()<CR>", "Open mini.files")
