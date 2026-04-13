local gh = require("afnan.pack").gh
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "CopilotChat.nvim" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("CopilotChat.nvim")
			end
			io.popen(
				"cd "
					.. vim.fn.stdpath("data")
					.. "/site/pack/core/opt/CopilotChat.nvim && make tiktoken"
			)
		end
	end,
})

vim.pack.add({
	{ src = gh("nvim-lua/plenary.nvim") },
	{ src = gh("CopilotC-Nvim/CopilotChat.nvim") },
})

vim.cmd.packadd("plenary.nvim")
vim.cmd.packadd("CopilotChat.nvim")
