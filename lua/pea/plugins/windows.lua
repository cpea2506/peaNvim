return {
	{
		"anuvyklack/windows.nvim",
		keys = {
			{ "<C-w>a", "<cmd>WindowsMaximize<cr>", desc = "Windows Maximize" },
			{ "<C-w>=", "<cmd>WindowsEqualize<cr>", desc = "Windows Equalize" },
		},
		config = true,
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
	},
	{
		"anuvyklack/middleclass",
		lazy = true,
	},
	{
		"anuvyklack/animation.nvim",
		lazy = true,
	},
}
