return {
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
		},
		opts = {
			padding = true,
			sticky = true,
			ignore = "^$",
			mappings = {
				basic = true,
				extra = true,
			},
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			extra = {
				above = "gcO",
				below = "gco",
				eol = "gcA",
			},
			pre_hook = function(...)
				local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

				if loaded and ts_comment then
					return ts_comment.create_pre_hook()(...)
				end
			end,
		},
		event = "User FileOpened",
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
	},
}
