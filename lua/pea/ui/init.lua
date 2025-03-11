local input = require("pea.ui.input")
vim.ui.input = input

-- Add border to floating windows.
-- TODO: This is a temporary solution until https://github.com/neovim/neovim/issues/32242 is resolved.
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = "rounded"

	return orig_open_floating_preview(contents, syntax, opts, ...)
end
