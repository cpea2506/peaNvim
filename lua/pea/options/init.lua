local options = require("pea.options.options")

for option, value in pairs(options) do
	vim.opt[option] = value
end

local global = require("pea.options.global")

for option, value in pairs(global) do
	vim.g[option] = value
end
