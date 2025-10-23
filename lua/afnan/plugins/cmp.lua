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
			-- local compare = cmp.config.compare

			local kind = {
				Text = "  ",
				Method = "  ",
				Function = " 󰊕 ",
				Constructor = "  ",
				Field = "  ",
				Variable = "[]",
				Class = " פּ ",
				Interface = "  ",
				Module = " 󱒌 ",
				Property = "  ",
				Unit = "  ",
				Value = "  ",
				Enum = "  ",
				Keyword = "  ",
				Snippet = "  ",
				Color = "  ",
				File = "  ",
				Reference = "  ",
				Folder = "  ",
				EnumMember = "  ",
				Constant = "  ",
				Struct = "  ",
				Event = "  ",
				Operator = "  ",
				TypeParameter = "  ",
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
				{ name = "vim-dadbod-completion" },
				{ name = "devicons" },
				{ name = "path" },
				{ name = "luasnip", max_item_count = 2 },
				{ name = "nvim_lsp" },
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

			local lspkind_comparator = function(conf)
				local lsp_types = require("cmp.types").lsp
				return function(entry1, entry2)
					if entry1.source.name ~= "nvim_lsp" then
						if entry2.source.name == "nvim_lsp" then
							return false
						else
							return nil
						end
					end
					local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
					local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
					if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
						kind1 = "Parameter"
					end
					if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
						kind2 = "Parameter"
					end

					local priority1 = conf.kind_priority[kind1] or 0
					local priority2 = conf.kind_priority[kind2] or 0
					if priority1 == priority2 then
						return nil
					end
					return priority2 < priority1
				end
			end

			local label_comparator = function(entry1, entry2)
				return entry1.completion_item.label < entry2.completion_item.label
			end

			vim.api.nvim_create_user_command("CmpDevicons", DeviconsCompletion, {})

			vim.opt.pumheight = 9
			vim.o.pumblend = 20

			cmp.setup({
				view = { entries = { name = "custom", selection_order = "near_cursor" } },
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
						cmp.config.compare.score,
						cmp.config.compare.sort_text,
						lspkind_comparator({
							kind_priority = {
								Parameter = 14,
								Variable = 12,
								Field = 11,
								Property = 11,
								Constant = 10,
								Enum = 10,
								EnumMember = 10,
								Event = 10,
								Function = 10,
								Method = 10,
								Operator = 10,
								Reference = 10,
								Struct = 10,
								File = 8,
								Folder = 8,
								Class = 5,
								Color = 5,
								Module = 5,
								Keyword = 2,
								Constructor = 1,
								Interface = 1,
								Snippet = 0,
								Text = 1,
								TypeParameter = 1,
								Unit = 1,
								Value = 1,
							},
						}),
						label_comparator,
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
	-- init.lua or plugin/blink-cmp.lua
	--[[ {
      -- in your plugins.lua
      "Saghen/blink.cmp", -- the core engine
      version = "*",  -- pin or use latest
      opts = {
         snippets = { preset = "luasnip" },
         providers = {
            { name = "snippets" }, -- LuaSnip & friendly-snippets
            { name = "lsp" }, -- LSP suggestions
            { name = "buffer" }, -- buffer words
            { name = "path" }, -- filesystem paths
         },
         keymap = {
            preset = "none", -- disable blink’s default mappings
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-Space>"] = { "show" },
            ["<C-e>"] = { "cancel" },
            ["<CR>"] = { "select_and_accept" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
         },

         window = {
            border = "rounded",
            winhighlight = "Pmenu:Normal,CursorLine:PmenuSel",
         },
         cmdline = { enabled = true },

         fuzzy = {
            enabled = true,
            proximity_bonus = true,
            frecency = true,
         },
      },
      dependencies = {
         "neovim/nvim-lspconfig", -- for LSP source
         "L3MON4D3/LuaSnip", -- for snippet support
         "rafamadriz/friendly-snippets",
      },
      config = function()
         local blink = require("blink-cmp")
         local ls = require("luasnip")

         blink.setup()
      end,
   }, ]]
}
