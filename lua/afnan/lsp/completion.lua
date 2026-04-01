local utils = require("afnan.lsp.utils")
local gh = require("afnan.pack").gh

vim.pack.add({ gh("xzbdmw/colorful-menu.nvim") })
vim.cmd.packadd("colorful-menu.nvim")

local colorful = require("colorful-menu")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("EnableNativeCompletion", { clear = true }),
	desc = "Enable vim.lsp.completion and documentation",
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		vim.o.autocompletedelay = 10000
		if client:supports_method("textDocument/completion") then
			vim.o.completeopt = "fuzzy,menuone,noselect,popup"
			vim.o.complete = ".,o"
			vim.o.pumheight = 15
			vim.o.pummaxwidth = 80
			vim.o.pumwidth = 30
			vim.o.pumborder = "single"

			vim.lsp.inline_completion.enable()

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

				autotrigger = true,
				-- cmp = function(_, _) end
			})
			vim.bo.autocomplete = vim.bo.buftype == ""

			vim.keymap.set("i", "<Tab>", function()
				if utils.has_words_before() then
					return "<C-n>"
				else
					return "<Tab>"
				end
			end, { expr = true, silent = true })

			vim.keymap.set("i", "<C-y>", function()
				if not vim.lsp.inline_completion.get() then
					print("s")
					return "<C-y>"
				end
			end, { expr = true })

			vim.keymap.set("i", "<S-Tab>", function()
				if utils.has_words_before() then
					return "<C-p>"
				else
					return "<S-Tab>"
				end
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<CR>", function()
				if utils.has_words_before() then
					local item = vim.v.completed_item
					if item.word then
						return "<C-y>"
					else
						return "<C-n><C-y>"
					end
				else
					return "<CR>"
				end
			end, { expr = true, silent = true })

			-- ignore . and do not open menu
			vim.api.nvim_create_autocmd("InsertCharPre", {
				callback = function()
					if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
						return
					end
					if vim.v.char == "." or vim.v.char == " " then
						local key = vim.keycode("<c-x><c-o>")
						vim.api.nvim_feedkeys(key, "m", false)
					elseif vim.v.char == "/" then
						-- shows path completion when / is entered
						vim.api.nvim_feedkeys(vim.keycode("<C-X><C-F>"), "ni", false)
					end
				end,
			})
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

