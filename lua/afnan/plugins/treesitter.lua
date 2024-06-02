return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{ "windwp/nvim-ts-autotag", ft = { "html", "javascript" } },
			{ "p00f/nvim-ts-rainbow" },
			{ "JoosepAlviste/nvim-ts-context-commentstring" },
		},
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			local tsinstall = require("nvim-treesitter.install")
			treesitter.setup({
				auto_install = true,
				highlight = { enable = true, additional_vim_regex_highlighting = false },
				indent = { enable = true, disable = "yaml" },
				rainbow = { enable = true, extended_mode = false },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				autopairs = { enable = true },
			})

			require("ts_context_commentstring").setup({})
			vim.g.skip_ts_context_commentstring_module = true

			tsinstall.prefer_git = true

			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = true,
				},
			})
		end,
	},
}
