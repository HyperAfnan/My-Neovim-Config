return {
   -- "stevearc/conform.nvim",
   -- event = { "BufWritePre" },
   -- cmd = "ConformInfo",
   -- config = function()
   -- 	require("conform").setup({
   -- 		format_on_save = function()
   -- 			return
   -- 		end,
   -- 		formatters_by_ft = {
   -- 			lua = { "stylua" },
   -- 			python = { "black" },
   -- 			javascript = { "prettier" },
   -- 			javascriptreact = { "prettier" },
   -- 			css = { "prettier" },
   -- 			html = { "prettier" },
   -- 		},
   -- 	})
   -- end,
   {
      "nvimtools/none-ls.nvim",
      config = function()
         local null_ls = require("null-ls")

         null_ls.setup({
            sources = {
               null_ls.builtins.formatting.stylua,
               null_ls.builtins.code_actions.gitsigns,
               -- null_ls.builtins.completion.spell,
               null_ls.builtins.formatting.prettierd,
            },
         })
      end,
      requires = { "nvim-lua/plenary.nvim" },
   },
}
