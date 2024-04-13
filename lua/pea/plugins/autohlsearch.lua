return {
	"asiryk/auto-hlsearch.nvim",
	keys = {
		"/",
		"?",
		"*",
		"#",
		"n",
		"N",
		{
			"<leader>h",
			function()
				vim.o.hlsearch = false
			end,
			desc = "Turn off HlSearch",
		},
	},
	opts = {
		create_commands = false,
	},
}
