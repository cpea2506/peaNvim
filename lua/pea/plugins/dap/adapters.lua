local utils = require "pea.plugins.dap.utils"

local adapters = {
    vstuc = {
        type = "executable",
        command = "dotnet",
        args = { utils.vstuc_path .. "UnityDebugAdapter.dll" },
        name = "Attach to Unity",
    },
}

return adapters
