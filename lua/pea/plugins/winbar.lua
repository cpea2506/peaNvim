return {
    "SmiteshP/nvim-navic",
    event = "LazyFile",
    opts = function()
        local icons = require "pea.ui.icons"

        return {
            icons = vim.tbl_map(function(icon)
                return icon .. " "
            end, icons.kind),
            lsp = {
                auto_attach = true,
            },
            highlight = true,
            separator = " " .. icons.ui.ChevronRight .. " ",
            modified_symbol = " " .. icons.ui.Circle,
            exclude_filetypes = {
                "",
                "TelescopePrompt",
                "dap-repl",
                "fzf",
                "help",
                "lazy",
                "noice",
                "fyler",
                "toggleterm",
                "qf",
                "input",
                "lazygit",
            },
        }
    end,
    config = function(_, opts)
        local navic = require "nvim-navic"
        navic.setup(opts)

        local function is_empty(s)
            return s == nil or s == ""
        end

        local function get_filename()
            local filename = vim.fn.expand "%:t"

            if is_empty(filename) then
                return ""
            end

            local extension = vim.fn.expand "%:e"
            local devicons = require "nvim-web-devicons"
            local fileicon, hlgroup = devicons.get_icon(filename, extension, { default = true })

            return " " .. "%#" .. hlgroup .. "#" .. fileicon .. "%*" .. " " .. "%#WinBar#" .. filename .. "%*"
        end

        local function get_locations(bufnr)
            local filename = get_filename()

            if not navic.is_available(bufnr) then
                return filename
            end

            local locations = navic.get_location(nil, bufnr)

            if is_empty(locations) then
                return filename
            end

            return filename .. "%#NavicSeparator#" .. opts.separator .. "%*" .. locations
        end

        local augroup = vim.api.nvim_create_augroup("navic-winbar", { clear = true })

        vim.api.nvim_create_autocmd({
            "CursorHoldI",
            "CursorHold",
            "BufWinEnter",
            "BufFilePost",
            "InsertEnter",
            "BufWritePost",
            "TabClosed",
            "TabEnter",
        }, {
            group = augroup,
            callback = function(args)
                local bufnr = args.buf

                if vim.tbl_contains(opts.exclude_filetypes, vim.bo[bufnr].filetype) then
                    return
                end

                local winbar = get_locations(bufnr)

                if vim.bo[bufnr].mod then
                    winbar = winbar .. "%#LspCodeLens#" .. opts.modified_symbol .. "%*"
                end

                vim.api.nvim_set_option_value("winbar", winbar, { scope = "local" })
            end,
        })
    end,
}
