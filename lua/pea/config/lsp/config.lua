local M = {}

local icons = require("pea.config.ui.icons")

M.diagnostics = {
	update_in_insert = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.ERROR,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.WARN,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.HINT,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.INFO,
		},
	},
	virtual_lines = {
		current_line = true,
		format = function(diagnostic)
			local severity = vim.diagnostic.severity[diagnostic.severity]

			return icons.diagnostics[severity] .. " " .. diagnostic.message
		end,
	},
	underline = true,
	severity_sort = true,
	float = {
		source = true,
		severity_sort = true,
		focusable = true,
		style = "minimal",
		border = "rounded",
	},
}

local function set_keymaps(bufnr)
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

local codelens_refresh_group = vim.api.nvim_create_augroup("pea_codelens_refresh", { clear = true })
local document_highlight_group = vim.api.nvim_create_augroup("pea_document_highlight", { clear = true })

M.on_attach = function(client, bufnr)
	set_keymaps(bufnr)

	if client:supports_method("textDocument/inlayHint", bufnr) then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	if client:supports_method("textDocument/codeLens", bufnr) then
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			group = codelens_refresh_group,
			buffer = bufnr,
			callback = vim.lsp.codelens.refresh,
		})
	end

	if client:supports_method("textDocument/documentHighlight", bufnr) then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = document_highlight_group,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd("CursorMoved", {
			group = document_highlight_group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

M.on_exit = function(client, bufnr)
	if client:supports_method("textDocument/codeLens", bufnr) then
		vim.api.nvim_clear_autocmds({
			group = codelens_refresh_group,
			buffer = bufnr,
		})
	end

	if client:supports_method("textDocument/documentHighlight", bufnr) then
		vim.api.nvim_clear_autocmds({
			group = document_highlight_group,
			buffer = bufnr,
		})
	end
end

M.capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	return capabilities
end

return M
