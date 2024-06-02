return {
	{
		"prichrd/netrw.nvim",
		config = function()
			require("netrw").setup({
				icons = {
					symlink = "",
					directory = "",
					file = "",
				},
				use_devicons = true,
				mappings = {},
			})
			vim.g.netrw_banner = 0
			vim.g.netrw_liststyle = 3
			vim.g.netrw_keepdir = 0
			vim.g.netrw_liststyle = 3
			vim.g.netrw_list_hide = [[.*\.swp$,.DS_Store,*/tmp/*,*.so,*.swp,*.zip,*.git,^\.\.\=/\=$]]
			vim.g.netrw_browse_split = 3
			vim.g.netrw_winsize = 15
			vim.g.netrw_localcopydircmd = "cp -r"
		end,
	},
}
