local function augroup(name)
    return vim.api.nvim_create_augroup("pea_" .. name, { clear = true })
end

local autocmds = {
    {
        "TextYankPost",
        {
            group = augroup "highlight_yank",
            callback = function()
                vim.hl.on_yank()
            end,
        },
    },
    {
        "FileType",
        {
            group = augroup "q_close",
            pattern = { "help", "man", "qf", "startuptime", "checkhealth", "man" },
            callback = function(args)
                local bufnr = args.buf

                vim.bo[bufnr].buflisted = false

                vim.schedule(function()
                    vim.keymap.set("n", "q", function()
                        vim.cmd.close()

                        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
                    end, { buffer = bufnr, silent = true, desc = "Quit buffer" })
                end)
            end,
        },
    },
    {
        { "FocusGained", "TermClose", "TermLeave" },
        {
            group = augroup "checktime",
            callback = function()
                if vim.o.buftype ~= "nofile" then
                    vim.cmd.checktime()
                end
            end,
        },
    },
    {
        "VimResized",
        {
            group = augroup "resize_splits",
            callback = function()
                local current_tab = vim.fn.tabpagenr()

                vim.cmd.tabdo "wincmd ="
                vim.cmd.tabnext(current_tab)
            end,
        },
    },
    {
        "VimLeave",
        {
            group = augroup "restore_cursor",
            callback = function()
                vim.o.guicursor = ""
                vim.api.nvim_chan_send(vim.v.stderr, "\x1b[ q")
            end,
        },
    },
}

for _, autocmd in pairs(autocmds) do
    vim.api.nvim_create_autocmd(autocmd[1], autocmd[2])
end
