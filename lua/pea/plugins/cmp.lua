local icons = require("pea.icons").kind

return {
	"saghen/blink.cmp",
	version = "*",
	build = "cargo build --release",
	dependencies = {
		"mikavilpas/blink-ripgrep.nvim",
		"rafamadriz/friendly-snippets",
	},
	event = {
		"InsertEnter",
		"CmdlineEnter",
	},
	opts = {
		appearance = {
			kind_icons = {
				Text = icons.Text,
				Method = icons.Method,
				Function = icons.Function,
				Constructor = icons.Constructor,

				Field = icons.Field,
				Variable = icons.Variable,
				Property = icons.Property,

				Class = icons.Class,
				Interface = icons.Interface,
				Struct = icons.Struct,
				Module = icons.Module,

				Unit = icons.Unit,
				Value = icons.Value,
				Enum = icons.Enum,
				EnumMember = icons.EnumMember,

				Keyword = icons.Keyword,
				Constant = icons.Constant,

				Snippet = icons.Snippet,
				Color = icons.Color,
				File = icons.File,
				Reference = icons.Reference,
				Folder = icons.Folder,
				Event = icons.Event,
				Operator = icons.Operator,
				TypeParameter = icons.TypeParameter,
			},
		},
		keymap = {
			preset = "none",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-d>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},
		completion = {
			ghost_text = {
				enabled = true,
				show_with_selection = true,
				show_without_selection = false,
			},
			menu = {
				border = "rounded",
				draw = {
					columns = { { "kind_icon" }, { "label", gap = 1, "source_name" } },
					components = {
						source_name = {
							text = function(ctx)
								return "(" .. ctx.source_name .. ")"
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
				window = {
					border = "rounded",
				},
			},
		},
		signature = {
			enabled = true,
			trigger = {
				show_on_insert = true,
			},
			window = {
				border = "rounded",
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
			providers = {
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					opts = {
						search_casing = "--smart-case",
					},
				},
				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					opts = {
						friendly_snippets = true,
						global_snippets = { "all" },
						extended_filetypes = {
							cs = { "unity" },
						},
					},
				},
			},
		},
		cmdline = {
			enabled = true,
			completion = {
				menu = {
					auto_show = true,
					draw = {
						columns = { { "kind_icon" }, { "label" } },
					},
				},
			},
			keymap = {
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<Tab>"] = { "accept", "fallback" },
				["<CR>"] = { "accept_and_enter", "fallback" },
			},
		},
	},
}
