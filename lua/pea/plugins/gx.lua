return {
	"chrishrb/gx.nvim",
	keys = {
		{ "gx", "<cmd>Browse<cr>", mode = { "n", "x" } },
	},
	cmd = "Browse",
	init = function()
		vim.g.netrw_nogx = 1
	end,
	submodules = false,
	opts = {
		handlers = {
			plugin = true,
			github = true,
			brewfile = true,
			package_json = true,
			search = true,
		},
	},
}
