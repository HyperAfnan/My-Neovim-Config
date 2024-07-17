local augroup = vim.api.nvim_create_augroup
local cmd = vim.api.nvim_create_autocmd

cmd("BufEnter", {
	desc = "Disable Autocommenting",
	command = "set fp-=c fo-=r fo-=o",
})

augroup("_term", {})

cmd("TermOpen", {
	desc = "Auto Insert",
	group = "_term",
	command = "startinsert",
})

cmd("TermOpen", {
	desc = "Unset numbers",
	group = "_term",
	command = "setlocal nonu",
})

augroup("_buffer", {})

cmd("TextYankPost", {
	desc = "Highlight while yanking",
	group = "_buffer",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual" })
	end,
})

augroup("_lsp", {})

cmd({ "CursorHold" }, {
	desc = "Open float when there is diagnostics",
	group = "_lsp",
	callback = vim.diagnostic.open_float,
})

augroup("_autosave", {})

cmd({ "InsertLeave", "TextChanged" }, {
	desc = "Autosave",
	pattern = "*.",
	group = "_autosave",
	command = "write",
})
