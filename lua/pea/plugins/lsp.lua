return {
    {
        "neovim/nvim-lspconfig",
        event = "LazyFile",
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
    },
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = function()
            local icons = require "pea.ui.icons"

            return {
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
                ui = {
                    border = "rounded",
                    keymaps = {
                        toggle_package_expand = "o",
                        uninstall_package = "d",
                    },
                    icons = {
                        package_installed = icons.ui.ThinTick,
                        package_pending = icons.ui.ArrowRight,
                        package_uninstalled = icons.ui.Close,
                    },
                },
            }
        end,
    },
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        opts = {
            filewatching = "roslyn",
        },
    },
    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        opts = {
            date_format = "%d-%m-%Y",
            popup = {
                autofocus = true,
                border = "rounded",
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
            completion = {
                crates = {
                    enabled = true,
                    max_results = 8,
                    min_chars = 3,
                },
            },
        },
    },
}
