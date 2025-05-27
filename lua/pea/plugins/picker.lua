return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		enabled = function()
			local utils = require("pea.utils")

			return not utils.is_windows
		end,
		keys = {
			{ "<leader>sf", "<cmd>FzfLua files<cr>", desc = "FzfLua Files" },
			{ "<leader>st", "<cmd>FzfLua live_grep<cr>", desc = "FzfLua Grep" },
			{ "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "FzfLua Diagnostics" },
		},
		opts = function()
			local icons = require("pea.ui.icons")

			return {
				winopts = {
					height = 0.85,
					width = 0.5,
					title_flags = false,
					treesitter = true,
					preview = {
						border = "rounded",
						layout = "vertical",
						vertical = "up:50%",
						scrollbar = false,
					},
				},
				fzf_opts = {
					["--prompt"] = icons.ui.Telescope .. " ",
					["--pointer"] = " ",
					["--cycle"] = true,
					["--no-scrollbar"] = true,
				},
				fzf_colors = {
					true,
					["gutter"] = "-1",
				},
				files = {
					cwd_prompt = false,
					formatter = "path.filename_first",
				},
				grep = {
					hidden = true,
				},
				keymap = {
					builtin = {
						true,
						["<C-d>"] = "preview-page-down",
						["<C-u>"] = "preview-page-up",
					},
					fzf = {
						true,
						["ctrl-d"] = "preview-page-down",
						["ctrl-u"] = "preview-page-up",
					},
				},
			}
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		enabled = function()
			local utils = require("pea.utils")

			return utils.is_windows
		end,
		keys = {
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Telescope Find Files" },
			{ "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Telescope Find Text" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Telescope Buffers" },
		},
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		opts = function()
			local icons = require("pea.ui.icons")
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
	},
}
