local keymappings = require("pea.keymappings.keys")

local generic_opts = { noremap = true, silent = true }

for mode, keys in pairs(keymappings) do
	for key, value in pairs(keys) do
		local opts = generic_opts

		if type(value) == "table" then
			opts = vim.tbl_extend("force", opts, value[2])
			value = value[1]
		end

		if value then
			vim.keymap.set(mode, key, value, opts)
		else
			pcall(vim.api.nvim_del_keymap, mode, key)
		end
	end
end
