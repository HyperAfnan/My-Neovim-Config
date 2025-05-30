
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

these functions will be used to get current node, to which more things will be added
tip: all the working will be in the form of autocmd with some kind of events

```lua
    local get_node = vim.treesitter.get_node
    local cur_pos = vim.api.nvim_win_get_cursor

    ---An insert mode implementation of `vim.treesitter`'s `get_node`
    ---@param opts table? Opts to be passed to `get_node`
    ---@return TSNode node The node at the cursor
    local get_node_insert_mode = function(opts)
    opts = opts or {}
    local ins_curs = cur_pos(0)
    ins_curs[1] = math.max(ins_curs[1] - 1, 0)
    ins_curs[2] = math.max(ins_curs[2] - 1, 0)
    opts.pos = ins_curs
    return get_node(opts) --[[@as TSNode]]
    end

    ---Whether or not the cursor is in a JSX-tag region
    ---@param insert_mode boolean Whether or not the cursor is in insert mode
    ---@return boolean
    M.in_jsx_tags = function(insert_mode)
    local current_node = insert_mode and get_node_insert_mode() or get_node()
    return current_node and current_node:__has_ancestor { 'jsx_element' } or false
    end
```

# Custom commentstring for jsx and tsx filetype 

this is a rough code of how will it be implemented
it will be using the same code being used for priotizing 
and deprioritizing of lsp kinds

```lua
    local get_option = vim.filetype.get_option
    local in_jsx = require('rileybruins.utils').in_jsx_tags
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.filetype.get_option = function(filetype, option)
        if option ~= 'commentstring' then
        return get_option(filetype, option)
        end
        if filetype == 'javascriptreact' or filetype == 'typescriptreact' then
        local line = vim.api.nvim_get_current_line()
        if in_jsx(false) or line:match('^%s-{/%*.-%*/}%s-$') then
            return '{/*%s*/}'
        end
        end
        return get_option(filetype, option)
    end
```

# Custom completion sort comparators

```lua 
TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
comparators = {
    cmp.config.compare.score,
    cmp.config.compare.sort_text,
    lspkind_comparator({
        kind_priority = {
            Parameter = 14,
            Variable = 12,
            Field = 11,
            Property = 11,
            Constant = 10,
            Enum = 10,
            EnumMember = 10,
            Event = 10,
            Function = 10,
            Method = 10,
            Operator = 10,
            Reference = 10,
            Struct = 10,
            File = 8,
            Folder = 8,
            Class = 5,
            Color = 5,
            Module = 5,
            Keyword = 2,
            Constructor = 1,
            Interface = 1,
            Snippet = 0,
            Text = 1,
            TypeParameter = 1,
            Unit = 1,
            Value = 1,
        },
    }),
    label_comparator,
}
```
