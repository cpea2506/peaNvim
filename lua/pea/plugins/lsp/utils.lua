local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local codelens_refresh_group = augroup("codelens_refresh", { clear = false })
local document_highlight_group = augroup("document_highlight", { clear = false })

M.on_attach = function(client, bufnr)
	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	if client.supports_method("textDocument/codeLens") then
		autocmd({ "BufEnter", "InsertLeave" }, {
			group = codelens_refresh_group,
			buffer = bufnr,
			callback = vim.lsp.codelens.refresh,
		})
	end

	if client.supports_method("textDocument/documentHighlight") then
		autocmd({ "CursorHold", "CursorHoldI" }, {
			group = document_highlight_group,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})

		autocmd("CursorMoved", {
			group = document_highlight_group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	require("pea.plugins.lsp.keymaps").on_attach(client, bufnr)
end

M.on_exit = function(client, bufnr)
	if client.supports_method("textDocument/codeLens") then
		vim.api.nvim_clear_autocmds({
			group = codelens_refresh_group,
			buffer = bufnr,
		})
	end

	if client.supports_method("textDocument/documentHighlight") then
		vim.api.nvim_clear_autocmds({
			group = document_highlight_group,
			buffer = bufnr,
		})
	end
end

M.capabilities = function()
	local has_nvim_lsp, nvim_lsp = pcall(require, "cmp_nvim_lsp")
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	if not has_nvim_lsp then
		return capabilities
	end

	capabilities = vim.tbl_deep_extend("force", capabilities, nvim_lsp.default_capabilities())

	return capabilities
end

return M
