return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			insert_only = false,
			override = function(conf)
				conf.anchor = "NW"
				conf.col = 1
				conf.row = 1

				return conf
			end,
			win_options = {
				winblend = 0,
			},
			mappings = {
				n = {
					["q"] = "Close",
				},
			},
		},
		select = {
			backend = { "telescope" },
		},
	},
}
