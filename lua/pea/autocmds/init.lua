local autocmds = require("pea.autocmds.autocmds")

for _, autocmd in pairs(autocmds) do
	vim.api.nvim_create_autocmd(autocmd[1], autocmd[2])
end
