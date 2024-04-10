return {
	"fedepujol/move.nvim",
	keys = {
		{
			{ "<M-j>", ":MoveLine(1)<CR>", desc = "Move Line Up", mode = "n" },
			{ "<M-k>", ":MoveLine(-1)<CR>", desc = "Move Line Down", mode = "n" },
			{ "<M-h>", ":MoveHChar(-1)<CR>", desc = "Move Char Left", mode = "n" },
			{ "<M-l>", ":MoveHChar(1)<CR>", desc = "Move Char Right", mode = "n" },
		},
	},
}
