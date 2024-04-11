local keymapping = {
	n = {
		["<leader>q"] = "<cmd>confirm q<cr>",
		["<C-e>"] = "<cmd>BuffClose<cr>",
		["<C-s>"] = "<cmd>w<cr>",

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
	c = {
		-- Navigate tab completion with <c-j> and <c-k>.
		-- Runs conditionally.
		["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
		["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
	},
}

return keymapping
