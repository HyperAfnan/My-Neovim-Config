return  {
	"NTBBloodbath/galaxyline.nvim",
	dependencies = {
		{
			"rlch/github-notifications.nvim",
			config = function()
				require("github-notifications").setup({
					icon = "",
					cache = true,
					mappings = {
						mark_read = "<CR>",
						hide = "d",
						open_in_browser = "o",
					},
				})
			end,
		},
	},
	config = function()
		require("afnan.core.statusline")
	end,
}
