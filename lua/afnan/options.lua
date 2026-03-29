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

set.wildmode = "longest,full"

set.number = true
set.relativenumber = true
set.ruler = true

set.showmode = false

set.signcolumn = "auto:1-2"

set.hidden = true
set.cmdheight = 1
set.backup = false
set.writebackup = false

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

set.showtabline = 2

set.updatetime = 100

set.timeoutlen = 300

vim.o.confirm = true

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

set.swapfile = false

vim.g.maplaeder = ","
vim.g.maplocalleader = ","
vim.g.have_nerd_font = true

vim.opt.fillchars = { eob = " " }

local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"syntax",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}

for _, plugin in ipairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

vim.g.loaded_2html_plugin = 1

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
