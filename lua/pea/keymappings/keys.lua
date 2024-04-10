local keymapping = {
	n = {
		["<leader>q"] = "<cmd>q<cr>",
		["<C-e>"] = "<cmd>bd<cr>",
		["<C-s>"] = "<cmd>w<cr>",

		-- Better window movement.
		["<C-h>"] = "<C-w>h",
		["<C-j>"] = "<C-w>j",
		["<C-k>"] = "<C-w>k",
		["<C-l>"] = "<C-w>l",

		-- Move current line / block.
		["<M-j>"] = ":m .+1<cr>==",
		["<M-k>"] = ":m .-2<cr>==",
	},
	i = {},
	v = {
		-- Better indenting
		["<"] = "<gv",
		[">"] = ">gv",
	},

	x = {
		-- Move current line / block.
		["<M-j>"] = ":m '>+1<cr>gv-gv",
		["<M-k>"] = ":m '<-2<cr>gv-gv",
	},
	c = {
		-- Navigate tab completion with <c-j> and <c-k>.
		-- Runs conditionally.
		["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
		["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
	},
}

return keymapping
