return {
	"numToStr/Comment.nvim",
	keys = {
		{ "gc", mode = { "n", "v" } },
		{ "gb", mode = { "n", "v" } },
	},
	opts = {
		padding = true,
		sticky = true,
		ignore = "^$",
		mappings = {
			basic = true,
			extra = true,
		},
		toggler = {
			line = "gcc",
			block = "gbc",
		},
		opleader = {
			line = "gc",
			block = "gb",
		},
		extra = {
			above = "gcO",
			below = "gco",
			eol = "gcA",
		},
	},
}
