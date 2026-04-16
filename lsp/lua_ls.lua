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

return {
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
		completion = {
			showWord = "Disable",
			displayContext = 0,
			callSnippet = "Replace",
		},
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
	cmd = { "lua-language-server" },
}
