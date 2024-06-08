---@diagnostic disable: param-type-mismatch
return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
			{ "nvim-tree/nvim-web-devicons" },
			{ "hrsh7th/cmp-cmdline" },
			{
				"KadoBOT/cmp-plugins",
				config = function()
					require("cmp-plugins").setup({
						files = { ".*\\.lua" },
					})
				end,
			},
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
				config = function()
					local ls = require("luasnip")
					local types = require("luasnip.util.types")

					ls.config.setup({
						history = true,
						updateevents = "TextChangedI",
						enable_autosnippets = true,
						ft_func = function()
							return vim.split(vim.bo.filetype, ".", true)
						end,
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
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			local cmp = require("cmp")
			local ls = require("luasnip")

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
				else
					return vim_item.kind
				end
			end

			local function kind_settings2(entry, vim_item)
				if entry.source.name == "plugins" then
					return ""
				else
					return kind[vim_item.kind]
				end
			end

			local borders = { " ", " ", " ", " ", " ", " ", " ", " " }

			local sources = {
				-- { name = "luasnip", max_item_count = 2 },
				{ name = "nvim_lsp", max_item_count = 4 },
				{ name = "nvim_lsp_signature_help" },
				{ name = "buffer", max_item_count = 2 },
				{ name = "path" },
				{ name = "devicons", priority = 500 },
			}

			if vim.o.ft == "lua" then
				table.insert(sources, { name = "nvim_lua" })
				table.insert(sources, { name = "plugins" })
			end

         if not vim.o.ft == "html" then
            table.insert(sources, { name = "luasnip"})
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

			vim.opt.pumheight = 8
			vim.o.pumblend = 20

			cmp.setup({
				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body)
					end,
				},

				window = {
					completion = { border = borders },
					documentation = { border = borders },
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if ls.expand_or_jumpable() then
							ls.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if ls.jumpable(-1) then
							ls.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						function(entry1, entry2)
							local _, entry1_under = entry1.completion_item.label:find("^_+")
							local _, entry2_under = entry2.completion_item.label:find("^_+")
							entry1_under = entry1_under or 0
							entry2_under = entry2_under or 0
							if entry1_under > entry2_under then
								return false
							elseif entry1_under < entry2_under then
								return true
							end
						end,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},

				formatting = {
					fields = { "abbr", "kind", "menu" },
					kind_icons = kind,
					format = function(entry, vim_item)
						vim_item.abbr = vim_item.abbr:sub(1, 30)
						vim_item.kind =
							string.format("%s %s", kind_settings1(entry, vim_item), kind_settings2(entry, vim_item))
						vim_item.dup = { buffer = 0, path = 0, nvim_lsp = 0, nvim_lua = 0 }
						return vim_item
					end,
				},
				sources = sources,
			})

			cmp.setup.cmdline({ "/", "?" }, {
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
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
