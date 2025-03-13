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
		event = { "BufRead", "VeryLazy" },
		dependencies = {
			"HiPhish/rainbow-delimiters.nvim",
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					mode = "cursor",
					max_lines = 3,
				},
			},
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
}
