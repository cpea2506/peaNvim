return {
    "A7Lavinraj/fyler.nvim",
    lazy = false,
    keys = {
        { "<leader>e", "<cmd>Fyler<cr>", desc = "Open Explorer" },
    },
    opts = function()
        local icons = require "pea.ui.icons"

        return {
            integrations = {
                icon = "nvim_web_devicons",
            },
            views = {
                finder = {
                    close_on_select = true,
                    confirm_simple = false,
                    default_explorer = true,
                    delete_to_trash = true,
                    follow_current_file = true,
                    icon = {
                        directory_collapsed = icons.kind.Folder,
                        directory_expanded = icons.ui.FolderExpanded,
                        directory_empty = icons.ui.FolderEmpty,
                    },
                    git_status = {
                        enabled = false,
                    },
                    indentscope = {
                        enabled = true,
                    },
                    watcher = {
                        enabled = true,
                    },
                    win = {
                        border = "rounded",
                        kind = "float",
                        kind_presets = {
                            float = {
                                height = "80%",
                                width = "80%",
                                top = "7.5%",
                                left = "7.5%",
                            },
                        },
                        win_opts = {
                            number = vim.o.number,
                        },
                    },
                },
            },
        }
    end,
}
