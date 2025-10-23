return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({ style = "storm" })
			vim.cmd("colorscheme tokyonight-night")
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { dark = "mocha" },
				transparent_background = true,
				show_end_of_buffer = false,
				term_colors = false,
				dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
				no_italic = false,
				no_bold = false,
				no_underline = false,
				styles = {
					comments = {},
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				default_integrations = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					noice = true,
					nvimtree = true,
					treesitter_context = true,
					which_key = true,
					treesitter = true,
					notify = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
							ok = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
							ok = { "underline" },
						},
						inlay_hints = { background = true },
					},
					mini = { enabled = true, indentscope_color = "" },
				},
			})
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd("colorscheme gruvbox")
		end,
		opts = { contrast = "hard" },
	},
}
