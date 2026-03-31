local gh = require("afnan.pack").gh

vim.pack.add({ gh("lukas-reineke/indent-blankline.nvim") })
vim.cmd.packadd("indent-blankline.nvim")

require("ibl").setup({})
