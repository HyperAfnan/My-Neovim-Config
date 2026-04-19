local gh = require("afnan.pack").gh

vim.pack.add({ gh("folke/snacks.nvim") })

vim.cmd.packadd({ "snacks.nvim" })

require("snacks").setup({
	explorer = { enabled = true },
	scroll = { enabled = true },
	fuzzy = { enabled = true },
	zen = { enabled = true },
   notifier = { enabled = true },
})

vim.notify = Snacks.notifier.notify
