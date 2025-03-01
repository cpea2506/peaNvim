local utils = require("pea.utils")

local options = {
	wrap = true,
	tabstop = 4,
	list = false,
	hidden = true,
	cmdheight = 0,
	shiftwidth = 4,
	number = true,
	whichwrap = "",
	pumheight = 10,
	showtabline = 0,
	showmode = false,
	linebreak = true,
	timeoutlen = 250,
	conceallevel = 0,
	autoindent = true,
	ignorecase = true,
	smartcase = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	termguicolors = true,
	title = true,
	undofile = true,
	updatetime = 100,
	writebackup = false,
	expandtab = true,
	cursorline = true,
	numberwidth = 4,
	signcolumn = "yes",
	scrolloff = 8,
	sidescrolloff = 8,
	showcmd = false,
	ruler = false,
	laststatus = 3,
	fileencoding = "utf-8",
	clipboard = "unnamedplus",
	fillchars = { eob = " " },
	guicursor = "i-ci-ve:hor30",
	guifont = "SFMono Nerd Font:h13",
	completeopt = { "menuone", "noselect" },
}

if utils.is_windows then
	local windows_options = {
		shell = "pwsh-preview -NoLogo",
		shellcmdflag = "-ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
		shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
		shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
		shellquote = "",
		shellxquote = "",
	}

	options = vim.tbl_deep_extend("force", options, windows_options)
end

return options
