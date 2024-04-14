return {
	"EnochMtzR/roslyn.nvim",
	event = "BufRead *.cs",
	config = function()
		local lsp = require("pea.plugins.lsp.utils")

		require("roslyn").setup({
			on_attach = lsp.on_attach,
			capabilities = lsp.capabilities(),
		})
	end,
}
