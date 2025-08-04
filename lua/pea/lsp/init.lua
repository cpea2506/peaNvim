local config = require "pea.lsp.config"

vim.diagnostic.config(config.diagnostics())

vim.lsp.config("*", {
    capabilities = config.capabilities(),
})

local augroup = vim.api.nvim_create_augroup("pea_lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        config.on_attach(client, bufnr)
    end,
})

vim.api.nvim_create_autocmd("LspDetach", {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        config.on_detach(client, bufnr)
    end,
})
