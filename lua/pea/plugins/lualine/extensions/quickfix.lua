local M = {}

local colors = require("pea.plugins.lualine.colors")
local components = require("pea.plugins.lualine.components")

local label = {
	function()
		local loclist = vim.fn.getloclist(0, { title = 0 })
		local qflist = vim.fn.getqflist({ title = 0 })
		local is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0

		return is_loclist and "Location: " .. loclist.title or "Quickfix: " .. qflist.title
	end,
	color = { fg = colors.jungle_green },
}

function M.init()
	vim.g.qf_disable_statusline = true
end

M.sections = {
	lualine_c = {
		components.leftbar,
		components.evil,
		components.location,
		components.center,
		label,
	},
	lualine_x = {
		components.scrollbar,
	},
}

M.filetypes = { "qf" }

return M
