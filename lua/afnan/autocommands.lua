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

vim.api.nvim_create_autocmd({ "CursorHold" }, {
	desc = "Open float when there is diagnostics",
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, "\"")
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		if vim.fn.mode() == "n" then
			local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break
				end
			end

			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- goto next/prev diagnostic with gk/gj when lsp is attached
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
	callback = function()
		vim.keymap.set("n", "gk", vim.diagnostic.goto_next, { silent = true })
		vim.keymap.set("n", "gj", vim.diagnostic.goto_prev, { silent = true })
	end,
})

-- lazyload cloak.nvim when opening a .env file
vim.api.nvim_create_autocmd("BufRead", {
	callback = function()
		require("afnan.cloak")
	end,
})
