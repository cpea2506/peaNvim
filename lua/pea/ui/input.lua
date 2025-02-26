local utils = require("pea.ui.utils")

local icon = " "
local prefer_width = 40
local max_width = { 140, 0.9 }
local min_width = { 20, 0.2 }

local win_config = {
	relative = "cursor",
	anchor = "NW",
	row = 1,
	col = 1,
	width = 40,
	height = 1,
	focusable = false,
	noautocmd = true,
	style = "minimal",
	border = "rounded",
}

local win_options = {
	wrap = false,
	list = true,
	listchars = "precedes:…,extends:…",
	sidescrolloff = 0,
	statuscolumn = " %#InputIcon#" .. icon .. " ",
}

local buf_options = {
	swapfile = false,
	bufhidden = "wipe",
	filetype = "Input",
}

local function trim_and_pad_title(title)
	title = vim.trim(title):gsub(":$", "")

	return (" %s "):format(title)
end

vim.ui.input = function(opts, on_confirm)
	local prompt = opts.prompt or "Input"
	local default = opts.default or ""

	local prompt_lines = vim.split(prompt, "\n", { plain = true, trimempty = true })
	local width = utils.calculate_width(prefer_width, win_config.width, min_width, max_width)
	width = math.max(width, 4 + utils.get_max_strwidth(prompt_lines))

	if default then
		width = math.max(width, 2 + vim.api.nvim_strwidth(default))
	end

	win_config.title = trim_and_pad_title(prompt)
	win_config.width = utils.calculate_width(width, win_config.width, min_width, max_width)

	on_confirm = on_confirm or function() end

	local function close(winid, content)
		vim.cmd.stopinsert()
		on_confirm(content)
		vim.api.nvim_win_close(winid, true)
	end

	-- Create floating window.
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winid = vim.api.nvim_open_win(bufnr, true, win_config)

	-- Set buffer options.
	for option, value in pairs(buf_options) do
		vim.api.nvim_set_option_value(option, value, { scope = "local", buf = bufnr })
	end

	-- Set window options.
	for option, value in pairs(win_options) do
		vim.api.nvim_set_option_value(option, value, { scope = "local", win = winid })
	end

	if default then
		vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, { default })
		vim.cmd.startinsert()
		vim.api.nvim_win_set_cursor(winid, { 1, vim.str_utfindex(default) + 1 })
	end

	vim.keymap.set({ "n", "i", "v" }, "<cr>", function()
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)

		close(winid, lines[1])
	end, { buffer = bufnr })

	vim.keymap.set("n", "<esc>", function()
		close(winid)
	end, { buffer = bufnr })

	vim.keymap.set("i", "<C-c>", function()
		close(winid)
	end, { buffer = bufnr })

	vim.keymap.set("n", "q", function()
		close(winid)
	end, { buffer = bufnr })

	vim.api.nvim_create_autocmd("BufLeave", {
		desc = "Cancel vim.ui.input",
		buffer = bufnr,
		nested = true,
		once = true,
		callback = function()
			close(winid)
		end,
	})
end
