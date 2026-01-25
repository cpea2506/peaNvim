return {
    "A7Lavinraj/fyler.nvim",
    event = "LazyFile",
    keys = {
        { "<leader>e", "<cmd>Fyler<cr>", desc = "Open Explorer" },
    },
    init = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("pea_explorer", { clear = true }),
            callback = function(args)
                vim.schedule(function()
                    local file = args.file
                    local buf_name = vim.api.nvim_buf_get_name(0)
                    local is_no_name_buffer = buf_name == "" and vim.bo.filetype == "" and vim.bo.buftype == ""
                    local is_directory = vim.fn.isdirectory(file) == 1

                    if not is_no_name_buffer and not is_directory then
                        return
                    end

                    if is_directory then
                        vim.cmd.cd(file)
                    end

                    require("fyler").open { kind = "replace" }
                end)
            end,
        })
    end,
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
                    columns = {
                        git = {
                            enabled = false,
                        },
                        diagnostic = {
                            enabled = false,
                        },
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
