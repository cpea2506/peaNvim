local M = {}

local document_highlight_group = vim.api.nvim_create_augroup("pea_document_highlight", { clear = true })

---@param client vim.lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
    require("pea.lsp.keymaps").set(bufnr)

    if client:supports_method("textDocument/inlayHint", bufnr) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client:supports_method("textDocument/documentColor", bufnr) then
        vim.lsp.document_color.enable(true, bufnr, { style = "virtual" })
    end

    if client:supports_method("textDocument/onTypeFormatting", bufnr) then
        vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
    end

    if client:supports_method("textDocument/codeLens", bufnr) then
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end

    if client:supports_method("textDocument/documentHighlight", bufnr) then
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
end

---@param _ vim.lsp.Client
---@param bufnr integer
M.on_detach = function(_, bufnr)
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

---@type table<string, string|integer>
local progress_message_ids = {}

M.on_progress = function(client, token, value)
    local icons = require "pea.ui.icons"

    local progress_id = ("%s.%s"):format(client.id, token)
    local percentage = value.percentage or 0

    if value.kind == "end" then
        vim.api.nvim_echo({ { "Done", "Type" } }, true, {
            id = progress_message_ids[progress_id],
            kind = "progress",
            status = "success",
            percent = percentage,
            title = ("%s [%s] %s"):format(icons.ui.Tick, client.name, value.title),
        })

        progress_message_ids[progress_id] = nil
    else
        local spinner = icons.ui.Spinner
        local count = #spinner
        local index = math.min(math.floor((percentage / 100) * count) + 1, count)

        progress_message_ids[progress_id] = vim.api.nvim_echo({ { value.message or "", "Type" } }, true, {
            id = progress_message_ids[progress_id],
            kind = "progress",
            status = "running",
            percent = percentage,
            title = ("%s [%s] %s"):format(spinner[index], client.name, value.title),
        })
    end
end

return M
