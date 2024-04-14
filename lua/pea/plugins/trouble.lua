local icons = require("pea.icons").diagnostics

return {
	"folke/trouble.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	keys = {
		{ "<leader>to", "<cmd>TroubleToggle<cr>", desc = "Show Diagnostics" },
	},
	opts = {
		auto_open = false,
		auto_close = true,
		use_diagnostic_signs = false,
		signs = {
			error = icons.ERROR,
			warning = icons.WARN,
			hint = icons.HINT,
			information = icons.INFO,
			other = icons.INFO,
		},
	},
}
