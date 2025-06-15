local utils = require "pea.utils"

local options = {
    vim = {
        wrap = true,
        tabstop = 4,
        list = true,
        listchars = "tab:⇤–⇥,space:·,trail:·,precedes:⇠,extends:⇢,nbsp:×",
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
        fixeol = false,
        conceallevel = 2,
        autoindent = true,
        ignorecase = true,
        smartcase = true,
        smartindent = true,
        splitbelow = true,
        splitright = true,
        swapfile = false,
        termguicolors = true,
        confirm = true,
        title = true,
        undofile = true,
        updatetime = 250,
        writebackup = false,
        expandtab = true,
        cursorline = true,
        numberwidth = 4,
        signcolumn = "yes",
        scrolloff = 8,
        smoothscroll = true,
        sidescrolloff = 8,
        showcmd = false,
        ruler = false,
        laststatus = 3,
        winborder = "rounded",
        fileencoding = "utf-8",
        clipboard = "unnamedplus",
        fillchars = "eob: ",
        guicursor = "i-ci-ve-t:hor30",
        guifont = "SFMono Nerd Font:h13",
        completeopt = "menu,menuone,noselect",
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
