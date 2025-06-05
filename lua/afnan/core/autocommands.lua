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
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = {"javascript", "typescript", "javascriptreact", "typescriptreact"},
--   callback = function()
--     vim.bo.makeprg = "npx eslint  "
--     vim.bo.errorformat = "%f:%l:%c: %m,%E%f: line %l\\, col %c\\, %m,%-G%.%#"
--   end
-- })
--
-- vim.api.nvim_create_autocmd("QuickFixCmdPost", {
--   pattern = {"make", "grep", "grepadd", "vimgrep"},
--   command = "cwindow"
-- })

augroup("_db", {})
cmd("FileType", {
	desc = "disable folding in dbui buffer",
	group = "_db",
	pattern = "dbui",
	command = "setlocal foldmethod=manual",
})

cmd("BufEnter", {
	pattern = "copilot-*",
	callback = function()
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
	end,
})
