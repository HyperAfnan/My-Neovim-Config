return {
   {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-tree/nvim-web-devicons",
         { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
         { 'nvim-telescope/telescope-ui-select.nvim' }
      },
      config = function()
         local telescope = require("telescope")
         local previewers = require("telescope.previewers")
         local load = telescope.load_extension

         local actions = require('telescope.actions')
         local action_state = require('telescope.actions.state')

         local function multiopen(prompt_bufnr)
            local picker = action_state.get_current_picker(prompt_bufnr)
            local multi = picker:get_multi_selection()

            if not vim.tbl_isempty(multi) then
               actions.close(prompt_bufnr)
               for _, j in pairs(multi) do
                  if j.path ~= nil then
                     local path = vim.fn.fnameescape(j.path)
                     if j.lnum ~= nil then
                        vim.cmd(string.format("silent! edit +%d %s", j.lnum, path))
                     else
                        vim.cmd(string.format("silent! edit %s", path))
                     end
                  end
               end
            else
               actions.select_default(prompt_bufnr)
            end
         end

         telescope.setup({
            defaults = {
               mappings = { i = { ["<CR>"] = multiopen, }, n = { ["<CR>"] = multiopen, }, },
               prompt_prefix = "  ",
               show_line = false,
               selection_caret = " ",
               entry_prefix = "  ",
               initial_mode = "insert",
               prompt_title = false,
               results_title = false,
               preview_title = false,
               selection_strategy = "reset",
               sorting_strategy = "descending",
               layout_strategy = "vertical",
               layout_config = {
                  horizontal = { mirror = false },
                  vertical = { mirror = true },
               },
               file_ignore_patterns = {
                  "__pycache__",
                  "node_modules",
                  ".git/*",
                  ".cache",
                  "storage",
                  ".ssh",
                  "snippets",
               },
               border = {},
               borderchars = {
                  preview = { " ", " ", " ", " ", " ", " ", " ", " " },
                  prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
                  results = { " ", " ", " ", " ", " ", " ", " ", " " },
               },
               color_devicons = true,
               use_less = true,
               path_display = {},
               set_env = { ["COLORTERM"] = "truecolor" },
               grep_previewer = previewers.vim_buffer_vimgrep.new,
               qflist_previewer = previewers.vim_buffer_qflist.new,
               buffer_previewer_maker = previewers.buffer_previewer_maker,
               preview = {
                  file_previewer = require("telescope.previewers").new_termopen_previewer({
                     get_command = function(entry)
                        return {
                           "less",
                           "-R",
                           "--tabs=4",
                           "-N",
                           "--quit-if-one-screen",
                           entry.path,
                        }
                     end,
                  }),
               },
            },
            pickers = {
               find_files = {
                  hidden = true,
                  prompt_title = false,
                  previewer = true,
                  results_title = false,
                  preview_title = false,
                  find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
               },
            },
            extensions = {
               fzf = {
                  fuzzy = true,
                  override_generic_sorter = true,
                  override_file_sorter = true,
                  case_mode = "ignore_case",
               },
            },
         })
         load("fzf")
         load("ghn")
         load("ui-select")
         load("refactoring")

      end,
   },
}
