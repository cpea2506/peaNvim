local M = {}

local function set_lsp_keymaps(bufnr)
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

local codelens_refresh_group = vim.api.nvim_create_augroup("pea_codelens_refresh", { clear = true })
local document_highlight_group = vim.api.nvim_create_augroup("pea_document_highlight", { clear = true })

M.on_attach = function(_, bufnr)
    set_lsp_keymaps(bufnr)

    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    vim.lsp.document_color.enable(true, bufnr, { style = "virtual" })

    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = codelens_refresh_group,
        buffer = bufnr,
        callback = function(args)
            vim.lsp.codelens.refresh { bufnr = args.buf }
        end,
    })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = document_highlight_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
        group = document_highlight_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
    })
end

M.on_exit = function(_, bufnr)
    vim.api.nvim_clear_autocmds {
        group = codelens_refresh_group,
        buffer = bufnr,
    }

    vim.api.nvim_clear_autocmds {
        group = document_highlight_group,
        buffer = bufnr,
    }
end

M.capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    return capabilities
end

M.diagnostics = function()
    local icons = require "pea.ui.icons"

    return {
        update_in_insert = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = icons.diagnostics.ERROR,
                [vim.diagnostic.severity.WARN] = icons.diagnostics.WARN,
                [vim.diagnostic.severity.HINT] = icons.diagnostics.HINT,
                [vim.diagnostic.severity.INFO] = icons.diagnostics.INFO,
            },
        },
        virtual_lines = {
            current_line = true,
            format = function(diagnostic)
                local severity = vim.diagnostic.severity[diagnostic.severity]

                return icons.diagnostics[severity] .. " " .. diagnostic.message
            end,
        },
        underline = true,
        severity_sort = true,
        float = {
            source = true,
            severity_sort = true,
            focusable = true,
            style = "minimal",
            border = "rounded",
        },
    }
end

return M
