local gh = require("afnan.pack").gh

vim.pack.add({
	{ src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
	{ src = gh("nvim-lua/plenary.nvim") },
})

local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", ",a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

-- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

vim.keymap.set("n", ",p", function()
	require("harpoon"):list():prev()
end)
vim.keymap.set("n", ",n", function()
	require("harpoon"):list():next()
end)
