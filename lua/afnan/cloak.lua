local gh = require("afnan.pack").gh

vim.pack.add({
	{
		src = gh("laytan/cloak.nvim"),
		name = "cloak.nvim",
	},
})
require("cloak").setup({ enabled = true })

vim.keymap.set("n", "<cr>", ":CloakPreviewLine<cr>", { noremap = true, silent = true })
