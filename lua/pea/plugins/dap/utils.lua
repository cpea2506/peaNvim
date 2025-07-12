local function get_vstuc_path()
    local vstuc_root = vim.env.HOME .. "/.vscode/extensions/"
    local handle = vim.loop.fs_scandir(vstuc_root)

    while handle do
        local name, type = vim.loop.fs_scandir_next(handle)

        if not name then
            break
        end

        if type == "directory" and name:match "^visualstudiotoolsforunity%.vstuc%-.+" then
            return vstuc_root .. name .. "/bin/"
        end
    end

    return nil
end

return {
    vstuc_path = get_vstuc_path(),
}
