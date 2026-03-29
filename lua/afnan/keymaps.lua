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

