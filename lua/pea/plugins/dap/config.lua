local M = {}

local vstuc_path = vim.env.HOME .. "/.vscode-insiders/extensions/visualstudiotoolsforunity.vstuc-1.1.1/bin/"

local adapters = {
	vstuc = {
		type = "executable",
		command = "dotnet",
		args = { vstuc_path .. "UnityDebugAdapter.dll" },
		name = "Attach to Unity",
	},
}

local configurations = {
	cs = {
		{
			type = "vstuc",
			request = "attach",
			name = "Attach to Unity",
			logFile = vim.fs.joinpath(vim.fn.stdpath("data")) .. "/vstuc.log",
			projectPath = function()
				local path = vim.fn.expand("%:p")

				while true do
					local new_path = vim.fn.fnamemodify(path, ":h")

					if new_path == path then
						return ""
					end

					path = new_path
					local assets = vim.fn.glob(path .. "/Assets")

					if assets ~= "" then
						return path
					end
				end
			end,
			endPoint = function()
				local system_obj = vim.system({ "dotnet", vstuc_path .. "UnityAttachProbe.dll" }, { text = true })
				local probe_result = system_obj:wait(2000).stdout

				if probe_result == nil or #probe_result == 0 then
					print("No endpoint found (is Unity running?)")

					return ""
				end

				for json in vim.gsplit(probe_result, "\n") do
					if json == "" then
						return
					end

					local probe = vim.json.decode(json)

					for _, p in pairs(probe) do
						if p.isBackground == false then
							return p.address .. ":" .. p.debuggerPort
						end
					end
				end

				return ""
			end,
		},
	},
}

M.setup = function()
	local dap = require("dap")

	for adapter, config in pairs(adapters) do
		dap.adapters[adapter] = config
	end

	for filetype, config in pairs(configurations) do
		dap.configurations[filetype] = config
	end
end

return M
