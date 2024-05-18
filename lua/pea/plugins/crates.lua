return {
	"saecki/crates.nvim",
	event = "BufRead Cargo.toml",
	opts = {
		date_format = "%d-%m-%Y",
		disable_invalid_feature_diagnostic = true,
		popup = {
			autofocus = true,
			border = "rounded",
		},
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
		completion = {
			crates = {
				enabled = true,
				max_results = 8,
				min_chars = 3,
			},
			cmp = {
				enabled = true,
			},
		},
	},
}
