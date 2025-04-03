return {
	"cpea2506/one_monokai.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		highlights = function(colors)
			return {
				["@lsp.type.event.cs"] = { fg = colors.yellow },
				["@lsp.type.delegate.cs"] = { link = "@function" },
				["@lsp.type.keyword.cs"] = { fg = colors.pink },
				["@lsp.type.constant.cs"] = { link = "@constant" },
				["@lsp.type.interface.cs"] = { link = "@type" },

				WinBar = { link = "Normal" },
				PeaInputIcon = { fg = colors.cyan },
				PeaSelectOption = { fg = colors.aqua },
				PeaSelectOptionIcon = { bg = colors.dark_gray },
				DapBreakpoint = { fg = colors.dark_red, ctermbg = 0 },
				DapLogPoint = { fg = colors.aqua, ctermbg = 0 },
				DapStopped = { fg = colors.green, ctermbg = 0 },
			}
		end,
	},
}
