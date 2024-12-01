return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- Go
            dap.configurations.go = {
                {
                    type = "go",
                    name = "Debug",
                    request = "launch",
                    program = "${file}",
                },
                {
                    type = "go",
                    name = "Debug Test",
                    request = "launch",
                    mode = "test",
                    program = "${file}",
                },
                {
                    type = "go",
                    name = "Debug Package",
                    request = "launch",
                    program = "./${relativeFileDirname}",
                },
            }
            dap.adapters.go = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
                    args = { "dap", "-l", "127.0.0.1:${port}" },
                },
            }

            -- Ruby
            -- Requires: gem install ruby-debug-ide debase
            dap.adapters.ruby = {
                type = "executable",
                command = "bundle",
                args = { "exec", "rdebug-ide" },
            }
            dap.configurations.ruby = {
                {
                    type = "ruby",
                    request = "launch",
                    name = "Rails server",
                    program = "bundle",
                    programArgs = { "exec", "rails", "s" },
                    useBundler = true,
                },
                {
                    type = "ruby",
                    request = "attach",
                    name = "Attach to Process",
                    remoteHost = "127.0.0.1",
                    remotePort = 1234,
                    remoteWorkspace = "${workspaceFolder}",
                },
            }

            -- C#
            dap.adapters.coreclr = {
                type = "executable",
                command = "dotnet",
                args = { "exec", "~/.local/share/nvim/mason/packages/netcoredbg/", "--interpreter=vscode" },
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "Launch",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            "Path to dll: ",
                            vim.fn.getcwd() .. "~/projects/vitae/bin/Debug/net9.0/vitae.dll",
                            "file"
                        )
                    end,
                },
            }

            vim.fn.sign_define("DapBreakpoint", { text = "󰃤" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[d]ebug [c]ontinue" })
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "toggle [d]ebug [b]reakpoint" })
            vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "[d]ebug [n]ext (step over)" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[d]ebug [i]nto (step into)" })
            vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "[d]ebug [o]ut (step out)" })
            vim.keymap.set("n", "<leader>dC", function() dap.clear_breakpoints() end, { desc = "[C]lear breakpoints" })
            vim.keymap.set("n", "<leader>de", function()
                dap.clear_breakpoints()
                dap.terminate()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
            end, { desc = "[d]ebug [e]xit" })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
            automatic_setup = true,
            handlers = {},
        },
    },
}
