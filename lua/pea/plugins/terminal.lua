---@diagnostic disable-next-line: lowercase-global
function lazygit_toggle()
	local terminal = require("toggleterm.terminal").Terminal
	local size = 99999

	local lazygit = terminal:new({
		cmd = "lazygit",
		hidden = true,
		direction = "float",
		float_opts = {
			border = "none",
			width = size,
			height = size,
		},
		on_open = function(_)
			vim.cmd("startinsert!")
		end,
		on_close = function(_) end,
		count = 99,
	})

	lazygit:toggle()
end

return {
	{
		"akinsho/toggleterm.nvim",
		keys = {
			"<C-t>",
			{ "<leader>gg", "<cmd>lua lazygit_toggle()<cr>", desc = "Lazygit Toggle" },
		},
		opts = {
			open_mapping = "<C-t>",
			direction = "horizontal",
			close_on_exit = true,
			shade_terminals = false,
			autochdir = true,
			size = 15,
		},
	},
}
