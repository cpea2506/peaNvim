local handler = require "lazy.core.handler.event"

local events = {
    LazyFile = {
        id = "LazyFile",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    },
}

for event, mapping in pairs(events) do
    handler.mappings[event] = mapping
    handler.mappings["User " .. event] = mapping
end
