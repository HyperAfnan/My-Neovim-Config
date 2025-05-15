local set = vim.opt

set.compatible = false
vim.cmd("set t_Co=256")

vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

set.termguicolors = true

set.encoding = "utf-8"
set.fileencoding = "utf-8"
set.fileencodings = "utf-8"

set.wildmode = 'longest,full'

set.number = true
set.relativenumber = true
set.ruler = true

-- set.fillchars = {
-- 	eob = "*",
-- }

set.showmode = false

set.signcolumn = "auto:1-2"

set.hidden = true
set.cmdheight = 1
set.backup = false
set.writebackup = false
-- set.conceallevel = 2

set.wrap = false

if vim.o.ft == "log" then
	set.wrap = true
end

set.title = true

set.clipboard = "unnamedplus"

set.autoindent = true
set.smartindent = true
set.shiftround = true
set.shiftwidth = 3
set.tabstop = 3
set.cursorline = true

set.smarttab = true
set.expandtab = true

set.laststatus = 3
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })

set.showtabline = 2

set.updatetime = 100

set.scrolloff = 20

set.spell = false
set.spelllang = "en_us"

set.splitright = false
set.splitbelow = false
set.splitkeep = "cursor"

set.formatoptions:remove("cro")
set.shortmess:append("c")
set.hlsearch = true
set.ignorecase = true

set.inccommand = "nosplit"

vim.cmd("set foldmethod=manual")

vim.g.loaded_perl_provider = false
vim.g.loaded_ruby_provider = false
vim.g.python3_host_prog = "/data/data/com.termux/files/usr/bin/python3"
vim.g.python2_host_prog = "/data/data/com.termux/files/usr/bin/python2"
