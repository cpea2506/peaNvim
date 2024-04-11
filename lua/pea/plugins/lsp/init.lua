vim.diagnostic.config({
	update_in_insert = true,
	signs = {
		active = true,
		values = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "" },
			{ name = "DiagnosticSignInfo", text = "" },
		},
	},
	virtual_text = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = "rounded",
	},
})

return {
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {},
		config = function(_, opts) end,
		{

			"williamboman/mason.nvim",
			cmd = "Mason",
			keys = {
				{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
			},
			build = ":MasonUpdate",
			opts = {
				ensure_installed = {
					"stylua",
				},
				ui = {
					keymaps = {
						toggle_package_expand = "o",
						uninstall_package = "d",
					},
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
			config = true,
		},
	},
}
