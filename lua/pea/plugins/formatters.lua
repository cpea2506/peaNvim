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
			javascript = { "prettier" },
			typescript = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	config = function(_, opts)
		local conform = require("conform")
		local utils = require("conform.util")

		opts.formatters = {
			csharpier = {
				cwd = utils.root_file({ ".csharpierrc" }),
				require_cwd = true,
			},
		}

		conform.setup(opts)
	end,
}
