
			-- -- Emmet
			-- lspconfig.emmet_language_server.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	filetypes = { "css", "html", "jsx", "tsx", "javascriptreact" },
			-- })

local M = {}

local utils = require("afnan.lsp-config.utils")
local lspconfig = require("lspconfig")

M.setup = function()
   lspconfig.emmet_language_server.setup({
      on_attach = utils.on_attach,
      capabilities = utils.capabilities,
      filetypes = { "css", "html", "jsx", "tsx", "javascriptreact" },
   })

   vim.lsp.enable("emmet_language_server")
end

return M
