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
		},
		formatters = {
			csharpier = {
				cwd = function(_, ctx)
					return vim.fs.root(ctx.dirname, { ".csharpierrc" })
				end,
				require_cwd = true,
			},
		},
		format_on_save = function(bufnr)
			local ignore_filetypes = { "lua" }

			if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				return { lsp_format = "fallback" }
			end

			-- SAFETY: gitsigns is always loaded before conform.
			local gitsigns = require("gitsigns")
			local hunks = gitsigns.get_hunks(bufnr)

			if hunks == nil then
				return
			end

			local conform = require("conform")

			for i = #hunks, 1, -1 do
				local hunk = hunks[i]

				if hunk ~= nil and hunk.type ~= "delete" then
					local start = hunk.added.start
					local last = start + hunk.added.count
					local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
					local range = {
						start = { start, 0 },
						["end"] = { last - 1, last_hunk_line:len() },
					}

					conform.format({ range = range, lsp_format = "fallback" })
				end
			end
		end,
	},
}
