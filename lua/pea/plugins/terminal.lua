return {
	{
	  "akinsho/toggleterm.nvim",
	  keys = {
		  "<C-t>",
	  },
	  opts = {
		  open_mapping = "<C-t>",
		  direction = "horizontal",
		  close_on_exit = true,
		  shade_terminals = false,
		  autochdir = true,
		  size = 15,
	  },
	  config = function()
		local function lazygit_toggle()
			local Terminal = require("toggleterm.terminal").Terminal
			  local lazygit = Terminal:new {
				cmd = "lazygit",
				hidden = true,
				direction = "float",
				float_opts = {
				  border = "none",
				  width = 100000,
				  height = 100000,
				},
				on_open = function(_)
				  vim.cmd "startinsert!"
				end,
				on_close = function(_) end,
				count = 99,
				  }
		  lazygit:toggle()

		  vim.keymap.set("n", "<leader>gg", [[<cmd>lua require("pea.plugins.terminal").lazygit_toggle()<cr>]], {desc = "Lazygit Toggle"})
	  end
	}
}
