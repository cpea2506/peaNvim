local vim_options = require("pea.options.vim_options")

for option, value in pairs(vim_options) do
	vim.opt[option] = value
end

local global_options = require("pea.options.global_options")

for option, value in pairs(global_options) do
	vim.g[option] = value
end
