return {
   { "tpope/vim-fugitive", cmd = "Git", },
   {
      "lewis6991/gitsigns.nvim",
      config = function()
         local gitsigns = require("gitsigns")
         local border = { " ", " ", " ", " ", " ", " ", " ", " " }
         gitsigns.setup({
            signs = {
               add = { text = "┃" },
               change = { text = "┃" },
               delete = { text = "_" },
               topdelete = { text = "‾" },
               changedelete = { text = "~" },
               untracked = { text = "┆" },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = { follow_files = true },
            auto_attach = true,
            attach_to_untracked = true,
            current_line_blame = false,
            current_line_blame_opts = {
               virt_text = true,
               virt_text_pos = "eol",
               delay = 1000,
               ignore_whitespace = false,
               virt_text_priority = 100,
            },
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,
            max_file_length = 40000,
            preview_config = {
               border = border,
               style = "minimal",
               relative = "cursor",
               row = 0,
               col = 1,
            },
         })
      end,
   },
}
