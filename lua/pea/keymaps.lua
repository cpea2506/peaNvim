local keymaps = {
    { "n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" } },
    { "n", "<C-s>", "<cmd>w<cr>", { desc = "Save File" } },
    { "n", "<C-e>", "<cmd>BufClose<cr>", { desc = "Close Buffer" } },

    -- Better window movement.
    { "n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true } },
    { "n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true } },
    { "n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true } },
    { "n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true } },

    -- Better indenting.
    { "v", "<", "<gv" },
    { "v", ">", ">gv" },

    -- Lazy specific
    { "n", "<leader>ph", "<cmd>Lazy<cr>", { desc = "Lazy Status" } },
    { "n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Lazy Sync" } },
}

for _, key in pairs(keymaps) do
    local opts = key[4] or {}
    opts.silent = true

    vim.keymap.set(key[1], key[2], key[3], opts)
end
