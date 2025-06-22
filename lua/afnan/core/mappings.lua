local function set_keymap(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true })
end

set_keymap("", "k", "gk")
set_keymap("", "j", "gj")
set_keymap("n", "<A-q>", ":q<CR>")
set_keymap("n", "<A-w>", ":write<CR>")
set_keymap("n", "<space>", ":")
set_keymap("v", "<space>", ":")
if vim.o.ft == "lua" then
	set_keymap("n", "<F5>", "<cmd>write<CR> <cmd>source %<cr>")
	set_keymap("n", "<F6>", "<cmd>set rtp+=.<CR> <cmd>source %<cr>")
else
	set_keymap("n", "<F5>", "<cmd>RunFile<cr>")
end

set_keymap("i", "<C-BS>", "<esc>cb")

-- single line movement
set_keymap("n", "<A-left>", "0")
set_keymap("n", "<A-right>", "$")
set_keymap("i", "<A-right>", "<ESC>$ i")
set_keymap("i", "<A-left>", "<ESC>0 i")

-- Resizing
set_keymap("n", "<A-Up>", "<cmd>resize +2<cr>")
set_keymap("n", "<A-Down>", "<cmd>resize -2<cr>")
set_keymap("n", "<A-Left>", "<cmd>vertical resize +2<cr>")
set_keymap("n", "<A-Right>", "<cmd>vertical resize -2<cr>")

-- Indentation
set_keymap("v", "<", "<gv")
set_keymap("v", ">", ">gv")
set_keymap("n", "<", "<<")
set_keymap("n", ">", ">>")

set_keymap("t", "<ESC>", "<C-\\><C-n>")

-- for split movement in normal mode
set_keymap("n", "<A-h>", "<C-w>h")
set_keymap("n", "<A-j>", "<C-w>j")
set_keymap("n", "<A-k>", "<C-w>k")
set_keymap("n", "<A-l>", "<C-w>l")

-- for split movement in normal mode
set_keymap("i", "<A-h>", "<esc><C-w>hi")
set_keymap("i", "<A-j>", "<esc><C-w>ji")
set_keymap("i", "<A-k>", "<esc><C-w>ki")
set_keymap("i", "<A-l>", "<esc><C-w>li")

-- for buffer
set_keymap("n", "<tab>", ":BufferLineCycleNext<CR>")
set_keymap("n", "<S-tab>", ":BufferLineCyclePrev<CR>")
set_keymap("n", ",bd", ":bdelete<CR>")

-- For quickfix list
set_keymap("n", "<C-j>", ":cnext<CR>")
set_keymap("n", "<C-k>", ":cprev<CR>")

set_keymap("n", "Y", "y$")

--Some custom completion
set_keymap("i", "<C-c>", "<C-x><C-v>")
set_keymap("i", "<C-f>", "<C-x><C-f>")

-- split keymap
set_keymap("n", "sv", ":vsplit %<CR>")

set_keymap("i", "<C-v>", "<esc>pi")

-- Move lines without ruining registers
-- set_keymap("i", "<C-j>", "<esc>:m .+1<CR>==")
-- set_keymap("i", "<C-k>", "<esc>:m .-2<CR>==")
set_keymap("n", ",K", ":m .-2<CR>==")
set_keymap("n", ",J", ":m .+1<CR>==")
set_keymap("v", "K", ":m '>+1<CR>gv=gv")
set_keymap("v", "J", ":m '<-2<CR>gv=gv")

set_keymap("n", ",ii", function()
	require("nvim-market").install_picker()
end)
set_keymap("n", ",iu", function()
	require("nvim-market").remove_picker()
end)

set_keymap("n", "mm", function()
	require("miss").has_missed_files(function()
		vim.cmd(":G")
	end)
end)
