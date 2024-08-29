return {
	"docker_telescope",
	dir = "~/.config/nvim/lua/custom/docker_telescope.lua",
	dev = true,
	enabled = false,
	config = function()
		require("docker_telescope").setup()
	end,
}
