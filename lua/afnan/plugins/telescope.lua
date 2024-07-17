return {

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		tag = "0.1.7",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local previewers = require("telescope.previewers")
			local load = telescope.load_extension

			telescope.setup({
				defaults = {
					prompt_prefix = "  ",
					show_line = false,
					selection_caret = " ",
					entry_prefix = "  ",
					initial_mode = "insert",
					prompt_title = false,
					results_title = false,
					preview_title = false,
					selection_strategy = "reset",
					sorting_strategy = "descending",
					layout_strategy = "vertical",
					layout_config = {
						horizontal = { mirror = false },
						vertical = { mirror = true },
					},
					file_ignore_patterns = { "__pycache__", "node_modules", ".git/*", ".cache", "storage", ".ssh" },
					border = {},
					borderchars = {
						preview = { " ", " ", " ", " ", " ", " ", " ", " " },
						prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
						results = { " ", " ", " ", " ", " ", " ", " ", " " },
					},
					color_devicons = true,
					use_less = true,
					path_display = {},
					set_env = { ["COLORTERM"] = "truecolor" },
					file_previewer = previewers.vim_buffer_cat.new,
					grep_previewer = previewers.vim_buffer_vimgrep.new,
					qflist_previewer = previewers.vim_buffer_qflist.new,
					buffer_previewer_maker = previewers.buffer_previewer_maker,
				},
				pickers = {
					find_files = {
						hidden = true,
						prompt_title = false,
						previewer = true,
						results_title = false,
						preview_title = false,
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "ignore_case",
					},
				},
			})
			load("fzf")
			load("ghn")
			-- load("noice")
		end,
	},
}
