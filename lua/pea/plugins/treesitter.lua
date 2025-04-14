return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	cmd = { "TSInstall", "TSUpdateSync" },
	event = "LazyFile",
	dependencies = {
		{
			"HiPhish/rainbow-delimiters.nvim",
			submodules = false,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				mode = "cursor",
				max_lines = 3,
			},
		},
	},
	opts = {
		auto_install = true,
		autotag = {
			enable = true,
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
