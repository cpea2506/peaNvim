return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				lua = { "selene" },
			},
		},
		config = function(_, opts)
			local lint = require("lint")

			lint.linters_by_ft = opts.linters_by_ft

			local function debounce(ms, fn)
				local timer = vim.uv.new_timer()

				return function(...)
					local argv = { ... }

					if timer then
						timer:start(ms, 0, function()
							timer:stop()
							vim.schedule_wrap(fn)(unpack(argv))
						end)
					end
				end
			end

			local function try_lint()
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)

				names = vim.list_extend({}, names)

				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				-- Filter out linters that don't exist or don't match the condition.
				local ctx = {
					filename = vim.api.nvim_buf_get_name(0),
				}
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]

					if not linter then
						vim.notify_once("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
					end

					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				if #names > 0 then
					lint.try_lint(names)
				end
			end

			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = debounce(100, try_lint),
			})
		end,
	},
}
