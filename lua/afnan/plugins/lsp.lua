return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
			"kosayoda/nvim-lightbulb",
		},
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local lspconfig = require("lspconfig")
			local lightbulb = require("nvim-lightbulb")
         local border = { " ", " ", " ", " ", " ", " ", " ", " " }
			local capabilities = cmp_nvim_lsp.default_capabilities()

			local function on_attach(client, bufnr)
				if client.resolved_capabilities.document_highlight then
					vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
					vim.api.nvim_create_autocmd({
						callback = function()
							vim.lsp.buf.document_highlight()
						end,
						buffer = bufnr,
					}, "CursorHold")
					vim.api.nvim_create_autocmd({
						callback = function()
							vim.lsp.buf.clear_references()
						end,
						buffer = bufnr,
					}, "CursorMoved")
				end
			end
			lightbulb.setup({
				autocmd = { enabled = true },
				sign = { enable = false },
				float = { enable = true },
			})
			lspconfig.tsserver.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					completions = {
						completeFunctionCalls = true,
					},
				},
				init_options = {
					preferences = {
						includeCompletionsWithSnippetText = true,
						includeCompletionsForImportStatements = true,
					},
				},
				root_dir = function()
					return vim.loop.cwd()
				end,
				single_file_support = true,
			})

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
			lspconfig.cssls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					root_dir = function()
						return vim.loop.cwd()
					end,
				},
			})
			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "it", "describe", "before_each", "self" },
							disable = { "trailing-space", "deprecated", "lowercase-global" },
						},
						runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
					completion = {
						showWord = "Disable",
					},
					IntelliSense = {
						traceBeSetted = true,
						traceFieldInject = true,
						traceLocalSet = true,
						traceReturn = true,
					},
					hint = {
						arrayIndex = "Auto",
						enable = true,
						paramName = "All",
						paramType = true,
						setType = false,
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
					format = { enable = true },
				},
			})

			lspconfig.emmet_language_server.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					root_dir = function()
						return vim.loop.cwd()
					end,
				},
			})


local codes =  {
		no_matching_function = {
			message = " Can't find a matching function",
			"redundant-parameter",
			"ovl_no_viable_function_in_call",
		},
		empty_block = { message = " That shouldn't be empty here", "empty-block" },
		missing_symbol = {
			message = " Here should be a symbol",
			"miss-symbol",
		},
		expected_semi_colon = {
			message = " Remember the `;` or `,`",
			"expected_semi_declaration",
			"miss-sep-in-table",
			"invalid_token_after_toplevel_declarator",
		},
		redefinition = {
			message = " That variable was defined before",
			"redefinition",
			"redefined-local",
		},
		no_matching_variable = {
			message = " Can't find that variable",
			"undefined-global",
			"reportUndefinedVariable",
		},
		trailing_whitespace = {
			message = " Remove trailing whitespace",
			"trailing-whitespace",
			"trailing-space",
		},
		unused_variable = {
			message = " Don't define variables you don't use",
			"unused-local",
		},
		unused_function = {
			message = " Don't define functions you don't use",
			"unused-function",
		},
		useless_symbols = {
			message = " Remove that useless symbols",
			"unknown-symbol",
		},
		wrong_type = {
			message = " Try to use the correct types",
			"init_conversion_failed",
		},
		undeclared_variable = {
			message = " Have you delcared that variable somewhere?",
			"undeclared_var_use",
		},
		lowercase_global = {
			message = " Should that be a global? (if so make it uppercase)",
			"lowercase-global",
		},
	}

local function format(diagnostic)
		local code = diagnostic.user_data.lsp.code
		for _, table in pairs(codes) do
			if vim.tbl_contains(table, code) then
				return table.message
			end
		return diagnostic.message
	end
end
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
	update_in_insert = false,
	underline = true,
	float = {
		focusable = false,
		border = border,
		scope = "cursor",
		source = "if_many",
		 format = format,
		header = { "Cursor Diagnostics: ", "DiagnosticInfo" },
		pos = 1,
		prefix = prefix,
	},
})

-- Hover
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = border,
})

-- Signature Help
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = border,
})

-- Reference
-- Reference: https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/lua/config/lsp/handlers.lua#L16
vim.lsp.handlers["textDocument/references"] = wrap_options({ layout_strategy = "vertical" }, "lsp_references")

-- Document Symboll
-- Reference: https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/lua/config/lsp/handlers.lua#L20
vim.lsp.handlers["textDocument/documentSymbol"] = require("telescope.builtin").lsp_document_symbols

-- Defination
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
			util.jump_to_location(result[1])

			if #result > 1 then
				util.set_qflist(util.locations_to_items(result))
				api.nvim_command("copen")
				api.nvim_command("wincmd p")
			end
		else
			util.jump_to_location(result)
		end
	end

	return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition("split")
		end,
	},
}
