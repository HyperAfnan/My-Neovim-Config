function keymap(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { remap = true, silent = true })
end

keymap("n", "<A-q>", ":q<CR>")
keymap("n", "<A-w>", ":write<CR>")

keymap("n", "<space>", ":")

keymap("n", "<Tab>", ":bnext<CR>")
keymap("n", "<S-Tab>", ":bprev<CR>")

keymap("n", "sv", ":split %<CR>")

keymap("n", "<S-q>", ":bd<CR>")

keymap("n", "<C-n>", function()
	Snacks.explorer()
end)

keymap("n", "<A-left>", "0")
keymap("n", "<A-right>", "$")
keymap("i", "<A-right>", "<ESC>$ i")
keymap("i", "<A-left>", "<ESC>0 i")

keymap("n", "<A-Up>", "<cmd>resize +2<cr>")
keymap("n", "<A-Down>", "<cmd>resize -2<cr>")
keymap("n", "<A-Left>", "<cmd>vertical resize +2<cr>")
keymap("n", "<A-Right>", "<cmd>vertical resize -2<cr>")

keymap("v", "<", "<gv")
keymap("v", ">", ">gv")
keymap("n", "<", "<<")
keymap("n", ">", ">>")

keymap("t", "<ESC>", "<C-\\><C-n>")

keymap("n", "<A-h>", "<C-w>h")
keymap("n", "<A-j>", "<C-w>j")
keymap("n", "<A-k>", "<C-w>k")
keymap("n", "<A-l>", "<C-w>l")

keymap("i", "<A-h>", "<esc><C-w>hi")
keymap("i", "<A-j>", "<esc><C-w>ji")
keymap("i", "<A-k>", "<esc><C-w>ki")
keymap("i", "<A-l>", "<esc><C-w>li")
