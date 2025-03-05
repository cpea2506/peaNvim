local utils = require("pea.utils")
local conditions = require("pea.plugins.lualine.conditions")
local colors = require("pea.plugins.lualine.colors")
local icons = require("pea.icons")

local components = {
	leftbar = {
		function()
			return icons.ui.HeavyLine
		end,
		color = { fg = colors.blue },
		padding = { left = 0, right = 1 },
	},
	evil = {
		function()
			-- auto change color according to neovims mode
			local mode_color = {
				n = colors.red,
				i = colors.green,
				v = colors.blue,
				[""] = colors.blue,
				V = colors.blue,
				c = colors.magenta,
				no = colors.red,
				s = colors.orange,
				S = colors.orange,
				[""] = colors.orange,
				ic = colors.yellow,
				R = colors.violet,
				Rv = colors.violet,
				cv = colors.red,
				ce = colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				["r?"] = colors.cyan,
				["!"] = colors.red,
				t = colors.red,
			}

			vim.api.nvim_set_hl(0, "LualineMode", {
				fg = mode_color[vim.fn.mode()],
				bg = colors.bg,
			})

			return icons.ui.Evil
		end,
		color = "LualineMode",
		padding = { right = 1 },
	},
	filesize = {
		"filesize",
		cond = conditions.buffer_not_empty,
	},
	diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		symbols = {
			error = icons.diagnostics.ERROR .. " ",
			warn = icons.diagnostics.WARN .. " ",
			info = icons.diagnostics.INFO .. " ",
		},
		diagnostics_color = {
			color_error = { fg = colors.red },
			color_warn = { fg = colors.yellow },
			color_info = { fg = colors.cyan },
		},
	},
	center = {
		"%=",
	},
	lsp = {
		function()
			local bufnr = vim.api.nvim_get_current_buf()
			local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
			local buf_client_names = { "LS Inactive" }

			if #buf_clients ~= 0 then
				buf_client_names = {}
			end

			for _, client in pairs(buf_clients) do
				buf_client_names[#buf_client_names + 1] = client.name
			end

			-- Add formatters.
			local formatters = require("conform").list_formatters(bufnr)
			local formatter_names = vim.tbl_map(function(f)
				return f.name
			end, formatters)
			vim.list_extend(buf_client_names, formatter_names)

			-- Add linters.
			local linter_names = require("lint")._resolve_linter_by_ft(vim.bo.filetype)
			vim.list_extend(buf_client_names, linter_names)

			return table.concat(buf_client_names, (" %s "):format(icons.ui.ThinLine))
		end,
		icon = icons.ui.Setting .. " LSP:",
		color = { fg = colors.jungle_green, gui = "bold" },
	},
	diff = {
		"diff",
		source = function()
			local gitsigns = vim.b.gitsigns_status_dict

			if gitsigns then
				return {
					added = gitsigns.added,
					modified = gitsigns.changed,
					removed = gitsigns.removed,
				}
			end
		end,
		symbols = {
			added = icons.git.LineAdded,
			modified = icons.git.LineModified,
			removed = icons.git.LineRemoved,
		},
		diff_color = {
			added = { fg = colors.green },
			modified = { fg = colors.orange },
			removed = { fg = colors.red },
		},
		cond = conditions.should_hide_in_width,
	},
	branch = {
		"b:gitsigns_head",
		icon = icons.git.Branch,
		color = { fg = colors.violet, gui = "bold" },
		cond = conditions.should_hide_in_width,
	},
	filetype = {
		"filetype",
		cond = conditions.should_hide_in_width,
	},
	location = {
		"location",
		cond = conditions.should_hide_in_width,
	},
	os = {
		function()
			return utils.is_windows and icons.ui.Windows or icons.ui.Apple
		end,
		cond = conditions.should_hide_in_width,
		color = { fg = utils.is_windows and colors.cerulean or colors.fg },
	},
	encoding = {
		"o:encoding",
		cond = conditions.should_hide_in_width,
		color = { fg = colors.green, gui = "bold" },
	},
	treesitter = {
		function()
			local bufnr = vim.api.nvim_get_current_buf()
			local active_status = vim.treesitter.highlighter.active[bufnr]

			return active_status and icons.ui.Treesitter .. " " or ""
		end,
		color = { fg = colors.green },
		padding = { right = 0 },
	},
	scrollbar = {
		function()
			local current = vim.fn.line(".")
			local total = vim.fn.line("$")
			local chars = icons.ui.Scrollbar
			local index = math.ceil(current / total * #chars)

			return chars[index]
		end,
		color = { fg = colors.yellow },
		padding = { left = 1 },
	},
	macro = {
		"macro",
		fmt = function()
			local reg = vim.fn.reg_recording()

			return reg ~= "" and "recording @" .. reg or nil
		end,
		color = { fg = colors.orange },
		draw_empty = false,
	},
}

return components
