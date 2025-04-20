---@class extensions
---@field lazy table
---@field quickfix table
local M = {}

setmetatable(M, {
	__index = function(_, key)
		return require("pea.plugins.lualine.extensions." .. key)
	end,
})

return M
