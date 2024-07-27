return {
   {
      "windwp/nvim-autopairs",
      event = { "InsertEnter" },
      dependencies = {
         "hrsh7th/nvim-cmp",
      },
      config = function()
         local npairs = require("nvim-autopairs")
         npairs.setup({
            check_ts = true,
            map_cr = false,
            ts_config = {
               javascript = { "template_string" },
            },
         })

         local cmp_autopairs = require("nvim-autopairs.completion.cmp")
         local cmp = require("cmp")
         local handlers = require("nvim-autopairs.completion.handlers")

         cmp.event:on(
            "confirm_done",
            cmp_autopairs.on_confirm_done({
               filetypes = {
                  ["*"] = {
                     ["("] = {
                        kind = {
                           cmp.lsp.CompletionItemKind.Function,
                           cmp.lsp.CompletionItemKind.Method,
                        },
                        handler = handlers["*"],
                     },
                  },
               },
            })
         )
         -- _G.MUtils = {}
         -- MUtils.completion_confirm = function()
         --    if vim.fn["coc#pum#visible"]() ~= 0 then
         --       return vim.fn["coc#pum#confirm"]()
         --    else
         --       return npairs.autopairs_cr()
         --    end
         -- end
         --
         -- vim.api.nvim_set_keymap(
         --    "i",
         --    "<CR>",
         --    "v:lua.MUtils.completion_confirm()",
         --    { expr = true, noremap = true, silent = true }
         -- )
      end,
   },
}
