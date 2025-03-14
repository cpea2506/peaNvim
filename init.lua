local modules = {
	"utils",
	"options",
	"manager",
	"inputs",
	"autocmds",
	"usercmds",
	"keymaps",
	"ui",
}

for _, module in pairs(modules) do
	require("pea." .. module)
end

local M = {}

function M.setup(opts)
	require("lazyvim.config").setup(opts)
end

return M
