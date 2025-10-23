local M = {}

local utils = require("afnan.lsp-config.utils")

M.setup = function()
	vim.lsp.config("pyright", {
		filetypes = { "python" },
		on_attach = utils.on_attach,
		capabilities = utils.capabilities,
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
					typeCheckingMode = "basic",
					inlayHints = {
						variableTypes = true,
						functionReturnTypes = true,
						propertyDeclarationTypes = true,
						paramTypes = true,
						callArgumentTypes = true,
					},
				},
			},
		},
		single_file_support = true,
	})

	vim.lsp.config("ruff", {
		filetypes = { "python" },
		on_attach = utils.on_attach,
		capabilities = utils.capabilities,
		settings = {},
		single_file_support = true,
		init_options = {
			settings = {},
		},
	})

	vim.lsp.enable("pyright")
	vim.lsp.enable("ruff")
end
return M
