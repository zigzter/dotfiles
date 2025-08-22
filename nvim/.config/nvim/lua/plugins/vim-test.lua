-- Run tests from nvim
return {
  "vim-test/vim-test",
  config = function()
    vim.g["test#typescript#denotest#options"] = "--allow-read"
    vim.g["test#javascript#denotest#options"] = "--allow-read"

    -- Add --require test/setup.js for Node.js test runners
    vim.g["test#javascript#mocha#options"] = "--require test/setup.js"
    vim.g["test#javascript#jest#options"] = "--require test/setup.js"
    vim.g["test#javascript#tap#options"] = "--require test/setup.js"
  end,
}
