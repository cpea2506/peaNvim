local commands = require("pea.commands.commands")

for _, command in pairs(commands) do
	local opts = vim.tbl_deep_extend("force", { force = true }, command.opts or {})

	vim.api.nvim_create_user_command(command.name, command.fn, opts)
end
