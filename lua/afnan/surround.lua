local gh = require("afnan.pack").gh


vim.pack.add({
   gh "nvim-mini/mini.surround"
})

vim.cmd.packadd("mini.surround")


require("mini.surround").setup({})
