local keymapping = {
	n = {
		["<leader>q"] = "<cmd>confirm q<cr>",
		["<C-e>"] = "<cmd>BuffClose<cr>",
		["<C-s>"] = "<cmd>confirm w<cr>",

		-- Better window movement.
		["<C-h>"] = "<C-w>h",
		["<C-j>"] = "<C-w>j",
		["<C-k>"] = "<C-w>k",
		["<C-l>"] = "<C-w>l",

		["<leader>Th"] = "<cmd>Inspect<cr>",
	},
	i = {},
	v = {
		-- Better indenting
		["<"] = "<gv",
		[">"] = ">gv",
	},
}

return keymapping
