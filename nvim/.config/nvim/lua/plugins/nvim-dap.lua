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
