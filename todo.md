
# implement custom completion sort comporators

## Prioritization and Deprioritization of lsp kinds

This is how it will look like roughly, 
in this implementation, it is basically deprioritizing the snippets by the lsp

``` lua 
      opts = function(_, opts)
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      -- local types = require("cmp.types")

      -- Function to sort LSP snippets, so that they appear at the end of LSP suggestions
      -- local function deprioritize_snippet(entry1, entry2)
      --   if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
      --     return false
      --   end
      --   if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
      --     return true
      --   end
      -- end

      -- Insert `deprioritize_snippet` first in the `comparators` table, so that it has priority
      -- over the other default comparators
      -- table.insert(opts.sorting.comparators, 1, deprioritize_snippet)

      -- Insert parentheses after selecting method/function
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- Make codeium suggestions appear only when `nvim-cmp` menu is closed
      -- local neocodeium = require("neocodeium")
      -- local commands = require("neocodeium.commands")
```

this is a chunk of code from this config 
https://github.com/dpetka2001/dotfiles/blob/main/dot_config/nvim/lua/plugins/coding.lua

## Getting the current treesitter context

    To be decided
