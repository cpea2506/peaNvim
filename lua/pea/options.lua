local utils = require("pea.utils")

local options = {
	vim = {
		wrap = true,
		tabstop = 4,
		shiftwidth = 4,
		expandtab = true,
		list = false,
		hidden = true,
		number = true,
		numberwidth = 4,
		signcolumn = "yes",
		linebreak = true,
		whichwrap = "",
		pumheight = 10,
		completeopt = "menu,menuone,noselect",
		timeoutlen = 250,
		updatetime = 250,
		fixeol = false,
		conceallevel = 2,
		autoindent = true,
		smartindent = true,
		ignorecase = true,
		smartcase = true,
		splitbelow = true,
		splitright = true,
		swapfile = false,
		writebackup = false,
		undofile = true,
		fileencoding = "utf-8",
		cursorline = true,
		scrolloff = 8,
		sidescrolloff = 8,
		termguicolors = true,
		confirm = true,
		fillchars = "eob: ",
		clipboard = "unnamedplus",
	},
	global = {
		mapleader = " ",
	},
}

if utils.is_windows then
	options = vim.tbl_deep_extend("force", options, {
		vim = {
			shell = "pwsh-preview",
			shellcmdflag = "-NoLogo -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';",
			shellredir = "2>&1 | %{ '$_' } | Out-File %s; exit $LastExitCode",
			shellpipe = "2>&1 | %{ '$_' } | Tee-Object %s; exit $LastExitCode",
			shellquote = "",
			shellxquote = "",
		},
	})
end

for option, value in pairs(options.vim) do
	vim.o[option] = value
end

for option, value in pairs(options.global) do
	vim.g[option] = value
end
