local usercmds = {
	{
		"BufClose",
		function()
			local command = "bd"
			local bo = vim.bo
			local api = vim.api
			local fmt = string.format
			local fn = vim.fn
			local bufnr = api.nvim_get_current_buf()
			local bufname = api.nvim_buf_get_name(bufnr)
			local force_close = false

			local choice

			if bo.modified then
				choice = fn.confirm(fmt([[Save changes to "%s"?]], bufname), "&Yes\n&No\n&Cancel")

				if choice == 1 then
					vim.api.nvim_buf_call(bufnr, function()
						vim.cmd("w")
					end)
				elseif choice == 2 then
					force_close = true
				else
					return
				end
			end

			local windows = vim.tbl_filter(function(win)
				return api.nvim_win_get_buf(win) == bufnr
			end, api.nvim_list_wins())

			if force_close then
				command = command .. "!"
			end

			local buffers = vim.tbl_filter(function(buf)
				return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
			end, api.nvim_list_bufs())

			if #buffers > 1 and #windows > 0 then
				for i, v in ipairs(buffers) do
					if v == bufnr then
						local prev_buf_idx = i == 1 and #buffers or (i - 1)
						local prev_buffer = buffers[prev_buf_idx]
						for _, win in ipairs(windows) do
							api.nvim_win_set_buf(win, prev_buffer)
						end
					end
				end
			end

			if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
				vim.cmd(string.format("%s %d", command, bufnr))
			end
		end,
	},
}

for _, usercmd in pairs(usercmds) do
	local opts = vim.tbl_deep_extend("force", { force = true }, usercmd[3] or {})

	vim.api.nvim_create_user_command(usercmd[1], usercmd[2], opts)
end
