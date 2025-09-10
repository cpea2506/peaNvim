return {
    cmd = { "shader-ls", "stdio" },
    filetypes = { "glsl", "shaderlab" },
    root_dir = vim.fs.root(0, function(name, _)
        return name:match "%.csproj$" ~= nil
    end),
    settings = {
        ShaderLab = {
            CompletionWord = true,
        },
    },
}
