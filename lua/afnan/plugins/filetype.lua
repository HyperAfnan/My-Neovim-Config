return {
	"nathom/filetype.nvim",
	config = function()
		require("filetype").setup({
			overrides = {
				complex = {
					[".luacheckrc"] = "lua",
				},
			},
		})
	end,
}
