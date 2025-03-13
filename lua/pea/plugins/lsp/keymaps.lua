local M = {}

local keymappings = {
	{ "gd", vim.lsp.buf.definition, desc = "Definition" },
	{ "gr", vim.lsp.buf.references, desc = "References" },
	{ "gi", vim.lsp.buf.implementation, desc = "Implementation" },
	{
		"gl",
		function()
			local config = vim.diagnostic.config().float
			config.scope = "line"

			vim.diagnostic.open_float(config)
		end,
		desc = "Show Line Diagnostics",
	},
	{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
	{ "<leader>la", vim.lsp.buf.code_action, mode = { "n", "v" }, desc = "Code Action" },
	{ "<leader>ll", vim.lsp.codelens.run, mode = { "n", "v" }, desc = "Codelens" },
	{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
	{ "<leader>ls", vim.lsp.buf.document_symbol, desc = "Document Symbol" },
}

function M.on_attach(_, bufnr)
	local keyhandler = require("lazy.core.handler.keys")
	local keys = keyhandler.resolve(keymappings)

	for _, key in pairs(keys) do
		local opts = keyhandler.opts(key)

		opts.silent = true
		opts.noremap = true
		opts.buffer = bufnr

		vim.keymap.set(key.mode, key.lhs, key.rhs, opts)
	end
end

return M
