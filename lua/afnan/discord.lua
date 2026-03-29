local gh = require("afnan.pack").gh

vim.pack.add({ gh("vyfor/cord.nvim") })
vim.cmd.packadd("cord.nvim")

require("cord").setup({
	display = { theme = "catppuccin", },
	idle = { details = "Resting after long work", },
})
