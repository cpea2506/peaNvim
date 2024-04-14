local icons = require("pea.icons")

return {
	"lewis6991/gitsigns.nvim",
	event = "BufRead",
	opts = {
		signs = {
			add = { text = icons.ui.BoldLine },
			change = { text = icons.ui.BoldLine },
			delete = { text = icons.ui.Triangle },
			topdelete = { text = icons.ui.Triangle },
			changedelete = { text = icons.ui.BoldLine },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = true,
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 500,
			ignore_whitespace = false,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		sign_priority = 6,
		status_formatter = nil,
		update_debounce = 100,
		max_file_length = 40000,
		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		on_attach = function(bufnr)
			local keyhandler = require("lazy.core.handler.keys")
			local gitsigns = require("gitsigns")

			local keymappings = {
				{
					"<leader>gn",
					function()
						gitsigns.nav_hunk("next")
					end,
					desc = "Git Navigate to Next Hunk",
				},

				{
					"<leader>gp",
					function()
						gitsigns.nav_hunk("prev")
					end,
					desc = "Git Navigate to Previous Hunk",
				},
				{ "<leader>gs", gitsigns.stage_hunk, desc = "Git Stage Hunk" },
				{ "<leader>gr", gitsigns.reset_hunk, desc = "Git Reset Hunk" },
				{
					"<leader>gs",
					function()
						gitsigns.stage_hunk({
							vim.fn.line("."),
							vim.fn.line("v"),
						})
					end,
					mode = "v",
					desc = "Git Stage Hunk",
				},
				{
					"<leader>gr",
					function()
						gitsigns.reset_hunk({
							vim.fn.line("."),
							vim.fn.line("v"),
						})
					end,
					mode = "v",
					desc = "Git Reset Hunk",
				},
				{ "<leader>gS", gitsigns.stage_buffer, desc = "Git Stage Buffer" },
				{ "<leader>gu", gitsigns.undo_stage_hunk, "Git Undo Stage Hunk" },
				{ "<leader>gR", gitsigns.reset_buffer, "Git Reset Buffer" },
				{ "<leader>gp", gitsigns.preview_hunk, "Git Preview Hunk" },
				{ "<leader>gd", gitsigns.diffthis },
				{
					"<leader>gD",
					function()
						gitsigns.diffthis("~")
					end,
				},
				{ "<leader>ge", gitsigns.toggle_deleted },
			}

			local keys = keyhandler.resolve(keymappings)

			for _, key in pairs(keys) do
				local opts = keyhandler.opts(key)
				opts.silent = true
				opts.buffer = bufnr

				vim.keymap.set(key.mode, key.lhs, key.rhs, opts)
			end
		end,
	},
}
