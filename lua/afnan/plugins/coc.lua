return {
	{
		"neoclide/coc.nvim",
		branch = "release",
		ft = { "html", "css", "javascript", "javascriptreact" },
		config = function()
			function _G.show_docs()
				if vim.fn.CocAction("hasProvider", "hover") then
					vim.fn.CocActionAsync("definitionHover")
				else
					vim.fn.feedkeys("K", "in")
				end
			end

			local function set_keymap(mode, lhs, rhs)
				vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true })
			end

			set_keymap("n", "gj", "<Plug>(coc-diagnostic-prev)")
			set_keymap("n", "gk", "<Plug>(coc-diagnostic-next)")
			set_keymap("n", "gd", "<Plug>(coc-definition)")
			set_keymap("n", "gy", "<Plug>(coc-type-definition)")
			set_keymap("n", "gI", "<Plug>(coc-implementation)")
			set_keymap("n", "gR", "<Plug>(coc-references)")
			set_keymap("n", "K", "<CMD>lua _G.show_docs()<CR>")
			set_keymap("n", "gr", "<Plug>(coc-rename)")
			set_keymap("n", "gf", "<Plug>(coc-format-selected)")
			set_keymap("n", "gac", "<Plug>(coc-codeaction-cursor)")
			set_keymap("n", "gaf", "<Plug>(coc-codeaction-source)")
			set_keymap("n", "qf", "<Plug>(coc-fix-current)")

			vim.g.coc_snippet_next = "<tab>"
			vim.g.coc_snippet_prev = "<S-tab>"
			vim.o.pumblend = 20

			vim.api.nvim_create_augroup("CocGroup", {})
			vim.api.nvim_create_autocmd("CursorHold", {
				group = "CocGroup",
				command = "silent call CocActionAsync('highlight')",
				desc = "Highlight symbol under cursor on CursorHold",
			})
		end,
	},
}
