return {
	{ "nvim-lua/plenary.nvim" },
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			vim.notify = function(msg, level, opts)
				notify(msg, level, opts)
				vim.opt.termguicolors = true
			end
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		lazyload = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
				lastplace_open_folds = true,
			})
		end,
	},
}
