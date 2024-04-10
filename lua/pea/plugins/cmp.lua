return {
	{
		"hrsh7th/nvim-cmp",
		opts = {
			view = {
				entries = {
					name = "custom",
					selection_order = "near_cursor",
				},
			},
			confirm_opts = {
				select = true,
			},
			experimental = {
				ghost_text = true,
			},
			sources = {
				{
					name = "nvim_lsp",
					entry_filter = function(entry, _)
						local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]

						return kind ~= "Snippet"
					end,
				},
				{ name = "nvim_lsp_signature_help" },
				{
					name = "rg",
					keyword_length = 5,
					option = {
						additional_arguments = "--smart-case",
					},
				},
				{ name = "path" },
				{ name = "luasnip" },
				{ name = "nvim_lua" },
				{ name = "buffer" },
			},
		},
		config = function(_, opts)
			local cmp = require("cmp")

			cmp.setup(opts)

			local cmdline_mappings = cmp.mapping.preset.cmdline()
			cmdline_mappings["<C-j>"] = cmdline_mappings["<S-Tab>"]
			cmdline_mappings["<C-k>"] = cmdline_mappings["<Tab>"]

			cmp.cmdline.setup(":", {
				mapping = cmdline_mappings,
				sources = {
					{ name = "cmdline" },
				},
			})
			cmp.cmdline.setup({ "/", "?" }, {
				mapping = cmdline_mappings,
				sources = {
					{ name = "buffer" },
				},
			})
		end,
		event = {
			"InsertEnter",
			"CmdlineEnter",
		},
		dependencies = {
			"cmp-nvim-lsp",
			"cmp-path",
			"cmp_luasnip",
			"cmp-buffer",
			"cmp-cmdline",
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		lazy = true,
	},
	{
		"saadparwaiz1/cmp_luasnip",
		lazy = true,
	},
	{
		"hrsh7th/cmp-buffer",
		lazy = true,
	},
	{
		"hrsh7th/cmp-path",
		lazy = true,
	},
	{
		"hrsh7th/cmp-cmdline",
		lazy = true,
	},
}
