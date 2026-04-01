local gh = require("afnan.pack").gh

vim.pack.add({ { src = gh("b0o/schemastore.nvim") } })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("emmet_language_server")

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=never",
	},
	single_file_support = true,
	filetypes = { "c", "cpp" },
})
vim.lsp.enable("clangd")
vim.lsp.enable("copilot")

-- Special Thanks to https://www.reddit.com/user/jimdimi for sharing this snippet
-- This is the full link to the snippet https://www.reddit.com/r/neovim/comments/1g1x0v3/hacking_native_snippets_into_lsp_for_builtin/

-- Language server for snippets
local sn_group = vim.api.nvim_create_augroup("SnippetServer", { clear = true })
local snippets = require("afnan.lsp.snippets")

-- Variable to track the last active LSP client ID
local last_client_id = nil
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = sn_group,
	callback = function()
		-- Stop the previous LSP client if it exists
		if last_client_id then
			local client = vim.lsp.get_client_by_id(last_client_id)
			if client then
				client:stop()
			end

			last_client_id = nil
		end
		-- Delay to ensure the previous server has fully stopped before starting a new one
		vim.defer_fn(function()
			-- paths table
			local pkg_path_fr = vim.fn.stdpath("data")
				.. "/site/pack/core/opt/friendly-snippets/package.json"
			local paths = snippets.parse_pkg(pkg_path_fr, vim.bo.filetype)
			if not paths or #paths == 0 then
				return
			end

			-- Concat all the snippets from all the paths
			local all_snippets = { isIncomplete = false, items = {} }
			for _, snips_path in ipairs(paths) do
				local snips = snippets.read_file(snips_path)
				local lsp_snip = snippets.process_snippets(snips, "USR")
				if lsp_snip and lsp_snip.items then
					for _, snippet_item in ipairs(lsp_snip.items) do
						table.insert(all_snippets.items, snippet_item)
					end
				end
			end
			local client_id = snippets.start_mock_lsp(all_snippets)

			-- Store the new client ID for future buffer changes
			last_client_id = client_id
		end, 500)
	end,
	desc = "Handle LSP for buffer changes",
})
