local modules = {
	"options",
	"manager",
	"autocmds",
	"commands",
	"keymappings",
	"utils",
	"ui",
}

for _, module in pairs(modules) do
	require("pea." .. module)
end
