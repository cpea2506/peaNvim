return {
	"Decodetalkers/csharpls-extended-lsp.nvim",
	event = "BufRead *.cs",
	dependencies = "nvim-lspconfig",
	config = function()
		local csharpls_extended = require("csharpls_extended")
		local lspconfig = require("lspconfig")

		lspconfig.csharp_ls.setup({
			handlers = {
				["textDocument/definition"] = csharpls_extended.handler,
				["textDocument/typeDefinition"] = csharpls_extended.handler,
			},
		})
	end,
}
