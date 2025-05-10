return {
   {
      "MunifTanjim/nui.nvim",
      event = "InsertEnter",
      config = function()
         local Menu = require("nui.menu")
         local event = require("nui.utils.autocmd").event
         local function get_prompt_text(prompt, default_prompt)
            local prompt_text = prompt or default_prompt
            if prompt_text:sub(-1) == ":" then
               prompt_text = "[" .. prompt_text:sub(1, -2) .. "]"
            end
            return prompt_text
         end

         local function override_select()
            local UISelect = Menu:extend("UISelect")

            function UISelect:init(items, opts, on_done)
               local border_top_text = get_prompt_text(opts.prompt, "[Select Item]")
               local kind = opts.kind or "unknown"
               local format_item = opts.format_item
                   or function(item)
                      return tostring(item.__raw_item or item)
                   end

               local popup_options = {
                  relative = "editor",
                  position = "50%",
                  border = {
                     style = "rounded",
                     text = {
                        top = border_top_text,
                        top_align = "left",
                     },
                  },
                  win_options = {
                     winhighlight = "NormalFloat:Normal",
                  },
                  zindex = 999,
               }

               if kind == "codeaction" then
                  popup_options.relative = "cursor"
                  popup_options.position = {
                     row = 1,
                     col = 0,
                  }
               end

               local max_width = popup_options.relative == "editor" and vim.o.columns - 4
                   or vim.api.nvim_win_get_width(0) - 4
               local max_height = popup_options.relative == "editor"
                   and math.floor(vim.o.lines * 80 / 100)
                   or vim.api.nvim_win_get_height(0)

               local menu_items = {}
               for index, item in ipairs(items) do
                  if type(item) ~= "table" then
                     item = { __raw_item = item }
                  end
                  item.index = index
                  local item_text = string.sub(format_item(item), 0, max_width)
                  menu_items[index] = Menu.item(item_text, item)
               end

               local menu_options = {
                  min_width = vim.api.nvim_strwidth(border_top_text),
                  max_width = max_width,
                  max_height = max_height,
                  lines = menu_items,
                  on_close = function()
                     on_done(nil, nil)
                  end,
                  on_submit = function(item)
                     on_done(item.__raw_item or item, item.index)
                  end,
               }

               UISelect.super.init(self, popup_options, menu_options)

               self:on(event.BufLeave, function()
                  on_done(nil, nil)
               end, { once = true })
            end

            local select_ui = nil

            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(items, opts, on_choice)
               assert(type(on_choice) == "function", "missing on_choice function")

               if select_ui then
                  vim.api.nvim_err_writeln("busy: another select is pending!")
                  return
               end

               select_ui = UISelect(items, opts, function(item, index)
                  if select_ui then
                     select_ui:unmount()
                  end
                  on_choice(item, index)
                  select_ui = nil
               end)

               select_ui:mount()
            end
         end
         override_select()

         function _G.sub()
            vim.ui.input({
               prompt = "Input: ",
               default_value = vim.fn.expand("<cword>"),
            }, function(value1)
               vim.ui.input({
                  prompt = "Substitute: ",
               }, function(value2)
                  vim.cmd("%s/" .. value1 .. "/" .. value2)
               end)
            end)
         end

         vim.keymap.set("n", "su", _G.sub, { noremap = true, silent = true })
      end,
   },
   {
      "NvChad/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      config = function()
         require("colorizer").setup()
      end,
   },
   {
      "rachartier/tiny-devicons-auto-colors.nvim",
      dependencies = {
         "nvim-tree/nvim-web-devicons",
      },
      event = "VeryLazy",
      config = function()
         require("tiny-devicons-auto-colors").setup()
      end,
   },
}
