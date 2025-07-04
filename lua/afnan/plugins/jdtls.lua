return {
   {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = function()
         require("mason").setup()
      end
   },
   {
   "williamboman/mason-lspconfig.nvim",
      dependencies = { "neovim/nvim-lspconfig" },
      config = function()
         require("mason-lspconfig").setup()
      end
   }

}
