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
		},
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			local tsinstall = require("nvim-treesitter.install")
			treesitter.setup({
				auto_install = true,
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

			tsinstall.prefer_git = true
		end,
	},
}
