return {
    "A7Lavinraj/fyler.nvim",
    lazy = false,
    keys = {
        { "<leader>e", "<cmd>Fyler<cr>", desc = "Open Explorer" },
    },
    opts = {
        default_explorer = true,
        close_on_select = true,
        icon_provider = "nvim-web-devicons",
        views = {
            explorer = {
                width = 0.8,
                height = 0.8,
                kind = "float",
                border = "rounded",
            },
        },
        mappings = {
            explorer = {
                n = {
                    ["q"] = "CloseView",
                    ["<CR>"] = "Select",
                    ["<C-CR>"] = "SelectRecursive",
                },
            },
        },
    },
}
