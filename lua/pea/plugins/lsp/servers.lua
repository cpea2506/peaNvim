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
					globals = { "vim" },
				},
			},
		},
	},
}

return servers
