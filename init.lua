local modules = {
	"options",
	"manager",
	"keymappings",
	"commands",
}

for _, module in pairs(modules) do
	require("pea." .. module)
end
