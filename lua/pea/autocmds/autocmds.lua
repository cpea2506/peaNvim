local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

return {
	{
		"TextYankPost",
		{
			group = augroup("highlight_yank"),
			desc = "Highlight text on yank",
			callback = function()
				vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
			end,
		},
	},
	{
		"FileType",
		{
			group = augroup("q_close"),
			pattern = {
				"help",
				"lspinfo",
				"qf",
				"startuptime",
				"checkhealth",
				"man",
				"floaterm",
				"lspinfo",
				"lsp-installer",
				"DressingSelect",
			},
			callback = function(event)
				vim.bo[event.buf].buflisted = false

				vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
			end,
		},
	},
	{
		{ "FocusGained", "TermClose", "TermLeave" },
		{
			group = augroup("checktime"),
			callback = function(_)
				if vim.o.buftype ~= "nofile" then
					vim.cmd("checktime")
				end
			end,
		},
	},
	{
		"VimResized",
		{
			group = augroup("resize_splits"),
			callback = function()
				local current_tab = vim.fn.tabpagenr()

				vim.cmd("tabdo wincmd =")
				vim.cmd("tabnext " .. current_tab)
			end,
		},
	},
}
