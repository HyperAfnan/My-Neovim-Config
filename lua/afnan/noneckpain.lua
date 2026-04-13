local gh = require("afnan.pack").gh

vim.pack.add({ { src = gh("shortcuts/no-neck-pain.nvim") } })

vim.cmd.packadd("no-neck-pain.nvim")

require("no-neck-pain").setup({
	debug = false,
	width = 100,
	minSideBufferWidth = 10,
	disableOnLastBuffer = false,
	fallbackOnBufferDelete = true,
	autocmds = {
		enableOnVimEnter = false,
		enableOnTabEnter = false,
		reloadOnColorSchemeChange = false,
		skipEnteringNoNeckPainBuffer = false,
	},
	mappings = {
		enabled = false,
		toggle = "<Leader>np",
		toggleLeftSide = "<Leader>nql",
		toggleRightSide = "<Leader>nqr",
		widthUp = "<Leader>n=",
		widthDown = "<Leader>n-",
		scratchPad = "<Leader>ns",
	},
	callbacks = {
		preEnable = nil,
		postEnable = nil,
		preDisable = nil,
		postDisable = nil,
	},
	integrations = {
		NvimTree = { position = "left", reopen = true },
		NeoTree = { position = "left", reopen = true },
		undotree = { position = "left" },
		neotest = { position = "right", reopen = true },
		NvimDAPUI = { position = "none", reopen = true },
		outline = { position = "right", reopen = true },
		aerial = { position = "right", reopen = true },
		dashboard = { enabled = false, filetypes = nil },
	},
})
