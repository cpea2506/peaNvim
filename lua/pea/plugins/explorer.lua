return {
	"stevearc/oil.nvim",
	lazy = false,
	keys = {
		{ "<leader>e", "<cmd>Oil --float<cr>", desc = "Open Explorer" },
	},
	opts = {
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		keymaps = {
			["g?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-j>"] = { "actions.select", opts = { vertical = true } },
			["<C-h>"] = { "actions.select", opts = { horizontal = true } },
			["<C-c>"] = { "actions.close", mode = "n" },
			["R"] = "actions.refresh",
			["-"] = { "actions.parent", mode = "n" },
			["_"] = { "actions.open_cwd", mode = "n" },
			["`"] = { "actions.cd", mode = "n" },
			["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["g."] = { "actions.toggle_hidden", mode = "n" },
			["g\\"] = { "actions.toggle_trash", mode = "n" },
		},
		use_default_keymaps = false,
		lsp_file_methods = {
			autosave_changes = true,
		},
		float = {
			max_width = 0.8,
			max_height = 0.8,
		},
		watch_for_changes = true,
		view_options = {
			show_hidden = true,
		},
	},
}
