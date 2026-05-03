local gh = require("afnan.pack").gh

vim.pack.add({
   { src = gh("iamcco/markdown-preview.nvim"), name = "markdown-preview.nvim" },
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = "markdown",
   callback = function()
      vim.cmd.packadd("markdown-preview.nvim")
      vim.fn["mkdp#util#install"]()
   end,
})
