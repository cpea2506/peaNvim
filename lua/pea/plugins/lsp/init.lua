local icons = require("pea.config.ui.icons")

return {
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			diagnostics = {
				update_in_insert = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.diagnostics.ERROR,
						[vim.diagnostic.severity.WARN] = icons.diagnostics.WARN,
						[vim.diagnostic.severity.HINT] = icons.diagnostics.HINT,
						[vim.diagnostic.severity.INFO] = icons.diagnostics.INFO,
					},
				},
				virtual_lines = {
					format = function(diagnostic)
						local severity = vim.diagnostic.severity[diagnostic.severity]

						return icons.diagnostics[severity] .. " " .. diagnostic.message
					end,
				},
				underline = true,
				severity_sort = true,
				float = {
					source = true,
					severity_sort = true,
					focusable = true,
					style = "minimal",
					border = "rounded",
				},
			},
		},
		config = function(_, opts)
			local utils = require("pea.plugins.lsp.utils")

			vim.diagnostic.config(opts.diagnostics)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					utils.on_attach(client, bufnr)
				end,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					utils.on_exit(client, bufnr)
				end,
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function(_, opts)
			local mason_lspconfig = require("mason-lspconfig")
			local servers = require("pea.plugins.lsp.servers")

			mason_lspconfig.setup(opts)
			mason_lspconfig.setup_handlers({ servers.setup })
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"cmake-language-server",
				"json-lsp",
				"lua-language-server",
				"marksman",
				"rust-analyzer",
				"csharpier",
				"prettier",
				"typescript-language-server",
				"stylua",
				"taplo",
				"yaml-language-server",
			},
			ui = {
				border = "rounded",
				keymaps = {
					toggle_package_expand = "o",
					uninstall_package = "d",
				},
				icons = {
					package_installed = icons.ui.ThinTick,
					package_pending = icons.ui.ArrowRight,
					package_uninstalled = icons.ui.Close,
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)

			local registry = require("mason-registry")

			registry:on("package:install:success", function()
				vim.defer_fn(function()
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = registry.get_package(tool)

					if not p:is_installed() then
						p:install()
					end
				end
			end

			if registry.refresh then
				registry.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}
