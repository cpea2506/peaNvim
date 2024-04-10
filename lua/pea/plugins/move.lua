return {
	"fedepujol/move.nvim",
	keys = {
		-- Normal mode
		{ "<M-j>", "<cmd>MoveLine(1)<cr>", mode = "n" },
		{ "<M-k>", "<cmd>MoveLine(-1)<cr>", mode = "n" },
		{ "<M-h>", "<cmd>MoveHChar(-1)<cr>", mode = "n" },
		{ "<M-l>", "<cmd>MoveHChar(1)<cr>", mode = "n" },
		-- Block mode
		{ "<M-j>", "<cmd>MoveBlock(1)<cr>", mode = "v" },
		{ "<M-k>", "<cmd>MoveBlock(-1)<cr>", mode = "v" },
		{ "<M-h>", "<cmd>MoveHBlock(-1)<cr>", mode = "v" },
		{ "<M-l>", "<cmd>MoveHBlock(1)<cr>", mode = "v" },
	},
	opts = {
		char = {
			enable = true,
		},
	},
}
