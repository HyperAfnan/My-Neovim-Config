return {
	{
		"0x00-ketsu/autosave.nvim",
		config = function()
			require("autosave").setup({
				prompt_message = function()
					return ""
				end,
			})
		end,
	},
}
