return {
	{
		"folke/todo-comments.nvim",
		-- cmd = "TodoTelescope",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost" },
		opts = {

			signs = false,
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
			-- gui_style = {
			-- 	fg = "NONE", -- The gui style to use for the fg highlight group.
			-- 	bg = "BOLD", -- The gui style to use for the bg highlight group.
			-- },
			-- merge_keywords = true, -- when true, custom keywords will be merged with the defaults
			-- highlight = {
			-- 	multiline = true, -- enable multine todo comments
			-- 	multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
			-- 	multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
			-- 	before = "", -- "fg" or "bg" or empty
			-- 	keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
			-- 	after = "fg", -- "fg" or "bg" or empty
			-- 	pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
			-- 	comments_only = true, -- uses treesitter to match keywords in comments only
			-- 	max_line_len = 400,
			-- 	exclude = {},
			-- },
			-- colors = {
			-- 	error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
			-- 	warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
			-- 	info = { "DiagnosticInfo", "#2563EB" },
			-- 	hint = { "DiagnosticHint", "#10B981" },
			-- 	default = { "Identifier", "#7C3AED" },
			-- 	test = { "Identifier", "#FF00FF" },
			-- },
			-- search = {
			-- 	command = "rg",
			-- 	args = {
			-- 		"--color=never",
			-- 		"--no-heading",
			-- 		"--with-filename",
			-- 		"--line-number",
			-- 		"--column",
			-- 	},
			-- 	pattern = [[\b(KEYWORDS):]], -- ripgrep regex
			-- },
		},
	},
	{
		"atiladefreitas/dooing",
		config = function()
			require("dooing").setup({
				save_path = vim.fn.stdpath("data") .. "/dooing_todos.json",
				timestamp = {
					enabled = true,
				},
				window = {
					width = 55, -- Width of the floating window
					height = 20, -- Height of the floating window
					border = "rounded", -- Border style
					position = "center", -- Window position: 'right', 'left', 'top', 'bottom', 'center',
					padding = {
						top = 1,
						bottom = 1,
						left = 2,
						right = 2,
					},
				},
				formatting = {
					pending = {
						icon = "○",
						format = { "icon", "notes_icon", "text", "due_date", "ect" },
					},
					in_progress = { icon = "◐", format = { "icon", "text", "due_date", "ect" } },
					done = { icon = "✓", format = { "icon", "notes_icon", "text", "due_date", "ect" } },
				},
				quick_keys = true,
				notes = { icon = "📓" },
				scratchpad = { syntax_highlight = "markdown" },
				per_project = {
					enabled = true, -- Enable per-project todos
					default_filename = "dooing.json", -- Default filename for project todos
					auto_gitignore = false, -- Auto-add to .gitignore (true/false/"prompt")
					on_missing = "prompt", -- What to do when file missing ("prompt"/"auto_create")
					auto_open_project_todos = false, -- Auto-open project todos on startup if they exist
				},
				nested_tasks = {
					enabled = true, -- Enable nested subtasks
					indent = 2, -- Spaces per nesting level
					retain_structure_on_complete = true, -- Keep nested structure when completing tasks
					move_completed_to_end = true, -- Move completed nested tasks to end of parent group
				},
				keymaps = {
					toggle_window = "<leader>td", -- Toggle global todos
					open_project_todo = "<leader>tD", -- Toggle project-specific todos
					new_todo = "i",
					create_nested_task = "<leader>tn", -- Create nested subtask under current todo
					toggle_todo = "x",
					delete_todo = "d",
					delete_completed = "D",
					close_window = "q",
					undo_delete = "u",
					add_due_date = "H",
					remove_due_date = "r",
					toggle_help = "?",
					toggle_tags = "t",
					toggle_priority = "<Space>",
					clear_filter = "c",
					edit_todo = "e",
					edit_tag = "e",
					edit_priorities = "p",
					delete_tag = "d",
					search_todos = "/",
					add_time_estimation = "T",
					remove_time_estimation = "R",
					import_todos = "I",
					export_todos = "E",
					remove_duplicates = "<leader>D",
					open_todo_scratchpad = "<leader>p",
					refresh_todos = "f",
					share_todos = "s",
				},
				calendar = {
					language = "en",
					icon = "",
					keymaps = {
						previous_day = "h",
						next_day = "l",
						previous_week = "k",
						next_week = "j",
						previous_month = "H",
						next_month = "L",
						select_day = "<CR>",
						close_calendar = "q",
					},
				},
				priorities = { { name = "important", weight = 4 }, { name = "urgent", weight = 2 } },
				priority_groups = {
					high = {
						members = { "important", "urgent" },
						color = nil,
						hl_group = "DiagnosticError",
					},
					medium = { members = { "important" }, color = nil, hl_group = "DiagnosticWarn" },
					low = { members = { "urgent" }, color = nil, hl_group = "DiagnosticInfo" },
				},
				hour_score_value = 1 / 8,
				done_sort_by_completed_time = false,
			})
		end,
	},
}
