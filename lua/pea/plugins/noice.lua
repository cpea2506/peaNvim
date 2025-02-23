local icons = require("pea.icons")

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = "MunifTanjim/nui.nvim",
	opts = {
		cmdline = {
			view = "cmdline",
			format = {
				cmdline = { icon_hl_group = "DevIconVim" },
				lua = { icon_hl_group = "DevIconLua" },
				help = { icon_hl_group = "Operator" },
			},
		},
		format = {
			spinner = {
				name = "circleFull",
			},
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
			signature = {
				enabled = false,
			},
			progress = {
				format_done = {
					{ icons.ui.Tick .. " ", hl_group = "Identifier" },
					{ "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
					{ "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
				},
			},
		},
		presets = {
			long_message_to_split = true,
			lsp_doc_border = true,
		},
		views = {
			mini = {
				win_options = {
					winblend = 0,
				},
			},
		},
	},
}
