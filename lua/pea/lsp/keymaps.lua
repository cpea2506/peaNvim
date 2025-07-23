local M = {}

local function dedup(items)
    local seen = {}
    local result = {}

    for _, value in ipairs(items) do
        local key = ("%s:%d:%s"):format(value.filename, value.lnum, value.text)

        if not seen[key] then
            table.insert(result, value)
            seen[key] = true
        end
    end

    return result
end

function M.set(bufnr)
    local function on_list(opts)
        opts.items = dedup(opts.items)

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

            local w = opts.reuse_win and vim.fn.win_findbuf(b)[1] or winid
            vim.api.nvim_win_set_buf(w, b)
            vim.api.nvim_win_set_cursor(w, { item.lnum, item.col - 1 })
            vim._with({ win = w }, function()
                -- Open folds under the cursor
                vim.cmd.normal { "zv", bang = true }
            end)
        else
            vim.fn.setqflist({}, " ", opts)
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
