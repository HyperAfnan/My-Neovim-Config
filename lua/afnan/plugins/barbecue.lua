return {
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
		config = function()
			vim.opt.updatetime = 200

			vim.api.nvim_create_autocmd({
				"WinResized",
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",
				"BufModifiedSet",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
			require("barbecue").setup({
				create_autocmd = false,
				symbols = {
					modified = "●",
					ellipsis = "…",
					separator = ">",
				},
				kinds = {
					Text = "  ",
					Method = "  ",
					Namespace = "  ",
					Function = "  ",
					Constructor = "  ",
					Package = "  ",
					Field = "  ",
					Variable = "[]",
					Class = " פּ ",
					Interface = " 蘒 ",
					Module = "  ",
					Property = "  ",
					Unit = "  ",
					Value = "  ",
					Enum = "  ",
					Keyword = "  ",
					Snippet = "  ",
					Color = "  ",
					File = "  ",
					Reference = "  ",
					Folder = "  ",
					EnumMember = "  ",
					Constant = "  ",
					Struct = "  ",
					String = "  ",
					Number = "  ",
					Boolean = "  ",
					Event = "  ",
					Operator = "  ",
					TypeParameter = "  ",
					Array = "  ",
				},
			})
		end,
	},
}
