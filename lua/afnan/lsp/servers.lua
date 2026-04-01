local gh = require("afnan.pack").gh

vim.pack.add({ { src = gh("b0o/schemastore.nvim") } })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("emmet_language_server")

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=never",
	},
	single_file_support = true,
	filetypes = { "c", "cpp" },
})
vim.lsp.enable("clangd")
vim.lsp.enable('copilot')
