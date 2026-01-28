return {
    "andrewferrier/debugprint.nvim",
    keys = { "g?p", "g?P", "g?v", "g?V" },
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
