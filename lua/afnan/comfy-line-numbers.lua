local gh = require("afnan.pack").gh

vim.pack.add({ gh("mluders/comfy-line-numbers.nvim") })

vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*",
	callback = function()
		vim.cmd.packadd("comfy-line-numbers.nvim")
		require("comfy-line-numbers").setup()
	end,
})
