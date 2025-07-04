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
						{ ",ghk", ":Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
						{ ",ghK", ":Gitsigns preview_hunk_inline<CR>", desc = "Preview inline Hunk" },
					},
					{
						group = "Buffer",
						mode = "n",
						{ ",gbs", ":Gitsigns stage_buffer<CR>", desc = "Stage Buffer" },
						{ ",gbr", ":Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
					},
               {
						group = "Neotree",
						mode = "n",
						{ ",n", ":Neotree<CR>", desc = "Set Local list" },
					},
					{
						group = "Localist",
						mode = "n",
						{ ",gl", ":Gitsigns  setloclist<CR>", desc = "Set Local list" },
					},
					{
						group = "Copilot Commands",
						mode = "n",
						{ ",cd", ":Copilot disable<CR>", desc = "Disable Copilot Completion" },
						{ ",cp", ":Copilot panel<CR>", desc = "Open copilot panel" },
					},
					{
						group = "Git commands",
						mode = "n",
						{ ",ggC", ":CopilotChatCommit<CR>", desc = "Generate Commit Message" },
						{ ",gg.", ":Git add .<CR>", desc = "Stages all files" },
						{ ",ggc", ":Git commit<CR>", desc = "Commit staged files" },
						{ ",ggp", ":Git push<CR>", desc = "Push to origin" },
						{ ",ggP", ":Git push<CR>", desc = "Pull from origin" },
						{ ",ggo", ":!gh repo view -w<CR>", desc = "Open repo in browser" },
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
					{ ",tg", ":Telescope git_status<CR>", desc = "All changed files" },
					{ ",T", ":Telescope<CR>", desc = "Open Telescope" },
					{ ",ti", ":Telescope import<CR>", desc = "Import modules through telescope" },
					{ ",te", ":Telescope rest select_env<CR>", desc = "Select env for rest.nvim" },
				},
				{
					group = "Vim Test",
					mode = "n",
					{ ",vn", ":TestNearest<CR>", desc = "Test nearest" },
					{ ",vf", ":TestFile<CR>", desc = "Test file" },
					{ ",vs", ":TestSuite<CR>", desc = "Test suite" },
					{ ",vl", ":TestLast<CR>", desc = "Test last" },
					{ ",vv", ":TestVisit<CR>", desc = "Visit Test" },
				},
			})
		end,
	},
}
