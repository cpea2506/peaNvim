local M = {}

local keymappings = {
	{ "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
	{ "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
	{ "gr", vim.lsp.buf.references, desc = "Go to References" },
	{ "gI", vim.lsp.buf.implementation, desc = "Go to Implementation" },
	{
		"gl",
		function()
			local config = vim.diagnostics.config().float
			config.scope = "line"

			vim.diagnostics.open_float(config)
		end,
		desc = "Show Line Diagnostics",
	},
	{ "gt", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
	{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
	{ "<leader>la", vim.lsp.buf.code_action, mode = { "n", "v" }, desc = "Code Action" },
	{ "<leader>ll", vim.lsp.codelens.run, mode = { "n", "v" }, desc = "Run Codelens" },
	{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
	{ "<leader>lj", vim.diagnostic.goto_next, desc = "Next Diagnostics" },
	{ "<leader>lk", vim.diagnostic.goto_prev, desc = "Previous Diagnostics" },
	{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
}

function M.on_attach(_, bufnr)
	local keyhandler = require("lazy.core.handler.keys")
	local keys = keyhandler.resolve(keymappings)

	for _, key in pairs(keys) do
		local opts = keyhandler.opts(key)

		opts.silent = true
		opts.buffer = bufnr

		vim.keymap.set(key.mode, key.lhs, key.rhs, opts)
	end
end

return M
