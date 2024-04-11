return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato",
			integrations = {
				dashboard = true,
				harpoon = true,
				leap = true,
				mason = true,
				mini = {
					enabled = true,
				},
				noice = true,
				telescope = {
					enabled = true,
				},
				treesitter = true,
			},
		})
	end,
}
