local keyhandler = require("lazy.core.handler.keys")

local keymappings = {
	{ "<leader>q", "<cmd>confirm q<cr>" },
	{ "<C-e>", "<cmd>BuffClose<cr>" },
	{ "<C-s>", "<cmd>confirm w<cr>" },

	-- Better window movement.
	{ "<C-h>", "<C-w>h" },
	{ "<C-j>", "<C-w>j" },
	{ "<C-k>", "<C-w>k" },
	{ "<C-l>", "<C-w>l" },

	{ "<leader>Th", vim.show_pos },

	-- Better indenting.
	{ "<", "<gv", mode = "v" },
	{ ">", ">gv", mode = "v" },
}

local keys = keyhandler.resolve(keymappings)

for _, key in pairs(keys) do
	local opts = keyhandler.opts(key)

	opts.silent = true
	opts.noremap = true

	vim.keymap.set(key.mode, key.lhs, key.rhs, opts)
end
