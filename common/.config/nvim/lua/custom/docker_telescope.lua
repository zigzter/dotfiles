local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values

local M = {}

M.show_docker_images = function(opts)
	pickers
		.new(opts, {
			finder = finders.new_table({ "yes", "no" }),
			sorter = config.generic_sorter(opts),
		})
		:find()
end

function M.setup()
	vim.keymap.set("n", "<leader>di", M.show_docker_images, { desc = "[D]ocker [I]mages" })
end

return M
