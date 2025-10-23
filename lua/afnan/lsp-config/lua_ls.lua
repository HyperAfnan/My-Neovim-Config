local M = {}

local utils = require("afnan.lsp-config.utils")

M.setup = function()
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	local library = {
		vim.fn.expand("$VIMRUNTIME/lua"),
		vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
		vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
		vim.fn.stdpath("data") .. "/lazy/nvim-cmp",
	}
	if vim.fn.getcwd() == vim.fn.stdpath("config") then
		table.insert(library, vim.fn.stdpath("config") .. "/lua")
	end

	vim.lsp.config.luals = {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (
						vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")
					)
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
		on_attach = utils.on_attach,
		capabilities = utils.capabilities,
	}
	vim.lsp.enable("lua_ls")
end
return M
