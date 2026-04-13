local gh = require("afnan.pack").gh

vim.pack.add({
	{ src = gh("lewis6991/gitsigns.nvim") },
	{ src = gh("esmuellert/codediff.nvim") },
	{ src = gh("NeogitOrg/neogit") },
	{ src = gh("nvim-lua/plenary.nvim") },
	{ src = gh("folke/snacks.nvim") },
})

local function in_git_repo()
	local result = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
	return vim.v.shell_error == 0 and result:match("true")
end

if in_git_repo() then
	vim.cmd.packadd("vim-fugitive")
	vim.cmd.packadd("gitsigns.nvim")

	vim.api.nvim_create_autocmd("CmdUndefined", {
		pattern = { "Neogit*" },
		callback = function()
			vim.print("Loading Neogit and its dependencies...")
			vim.cmd.packadd("Neogit")
			vim.cmd.packadd("plenary.nvim")
			vim.cmd.packadd("snacks.nvim")
		end,
		once = true,
	})

	vim.keymap.set("n", ",gg", "<cmd>Neogit<cr>", { desc = "Show Neogit UI" })
	vim.keymap.set("n", ",gv", "<cmd>Neogit kind=vsplit<cr>", { desc = "Show Neogit UI in vsplit" })

	require("gitsigns").setup({
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged_enable = true,
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = { follow_files = true },
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
			use_focus = true,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		max_file_length = 40000,
		preview_config = {
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	})
end
