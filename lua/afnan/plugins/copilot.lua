---@diagnostic disable: undefined-field
return {
	--[[ {
		"yetone/avante.nvim",
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false,
		opts = {
			instructions_file = "avante.md",
			provider = "copilot",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	}, ]]
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{
				"github/copilot.vim",
				config = function()
					vim.g.copilot_no_tab_map = true
					vim.g.copilot_hide_during_completion = true
					vim.g.copilot_proxy_strict_ssl = true
					vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
				end,
			},
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			system_prompt = "you are an inteligent and experienced ai agent, helping a programmer how to do work",
			model = "gpt-4.1",
			agent = "copilot",
			context = nil,
			sticky = nil,
			temperature = 0.1,
			headless = false,
			stream = nil,
			callback = nil,
			remember_as_sticky = true,
			window = {
				layout = "vertical",
				width = 0.5,
				height = 0.5,
				relative = "editor",
				border = "single",
				row = nil,
				col = nil,
				title = "Copilot Chat",
				footer = nil,
				zindex = 1,
			},
			show_help = true,
			highlight_selection = true,
			highlight_headers = true,
			references_display = "virtual",
			auto_follow_cursor = true,
			auto_insert_mode = false,
			insert_at_end = false,
			clear_chat_on_new_prompt = false,
			debug = false,
			log_level = "info",
			proxy = nil,
			allow_insecure = true,
			chat_autocomplete = true,
			log_path = vim.fn.stdpath("state") .. "/CopilotChat.log",
			history_path = vim.fn.stdpath("data") .. "/copilotchat_history",
			question_header = "# User ",
			answer_header = "# Copilot ",
			error_header = "# Error ",
			separator = "───",
			providers = {
				copilot = {},
				github_models = {},
				copilot_embeddings = {},
			},
			contexts = {
				buffer = {},
				buffers = {},
				file = {},
				files = {},
				git = {},
				url = {},
				register = {},
				quickfix = {},
				system = {},
			},
			prompts = {
				Explain = {
					prompt = "Provide a detailed explanation of the selected code, including its purpose, key functions, data flow, and any important programming concepts it demonstrates. Break down complex logic in simple terms.",
					system_prompt = "COPILOT_EXPLAIN",
				},
				Review = {
					prompt = "Perform a thorough code review. Evaluate: 1) Correctness, 2) Performance optimizations, 3) Error handling, 4) Readability, 5) Potential edge cases, 6) Security concerns. Suggest specific improvements with code examples.",
					system_prompt = "COPILOT_REVIEW",
				},
				Fix = {
					prompt = "Analyze this code for bugs, errors, edge cases, and implementation issues. Provide a corrected version with explanations for each fix. Include comments highlighting what changed and why.",
				},
				Optimize = {
					prompt = "Refactor this code for optimal performance and readability. Consider: 1) Time/space complexity, 2) Memory usage, 3) Algorithm selection, 4) Code structure. Provide before/after analysis with measurable improvements.",
				},
				Docs = {
					prompt = "Generate comprehensive documentation for this code including: 1) Function/class purpose, 2) Parameter descriptions with types and constraints, 3) Return values, 4) Usage examples, 5) Edge cases or limitations. Use appropriate documentation style for the language.",
				},
				Tests = {
					prompt = "Create thorough test cases for the selected code including: 1) Unit tests for individual functions, 2) Integration tests if applicable, 3) Edge case testing, 4) Performance benchmarks where relevant. Use appropriate testing framework for the language.",
				},
				Commit = {
					prompt = "Generate a commit message in Commitizen convention with a title under 50 characters and a wrapped description at 72 characters. The description should use bullet points starting with * and convey meaningful context about the change.",
					context = "git:staged",
				},
				Refactor = {
					prompt = "Refactor this code to improve maintainability without changing functionality. Focus on: 1) Reducing complexity, 2) Eliminating duplication, 3) Improving naming, 4) Applying design patterns where appropriate. Explain your refactoring decisions.",
				},
				Debug = {
					prompt = "Help debug this code. Identify potential issues, suggest troubleshooting approaches, and provide fixes. Walk through the execution flow highlighting problematic areas and explaining debugging techniques.",
				},
				Security = {
					prompt = "Audit this code for security vulnerabilities. Identify risks related to: 1) Input validation, 2) Authentication/authorization, 3) Data protection, 4) Common attack vectors. Provide secure alternatives with code examples.",
				},
				TypeHints = {
					prompt = "Add comprehensive type annotations/hints to this code. Include proper typing for parameters, return values, variables, and generics where applicable. Explain type decisions that enhance code safety and clarity.",
				},
				Neovim = {
					prompt = "Hey i am a beginner to neovim and want to contribute to neovim and i am stuck at this point can you elaborate this for me. Provide a detailed explanation of the selected code, including its purpose, key functions, data flow, and any important programming concepts it demonstrates. Break down complex logic in simple terms.",
				},
			},
			mappings = {
				complete = { insert = "<C-Tab>" },
				close = { normal = "q", insert = "<C-c>" },
				reset = { normal = "<C-l>", insert = "<C-l>" },
				submit_prompt = { normal = "<CR>", insert = "<CR>" },
				toggle_sticky = { normal = "grr" },
				clear_stickies = { normal = "grx" },
				accept_diff = { normal = "<C-y>", insert = "<C-y>" },
				jump_to_diff = { normal = "gj" },
				quickfix_answers = { normal = "gqa" },
				quickfix_diffs = { normal = "gqd" },
				yank_diff = { normal = "gy", register = "\"" },
				show_diff = { normal = "gd", full_diff = false },
				show_info = { normal = "gi" },
				show_context = { normal = "gc" },
				show_help = { normal = "gh" },
			},
		},
	},
}
