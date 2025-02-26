return {
	"cpea2506/one_monokai.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		themes = function(colors)
			return {
				["@lsp.type.event.cs"] = { fg = colors.yellow },
				["@lsp.type.delegate.cs"] = { link = "@function" },
				["@lsp.type.keyword.cs"] = { fg = colors.pink },
				["@lsp.type.constant.cs"] = { link = "@constant" },
				["@lsp.type.interface.cs"] = { link = "@type" },
				InputIcon = { fg = colors.cyan },
			}
		end,
	},
}
