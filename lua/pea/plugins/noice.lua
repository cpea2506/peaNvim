return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = "MunifTanjim/nui.nvim",
	opts = function()
		local icons = require("pea.config.ui.icons")

		return {
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
				hover = {
					enabled = false,
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
			},
			views = {
				mini = {
					win_options = {
						winblend = 0,
					},
				},
			},
		}
	end,
}
