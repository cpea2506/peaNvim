local icons = require("pea.ui.icons")

return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	keys = {
		{ "<F5>", "<cmd>DapContinue<cr>", desc = "Dap Continue" },
		{ "<F10>", "<cmd>DapStepOver<cr>", desc = "Dap Step Over" },
		{ "<F11>", "<cmd>DapStepInto<cr>", desc = "Dap Step Into" },
		{ "<F12>", "<cmd>DapStepOut<cr>", desc = "Dap Step Out" },
		{ "<leader>k", "<cmd>DapEval<cr>", desc = "Dap Eval", mode = { "n", "v" } },
		{ "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Dap Toggle Breakpoint" },
		{ "<leader>dt", [[<cmd>lua require("dapui").toggle({ reset = true })<cr>]], desc = "Dap Toggle" },
	},
	opts = {
		controls = {
			icons = {
				play = icons.ui.Triangle,
				terminate = icons.ui.Square,
			},
		},
		floating = {
			border = "rounded",
		},
		layouts = {
			{
				elements = {
					{
						id = "scopes",
						size = 0.25,
					},
					{
						id = "breakpoints",
						size = 0.25,
					},
					{
						id = "stacks",
						size = 0.25,
					},
					{
						id = "watches",
						size = 0.25,
					},
				},
				position = "right",
				size = 40,
			},
			{
				elements = {
					{
						id = "console",
						size = 0.5,
					},
					{
						id = "repl",
						size = 0.5,
					},
				},
				position = "bottom",
				size = 10,
			},
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup(opts)

		dap.listeners.before.attach.dapui_config = dapui.open
		dap.listeners.before.launch.dapui_config = dapui.open
		dap.listeners.before.event_terminated.dapui_config = dapui.close
		dap.listeners.before.event_exited.dapui_config = dapui.close

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

		require("pea.plugins.dap.config").setup()
	end,
}
