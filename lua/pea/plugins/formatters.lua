return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			cs = { "csharpier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			markdown = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
		},
		format_on_save = {
			async = true,
			lsp_format = "fallback",
		},
		formatters = {
			csharpier = {
				cwd = function(_, ctx)
					return vim.fs.root(ctx.dirname, { ".csharpierrc" })
				end,
				require_cwd = true,
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
