local M = {}

local codelens_refresh_group = vim.api.nvim_create_augroup("pea_codelens_refresh", { clear = true })
local document_highlight_group = vim.api.nvim_create_augroup("pea_document_highlight", { clear = true })

M.on_attach = function(_, bufnr)
    require("pea.lsp.keymaps").set(bufnr)

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

M.on_detach = function(_, bufnr)
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
