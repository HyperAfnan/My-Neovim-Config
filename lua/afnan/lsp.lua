local gh = require("afnan.pack").gh

vim.pack.add({
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("b0o/schemastore.nvim") },
})
vim.cmd.packadd("nvim-lspconfig")

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

local runtime_path = vim.split(package.path, ";")

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local library = {
	vim.fn.expand("$VIMRUNTIME/lua"),
	vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
}
if vim.fn.getcwd() == vim.fn.stdpath("config") then
	table.insert(library, vim.fn.stdpath("config") .. "/lua")
end

vim.lsp.config.lua_ls = {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end
	end,
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					"vim",
					"io",
					"it",
					"describe",
					"before_each",
					"self",
					"spy",
					"Snacks",
					"info",
				},
				disable = { "trailing-space", "deprecated", "lowercase-global" },
			},
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			workspace = {
				checkThirdParty = false,
				library = library,
			},
		},
		completion = { showWord = "Disable", callSnippet = "Replace" },
		IntelliSense = {
			traceBeSetted = true,
			traceFieldInject = true,
			traceLocalSet = true,
			traceReturn = true,
		},
		hint = { enable = true },
		hover = {
			enable = true,
			enumsLimit = 5,
			previewFields = 20,
			viewNumber = true,
			viewString = true,
			viewStringMax = 1000,
		},
		misc = { parameters = { "self" } },
		semantic = { annotation = true, enable = true, keyword = true, variable = true },
		window = { progressBar = true, statusBar = true },
		codeLens = { enable = true },
		telemetry = { enable = false },
	},
	filetypes = { "lua" },
}
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")

local schemastore = require("schemastore")

vim.lsp.config("jsonls", {
	filetypes = { "json", "jsonc" },
	init_options = { provideFormatter = false },
	single_file_support = true,
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
		},
	},
})

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
})
vim.lsp.enable("clangd")
