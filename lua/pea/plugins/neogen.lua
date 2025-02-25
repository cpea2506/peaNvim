return {
	"danymat/neogen",
	event = "BufRead",
	keys = {
		{ "<leader>ld", "<cmd>Neogen<cr>", desc = "Generate language documentation" },
	},
	opts = {
		snippet_engine = "nvim",
		languages = {
			cs = {
				template = {
					annotation_convention = "xmldoc",
				},
			},
		},
	},
}
