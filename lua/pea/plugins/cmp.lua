local icons = require("pea.icons").kind

return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Cmp sources.
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"ray-x/cmp-treesitter",
			"hrsh7th/cmp-nvim-lua",
			"lukas-reineke/cmp-rg",
			"hrsh7th/cmp-nvim-lsp-signature-help",

			-- Snippets.
			"nvim-snippets",
		},
		event = {
			"InsertEnter",
			"CmdlineEnter",
		},
		opts = {
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},
			completion = {
				completeopt = "menu,menuone,noselect",
				keyword_length = 1,
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				expandable_indicator = true,
				format = function(entry, vim_item)
					vim_item.kind = icons[vim_item.kind]

					vim_item.menu = ({
						nvim_lsp = "(LSP)",
						path = "(Path)",
						buffer = "(Buffer)",
						treesitter = "(TreeSitter)",
						snippets = "(Snippets)",
					})[entry.source.name]

					return vim_item
				end,
			},
			view = {
				entries = {
					name = "custom",
					selection_order = "near_cursor",
					follow_cursor = true,
				},
			},
			experimental = {
				ghost_text = true,
			},
			sources = {
				{ name = "nvim_lsp" },
				{
					name = "rg",
					keyword_length = 5,
					option = {
						additional_arguments = "--smart-case",
					},
				},
				{ name = "path" },
				{ name = "nvim_lua" },
				{ name = "buffer" },
				{ name = "treesitter" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "snippets" },
				{ name = "crates" },
			},
		},
		config = function(_, opts)
			local cmp = require("cmp")
			local cmp_buffer = require("cmp_buffer")
			local select_behavior = cmp.SelectBehavior
			local confirm_behavior = cmp.ConfirmBehavior
			local window = cmp.config.window
			local mapping = cmp.mapping

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				local line_range = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]

				return col ~= 0 and line_range:sub(col, col):match("%s") == nil
			end

			opts = vim.tbl_extend("force", opts, {
				sorting = {
					comparators = {
						function(...)
							return cmp_buffer:compare_locality(...)
						end,
						unpack(cmp.config.compare),
					},
				},
				confirmation = {
					default_behavior = confirm_behavior.Replace,
				},
				window = {
					completion = window.bordered(),
					documentation = window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = mapping(mapping.select_prev_item(), { "i", "c" }),
					["<C-j>"] = mapping(mapping.select_next_item(), { "i", "c" }),
					["<Down>"] = mapping(
						mapping.select_next_item({
							behavior = select_behavior.Select,
						}),
						{ "i" }
					),
					["<Up>"] = mapping(
						mapping.select_prev_item({
							behavior = select_behavior.Select,
						}),
						{ "i" }
					),
					["<C-d>"] = mapping.scroll_docs(-4),
					["<C-f>"] = mapping.scroll_docs(4),
					["<Tab>"] = mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif has_words_before() then
							cmp.complete()
							fallback()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-Space>"] = mapping.complete(),
					["<C-y>"] = mapping.abort(),
					["<CR>"] = mapping(function(fallback)
						if cmp.visible() then
							local confirm_opts = {
								behavior = confirm_behavior.Replace,
								select = true,
							}

							local is_insert_mode = function()
								return vim.api.nvim_get_mode().mode == "i"
							end

							if is_insert_mode() then
								confirm_opts.behavior = confirm_behavior.Insert
							end

							if cmp.confirm(confirm_opts) then
								return
							end
						end

						fallback()
					end),
				}),
			})

			cmp.setup(opts)

			local cmdline_mappings = cmp.mapping.preset.cmdline()
			cmdline_mappings["<C-j>"] = cmdline_mappings["<S-Tab>"]
			cmdline_mappings["<C-k>"] = cmdline_mappings["<Tab>"]

			cmp.setup.cmdline(":", {
				mapping = cmdline_mappings,
				sources = {
					{ name = "cmdline" },
				},
			})
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmdline_mappings,
				sources = {
					{ name = "buffer" },
				},
			})
		end,
	},
	{
		"garymjr/nvim-snippets",
		dependencies = "rafamadriz/friendly-snippets",
		keys = {
			{
				"<Tab>",
				function()
					if vim.snippet.jumpable(1) then
						vim.schedule(function()
							vim.snippet.jump(1)
						end)

						return
					end

					return "<Tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<Tab>",
				function()
					vim.schedule(function()
						vim.snippet.jump(1)
					end)
				end,
				expr = true,
				silent = true,
				mode = "s",
			},
			{
				"<S-Tab>",
				function()
					if vim.snippet.jumpable(-1) then
						vim.schedule(function()
							vim.snippet.jump(-1)
						end)

						return
					end

					return "<S-Tab>"
				end,
				expr = true,
				silent = true,
				mode = { "i", "s" },
			},
		},
		opts = {
			highlight_preview = true,
			create_cmp_source = true,
			friendly_snippets = true,
		},
	},
}
