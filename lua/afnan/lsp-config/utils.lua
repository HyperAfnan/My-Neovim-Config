local M = {}

local cmp_nvim_lsp = require("cmp_nvim_lsp")
M.capabilities = cmp_nvim_lsp.default_capabilities()

M.on_attach = function(_, bufnr)
	vim.o.foldmethod = "expr"
	vim.o.foldlevel = 99
	vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"

	local function set_keymap(mode, lhs, rhs)
		vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { silent = true, noremap = true })
	end

	set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>")
	set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
	set_keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
	set_keymap("n", "gI", ":lua vim.lsp.buf.implementation()<CR>")
	set_keymap("n", "gk", ":lua vim.diagnostic.goto_next()<CR>")
	set_keymap("n", "gj", ":lua vim.diagnostic.goto_prev()<CR>")
	set_keymap("n", "gR", ":lua vim.lsp.buf.references()<CR>")
	set_keymap("n", "gr", ":lua vim.lsp.buf.rename()<CR>")
	set_keymap("n", "ga", ":lua vim.lsp.buf.code_action()<CR>")
	set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	local inlay_hints_group = vim.api.nvim_create_augroup("LSP_inlayHints", { clear = false })
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = inlay_hints_group,
		desc = "Update inlay hints on line change",
		buffer = bufnr,
		callback = function()
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end,
	})
end

return M
