local M = {}

function M.on_attach(_, bufnr)
	local keymaps = {
		{ "n", "gd", vim.lsp.buf.definition, { desc = "Definition" } },
		{ "n", "gD", vim.lsp.buf.type_definition, { desc = "Type Definition" } },
		{ "n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" } },
		{ "n", "gn", vim.lsp.buf.rename, { desc = "Rename" } },
		{ { "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code Action" } },
		{ "n", "gr", vim.lsp.buf.references, { desc = "References", nowait = true } },
		{ "n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" } },
	}

	for _, key in pairs(keymaps) do
		local opts = key[4] or {}
		opts.silent = true
		opts.buffer = bufnr

		vim.keymap.set(key[1], key[2], key[3], opts)
	end
end

return M
