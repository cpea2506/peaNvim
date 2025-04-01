local M = {}

local utils = require("pea.plugins.lsp.utils")
local lspconfig = require("lspconfig")

local configs = {
	defaults = {
		lua_ls = {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = "ApplyInMemory",
					},
					codeLens = {
						enable = true,
					},
					completion = {
						callSnippet = "Replace",
					},
					hint = {
						enable = true,
						setType = true,
						arrayIndex = "Disable",
					},
					semantic = {
						keyword = true,
					},
					diagnostics = {
						disable = {
							"missing-parameter",
							"param-type-mismatch",
							"undefined-global",
						},
					},
				},
			},
		},
	},
}

M.setup = function(server)
	local opts = vim.tbl_deep_extend("force", {
		capabilities = vim.deepcopy(utils.capabilities()),
	}, configs.defaults[server] or {})

	lspconfig[server].setup(opts)
end

return M
