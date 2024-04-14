local M = {}

local lspconfig = require("lspconfig")

local custom_servers = {
	shaderlab_lsp = {
		default_config = {
			cmd = { "shader-ls", "stdio" },
			filetypes = { "glsl" },
			root_dir = lspconfig.util.root_pattern({ "*.csproj", "*.sln" }),
			settings = {
				ShaderLab = {
					CompletionWord = true,
				},
			},
		},
	},
}

M.setup_servers = function()
	for server, config in pairs(custom_servers) do
		require("lspconfig.configs")[server] = config

		lspconfig[server].setup({})
	end
end

return M
