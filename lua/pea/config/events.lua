local event_handler = require("lazy.core.handler.event")

local events = {
	LazyFile = {
		id = "LazyFile",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	},
}

for event, mapping in pairs(events) do
	event_handler.mappings[event] = mapping
	event_handler.mappings["User " .. event] = event_handler.mappings[event]
end
