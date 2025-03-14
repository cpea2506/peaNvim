local M = {}

local modules = {
	"options",
	"inputs",
	"autocmds",
	"usercmds",
	"keymaps",
	"ui.float",
	"ui.input",
}

local function init_lazy()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end

	vim.opt.rtp:prepend(lazypath)
end

local function setup_lazy()
	require("lazy").setup("pea.plugins", {
		root = vim.fn.stdpath("data") .. "/lazy",
		defaults = {
			lazy = true,
		},
		install = {
			missing = true,
			colorscheme = { "one_monokai" },
		},
		ui = {
			border = "rounded",
			backdrop = 100,
			title = "Plugins",
			title_pos = "center",
			pills = true,
			throttle = 20,
		},
		checker = {
			enabled = true,
			concurrency = nil,
			notify = true,
			frequency = 43200,
		},
		change_detection = {
			enabled = true,
			notify = true,
		},
		performance = {
			cache = {
				enabled = true,
			},
			reset_packpath = true,
		},
		profiling = {
			loader = true,
			require = true,
		},
	})
end

M.setup = function()
	init_lazy()

	for _, module in pairs(modules) do
		require("pea.config." .. module)
	end

	setup_lazy()
end

return M
