return {
	"anuvyklack/windows.nvim",
	dependencies = {
		"anuvyklack/middleclass",
		"anuvyklack/animation.nvim",
	},
	keys = {
		{ "<C-w>a", "<cmd>WindowsMaximize<cr>", desc = "Windows Maximize" },
		{ "<C-w>=", "<cmd>WindowsEqualize<cr>", desc = "Windows Equalize" },
	},
	event = "VeryLazy",
	config = true,
}
