return {
    "andrewferrier/debugprint.nvim",
    event = "LazyFile",
    opts = {
        filetypes = {
            ["cs"] = {
                left = [[Debug.Log($"]],
                right = [[");]],
                mid_var = "{",
                right_var = [[}");]],
            },
        },
    },
}
