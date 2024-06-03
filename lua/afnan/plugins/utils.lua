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
}
