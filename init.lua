local modules = {
	"utils",
	"options",
	"manager",
	"inputs",
	"autocmds",
	"usercmds",
	"keymappings",
	"ui",
}

for _, module in pairs(modules) do
	require("pea." .. module)
end
