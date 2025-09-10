return {
    "A7Lavinraj/fyler.nvim",
    lazy = false,
    keys = {
        { "<leader>e", "<cmd>Fyler<cr>", desc = "Open Explorer" },
    },
    opts = {
        icon_provider = "nvim_web_devicons",
        close_on_select = true,
        confirm_simple = false,
        default_explorer = true,
        icon = {
            directory_collapsed = "",
            directory_expanded = "",
            directory_empty = "",
        },
        git_status = {
            enabled = false,
        },
        indentscope = {
            enabled = true,
            group = "FylerIndentMarker",
            marker = "│",
        },
        track_current_buffer = true,
        win = {
            border = "rounded",
            kind = "float",
            kind_presets = {
                float = {
                    height = "0.8rel",
                    width = "0.8rel",
                    top = "0.075rel",
                    left = "0.075rel",
                },
            },
        },
    },
}
