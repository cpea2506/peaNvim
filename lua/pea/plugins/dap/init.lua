return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local adapters = require("pea.plugins.dap.adapters")
			local configurations = require("pea.plugins.dap.configurations")

			for adapter, config in pairs(adapters) do
				dap.adapters[adapter] = config
			end

			for filetype, config in pairs(configurations) do
				dap.configurations[filetype] = config
			end

			local icons = require("pea.ui.icons")

			vim.fn.sign_define("DapBreakpoint", {
				text = icons.ui.Circle,
				texthl = "DapBreakpoint",
				linehl = "Visual",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = icons.ui.CircleInfo,
				texthl = "DapBreakpoint",
				linehl = "Visual",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = icons.ui.CircleWarning,
				texthl = "DapBreakpoint",
				linehl = "Visual",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = icons.ui.CircleInfo,
				texthl = "DapLogPoint",
				linehl = "Visual",
				numhl = "DapLogPoint",
			})
			vim.fn.sign_define("DapStopped", {
				text = icons.ui.CirclePlay,
				texthl = "DapStopped",
				linehl = "Visual",
				numhl = "DapStopped",
			})
		end,
	},
	{
		"miroshQa/debugmaster.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		keys = "<leader>d",
		config = function()
			local debugmaster = require("debugmaster")

			debugmaster.plugins.cursor_hl.enabled = true
			debugmaster.plugins.ui_auto_toggle.enabled = true

			vim.keymap.set({ "n", "v" }, "<leader>d", debugmaster.mode.toggle, { nowait = true })
		end,
	},
}
