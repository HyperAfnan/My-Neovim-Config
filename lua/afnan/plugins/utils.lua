---@diagnostic disable: duplicate-set-field
return {
	{ "nvim-lua/plenary.nvim" },
	{
		"rcarriga/nvim-notify",
		event = "BufEnter",
		config = function()
			local notify = require("notify")
			vim.notify = function(msg, level, opts)
				notify(msg, level, opts)
				vim.opt.termguicolors = true
			end
			notify.setup({ background_colour = "#000000" })
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
	-- { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
	-- {
	--    "rest-nvim/rest.nvim",
	--    dependencies = {
	--       "nvim-neotest/nvim-nio",
	--       "nvim-treesitter/nvim-treesitter",
	--       opts = function(_, opts)
	--          opts.ensure_installed = opts.ensure_installed or {}
	--          table.insert(opts.ensure_installed, "http")
	--       end,
	--    },
	-- },
}
