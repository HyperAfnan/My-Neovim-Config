return {
   {
      "m4xshen/hardtime.nvim",
      dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
      opts = {
         restricted_keys = {
            ["h"] = {},
            ["l"] = {},
            ["j"] = {},
            ["k"] = {},
            ['<Up>'] = { 'n', 'x', 'i', 'v' },
            ['<Down>'] = { 'n', 'x', 'i', 'v' },
            ['<Left>'] = { 'n', 'x', 'i', 'v' },
            ['<Right>'] = { 'n', 'x', 'i', 'v' },
         },
         disabled_keys = {
            ["<Up>"] = {},
            ["<Down>"] = {},
            ["<Left>"] = {},
            ["<Right>"] = {},
         },
      },
   },
   {
      "tris203/precognition.nvim",
      event = "VeryLazy",
      opts = {
         startVisible = false,
         showBlankVirtLine = false,
         highlightColor = { link = "Comment" },
         hints = {
            Caret = { text = "^", prio = 2 },
            Dollar = { text = "$", prio = 1 },
            MatchingPair = { text = "%", prio = 5 },
            Zero = { text = "0", prio = 1 },
            w = { text = "w", prio = 10 },
            b = { text = "b", prio = 9 },
            e = { text = "e", prio = 8 },
            W = { text = "W", prio = 7 },
            B = { text = "B", prio = 6 },
            E = { text = "E", prio = 5 },
         },
         gutterHints = {
            G = { text = "G", prio = 10 },
            gg = { text = "gg", prio = 9 },
            PrevParagraph = { text = "{", prio = 8 },
            NextParagraph = { text = "}", prio = 8 },
            line = { text = "", prio = 7 },
         },
         disabled_fts = {
            "startify",
         },
      },
   },
}
