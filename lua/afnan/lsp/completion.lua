local utils = require("afnan.lsp.utils")
local gh = require("afnan.pack").gh

vim.pack.add({ gh("xzbdmw/colorful-menu.nvim") })
vim.cmd.packadd("colorful-menu.nvim")

local colorful = require("colorful-menu")

local completion_keys_group = vim.api.nvim_create_augroup("NativeCompletionKeys", { clear = false })
local completion_triggers_group = vim.api.nvim_create_augroup("NativeCompletionTriggers", { clear = false })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("EnableNativeCompletion", { clear = true }),
	desc = "Enable vim.lsp.completion and documentation",
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			vim.o.completeopt = "fuzzy,menuone,noselect,popup,preinsert,preview"
			vim.o.complete = ".,o"
			vim.o.pumheight = 15
			vim.o.pummaxwidth = 80
			vim.o.pumwidth = 30
			vim.o.pumborder = "single"

			-- vim.lsp.inline_completion.enable()

			vim.lsp.completion.enable(true, client.id, args.buf, {
				convert = function(item)
					local nchigh = colorful.native_completion_highlight(item, client)

					local abbr = item.label:gsub("%b()", ""):gsub("%b{}", ""):match("[%w_.]+.*")
						or item.label
					local menu = "[LSP]"

					return {
						abbr = abbr,
						abbr_hlgroup = nchigh.highlights,
						label = nchigh.label,
						menu = menu,
						kind = utils.kind_map[item.kind],
						kind_hlgroup = nchigh.highlights,
						--
						-- abbr = "abbr",
						-- label = "label",
						-- menu = "menu",
						-- kind = "kind",
						--
						--             abbr = utils.kind_map[item.kind],
						--             abbr_hlgroup = nchigh.highlights,
						--             kind = abbr,
						-- kind_hlgroup = nchigh.highlights,
						--             menu = menu,
						--             label = nchigh.label
					}
				end,

				autotrigger = client.name ~= "snippets_ls",
				cmp = function(a, b)
					local score_a = a._fuzzy_score or 0
					local score_b = b._fuzzy_score or 0
					if score_a ~= score_b then
						return score_a > score_b
					end

					local rank_a = utils.get_kind_rank(a)
					local rank_b = utils.get_kind_rank(b)
					if rank_a ~= rank_b then
						return rank_a < rank_b
					end

					return utils.get_sort_key(a) < utils.get_sort_key(b)
				end,
			})
			vim.bo[args.buf].autocomplete = vim.bo[args.buf].buftype == ""

			if not vim.b[args.buf].native_completion_keys then
				vim.b[args.buf].native_completion_keys = true

				vim.api.nvim_clear_autocmds({ group = completion_keys_group, buffer = args.buf })
				vim.api.nvim_clear_autocmds({ group = completion_triggers_group, buffer = args.buf })

				local function feed(keys)
					vim.api.nvim_feedkeys(vim.keycode(keys), "n", false)
				end

				vim.keymap.set({ "i", "s" }, "<Tab>", function()
					if vim.snippet and vim.snippet.active({ direction = 1 }) then
						vim.snippet.jump(1)
						return
					end
					if vim.fn.pumvisible() == 1 then
						feed("<C-n>")
						return
					end
					if utils.has_words_before() then
						feed("<C-n>")
					else
						feed("<Tab>")
					end
				end, { silent = true, buffer = args.buf })

				vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
					if vim.snippet and vim.snippet.active({ direction = -1 }) then
						vim.snippet.jump(-1)
						return
					end
					if vim.fn.pumvisible() == 1 then
						feed("<C-p>")
						return
					end
					if utils.has_words_before() then
						feed("<C-p>")
					else
						feed("<S-Tab>")
					end
				end, { silent = true, buffer = args.buf })

				vim.keymap.set("i", "<C-y>", function()
					if not vim.lsp.inline_completion.get() then
						return "<C-y>"
					end
				end, { expr = true, buffer = args.buf })

				vim.keymap.set("i", "<CR>", function()
					if vim.fn.pumvisible() ~= 1 then
						return "<CR>"
					end

					local info = vim.fn.complete_info({ "selected" })
					if info.selected == -1 then
						return "<C-n><C-y>"
					end
					return "<C-y>"
				end, { expr = true, silent = true, buffer = args.buf })

				-- Trigger path completion when "/" is entered (buffer-local).
				vim.api.nvim_create_autocmd("InsertCharPre", {
					group = completion_triggers_group,
					buffer = args.buf,
					callback = function()
						if vim.fn.pumvisible() == 1 then
							return
						end
						if vim.v.char == "/" then
							vim.api.nvim_feedkeys(vim.keycode("<C-X><C-F>"), "ni", false)
						end
					end,
				})
			end
		end
	end,
})

-- thanks https://www.reddit.com/user/i-eat-omelettes/ for this snippet
-- full snippet https://www.reddit.com/r/neovim/comments/1lkifhf/comment/mzt8agj

-- when typing too quickly and/or vim scanning too many words for completion
-- the completion trigger can fire again before previous completion has finished
-- and you get double-feeds of <C-N> or whatever which is bad
-- so we need this (ugly) lock variable to track if there's already a completion
-- in progress and kill attempts to do another completion if yes
-- a timer should be a less coarse solution but it works so touch it not
local group = vim.api.nvim_create_augroup("ins-autocomplete", {})
local complete_in_progress = false

vim.api.nvim_create_autocmd("InsertCharPre", {
	desc = "for tracking completion progress",
	group = group,
	callback = function(args)
		if
			complete_in_progress
			or vim.fn.pumvisible() ~= 0
			or vim.tbl_contains({ "terminal", "prompt", "help" }, vim.bo[args.buf].buftype)
		then
			return
		end
		complete_in_progress = true
	end,
})

-- with this approach (InsertCharPre) the input char won't show up
-- (e.g. TextChanged events won't be trigger) until candidates are found
-- therefore we can confidently say completion has finished upon text change
vim.api.nvim_create_autocmd({ "TextChangedP", "TextChangedI" }, {
	desc = "reset complete_in_progress lock",
	group = group,
	callback = function()
		complete_in_progress = false
	end,
})
