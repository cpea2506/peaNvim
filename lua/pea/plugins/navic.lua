return {
	"smiteshp/nvim-navic",
	event = "LspAttach",
	opts = function()
		local icons = require("pea.config.ui.icons")

		return {
			icons = vim.tbl_map(function(icon)
				return icon .. " "
			end, icons.kind),
			lsp = {
				auto_attach = true,
			},
			depth_limit = 0,
			depth_limit_indicator = "..",
			separator = " " .. icons.ui.ChevronRight .. " ",
			highlight = true,
			exclude_filetypes = {
				"help",
				"lazy",
				"NvimTree",
				"toggleterm",
				"noice",
				"",
			},
		}
	end,
	config = function(_, opts)
		local navic = require("nvim-navic")
		local icons = require("pea.config.ui.icons")

		navic.setup(opts)

		local function is_empty(s)
			return s == nil or s == ""
		end

		local function get_filename()
			local filename = vim.fn.expand("%:t")

			if not is_empty(filename) then
				local extension = vim.fn.expand("%:e")
				local devicons = require("nvim-web-devicons")
				local fileicon, hlgroup = devicons.get_icon(filename, extension, { default = true })

				if is_empty(fileicon) then
					fileicon = icons.kind.File
				end

				local text_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
				vim.api.nvim_set_hl(0, "Winbar", { fg = text_hl.foreground })

				return " " .. "%#" .. hlgroup .. "#" .. fileicon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
			end
		end

		local function get_location()
			if not navic.is_available() then
				return ""
			end

			local location = navic.get_location()

			if not is_empty(location) and location ~= "error" then
				return "%#NavicSeparator#" .. icons.ui.ChevronRight .. "%* " .. location
			end

			return ""
		end

		local augroup = vim.api.nvim_create_augroup("navic-winbar", { clear = true })

		vim.api.nvim_create_autocmd({
			"CursorHoldI",
			"CursorHold",
			"BufWinEnter",
			"BufFilePost",
			"InsertEnter",
			"BufWritePost",
			"TabClosed",
			"TabEnter",
		}, {
			group = augroup,
			callback = function(args)
				if vim.tbl_contains(opts.exclude_filetypes, vim.bo[args.buf].filetype) then
					return
				end

				local winbar = get_filename()
				local location_added = false

				if not is_empty(winbar) then
					local location = get_location()
					winbar = winbar .. " " .. location

					if not is_empty(location) then
						location_added = true
					end
				end

				if not is_empty(winbar) and vim.api.nvim_get_option_value("mod", { buf = 0 }) then
					local modified = "%#LspCodeLens#" .. icons.ui.Circle .. "%*"

					if location_added then
						winbar = winbar .. " " .. modified
					else
						winbar = winbar .. modified
					end
				end

				vim.api.nvim_set_option_value("winbar", winbar, { scope = "local" })
			end,
		})
	end,
}
