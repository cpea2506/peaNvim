local M = {}

local utils = require("pea.config.ui.utils")
local icons = require("pea.config.ui.icons")

local max_width = { 140, 0.8 }
local min_width = { 80, 0.2 }
local max_height = 0.9
local min_height = { 10, 0.2 }

local win_config = {
	relative = "editor",
	anchor = "NW",
	width = nil,
	height = nil,
	focusable = false,
	noautocmd = true,
	zindex = 150,
	style = "minimal",
}

local win_options = {
	cursorline = true,
	cursorlineopt = "both",
	winhighlight = "Normal:FloatNormal,FloatBorder:FloatBorder,CursorLine:Visual",
	statuscolumn = [[%!v:lua.require("pea.config.ui.select").statuscolumn()]],
}

local buf_options = {
	swapfile = false,
	bufhidden = "wipe",
	filetype = "PeaSelect",
}

function M.statuscolumn()
	return vim.v.relnum == 0 and "%#PeaSelectOptionIcon#" .. icons.ui.Forward .. " " or ""
end

local function show_cursor(show)
	vim.api.nvim_set_hl(0, "PeaSelectHiddenCursor", { bg = "#abb2bf", blend = show and 0 or 100 })
	local guicursor = "a:PeaSelectHiddenCursor"

	if show then
		vim.opt.guicursor:remove(guicursor)
	else
		vim.opt.guicursor:append(guicursor)
	end
end

vim.ui.select = function(items, opts, on_choice)
	local prompt = opts.prompt or "Select"

	local bufnr = vim.api.nvim_create_buf(false, true)

	-- Set buffer options.
	for option, value in pairs(buf_options) do
		vim.api.nvim_set_option_value(option, value, { scope = "local", buf = bufnr })
	end

	local function close_window(winid)
		show_cursor(true)
		vim.api.nvim_win_close(winid or 0, true)
	end

	local function choose(winid)
		local cursor = vim.api.nvim_win_get_cursor(0)
		local i = cursor[1]

		close_window(winid)
		on_choice(items[i], i)
	end

	local function cancel(winid)
		close_window(winid)
		on_choice(nil, nil)
	end

	local lines = {}
	local highlights = {}
	local max_line_width = prompt and vim.api.nvim_strwidth(prompt) or 1

	for i, item in ipairs(items) do
		local prefix = i .. ": "

		table.insert(highlights, { #lines, prefix:len() })

		vim.keymap.set("n", tostring(i), function()
			close_window()
			on_choice(items[i], i)
		end, { buffer = bufnr })

		local formatted_item = opts.format_item and opts.format_item(item)
		local line = prefix .. (formatted_item or item)
		max_line_width = math.max(max_line_width, vim.api.nvim_strwidth(line))

		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
	vim.bo[bufnr].modifiable = false

	local ns = vim.api.nvim_create_namespace("pea_select")

	for _, hl in ipairs(highlights) do
		local lnum, end_col = unpack(hl)

		vim.hl.range(bufnr, ns, "PeaSelectOption", { lnum, 0 }, { lnum, end_col })
	end

	win_config.title = utils.trim_and_pad_title(prompt)
	win_config.width = utils.calc_width(win_config.relative, max_line_width, win_config.width, min_width, max_width)
	win_config.height = utils.calc_height(win_config.relative, #lines, win_config.height, min_height, max_height)
	win_config.row = utils.calc_row(win_config.relative, win_config.height)
	win_config.col = utils.calc_column(win_config.relative, win_config.width)

	show_cursor(false)

	local winid = vim.api.nvim_open_win(bufnr, true, win_config)

	-- Set window options.
	for option, value in pairs(win_options) do
		vim.api.nvim_set_option_value(option, value, { scope = "local", win = winid })
	end

	vim.keymap.set("n", "<cr>", function()
		choose(winid)
	end, { buffer = bufnr })

	vim.keymap.set("n", "<esc>", function()
		cancel(winid)
	end, { buffer = bufnr })

	vim.keymap.set("n", "<C-c>", function()
		cancel(winid)
	end, { buffer = bufnr })

	vim.keymap.set("n", "q", function()
		cancel(winid)
	end, { buffer = bufnr })

	local augroup = vim.api.nvim_create_augroup("pea_select", { clear = true })

	vim.api.nvim_create_autocmd("BufLeave", {
		group = augroup,
		desc = "Cancel vim.ui.select",
		buffer = bufnr,
		nested = true,
		once = true,
		callback = function()
			cancel(winid)
		end,
	})

	vim.api.nvim_create_autocmd("CmdlineEnter", {
		group = augroup,
		desc = "Show Cursor",
		buffer = bufnr,
		nested = true,
		callback = function()
			show_cursor(true)
		end,
	})

	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = augroup,
		desc = "Hide Cursor",
		buffer = bufnr,
		nested = true,
		callback = function()
			show_cursor(false)
		end,
	})
end

return M
