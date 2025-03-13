local servers = {}

local utils = require("pea.plugins.lsp.utils")
local lspconfig = require("lspconfig")
local lspconfigs = require("lspconfig.configs")

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
	customs = {
		shaderlab_ls = {
			default_config = {
				cmd = { "shader-ls", "stdio" },
				filetypes = { "glsl" },
				root_dir = vim.fs.root(0, function(name, _)
					return name:match("%.csproj$") ~= nil
				end),
				settings = {
					ShaderLab = {
						CompletionWord = true,
					},
				},
			},
		},
	},
}

servers.setup = function(server)
	local opts = vim.tbl_deep_extend("force", {
		capabilities = vim.deepcopy(utils.capabilities()),
	}, configs.defaults[server] or {})

	lspconfig[server].setup(opts)
end

for server, config in pairs(configs.customs) do
	lspconfigs[server] = config

	servers.setup(server)
end

return servers
