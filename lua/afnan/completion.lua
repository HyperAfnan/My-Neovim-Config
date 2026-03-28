local gh = require("afnan.pack").gh

vim.pack.add({ gh("rafamadriz/friendly-snippets") })
vim.pack.add({ gh("saghen/blink.cmp") })
vim.pack.add({ gh("onsails/lspkind.nvim") })

vim.cmd.packadd("friendly-snippets")
vim.cmd.packadd("blink.cmp")

local has_words_before = function()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	if col == 0 then
		return false
	end
	local line = vim.api.nvim_get_current_line()
	return line:sub(col, col):match("%s") == nil
end

vim.opt.pumheight = 9
vim.o.pumblend = 20

local ok, blink = pcall(require, "blink.cmp")
if ok then
	blink.setup({
		keymap = {
			preset = "none",
			["<Tab>"] = {
				function(cmp)
					if has_words_before() then
						return cmp.insert_next()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = { "insert_prev", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		},
		appearance = {
			highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
			kind_icons = {
				Text = "󰉿",
				Method = "󰊕",
				Function = "󰊕",
				Constructor = "󰒓",

				Field = "󰜢",
				Variable = "󰆦",
				Property = "󰖷",

				Class = "󱡠",
				Interface = "󱡠",
				Struct = "󱡠",
				Module = "󰅩",

				Unit = "󰪚",
				Value = "󰦨",
				Enum = "󰦨",
				EnumMember = "󰦨",

				Keyword = "󰻾",
				Constant = "󰏿",

				Snippet = "󱄽",
				Color = "󰏘",
				File = "󰈔",
				Reference = "󰬲",
				Folder = "󰉋",
				Event = "󱐋",
				Operator = "󰪚",
				TypeParameter = "󰬛",
			},
		},
		completion = {
			accept = { auto_brackets = { enabled = false } },
			menu = {
				border = "rounded",

				cmdline_position = function()
					if vim.g.ui_cmdline_pos ~= nil then
						local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
						return { pos[1] - 1, pos[2] }
					end
					local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
					return { vim.o.lines - height, 0 }
				end,

				draw = {
					columns = {
						{ "kind_icon", "label", gap = 1 },
						{ "kind" },
					},
					components = {
						kind_icon = {
							text = function(item)
								local kind = require("lspkind").symbol_map[item.kind] or ""
								return kind .. " "
							end,
							highlight = "CmpItemKind",
						},
						label = {
							text = function(item)
								return item.label
							end,
							highlight = "CmpItemAbbr",
						},
						kind = {
							text = function(item)
								return item.kind
							end,
							highlight = "CmpItemKind",
						},
					},
				},
				-- menu = {
				-- 	border = "single",
				-- 	draw = {
				-- 		treesitter = { "lsp" },
				-- 		components = {
				-- 			kind_icon = {
				-- 				text = function(ctx)
				-- 					local icon = ctx.kind_icon
				-- 					if vim.tbl_contains({ "Path" }, ctx.source_name) then
				-- 						local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
				-- 						if dev_icon then
				-- 							icon = dev_icon
				-- 						end
				-- 					end
				-- 					return icon .. ctx.icon_gap
				-- 				end,
				-- 				highlight = function(ctx)
				-- 					local hl = ctx.kind_hl
				-- 					if vim.tbl_contains({ "Path" }, ctx.source_name) then
				-- 						local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
				-- 						if dev_icon then
				-- 							hl = dev_hl
				-- 						end
				-- 					end
				-- 					return hl
				-- 				end,
				-- 			},
				-- 		},
				-- 	},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
				treesitter_highlighting = true,
				window = {
					border = "single",
				},
			},
		},

		signature = { window = { border = "single" } },

		sources = { default = { "lsp", "path", "snippets", "buffer" } },

		fuzzy = {
			implementation = "prefer_rust_with_warning",
			sorts = {
				function(a, b)
					if
						(a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name)
					then
						return
					end
					return b.client_name == "emmet_ls"
				end,
				"score",
				"sort_text",
			},
		},
	})
end
