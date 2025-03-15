local icons = require("pea.config.ui.icons")

local function isempty(s)
	return s == nil or s == ""
end

local function get_filename()
	local filename = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")

	if not isempty(filename) then
		local devicons = require("nvim-web-devicons")
		local file_icon, hl_group = devicons.get_icon(filename, extension, { default = true })

		if isempty(file_icon) then
			file_icon = icons.kind.File
		end

		local navic_text = vim.api.nvim_get_hl_by_name("Normal", true)

		vim.api.nvim_set_hl(0, "Winbar", { fg = navic_text.foreground })

		return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
	end
end

local function get_location()
	local nvim_navic = require("nvim-navic")

	local location = nvim_navic.get_location()

	if not nvim_navic.is_available() or location == "error" then
		return ""
	end

	if not isempty(location) then
		return "%#NavicSeparator#" .. icons.ui.ChevronRight .. "%* " .. location
	else
		return ""
	end
end

local function set_winbar()
	local value = get_filename()
	local location_added = false

	if not isempty(value) then
		local location_value = get_location()

		value = value .. " " .. location_value

		if not isempty(location_value) then
			location_added = true
		end
	end

	if not isempty(value) and vim.api.nvim_get_option_value("mod", { buf = 0 }) then
		local mod = "%#LspCodeLens#" .. icons.ui.Circle .. "%*"

		if location_added then
			value = value .. " " .. mod
		else
			value = value .. mod
		end
	end

	local num_tabs = #vim.api.nvim_list_tabpages()

	if num_tabs > 1 and not isempty(value) then
		local tabpage_number = tostring(vim.api.nvim_tabpage_get_number(0))

		value = value .. "%=" .. tabpage_number .. "/" .. tostring(num_tabs)
	end

	vim.api.nvim_set_option_value("winbar", value, { scope = "local" })
end

return {
	"smiteshp/nvim-navic",
	event = "VeryLazy",
	opts = {
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
	},
	config = function(_, opts)
		require("nvim-navic").setup(opts)

		local winbar_group = vim.api.nvim_create_augroup("navic-winbar", { clear = true })

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
			group = winbar_group,
			callback = function(args)
				if vim.tbl_contains(opts.exclude_filetypes, vim.bo[args.buf].filetype) then
					return
				end

				set_winbar()
			end,
		})
	end,
}
