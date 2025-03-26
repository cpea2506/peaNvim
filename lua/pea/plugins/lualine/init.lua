return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus

		if vim.fn.argc(-1) > 0 then
			-- Set an empty statusline till lualine loads.
			vim.o.statusline = " "
		else
			-- Hide the statusline on the starter page.
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		local colors = require("pea.plugins.lualine.colors")
		local components = require("pea.plugins.lualine.components")
		local extensions = require("pea.plugins.lualine.extensions")

		return {
			options = {
				theme = {
					normal = {
						c = { fg = colors.fg, bg = colors.bg },
					},
					inactive = {
						c = { fg = colors.fg, bg = colors.bg },
					},
				},
				disabled_filetypes = {
					"CodeAction",
					"PeaInput",
					"PeaSelect",
					"NvimTree",
					"TelescopePrompt",
					"lspinfo",
					"mason",
					"noice",
					"help",
					"toggleterm",
					"fzf",
				},
				globalstatus = true,
				component_separators = "",
				section_separators = "",
			},
			extensions = {
				extensions.lazy,
				extensions.quickfix,
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {
					components.leftbar,
					components.evil,
					components.filesize,
					components.filetype,
					components.location,
					components.macro,
					components.center,
					components.lsp,
				},
				lualine_x = {
					components.treesitter,
					components.os,
					components.encoding,
					components.branch,
					components.scrollbar,
				},
			},
			inactive_sections = {
				lualine_a = {
					"filename",
				},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}
	end,
}
