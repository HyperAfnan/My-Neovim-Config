return {
	filetypes = { "json", "jsonc" },
	init_options = { provideFormatter = true },
	single_file_support = true,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
		},
	},
}
