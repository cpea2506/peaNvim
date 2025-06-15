return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<leader>sf", "<cmd>FzfLua files<cr>", desc = "FzfLua Files" },
        { "<leader>st", "<cmd>FzfLua live_grep<cr>", desc = "FzfLua Grep" },
        { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "FzfLua Diagnostics" },
    },
    opts = function()
        local icons = require "pea.ui.icons"

        return {
            winopts = {
                height = 0.85,
                width = 0.5,
                title_flags = false,
                treesitter = true,
                preview = {
                    border = "rounded",
                    layout = "vertical",
                    vertical = "up:50%",
                    scrollbar = false,
                },
            },
            fzf_opts = {
                ["--prompt"] = icons.ui.Telescope .. " ",
                ["--pointer"] = " ",
                ["--cycle"] = true,
                ["--no-scrollbar"] = true,
            },
            fzf_colors = {
                true,
                ["gutter"] = "-1",
            },
            files = {
                cwd_prompt = false,
                formatter = "path.filename_first",
            },
            grep = {
                hidden = true,
            },
            keymap = {
                builtin = {
                    true,
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
                fzf = {
                    true,
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                },
            },
        }
    end,
}
