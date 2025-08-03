return {
    {
        "cpea2506/git-conflict.nvim",
        event = "VeryLazy",
        opts = {
            default_mappings = {
                ours = "co",
                theirs = "ct",
                both = "cb",
                none = "c0",
                next = "<C-j>",
                prev = "<C-k>",
            },
            default_commands = false,
            disable_diagnostics = true,
            list_opener = "copen",
            highlights = {
                incoming = "DiffAdd",
                current = "DiffText",
            },
        },
    },
    {
        "kdheepak/lazygit.nvim",
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
        init = function()
            vim.g.lazygit_floating_window_winblend = 0
            vim.g.lazygit_floating_window_scaling_factor = 1
        end,
    },
}
