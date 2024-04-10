return {
	{
		"folke/lazy.nvim",
		keys = {
			{ "<leader>pi", "<cmd>Lazy install<cr>", "Lazy Install" },
			{ "<leader>ps", "<cmd>Lazy sync<cr>", "Lazy Sync" },
			{ "<leader>pS", "<cmd>Lazy clear<cr>", "Lazy Status" },
			{ "<leader>pc", "<cmd>Lazy clean<cr>", "Lazy Clean" },
			{ "<leader>pu", "<cmd>Lazy update<cr>", "Lazy Update" },
			{ "<leader>pp", "<cmd>Lazy profile<cr>", "Lazy Profile" },
			{ "<leader>pl", "<cmd>Lazy log<cr>", "Lazy Log" },
			{ "<leader>pd", "<cmd>Lazy debug<cr>", "Lazy Debug" },
		},
		opts = {
			root = vim.fn.stdpath("data") .. "/lazy",
			defaults = {
				lazy = true,
			},
			install = {
				missing = true,
				colorscheme = { "one_monokai" },
			},
			ui = {
				border = "rounded",
				backdrop = 100,
				title = "Plugins",
				title_pos = "center",
				pills = true,
				throttle = 20,
			},
			checker = {
				enabled = true,
				concurrency = nil,
				notify = true,
				frequency = 43200,
			},
			change_detection = {
				enabled = true,
				notify = true,
			},
			performance = {
				cache = {
					enabled = true,
				},
				reset_packpath = true,
			},
			profiling = {
				loader = true,
				require = true,
			},
		},
	},
}
