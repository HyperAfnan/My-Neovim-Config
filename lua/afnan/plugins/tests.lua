return  {
  "nvim-neotest/neotest",
  dependencies = { "nvim-neotest/neotest-jest", "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim" },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest")({
          jestCommand = "npx jest",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(_) return vim.fn.getcwd() end,
        }),
      },
      icons = {
        passed = "✓",
        running = "->",
        failed = "",
        skipped = "",
        unknown = "?",
      },
    })
  end
}
