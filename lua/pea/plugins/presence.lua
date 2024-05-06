return {
	"vyfor/cord.nvim",
	build = "./build",
	event = "VeryLazy",
	opts = {
		usercmds = true,
		timer = {
			enable = true,
			interval = 1500,
			reset_on_idle = false,
			reset_on_change = false,
		},
		editor = {
			image = "neovim",
			client = "914799712794705961",
			tooltip = "The Lazy Text Editor",
		},
		display = {
			show_time = true,
			show_repository = false,
			show_cursor_position = false,
			swap_fields = false,
			workspace_blacklist = {},
		},
		lsp = {
			show_problem_count = true,
			severity = 1,
			scope = "workspace",
		},
		idle = {
			enable = true,
			show_status = true,
			disable_on_focus = true,
			text = "Chilling with my D",
			tooltip = "💤",
		},
		text = {
			viewing = "",
			editing = "",
			file_browser = "Browsing files in {}",
			plugin_manager = "Managing plugins in {}",
			lsp_manager = "Configuring LSP in {}",
			workspace = "Crababarian 🦀",
		},
		buttons = {
			{
				label = "View Repository",
				url = "git",
			},
		},
		assets = {
			lua = {
				icon = "lua",
			},
			rust = {
				icon = "rust",
			},
		},
	},
}
