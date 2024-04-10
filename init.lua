local modules = {
	"options",
	"manager",
	"keymappings",
}

for _, module in pairs(modules) do
	require("pea." .. module)
end
