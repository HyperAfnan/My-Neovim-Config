local M = {}

local utils = require("afnan.lsp-config.utils")

M.setup = function()
	vim.lsp.config("ts_ls", {
		filetypes = {
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"javascript",
			"js",
			"javascriptreact",
			"javascript.jsx",
		},
		on_attach = utils.on_attach,
		capabilities = utils.capabilities,
		settings = { completions = { completeFunctionCalls = true } },
		init_options = {
			preferences = {
				includeCompletionsWithSnippetText = true,
				includeCompletionsForImportStatements = true,
				includeCompletionsForModuleExports = true,
				includeCompletionsForObjectLiteralMethodSnippets = true,
				importModuleSpecifierEnding = "js",
				organizeImportsIgnoreCase = true,
				includeCompletionsForParameterSnippets = true,
				includeCompletionsForPropertySnippets = true,
				includeCompletionsWithInsertText = true,
				includeCompletionsForRenames = true,
				includeCompletionsForUnresolvedImports = true,
				quotePreference = "double",
			},
		},
		single_file_support = true,
	})

	vim.lsp.enable("ts_ls")
end
return M
