return {
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
		{ "<leader>Tu", "<cmd>TSUpdateSync<cr>", "Treesitter Update Sync" },
		{ "<leader>Th", "<cmd>TSHighlightCapturesUnderCursor<cr>", "Show Highlighting Group" },
	},
	event = "VeryLazy",
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
			playground = {
				enable = true,
			},
		})
	end,
}
