local icons = require("pea.icons").ui

return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Telescope Find Text" },
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Telescope Find Files" },
			{ "<leader>sp", "<cmd>Telescope project<cr>", desc = "Telescope Projects" },
			{ "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Telescope Buffers" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"telescope-fzf-native.nvim",
			"nvim-telescope/telescope-project.nvim",
		},
		opts = {
			defaults = {
				selection_strategy = "reset",
				scroll_strategy = "cycle",
				prompt_prefix = icons.Telescope .. " ",
				selection_caret = icons.Forward .. " ",
				entry_prefix = "  ",
				layout_strategy = "center",
				sorting_strategy = "ascending",
				layout_config = {
					preview_cutoff = 1,

					width = function(_, max_columns, _)
						return math.min(max_columns, 80)
					end,

					height = function(_, _, max_lines)
						return math.min(max_lines, 15)
					end,
				},
				results_title = false,
				initial_mode = "insert",
				file_ignore_patterns = { "^.git/" },
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
				path_display = { "smart" },
				winblend = 0,
				border = true,
				borderchars = {
					prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
					results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
					preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				},
				color_devicons = true,
				dynamic_preview_title = true,
				set_env = {
					COLORTERM = "truecolor",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					only_sort_text = true,
				},
				grep_string = {
					only_sort_text = true,
				},
				git_files = {
					hidden = true,
					show_untracked = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local previewers = require("telescope.previewers")
			local actions = require("telescope.actions")
			local sorters = require("telescope.sorters")

			opts.file_previewer = previewers.vim_buffer_cat.new
			opts.grep_previewer = previewers.vim_buffer_vimgrep.new
			opts.qflist_previewer = previewers.vim_buffer_qflist.new
			opts.file_sorter = sorters.get_fuzzy_file
			opts.generic_sorter = sorters.get_generic_fuzzy_sorter
			opts.pickers.buffers = {
				initial_mode = "insert",
				mappings = {
					i = {
						["<C-d>"] = actions.delete_buffer,
					},
					n = {
						["dd"] = actions.delete_buffer,
					},
				},
			}
			opts.defaults.mappings = {
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
			}

			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("project")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		lazy = true,
	},
}
