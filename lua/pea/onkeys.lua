local function namespace(name)
    return vim.api.nvim_create_namespace("pea_" .. name)
end

local on_key_listeners = {
    {
        function(char)
            if vim.fn.mode() == "n" then
                local hlsearch = vim.tbl_contains({ "<CR>", "/", "?", "*", "#", "n", "N" }, vim.fn.keytrans(char))

                if vim.o.hlsearch ~= hlsearch then
                    vim.o.hlsearch = hlsearch
                end
            end
        end,
        namespace "auto_hlsearch",
    },
}

for _, listener in pairs(on_key_listeners) do
    vim.on_key(listener[1], listener[2], listener[3])
end
