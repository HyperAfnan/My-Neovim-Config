return {
	"abecodes/tabout.nvim",
	lazy = false,
	config = function()
		require("tabout").setup({
			completion = true,
			tabouts = {
				{ open = "'", close = "'" },
				{ open = "\"", close = "\"" },
				{ open = "`", close = "`" },
				{ open = "<", close = ">" },
				{ open = "(", close = ")" },
				{ open = "[", close = "]" },
				{ open = "{", close = "}" },
			},
			ignore_beginning = true,
		})
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"L3MON4D3/LuaSnip",
	},
	opt = true,
	event = "InsertCharPre",
	priority = 1000,
}
