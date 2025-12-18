---@diagnostic disable: undefined-field
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{
				"windwp/nvim-ts-autotag",
				config = function()
					require("nvim-ts-autotag").setup({
						opts = {
							enable_close = true,
							enable_rename = true,
							enable_close_on_slash = true,
						},
					})
				end,
				ft = { "html", "javascript" },
			},
			{ "JoosepAlviste/nvim-ts-context-commentstring", event = "VeryLazy" },
			{
				"nvim-treesitter/nvim-treesitter-context",
				event = "VeryLazy",
				config = function()
					vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "none" })
					require("treesitter-context").setup({
						enable = true,
						multiwindow = true,
						max_lines = 2,
						min_window_height = 0,
						line_numbers = true,
						multiline_threshold = 20,
						trim_scope = "outer",
						mode = "cursor",
						separator = nil,
						zindex = 20,
						on_attach = nil,
					})
				end,
			},
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
            ensure_installed = { "lua", "html", "css", "tsx", "latex", "javascript", "json" },
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 100 * 1024
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				-- rainbow = { enable = true, extended_mode = false },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<F1>",
						scope_incremental = "<CR>",
						node_decremental = "<F2>",
					},
				},
				autopairs = { enable = true },
			})

			require("ts_context_commentstring").setup({})
			vim.g.skip_ts_context_commentstring_module = true

			require("nvim-treesitter.install").prefer_git = true
		end,
	},
}
