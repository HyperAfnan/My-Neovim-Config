local M = {}

local utils = require("afnan.lsp-config.utils")

M.setup = function()
	vim.lsp.config("clangd", {
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		on_attach = utils.on_attach,
		capabilities = utils.capabilities,
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--completion-style=detailed",
			"--header-insertion=never",
		},
		single_file_support = true,
	})
	vim.lsp.enable("clangd")
end

return M
