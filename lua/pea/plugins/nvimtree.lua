local icons = require("pea.config.ui.icons")

return {
	"nvim-tree/nvim-tree.lua",
	event = "BufEnter",
	dependencies = {
		{
			"antosha417/nvim-lsp-file-operations",
			dependencies = "nvim-lua/plenary.nvim",
			config = true,
		},
	},
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Open Explorer" },
	},
	opts = {
		reload_on_bufenter = true,
		hijack_cursor = true,
		hijack_netrw = true,
		sync_root_with_cwd = true,
		hijack_unnamed_buffer_when_opening = true,
		auto_reload_on_write = true,
		diagnostics = {
			enable = false,
		},
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
		actions = {
			open_file = {
				quit_on_open = true,
				resize_window = true,
			},
		},
		update_focused_file = {
			enable = true,
		},
		filters = {
			enable = false,
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return {
					desc = "nvim-tree: " .. desc,
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
				}
			end

			vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
			vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
			vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
			vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
			vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
			vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
			vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
			vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
			vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
			vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
			vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
			vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
			vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
			vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
			vim.keymap.set("n", "a", api.fs.create, opts("Create File Or Directory"))
			vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
			vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
			vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
			vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
			vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
			vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
			vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
			vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
			vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
			vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
			vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
			vim.keymap.set("n", "ge", api.fs.copy.basename, opts("Copy Basename"))
			vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
			vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
			vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
			vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
			vim.keymap.set("n", "L", api.node.open.toggle_group_empty, opts("Toggle Group Empty"))
			vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
			vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
			vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
			vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
			vim.keymap.set("n", "q", api.tree.close, opts("Close"))
			vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
			vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
			vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
			vim.keymap.set("n", "u", api.fs.rename_full, opts("Rename: Full Path"))
			vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Filter: Hidden"))
			vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
			vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
			vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
			vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
		end,
		view = {
			centralize_selection = true,
			adaptive_size = false,
			side = "right",
			preserve_window_proportions = true,
			width = {
				max = -1,
			},
			float = {
				enable = true,
				quit_on_focus_loss = false,
				open_win_config = function()
					return {
						row = 0,
						width = 30,
						border = "rounded",
						relative = "editor",
						col = vim.o.columns,
						height = vim.o.lines,
					}
				end,
			},
		},
		renderer = {
			full_name = false,
			indent_markers = {
				enable = true,
			},
			root_folder_label = ":t",
			icons = {
				glyphs = {
					git = {
						unmerged = icons.git.FileUnmerged,
						renamed = icons.git.FileRenamed,
						deleted = icons.git.FileDeleted,
						ignored = icons.git.FileIgnored,
						unstaged = icons.git.FileUnstaged,
						staged = icons.git.FileStaged,
						untracked = icons.git.FileUntracked,
					},
				},
			},
		},
	},
	config = function(_, opts)
		local nvimtree = require("nvim-tree")

		nvimtree.setup(opts)

		local function open_tree_on_setup(args)
			vim.schedule(function()
				local file = args.file
				local buf_name = vim.api.nvim_buf_get_name(0)
				local is_no_name_buffer = buf_name == "" and vim.bo.filetype == "" and vim.bo.buftype == ""
				local is_directory = vim.fn.isdirectory(file) == 1

				if not is_no_name_buffer and not is_directory then
					return
				end

				if is_directory then
					vim.cmd.cd(file)
				end

				require("nvim-tree.api").tree.open()
			end)
		end

		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("nvim-tree", { clear = true }),
			callback = open_tree_on_setup,
		})
	end,
}
