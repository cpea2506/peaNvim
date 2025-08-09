local M = {}

---@param bufnr integer
function M.set(bufnr)
    ---@param opts vim.lsp.LocationOpts.OnList
    local function on_list(opts)
        opts.items = vim.list.unique(opts.items, function(item)
            return (":%s:%d:%s"):format(item.filename, item.lnum, item.text)
        end)

        if #opts.items == 1 then
            local item = opts.items[1]
            local b = item.bufnr or vim.fn.bufadd(item.filename)

            -- Save position in jumplist
            vim.cmd.normal { "m'", bang = true }

            local winid = vim.api.nvim_get_current_win()

            -- Push a new item into tagstack
            local tagname = vim.fn.expand "<cword>"
            local curpos = vim.fn.getcurpos(winid)
            curpos[1] = bufnr
            local tagstack = { { tagname = tagname, from = curpos } }
            vim.fn.settagstack(vim.fn.win_getid(winid), { items = tagstack }, "t")

            vim.bo[b].buflisted = true

            vim.api.nvim_win_set_buf(winid, b)
            vim.api.nvim_win_set_cursor(winid, { item.lnum, item.col - 1 })
            vim._with({ win = winid }, function()
                -- Open folds under the cursor
                vim.cmd.normal { "zv", bang = true }
            end)
        else
            vim.fn.setqflist({}, " ", { title = opts.title, items = opts.items })
            vim.cmd "bo cope"
        end
    end

    local keymaps = {
        {
            "n",
            "gd",
            function()
                vim.lsp.buf.definition { on_list = on_list }
            end,
            { desc = "Definition" },
        },
        {
            "n",
            "gD",
            function()
                vim.lsp.buf.type_definition { on_list = on_list }
            end,
            { desc = "Type Definition" },
        },
        {
            "n",
            "gr",
            function()
                vim.lsp.buf.references(nil, { on_list = on_list })
            end,
            { desc = "References", nowait = true },
        },
        {
            "n",
            "gi",
            function()
                vim.lsp.buf.implementation { on_list = on_list }
            end,
            { desc = "Implementation" },
        },
        { "n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" } },
        { "n", "gn", vim.lsp.buf.rename, { desc = "Rename" } },
        { { "n", "v" }, "ga", vim.lsp.buf.code_action, { desc = "Code Action" } },
    }

    for _, key in pairs(keymaps) do
        local opts = key[4] or {}
        opts.silent = true
        opts.buffer = bufnr

        vim.keymap.set(key[1], key[2], key[3], opts)
    end
end

return M
