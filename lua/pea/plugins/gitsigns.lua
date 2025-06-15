return {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = function()
        local icons = require "pea.ui.icons"

        return {
            signs = {
                add = {
                    text = icons.ui.BoldLine,
                },
                change = {
                    text = icons.ui.BoldLine,
                },
                delete = {
                    text = icons.ui.Triangle,
                },
                topdelete = {
                    text = icons.ui.Triangle,
                },
                changedelete = {
                    text = icons.ui.BoldLine,
                },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            auto_attach = true,
            attach_to_untracked = true,
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 500,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = "<author>, <author_time:%R> " .. icons.ui.CircleMedium .. " <summary>",
            sign_priority = 6,
            status_formatter = nil,
            update_debounce = 100,
            max_file_length = 40000,
            preview_config = {
                border = "rounded",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
        }
    end,
}
