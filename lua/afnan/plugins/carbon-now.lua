return {
	{
		"ellisonleao/carbon-now.nvim",
		lazy = true,
		cmd = "CarbonNow",
		config = function()
			local carbon = require("carbon-now")
			carbon.setup({
				options = {
					theme = "tokyonight",
					font_family = "Monoid",
				},
			})
		end,
	},
}
