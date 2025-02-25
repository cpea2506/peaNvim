local utils = require("pea.ui.utils")

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

local function calculate_prefer_width(prompt, default)
	local prompt_lines = vim.split(prompt, "\n", { plain = true, trimempty = true })
	local width = utils.calculate_width(prefer_width, win_config.width, min_width, max_width, 0)
	width = math.max(prefer_width, 4 + utils.get_max_strwidth(prompt_lines))

	if default then
		width = math.max(prefer_width, 2 + vim.api.nvim_strwidth(default))
	end

	return utils.calculate_width(width, win_config.width, min_width, max_width)
end

vim.ui.input = function(opts, on_confirm)
	local prompt = opts.prompt or "Input"
	local default = opts.default or ""

	win_config.title = prompt
	win_config.width = calculate_prefer_width(prompt, default)

	on_confirm = on_confirm or function() end

	local function close(winid)
		on_confirm(nil)
		vim.cmd("stopinsert")
		vim.api.nvim_win_close(winid, true)
	end

	-- Create floating window.
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winid = vim.api.nvim_open_win(bufnr, true, win_config)

	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].filetype = "Input"

	vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, { default })
	vim.cmd("startinsert")
	vim.api.nvim_win_set_cursor(winid, { 1, vim.str_utfindex(default) + 1 })

	vim.keymap.set({ "n", "i", "v" }, "<cr>", function()
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)

		vim.cmd("stopinsert")
		on_confirm(lines[1])
		vim.api.nvim_win_close(winid, true)
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
