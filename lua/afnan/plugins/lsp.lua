return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
			{
				"gennaro-tedesco/nvim-jqx",
				event = { "BufReadPost" },
				ft = { "json", "yaml" },
			},
			-- TODO: Revisit eslint lsp when using with ts_ls
			--[[ {
				"esmuellert/nvim-eslint",
				config = function()
					require("nvim-eslint").setup({
						debug = false,
						filetypes = {
							"javascript",
							"javascriptreact",
							"javascript.jsx",
							"typescript",
							"typescriptreact",
							"typescript.tsx",
							"vue",
							"svelte",
							"astro",
						},
						handlers = {},
						settings = {
							validate = "on",
							packageManager = "npm",
							useESLintClass = true,
							experimental = { useFlatConfig = false },
							codeAction = {
								disableRuleComment = { enable = true, location = "separateLine" },
								showDocumentation = { enable = true },
							},
							codeActionOnSave = { mode = "all" },
							format = true,
							quiet = true,
							onIgnoredFiles = "off",
							options = {},
							rulesCustomizations = {},
							run = "onType",
							problems = { shortenToSingleLine = false },
							workingDirectory = { mode = "location" },
						},
					})
				end,
			}, ]]
		},
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local ts_ls_config = require("afnan.lsp-config.ts_ls")
			local lua_ls_config = require("afnan.lsp-config.lua_ls")
			local clangd_config = require("afnan.lsp-config.clangd")
			local pyright_config = require("afnan.lsp-config.pyright")
         local json_ls_config = require("afnan.lsp-config.json_ls")
         -- local emmet_ls_config = require("afnan.lsp-config.emmet")
			-- local lspconfig = require("lspconfig")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			lua_ls_config.setup()
			ts_ls_config.setup()
			clangd_config.setup()
			pyright_config.setup()
         json_ls_config.setup()
         -- emmet_ls_config.setup()
			-- vim.lsp.config("ts_ls", {
			-- 	-- on_attach = on_attach,
			-- 	-- capabilities = capabilities,
			-- 	settings = { completions = { completeFunctionCalls = true } },
			-- 	init_options = {
			-- 		preferences = {
			-- 			includeCompletionsWithSnippetText = true,
			-- 			includeCompletionsForImportStatements = true,
			-- 			includeCompletionsForModuleExports = true,
			-- 			includeCompletionsForObjectLiteralMethodSnippets = true,
			-- 			importModuleSpecifierEnding = "js",
			-- 			organizeImportsIgnoreCase = true,
			-- 			includeCompletionsForParameterSnippets = true,
			-- 			includeCompletionsForPropertySnippets = true,
			-- 			includeCompletionsWithInsertText = true,
			-- 			includeCompletionsForRenames = true,
			-- 			includeCompletionsForUnresolvedImports = true,
			-- 			quotePreference = "double",
			-- 		},
			-- 	},
			-- 	single_file_support = true,
			-- })

			-- lspconfig.pyright.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	settings = {
			-- 		python = {
			-- 			pythonPath = "./bin/python",
			-- 		},
			-- 	},
			-- })
			--
			-- -- JSON
			-- lspconfig.jsonls.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	init_options = { provideFormatter = false },
			-- 	single_file_support = true,
			-- 	settings = {
			-- 		json = { schemas = require("schemastore").json.schemas() },
			-- 	},
			-- })
			-- lspconfig.jdtls.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- })
			--
			-- -- HTML & CSS
			-- lspconfig.cssls.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- })
			-- lspconfig.html.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	init_options = {
			-- 		configurationSection = { "html", "css", "javascript" },
			-- 		embeddedLanguages = {
			-- 			css = true,
			-- 			javascript = true,
			-- 		},
			-- 	},
			-- })
			--
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- -- Lua
			-- lspconfig.lua_ls.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	settings = {
			-- 		Lua = {
			-- 			diagnostics = {
			-- 				globals = { "vim", "io", "it", "describe", "before_each", "self", "spy" },
			-- 				disable = { "trailing-space", "deprecated", "lowercase-global" },
			-- 			},
			-- 			runtime = {
			-- 				version = "LuaJIT",
			-- 				path = runtime_path,
			-- 			},
			-- 			workspace = {
			-- 				checkTHirdParty = false,
			-- 				library = library,
			-- 			},
			-- 		},
			-- 		completion = { showWord = "Disable", callSnippet = "Replace" },
			-- 		IntelliSense = {
			-- 			traceBeSetted = true,
			-- 			traceFieldInject = true,
			-- 			traceLocalSet = true,
			-- 			traceReturn = true,
			-- 		},
			-- 		hint = { enable = true },
			-- 		hover = {
			-- 			enable = true,
			-- 			enumsLimit = 5,
			-- 			previewFields = 20,
			-- 			viewNumber = true,
			-- 			viewString = true,
			-- 			viewStringMax = 1000,
			-- 		},
			-- 		misc = { parameters = { "self" } },
			-- 		semantic = { annotation = true, enable = true, keyword = true, variable = true },
			-- 		window = { progressBar = true, statusBar = true },
			-- 		codeLens = { enable = true },
			-- 		telemetry = { enable = false },
			-- 	},
			-- })
			--
			-- -- Emmet
			-- lspconfig.emmet_language_server.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	filetypes = { "css", "html", "jsx", "tsx", "javascriptreact" },
			-- })
			--
			-- -- bash/zsh
			-- lspconfig.bashls.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	filetypes = { "zsh", "sh", "bash" },
			-- 	settings = { bashIde = { globPattern = "*@(.sh|.zsh|.inc|.bash|.command)" } },
			-- })
			--
			local function prefix(diagnostic, i, total)
				local icon, highlight
				if diagnostic.severity == 1 then
					icon = ""
					highlight = "DiagnosticError"
				elseif diagnostic.severity == 2 then
					icon = ""
					highlight = "DiagnosticWarn"
				elseif diagnostic.severity == 3 then
					icon = ""
					highlight = "DiagnosticInfo"
				elseif diagnostic.severity == 4 then
					icon = ""
					highlight = "DiagnosticHint"
				end
				return i .. "/" .. total .. " " .. icon .. "  ", highlight
			end

			local function wrap_options(custom, handler)
				return function(opts)
					opts = opts and vim.tbl_extend(opts, custom) or custom
					if type(handler) == "string" then
						require("telescope.builtin")[handler](opts)
					else
						handler(opts)
					end
				end
			end

			-- Diagnostics Setup
			vim.diagnostic.config({
				signs = false,
				virtual_text = false,
				update_in_insert = true,
				underline = true,
				float = {
					focusable = false,
					border = "rounded",
					scope = "cursor",
					source = "if_many",
					header = { "Cursor Diagnostics: ", "DiagnosticInfo" },
					prefix = prefix,
				},
			})

			-- Hover
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			-- Signature Help
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, {
					border = "rounded",
				})

			-- Reference
			-- Reference: https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/lua/config/lsp/handlers.lua#L16
			vim.lsp.handlers["textDocument/references"] =
				wrap_options({ layout_strategy = "vertical" }, "lsp_references")

			-- Document Symbol
			-- Reference: https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/lua/config/lsp/handlers.lua#L20
			vim.lsp.handlers["textDocument/documentSymbol"] =
				require("telescope.builtin").lsp_document_symbols

			-- Definition
			local function goto_definition(split_cmd)
				local util = vim.lsp.util
				local log = require("vim.lsp.log")
				local api = vim.api

				local handler = function(_, result, ctx)
					local uri = result[1].targetUri
					local file = vim.fn.expand("%:t")
					local newUri = string.sub(uri, string.len(uri) - (string.len(file) - 1))

					if result == nil or vim.tbl_isempty(result) then
						local _ = log.info() and log.info(ctx.method, "No location found")
						return nil
					end

					if split_cmd then
						if file ~= newUri then
							vim.cmd(split_cmd)
						end
					end

					if vim.tbl_islist(result) then
						util.jump_to_location(result[1], "utf-8", true)

						if #result > 1 then
							vim.fn.setqflist(util.locations_to_items(result, "utf-8"))
							api.nvim_command("copen")
							api.nvim_command("wincmd p")
						end
					else
						util.jump_to_location(result, "utf-8", true)
					end
				end

				return handler
			end

			vim.lsp.handlers["textDocument/definition"] = goto_definition("vsplit")
		end,
	},

	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			server = { override = true, settings = {} },
			document_color = { enabled = true, kind = "inline", inline_symbol = "●", debounce = 200 },
			conceal = {
				enabled = false,
				min_length = nil,
				symbol = "",
				highlight = { fg = "#38BDF8" },
			},
			cmp = { highlight = "background" },
			telescope = { utilities = { callback = function(_, _) end } },
			extension = { queries = {}, patterns = {} },
		},
	},
}
