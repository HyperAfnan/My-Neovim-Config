local utils = require("afnan.lsp.utils")

vim.diagnostic.config({
	signs = false,
	virtual_text = false,
	update_in_insert = true,
	underline = true,
	float = {
		focusable = false,
		border = "single",
		scope = "cursor",
		source = "if_many",
		header = { "Cursor Diagnostics: ", "DiagnosticInfo" },
		prefix = utils.prefix,
	},
})
