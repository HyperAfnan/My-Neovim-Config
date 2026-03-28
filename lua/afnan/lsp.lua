local gh = require("afnan.pack").gh

vim.pack.add({ gh("neovim/nvim-lspconfig") })
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

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			diagnostics = {
				globals = { "vim", "io", "it", "describe", "before_each", "self", "spy" },
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
		})
	end,
	settings = {
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
   root_dir = function(fname)
      return vim.fs.root(fname, {
         ".luarc.json",
         ".luarc.jsonc",
         ".git",
      }) or vim.fn.getcwd()
   end,
	cmd = { "lua-language-server" },
}
vim.lsp.enable("lua_ls")

