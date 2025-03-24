---TODO: setup completion background highlight
---TODO: setup more sources
---TODO: learn about the lsp source and cusomize it more
---TODO: change sorting setting
---TODO: setup autopairs carefully -> issue made -> fixed it partialy -> made autocmd for setting its config
return {
   "max397574/care.nvim",
   dev = false,
   dependencies = {
      {
         "windwp/nvim-autopairs",
         lazy = false,
         config = function()
            require("nvim-autopairs").setup({
               check_ts = true,
               map_cr = false,
               ts_config = { javascript = { "template_string" } },
            })
         end,
      },
      { "max397574/care-cmp" },
      { "saadparwaiz1/cmp_luasnip" },
      {
         "L3MON4D3/LuaSnip",
         build = "make install_jsregexp",
         dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
         config = function()
            require("afnan.core.snippets")
         end,
      },
      -- {
      --    "luckasRanarison/tailwind-tools.nvim",
      --    name = "tailwind-tools",
      --    build = ":UpdateRemotePlugins",
      --    dependencies = {
      --       "nvim-treesitter/nvim-treesitter",
      --       "nvim-telescope/telescope.nvim",
      --       "neovim/nvim-lspconfig",
      --    },
      --    opts = {
      --       server = {
      --          override = true,             
      --          settings = {},                
      --          on_attach = function(client, bufnr)
      --             vim.notify("client is active")
      --          end, 
      --       },
      --       document_color = {
      --          enabled = true, 
      --          kind = "inline", 
      --          inline_symbol = "󰝤 ", 
      --          debounce = 200, 
      --       },
      --       conceal = {
      --          enabled = false, 
      --          min_length = nil, 
      --          symbol = "󱏿", 
      --          highlight = { fg = "#38BDF8", },
      --       },
      --       cmp = { highlight = "background", },
      --       telescope = { utilities = { callback = function(name, class) end, }},
      --       extension = { queries = {}, patterns = { }, },
      --    }
      -- },
   },
   config = function()
      vim.opt.pumheight = 9
      require("care.config").setup({
         ui = {
            menu = {
               border = "rounded",
               position = "auto",
               format_entry = function(entry, data)
                  local completion_item = entry.completion_item
                  local type_icons = require("care.config").options.ui.type_icons
                  local entry_kind = require("care.utils.lsp").get_kind_name(completion_item.kind)
                  --[[ local handlers = require("nvim-autopairs.completion.handlers")
						local npairs = require("nvim-autopairs")
						local rules = npairs.get_rules("(")
						local is_function, is_method =
							completion_item.kind == 3, completion_item.kind == 2
						local lisp_filetypes =
							{ clojure = true, clojurescript = true, fennel = true, janet = true }
						local is_lisp = lisp_filetypes[vim.bo.ft] == true
						local is_python = vim.bo.ft == "python"
						local buf = vim.api.nvim_get_current_buf()

						if is_function or is_method then
							if is_lisp then
								handler = handlers.lisp("(", completion_item, buf)
							elseif is_python then
								handler = handlers.python("(", completion_item, buf, rules)
							else
								handler = handlers["*"]("(", completion_item, buf, rules)
							end
						end ]]

                  -- care.api.set_event("confirm_done", function()
                  -- 	cmp_autopairs.on_confirm_done({
                  -- 		filetypes = {
                  -- 			["*"] = {
                  -- 				["("] = { kind = { 2, 3 }, handler, },
                  -- 			},
                  -- 		},
                  -- 	})
                  -- end)
                  return {
                     { { completion_item.label .. " ", "@care.entry" } },
                     { { type_icons[entry_kind], ("@care.type.%s"):format(entry_kind) } },
                     { { " " .. data.source_name .. " ", "Comment" } },
                  }
               end,
               scrollbar = { enabled = true, character = "┃", offset = 0 },
               alignments = { "left", "center", "right" },
            },
            docs_view = {
               max_height = 8,
               max_width = 50,
               border = "rounded",
               scrollbar = { enabled = true, character = "┃", offset = 0 },
               position = "auto",
            },
            type_icons = {
               Text = "  ",
               Method = "  ",
               Function = "  ",
               Constructor = "  ",
               Field = "  ",
               Variable = "[]",
               Class = " פּ ",
               Interface = " 蘒 ",
               Module = "  ",
               Property = "  ",
               Unit = "  ",
               Value = "  ",
               Enum = "  ",
               Keyword = "  ",
               Snippet = "  ",
               Color = "  ",
               File = "  ",
               Reference = "  ",
               Folder = "  ",
               EnumMember = "  ",
               Constant = "  ",
               Struct = "  ",
               Event = "  ",
               Operator = "  ",
               TypeParameter = "  ",
            },
            ghost_text = { enabled = false, position = "inline" },
         },
         integration = { autopairs = true },
         snippet_expansion = function(snippet_body)
            vim.snippet.expand(snippet_body)
         end,
         selection_behavior = "insert",
         confirm_behavior = "insert",
         keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
         sources = {
            path = { enabled = true },
            cmp_luasnip = { enabled = true },
            lsp = {
               filter = function(entry)
                  return entry.completion_item.kind ~= 1
               end,
            },
         },
         preselect = true,
         sorting_direction = "top-down",
         completion_events = { "TextChangedI" },
         enabled = function()
            local enabled = true
            if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
               enabled = false
            end
            return enabled
         end,
         max_view_entries = 200,
         debug = false,
      })

      local care = require("care")

      -- local autopair = require("nvim-autopairs.completion.cmp")

      -- local ts_utils = require("nvim-treesitter.ts_utils")
      -- local ts_node_func_parens_disabled = { named_imports = true, use_declaration = true }
      --
      -- local default_handler = autopair.filetypes["*"]["("].handler
      -- autopair.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
      -- 	local node_type = ts_utils.get_node_at_cursor():type()
      -- 	if ts_node_func_parens_disabled[node_type] then
      -- 		if item.data then
      -- 			item.data.funcParensDisabled = true
      -- 		else
      -- 			char = ""
      -- 		end
      -- 	end
      -- 	default_handler(char, item, bufnr, rules, commit_character)
      -- end

      --Mappings
      local ls = require("luasnip")
      local tabout = require("tabout")
      local npairs = require("nvim-autopairs")

      vim.keymap.set("i", "<Down>", "<Plug>(CareSelectNext)")
      vim.keymap.set("i", "<Up>", "<Plug>(CareSelectPrev)")

      vim.keymap.set("i", "<cr>", function()
         if care.api.is_open() then
            return care.api.confirm()
         else
            vim.fn.feedkeys(npairs.autopairs_cr(), "in")
         end
      end)

      vim.keymap.set("i", "<Tab>", function()
         if ls.jumpable(1) then
            ls.jump(1)
         else
            tabout.tabout()
         end
      end)
      vim.keymap.set("i", "<S-Tab>", function()
         if ls.jumpable(-1) then
            ls.jump(-1)
         else
            tabout.taboutBack()
         end
      end)

      vim.keymap.set("i", "<c-e>", "<Plug>(CareClose)")
   end,
}
