return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {},
		config = function()
			local wk = require("which-key")
			local mappings = {
				g = {
					name = "Gitsigns",
					h = {
						name = "Hunk",
						n = { ":Gitsigns next_hunk<CR>", "Next Hunk" },
						p = { ":Gitsigns prev_hunk<CR>", "Previous Hunk" },
						s = { ":Gitsigns stage_hunk<CR>", "Stage Hunk" },
						u = { ":Gitsigns undo_stage_hunk<CR>", "Unstage Hunk" },
						r = { ":Gitsigns reset_hunk<CR>", "Reset Hunk" },
					},
					b = {
						name = "Buffer",
						s = { ":Gitsigns stage_buffer<CR>", "Stage Buffer" },
						r = { ":Gitsigns reset_buffer<CR>", "Reset Buffer" },
					},
					p = { name = "Preview", h = { ":Gitsigns preview_hunk<CR>", "Preview Hunk" } },
				},
				t = {
					name = "Telescope",
					f = { ":Telescope find_files<CR>", "Find Files" },
					r = { ":Telescope live_grep<CR>", "Grep" },
					n = { ":lua require('github-notifications.menu').notifications()<CR>", "Github Notifications" },
					h = { ":Telescope help_tags<CR>", "Help tags" },
				},
			}

			local opts = { prefix = "", icons = { group = "➜" } }
			wk.register(mappings, opts)
		end,
	},
}
