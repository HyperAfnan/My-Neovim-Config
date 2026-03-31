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

-- Auto saves current file
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
	callback = function()
		if vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= "" then
			vim.cmd("silent! write")
		end
	end,
})
