return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			cs = { "csharpier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			markdown = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			cpp = { "clang-format" },
		},
		formatters = {
			csharpier = {
				cwd = function(_, ctx)
					return vim.fs.root(ctx.dirname, { ".csharpierrc" })
				end,
				require_cwd = true,
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
