local vim_options = require("lua.pea.options.vim_options")

for option, value in pairs(vim_options) do
	vim_options.opt[option] = value
end

local global_options = require("lua.pea.options.global_options")

for option, value in pairs(global_options) do
	vim_options.g[option] = value
end
