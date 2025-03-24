local M = {}

local modules = {
	"options",
	"inputs",
	"autocmds",
	"usercmds",
	"keymaps",
	"events",
	"ui.float",
	"ui.input",
	"ui.select",
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
		defaults = {
			lazy = true,
		},
		install = {
			colorscheme = { "one_monokai" },
		},
		ui = {
			border = "rounded",
			backdrop = 100,
			title = "Plugins",
			title_pos = "center",
		},
		checker = {
			enabled = true,
			frequency = 43200,
		},
		performance = {
			rtp = {
				disabled_plugins = {
					"gzip",
					"netrwPlugin",
					"tarPlugin",
					"tohtml",
					"tutor",
					"zipPlugin",
				},
			},
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
