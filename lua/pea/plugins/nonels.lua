return {
	{
		"nvimtools/none-ls.nvim",
		opts = function()
			local null_ls = require("null-ls")

			return {
				sources = {
					null_ls.builtins.formatting.stylua
				}
			}
		end
	},
}
