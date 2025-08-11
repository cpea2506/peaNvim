return {
    "A7Lavinraj/fyler.nvim",
    lazy = false,
    keys = {
        { "<leader>e", "<cmd>Fyler<cr>", desc = "Open Explorer" },
    },
    opts = {
        icon_provider = "nvim-web-devicons",
        views = {
            explorer = {
                close_on_select = true,
                confirm_simple = false,
                default_explorer = true,
                git_status = false,
                indentscope = {
                    enabled = true,
                    group = "FylerIndentMarker",
                    marker = "│",
                },
                win = {
                    border = "rounded",
                    kind = "float",
                    kind_presets = {
                        float = {
                            height = "0.8rel",
                            width = "0.8rel",
                        },
                    },
                },
            },
            confirm = {
                win = {
                    border = "rounded",
                    kind = "float",
                    kind_presets = {
                        float = {
                            height = "0.4rel",
                            width = "0.5rel",
                        },
                    },
                },
            },
        },
    },
}
