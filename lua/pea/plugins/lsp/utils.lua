local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local codelens_refresh_group = augroup("codelens_refresh", { clear = false })
local document_highlight_group = augroup("document_highlight", { clear = false })

M.on_attach = function(client, bufnr)
	if client:supports_method("textDocument/inlayHint", bufnr) then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	if client:supports_method("textDocument/codeLens", bufnr) then
		autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			group = codelens_refresh_group,
			buffer = bufnr,
			callback = vim.lsp.codelens.refresh,
		})
	end

	if client:supports_method("textDocument/documentHighlight", bufnr) then
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
	local has_blink, blink = pcall(require, "blink.cmp")
	local capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		has_blink and blink.get_lsp_capabilities() or {}
	)

	return capabilities
end

return M
