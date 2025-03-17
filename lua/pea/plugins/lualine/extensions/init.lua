---@class extensions
---@field lazy table
---@field quickfix table
local M = {}

local modules = {
	"lazy",
	"quickfix",
}

for _, mod in pairs(modules) do
	M[mod] = require("pea.plugins.lualine.extensions." .. mod)
end

return M
