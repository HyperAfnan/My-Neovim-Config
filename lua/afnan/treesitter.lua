local gh = require("afnan.pack").gh

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({ gh("nvim-treesitter/nvim-treesitter") })
vim.cmd.packadd("nvim-treesitter")

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
	ensure_installed = {
		"javascript",
		"javascriptreact",
		"typescript",
		"lua",
		"json",
		"vimdoc",
		"html",
		"css",
		"gitcommit",
		"markdown",
		"tsx",
		"yaml",
	},
	sync_install = false,
	auto_install = true,
	highlight = { enable = true, additional_vim_regex_highlighting = true },
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if vim.treesitter.language.add(lang) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.treesitter.start()
		end
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		require("nvim-treesitter").update()
	end,
})
