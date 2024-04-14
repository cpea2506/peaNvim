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
		event = "VeryLazy",
		dependencies = "HiPhish/rainbow-delimiters.nvim",
		config = function()
			require("nvim-treesitter.configs").setup({
				sync_install = true,
				auto_install = false,
				ensure_installed = {
					"bash",
					"comment",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"regex",
					"rust",
					"toml",
					"vim",
					"yaml",
					"vimdoc",
				},
				autotag = {
					enable = true,
				},
				highlight = {
					enable = true,
				},
				rainbow = {
					enable = true,
				},
			})
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		lazy = true,
	},
}
