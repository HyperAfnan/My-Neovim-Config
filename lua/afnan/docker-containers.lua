vim.opt.rtp:append("~/Projects/docker-containers.nvim")
local gh = require("afnan.pack").gh
--
vim.pack.add({ gh("akinsho/toggleterm.nvim") })
vim.cmd.packadd("toggleterm.nvim")

require("docker-containers").setup({
  position = "right",
  term = {
      direction = "horizontal"
  },
  maps = {
    collapse = "<space>",
    restart = "r",
    down = "d",
    start = "s",
    close = "q"
  },
  icons = {
    container_running = "",
    container_stopped = "",
    project = "",
    expanded = "",
    collapsed = "",
  }
})
