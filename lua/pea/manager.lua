local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

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
