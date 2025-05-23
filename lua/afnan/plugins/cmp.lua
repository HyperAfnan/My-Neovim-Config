---@diagnostic disable: undefined-field, redundant-parameter
--@diagnostic disable: param-type-mismatch
return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lua", ft = "lua" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "nvim-tree/nvim-web-devicons" },
			{
				"L3MON4D3/LuaSnip",
				event = "InsertEnter",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
				config = function()
					local ls = require("luasnip")
					local types = require("luasnip.util.types")

					ls.config.setup({
						history = true,
						updateevents = "TextChangedI",
						enable_autosnippets = true,
						ext_opts = {
							[types.choiceNode] = {
								active = {
									virt_text = { { "<-", "Error" } },
								},
							},
						},
					})

					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
		},
		config = function()
			local cmp = require("cmp")
			local ls = require("luasnip")
			local context = require("cmp.config.context")
			local compare = cmp.config.compare

			local kind = {
				Text = "  ",
				Method = "  ",
				Function = "  ",
				Constructor = "  ",
				Field = "  ",
				Variable = "[]",
				Class = " פּ ",
				Interface = " 蘒 ",
				Module = "  ",
				Property = "  ",
				Unit = "  ",
				Value = "  ",
				Enum = "  ",
				Keyword = "  ",
				Snippet = "  ",
				Color = "  ",
				File = "  ",
				Reference = "  ",
				Folder = "  ",
				EnumMember = "  ",
				Constant = "  ",
				Struct = "  ",
				Event = "  ",
				Operator = "  ",
				TypeParameter = "  ",
			}

			local function kind_settings1(entry, vim_item)
				if entry.source.name == "plugins" then
					return "Plugin"
				elseif vim.split(entry.source:get_debug_name(), ":")[2] == "emmet_language_server" then
					return "Emmet"
				else
					return vim_item.kind
				end
			end

			local function kind_settings2(entry, vim_item)
				if entry.source.name == "plugins" then
					return "  "
				elseif vim.split(entry.source:get_debug_name(), ":")[2] == "emmet_language_server" then
					return "  "
				else
					return kind[vim_item.kind]
				end
			end

			local sources = {
				{ name = "devicons" },
				{ name = "path" },
				{ name = "luasnip", max_item_count = 2 },
				{ name = "nvim_lsp", max_item_count = 6 },
				{ name = "buffer", max_item_count = 2 },
				{ name = "nvim_lsp_signature_help" },
			}

			if vim.o.ft == "lua" then
				table.insert(sources, { name = "nvim_lua" })
				table.insert(sources, { name = "plugins" })
			end

			if vim.o.ft == "html" then
				if context.in_treesitter_capture("attribute_value") then
					sources = {
						{ name = "nvim_lsp", max_item_count = 4 },
					}
				end
			end

			function DeviconsCompletion()
				local devicons = require("nvim-web-devicons")
				cmp.register_source("devicons", {

					complete = function(_, _, callback)
						local items = {}
						for _, icon in pairs(devicons.get_icons()) do
							table.insert(items, {
								label = icon.icon .. "  " .. icon.name,
								insertText = icon.icon,
								filterText = icon.name,
							})
						end
						callback({ items = items })
					end,
				})
			end

			vim.api.nvim_create_user_command("CmpDevicons", DeviconsCompletion, {})

			vim.opt.pumheight = 9
			vim.o.pumblend = 20

			cmp.setup({
				view = {
					entries = {
						name = "custom",
						selection_order = "near_cursor",
					},
				},
				completion = { completeopt = "menu,menuone,preview,noselect,fuzzy" },
				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body)
					end,
				},

				window = {
					documentation = {
						border = "rounded",
						winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
					},
					completion = {
						border = "rounded",
						winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
						scrollbar = true,
					},
					scrollbar = true,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if ls.expandable() then
								ls.expand()
							else
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif ls.locally_jumpable(1) then
							ls.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif ls.locally_jumpable(-1) then
							ls.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sorting = {
					comparators = {
						compare.offset,
						compare.exact,
						compare.scopes,
						compare.score,
						compare.recently_used,
						compare.locality,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
				},

				formatting = {
					fields = { "abbr", "kind", "menu" },
					kind_icons = kind,
					format = function(entry, vim_item)
						vim_item.abbr = vim_item.abbr:sub(1, 30)
						vim_item.kind = string.format(
							"%s %s",
							kind_settings1(entry, vim_item),
							kind_settings2(entry, vim_item)
						)
						vim_item.dup = { buffer = 0, path = 0, nvim_lsp = 0, nvim_lua = 0 }
						return vim_item
					end,
				},
				sources = sources,
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},
}
