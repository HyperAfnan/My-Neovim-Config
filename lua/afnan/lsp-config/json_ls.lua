local M = {}

local utils = require("afnan.lsp-config.utils")
local schemastore = require("schemastore")

M.setup = function()
   vim.lsp.config("jsonls", {
      filetypes = { "json", "jsonc" },
      on_attach = utils.on_attach,
      capabilities = utils.capabilities,
      init_options = { provideFormatter = false },
      single_file_support = true,
      settings = {
         json = {
            schemas = schemastore.json.schemas(),
         },
      },
   })

   vim.lsp.enable("jsonls")
end

return M
