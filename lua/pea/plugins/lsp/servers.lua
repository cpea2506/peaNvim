local utils = require("pea.plugins.lsp.utils")
local configs = require("lspconfig.configs")

local custom_servers = {
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
}

for server, config in pairs(custom_servers) do
	configs[server] = config

	utils.setup(server)
end

local servers = {
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
}

return servers
