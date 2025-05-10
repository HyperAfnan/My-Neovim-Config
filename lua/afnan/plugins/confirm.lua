return {
   "stevearc/conform.nvim",
   event = { "BufWritePre" },
   cmd = "ConformInfo",
   config = function()
      require("conform").setup({
         notify_on_error = true,
         format_on_save = function()
            return
         end,
         formatters_by_ft = {
            lua = { "stylua" },
            python = { "black" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
         },
      })
   end,
}
