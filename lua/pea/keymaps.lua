local keymaps = {
    { "n", "<leader>q", "<cmd>q<cr>" },
    { "n", "<C-s>", "<cmd>w<cr>" },
    { "n", "<C-e>", "<cmd>bd<cr>" },

    { "n", "<C-h>", "<C-w>h", { remap = true } },
    { "n", "<C-j>", "<C-w>j", { remap = true } },
    { "n", "<C-k>", "<C-w>k", { remap = true } },
    { "n", "<C-l>", "<C-w>l", { remap = true } },

    { "v", "<", "<gv" },
    { "v", ">", ">gv" },

    { "n", "<leader>ph", "<cmd>Lazy<cr>" },
    { "n", "<leader>ps", "<cmd>Lazy sync<cr>" },
}

for _, key in pairs(keymaps) do
    local opts = key[4] or {}
    opts.silent = true

    vim.keymap.set(key[1], key[2], key[3], opts)
end
