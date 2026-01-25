return {
    "tronikelis/conflict-marker.nvim",
    event = "VeryLazy",
    opts = {
        highlight = true,
        on_attach = function(conflict)
            local mid = "^=======$"
            local keymaps = {
                ["<C-j>"] = function()
                    vim.cmd("/" .. mid)
                end,
                ["<C-k>"] = function()
                    vim.cmd("?" .. mid)
                end,
                ["co"] = function()
                    conflict:choose_ours()
                end,
                ["ct"] = function()
                    conflict:choose_theirs()
                end,
                ["cb"] = function()
                    conflict:choose_both()
                end,
                ["cn"] = function()
                    conflict:choose_none()
                end,
            }

            for key, value in pairs(keymaps) do
                vim.keymap.set("n", key, value, { buffer = conflict.bufnr })
            end

            vim.diagnostic.enable(false, { bufnr = conflict.bufnr })
        end,
    },
}
