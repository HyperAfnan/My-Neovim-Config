return {
	{
		"samharju/yeet.nvim",
		requires = { "stevearc/dressing.nvim" },
		cmd = "Yeet",
		config = function()
			require("yeet").setup({
				yeet_and_run = true,
				interrupt_before_yeet = false,
				clear_before_yeet = true,
				notify_on_success = false,
				warn_tmux_not_running = true,
				cache_window_opts = function()
					return {
						relative = "editor",
						row = (vim.o.lines - 15) * 0.5,
						col = (vim.o.columns - math.ceil(0.6 * vim.o.columns)) * 0.5,
						width = math.ceil(0.6 * vim.o.columns),
						height = 15,
						border = "none",
						title = "Yeet",
					}
				end,
			})
		end,
	},
	{
		"nvchad/showkeys",
		cmd = "ShowkeysToggle",
		opts = {
			timeout = 1,
			maxkeys = 4,
			winopts = { border = "none" },
			show_count = true,
			keyformat = {
				["<BS>"] = "<- ",
				["<CR>"] = "CR",
				["<Space>"] = "_",
				["<Up>"] = "Up",
				["<Down>"] = "Down",
				["<Left>"] = "Left",
				["<Right>"] = "Right",
				["<PageUp>"] = "Page Up",
				["<PageDown>"] = "Page Down",
				["<M>"] = "Alt",
				["<C>"] = "Ctrl",
			},
		},
	},
	--[[ {
      "m4xshen/hardtime.nvim",
      dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
      opts = {
         restricted_keys = {
            ["h"] = {},
            ["l"] = {},
            ["j"] = {},
            ["k"] = {},
            ['<Up>'] = { 'n', 'x', 'i', 'v' },
            ['<Down>'] = { 'n', 'x', 'i', 'v' },
            ['<Left>'] = { 'n', 'x', 'i', 'v' },
            ['<Right>'] = { 'n', 'x', 'i', 'v' },
         },
         disabled_keys = {
            ["<Up>"] = {},
            ["<Down>"] = {},
            ["<Left>"] = {},
            ["<Right>"] = {},
         },
      },
   }, ]]
	{
		"tris203/precognition.nvim",
		cmd = "Precognition",
		event = "VeryLazy",
		opts = {
			startVisible = false,
			showBlankVirtLine = false,
			highlightColor = { link = "Comment" },
			hints = {
				Caret = { text = "^", prio = 2 },
				Dollar = { text = "$", prio = 1 },
				MatchingPair = { text = "%", prio = 5 },
				Zero = { text = "0", prio = 1 },
				w = { text = "w", prio = 10 },
				b = { text = "b", prio = 9 },
				e = { text = "e", prio = 8 },
				W = { text = "W", prio = 7 },
				B = { text = "B", prio = 6 },
				E = { text = "E", prio = 5 },
			},
			gutterHints = {
				G = { text = "G", prio = 10 },
				gg = { text = "gg", prio = 9 },
				PrevParagraph = { text = "{", prio = 8 },
				NextParagraph = { text = "}", prio = 8 },
				line = { text = "", prio = 7 },
			},
			disabled_fts = {
				"startify",
			},
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"vim-test/vim-test",
		dependencies = { "preservim/vimux" },
		config = function()
			vim.cmd("let test#strategy = 'vimux'")
		end,
	},
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = true,
		opts = {
			prompt_func_return_type = {
				go = false,
				java = false,
				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
				javascript = true,
			},
			prompt_func_param_type = {
				go = false,
				java = false,
				javascript = true,
				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			printf_statements = {},
			print_var_statements = {},
			show_success_message = true,
		},
	},
	{
		"wakatime/vim-wakatime",
		lazy = false,
	},
}
