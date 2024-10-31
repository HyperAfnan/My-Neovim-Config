return {
   "folke/persistence.nvim",
   event = "BufReadPre",
   keys = {
      { ",qs", function() require("persistence").load() end },
      {",qS", function() require("persistence").select() end},
      {",ql", function() require("persistence").load({ last = true }) end},
      {",qd", function() require("persistence").stop() end},
   },
   opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 0,
      branch = false,
   },
}
