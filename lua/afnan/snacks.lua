local gh = require("afnan.pack").gh

vim.pack.add({ gh("folke/snacks.nvim") })

vim.cmd.packadd({ "snacks.nvim" })

require("snacks").setup({ explorer = { enabled = true } })
