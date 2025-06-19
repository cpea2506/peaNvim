return {
    "catgoose/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
        lazy_load = true,
        user_commands = false,
        filetypes = {
            "*",
            "!lazy",
        },
        user_default_options = {
            names = false,
            RGB = true,
            RGBA = true,
            RRGGBB = true,
            RRGGBBAA = true,
            AARRGGBB = true,
            mode = "virtualtext",
            virtualtext = "■",
            virtualtext_inline = "before",
            virtualtext_mode = "foreground",
        },
    },
}
