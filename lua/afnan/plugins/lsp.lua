return {
	{
		"neovim/nvim-lspconfig",
		ft = { "lua", "markdown", "json", "c", "cpp" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
			{
				"folke/trouble.nvim",
				opts = {},
				cmd = "Trouble",
			},
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "luvit-meta/library", words = { "vim%.uv" } },
					},
				},
			},
			{ "Bilal2453/luvit-meta", lazy = true },
			{ "bfredl/nvim-luadev", ft = { "lua" }, cmd = { "Luadev" } },
			{
				"ravibrock/spellwarn.nvim",
				event = "VeryLazy",
				config = function()
					require("spellwarn").setup({
						event = {
							"CursorHold",
							"InsertLeave",
							"TextChanged",
							"TextChangedI",
							"TextChangedP",
						},
						enable = true,
						ft_config = {
							alpha = false,
							help = false,
							lazy = false,
							lspinfo = false,
							mason = false,
						},
						ft_default = true,
						max_file_size = nil,
						severity = {
							spellbad = "WARN",
							spellcap = "HINT",
							spelllocal = "HINT",
							spellrare = "INFO",
						},
						prefix = "Possible Misspelling(s): ",
						diagnostic_opts = {
							severity_sort = true,
							signs = false,
							virtual_text = false,
							update_in_insert = true,
							underline = true,
						},
					})
				end,
			},
			-- { mizio/typescript-tools.nvim" },
			-- {
			--    "mfussenegger/nvim-jdtls",
			--    ft = { "java" },
			--    config = function()
			--       require("jdtls").start_or_attach({
			--          cmd = { "/data/data/com.termux/files/home/jdtls/start.sh" },
			--          root_dir = require("jdtls.setup").find_root({ ".git" }),
			--          filetypes = { "java" },
			--       })
			--    end,
			-- },
		},
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local lspconfig = require("lspconfig")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			local function on_attach(client, bufnr)
				local function set_keymap(mode, lhs, rhs)
					vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { silent = true, noremap = true })
				end

				set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>")
				set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
				set_keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
				set_keymap("n", "gI", ":lua vim.lsp.buf.implementation()<CR>")
				set_keymap("n", "gk", ":lua vim.diagnostic.goto_next()<CR>")
				set_keymap("n", "gj", ":lua vim.diagnostic.goto_prev()<CR>")
				set_keymap("n", "gR", ":lua vim.lsp.buf.references()<CR>")
				set_keymap("n", "gr", ":lua vim.lsp.buf.rename()<CR>")
				set_keymap("n", "ga", ":lua vim.lsp.buf.code_action()<CR>")
				set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
				set_keymap("n", "gs", ":SymbolsOutline<CR>")
				print("Language Server: " .. client.name .. " is started!")

				local inlay_hints_group =
					vim.api.nvim_create_augroup("LSP_inlayHints", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = inlay_hints_group,
					desc = "Update inlay hints on line change",
					buffer = bufnr,
					callback = function()
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end,
				})
			end

			-- JAVASCRIPT
			-- lspconfig.tsserver.setup({
			--    on_attach = on_attach,
			--    capabilities = capabilities,
			--    settings = {
			--       completions = {
			--          completeFunctionCalls = true,
			--       },
			--    },
			--    init_options = {
			--       preferences = {
			--          includeCompletionsWithSnippetText = true,
			--          includeCompletionsForImportStatements = true,
			--       },
			--    },
			--    single_file_support = true,
			-- })

			-- JSON
			lspconfig.jsonls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				init_options = { provideFormatter = false },
				single_file_support = true,
				settings = {
					json = { schemas = require("schemastore").json.schemas() },
				},
			})

			-- HTML & CSS
			-- lspconfig.cssls.setup({
			--    on_attach = on_attach,
			--    capabilities = capabilities,
			-- })
			-- lspconfig.html.setup({
			--    on_attach = on_attach,
			--    capabilities = capabilities,
			-- })

			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")

			-- Lua
			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "io", "it", "describe", "before_each", "self" },
							disable = { "trailing-space", "deprecated", "lowercase-global" },
						},
						runtime = { version = "LuaJIT", path = runtime_path },
						workspace = {
							checkTHirdParty = false,
							--[[  vim.api.nvim_get_runtime_file("", true) ]]
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,

								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
					completion = {
						showWord = "Disable",
						callSnippet = "Replace",
					},
					IntelliSense = {
						traceBeSetted = true,
						traceFieldInject = true,
						traceLocalSet = true,
						traceReturn = true,
					},
					hint = {
						enable = true,
					},
					hover = {
						enable = true,
						enumsLimit = 5,
						previewFields = 20,
						viewNumber = true,
						viewString = true,
						viewStringMax = 1000,
					},
					misc = { parameters = { "self" } },
					semantic = {
						annotation = true,
						enable = true,
						keyword = true,
						variable = true,
					},
					window = { progressBar = true, statusBar = true },
					codeLens = { enable = true },
					-- telemetry = { enable = true },
				},
			})

			-- Emmet
			-- lspconfig.emmet_language_server.setup({
			--    on_attach = on_attach,
			--    capabilities = capabilities,
			--    filetypes = { "css", "html", "jsx", "tsx", "javascript", "javascriptreact" },
			-- })

			-- CLANGD
			lspconfig.clangd.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				-- cmd = { "/data/data/com.termux/files/home/jdtls/start.sh" },
				autostart = true,
			})

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
					if result == nil or vim.tbl_isempty(result) then
						local _ = log.info() and log.info(ctx.method, "No location found")
						return nil
					end

					if split_cmd then
						vim.cmd(split_cmd)
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

			--Inlay Hints
			-- local methods = vim.lsp.protocol.Methods
			-- local inlay_hint_handler = vim.lsp.handlers[methods["textDocument_inlayHint"]]
			-- vim.lsp.handlers[methods["textDocument_inlayHint"]] = function(err, result, ctx, config)
			--    local client = vim.lsp.get_client_by_id(ctx.client_id)
			--    if client then
			--       local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			--       result = vim.iter(result)
			--           :filter(function(hint)
			--              return hint.position.line + 1 == row
			--           end)
			--           :totable()
			--    end
			--    inlay_hint_handler(err, result, ctx, config)
			-- end
		end,
	},
}
