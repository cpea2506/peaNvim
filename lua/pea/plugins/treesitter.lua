return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "LazyFile",
        dependencies = "nvim-treesitter/nvim-treesitter-context",
        config = function()
            local treesitter = require "nvim-treesitter"
            local parsers = require "nvim-treesitter.parsers"

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("pea_treesitter", { clear = true }),
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match) or args.match

                    if not parsers[lang] then
                        return
                    end

                    local parser = vim.treesitter.get_parser(args.buf, lang, { error = false })

                    if not parser then
                        treesitter.install(lang):wait(30000)
                    end

                    vim.treesitter.start(args.buf, lang)

                    if vim.treesitter.query.get(lang, "indents") then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            mode = "cursor",
            max_lines = 3,
        },
        config = function(_, opts)
            require("treesitter-context").setup(opts)

            vim.keymap.set("n", "[c", function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end, { silent = true })
        end,
    },
}
