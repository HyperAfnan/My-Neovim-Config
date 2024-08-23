return {
	{
		"abecodes/tabout.nvim",
		lazy = false,
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>",
				act_as_tab = true,
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
			"hrsh7th/nvim-cmp",
		},
		opt = true,
		event = "InsertCharPre",
		priority = 1000,
	},
}
