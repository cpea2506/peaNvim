return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		cmd = {
			"TSInstall",
			"TSUninstall",
			"TSUpdate",
			"TSUpdateSync",
			"TSInstallInfo",
			"TSInstallSync",
		},
		keys = {
			{ "<leader>Tu", "<cmd>TSUpdateSync<cr>", desc = "Treesitter Update Sync" },
		},
		event = { "BufRead", "VeryLazy" },
		dependencies = {
			"HiPhish/rainbow-delimiters.nvim",
			"nvim-treesitter/nvim-treesitter-context",
		},
		opts = {
			sync_install = true,
			auto_install = true,
			autotag = {
				enable = true,
			},
			highlight = {
				enable = true,
			},
			rainbow = {
				enable = true,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			mode = "cursor",
			max_lines = 3,
		},
	},
}
