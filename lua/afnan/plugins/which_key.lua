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
			wk.add({
				{
					group = "Gitsigns",
					mode = "n",
					{
						group = "Hunk",
						mode = "n",
						{ ",ghn", ":Gitsigns next_hunk<CR>", desc = "Next Hunk" },
						{ ",ghp", ":Gitsigns prev_hunk<CR>", desc = "Previous Hunk" },
						{ ",ghs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
						{ ",ghu", ":Gitsigns undo_stage_hunk<CR>", desc = "Unstage Hunk" },
						{ ",ghr", ":Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
					},
					{
						group = "Buffer",
						mode = "n",
						{ ",gbs", ":Gitsigns stage_buffer<CR>", desc = "Stage Buffer" },
						{ ",gbr", ":Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
					},
				},
				{
					group = "Telescope",
					mode = "n",
					{ ",tf", ":Telescope find_files<CR>", desc = "Find Files" },
					{ ",tr", ":Telescope live_grep<CR>", desc = "Find Words" },
					{ ",th", ":Telescope help_tags<CR>", desc = "Find Help" },
					{
						",tn",
						function()
							require("github-notifications.menu").notifications()
						end,
						desc = "Find Github Notifications",
					},
					{ ",tu", ":Telescope resume<CR>", desc = "Resume Search" },
					{ ",tt", ":TodoTelescope<CR>", desc = "Todo List" },
					{ ",to", ":Telescope oldfiles<CR>", desc = "Previously Opened Files" },
					{ ",T", ":Telescope<CR>", desc = "Open Telescope" },
				},
				{
					group = "DAP",
				},
			})
		end,
	},
}
