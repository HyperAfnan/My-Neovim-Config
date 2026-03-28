-- Highlights selects on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Hides tmux statusline when in neovim
local tmux_group = vim.api.nvim_create_augroup("TmuxStatusControl", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	group = tmux_group,
	callback = function()
		if os.getenv("TMUX") then
			os.execute("tmux set status off")
		end
	end,
})

-- Restores tmux statuslie on leaving neovim
vim.api.nvim_create_autocmd("VimLeave", {
	group = tmux_group,
	callback = function()
		if os.getenv("TMUX") then
			os.execute("tmux set status on")
		end
	end,
})

-- -- Opens help buffer in full window instead of split window
-- local help_group = vim.api.nvim_create_augroup("Help-as-a-buffer", { clear = true })
-- vim.api.nvim_create_autocmd("BufWinEnter", {
-- 	group = help_group,
-- 	pattern = "*",
-- 	callback = function(event)
-- 		if vim.bo[event.buf].filetype == "help" then
-- 			vim.cmd.only()
-- 			vim.bo[event.buf].buflisted = true
-- 			vim.bo[event.buf].buftype = ""
-- 			vim.bo[event.buf].syntax = "help"
-- 			vim.keymap.set("n", "q", ":bd<CR>", { buffer = event.buf, silent = true })
-- 		end
-- 	end,
-- })
