local M = {}

local win_options = {
    wrap = false,
    list = true,
    listchars = "precedes:…,extends:…",
    sidescrolloff = 0,
    statuscolumn = [[%!v:lua.require("pea.ui.input").statuscolumn()]],
}

local buf_options = {
    swapfile = false,
    bufhidden = "wipe",
    filetype = "PeaInput",
}

local prefer_width = 40
local width_limit = {
    min_value = { 20, 0.2 },
    max_value = { 140, 0.9 },
}

function M.statuscolumn()
    local icons = require "pea.ui.icons"

    return " %#PeaInputIcon#" .. icons.ui.Write .. "  "
end

vim.ui.input = function(opts, on_confirm)
    local win_config = {
        relative = "cursor",
        anchor = "NW",
        row = 1,
        col = 1,
        width = 40,
        height = 1,
        focusable = false,
        noautocmd = true,
        style = "minimal",
    }

    local utils = require "pea.ui.utils"

    local prompt = opts.prompt or "Input"
    local default = opts.default or ""
    local prompt_lines = vim.split(prompt, "\n", { plain = true, trimempty = true })

    local width = utils.calc_width(win_config.relative, prefer_width, win_config.width, width_limit)
    width = math.max(width, 4 + utils.get_max_strwidth(prompt_lines), 2 + vim.api.nvim_strwidth(default))

    win_config.title = utils.trim_and_pad_title(prompt)
    win_config.width = utils.calc_width(win_config.relative, width, win_config.width, width_limit)

    local function close(winid, content)
        vim.cmd.stopinsert()
        on_confirm(content)
        vim.api.nvim_win_close(winid, true)
    end

    -- Create floating window.
    local bufnr = vim.api.nvim_create_buf(false, true)
    local winid = vim.api.nvim_open_win(bufnr, true, win_config)

    -- Set buffer options.
    for option, value in pairs(buf_options) do
        vim.api.nvim_set_option_value(option, value, { scope = "local", buf = bufnr })
    end

    -- Set window options.
    for option, value in pairs(win_options) do
        vim.api.nvim_set_option_value(option, value, { scope = "local", win = winid })
    end

    vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, { default })
    vim.cmd.startinsert()
    vim.api.nvim_win_set_cursor(winid, { 1, vim.str_utfindex(default, "utf-8") + 1 })

    vim.keymap.set({ "n", "i", "v" }, "<cr>", function()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)

        close(winid, lines[1])
    end, { buffer = bufnr })

    vim.keymap.set("n", "<esc>", function()
        close(winid)
    end, { buffer = bufnr })

    vim.keymap.set("i", "<C-c>", function()
        close(winid)
    end, { buffer = bufnr })

    vim.keymap.set("n", "q", function()
        close(winid)
    end, { buffer = bufnr })

    local augroup = vim.api.nvim_create_augroup("pea_input", { clear = true })

    vim.api.nvim_create_autocmd("BufLeave", {
        group = augroup,
        desc = "Cancel vim.ui.input",
        buffer = bufnr,
        nested = true,
        once = true,
        callback = function()
            close(winid)
        end,
    })
end

return M
