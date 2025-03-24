return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Telescope Find Files" },
		{ "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Telescope Find Text" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Telescope Buffers" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		},
	},
	opts = function()
		local icons = require("pea.config.ui.icons")
		local actions = require("telescope.actions")

		return {
			defaults = {
				prompt_prefix = icons.ui.Telescope .. " ",
				selection_caret = icons.ui.Forward .. " ",
				layout_strategy = "center",
				sorting_strategy = "ascending",
				path_display = { "smart" },
				dynamic_preview_title = true,
				results_title = false,
				file_ignore_patterns = { "^.git/" },
				layout_config = {
					preview_cutoff = 1,
					width = function(_, max_columns, _)
						return math.min(max_columns, 80)
					end,
					height = function(_, _, max_lines)
						return math.min(max_lines, 15)
					end,
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob=!.git/",
				},
				borderchars = {
					prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
					results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
					preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				},
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
					},
					n = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["q"] = actions.close,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")

		telescope.setup(opts)
		telescope.load_extension("fzf")
	end,
}
