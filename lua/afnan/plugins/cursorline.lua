return {
	{
		"mawkler/modicator.nvim",
		dependencies = { "navarasu/onedark.nvim", "folke/tokyonight.nvim", "Mofiqul/vscode.nvim" },
		config = function()
			require("modicator").setup({
				show_warnings = false,
				highlights = {
					defaults = {
						bold = false,
						italic = false,
					},
				},
				integration = {
					lualine = {
						enabled = true,
						mode_section = nil,
						highlight = "bg",
					},
				},
			})
		end,
	},
}
