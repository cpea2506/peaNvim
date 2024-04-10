return {
	{
		"anuvyklack/windows.nvim",
		keys = {
			{ "<C-w>a", "<cmd>WindowsMaximize<cr>", "Windows Maximize" },
			{ "<C-w>=", "<cmd>WindowsEqualize<cr>", "Windows Equalize" },
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
