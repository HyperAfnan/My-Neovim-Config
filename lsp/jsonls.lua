local schemastore = require("schemastore")

return {
	filetypes = { "json", "jsonc" },
	init_options = { provideFormatter = true },
	single_file_support = true,
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
		},
	},
}
