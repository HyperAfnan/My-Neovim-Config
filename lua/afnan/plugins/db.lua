return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-completion" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_win_position = "right"
		end,
	},
	{
		"kndndrj/nvim-dbee",
		requires = { "MunifTanjim/nui.nvim" },
		run = function()
			require("dbee").install("go")
		end,
		config = function()
			require("dbee").setup()
		end,
	},
}
