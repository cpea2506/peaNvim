local function toggle_lazygit()
    local terminal = require("toggleterm.terminal").Terminal
    local size = 99999

    local lazygit = terminal:new {
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
            border = "none",
            width = size,
            height = size,
        },
    }

    lazygit:toggle()
end

return {
    "akinsho/toggleterm.nvim",
    keys = {
        "<C-t>",
        { "<leader>gg", toggle_lazygit, desc = "Lazygit Toggle" },
    },
    opts = {
        open_mapping = "<C-t>",
        direction = "horizontal",
        close_on_exit = true,
        shade_terminals = false,
        autochdir = true,
        size = 15,
    },
}
