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
		dependencies = "HiPhish/rainbow-delimiters.nvim",
		config = function()
			require("nvim-treesitter.configs").setup({
				sync_install = true,
				auto_install = false,
				ensure_installed = {
					"glsl",
					"bash",
					"comment",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"regex",
					"rust",
					"c_sharp",
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
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufRead",
		opts = {
			mode = "cursor",
			max_lines = 3,
		},
	},
}
