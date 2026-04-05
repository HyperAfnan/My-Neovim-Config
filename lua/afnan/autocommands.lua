-- Highlights selects on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Hides tmux statusline when in neovim
local tmux_group = vim.api.nvim_create_augroup("TmuxStatusControl", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	group = tmux_group,
	callback = function()
		if os.getenv("TMUX") then
			os.execute("tmux set status off")
		end
	end,
})

-- Restores tmux statuslie on leaving neovim
vim.api.nvim_create_autocmd("VimLeave", {
	group = tmux_group,
	callback = function()
		if os.getenv("TMUX") then
			os.execute("tmux set status on")
		end
	end,
})

-- Auto saves current file
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
	callback = function()
		if vim.bo.modified and vim.api.nvim_buf_get_name(0) ~= "" then
			vim.cmd("silent! write")
		end
	end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
	desc = "Open float when there is diagnostics",
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, "\"")
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		if vim.fn.mode() == "n" then
			local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break
				end
			end

			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- goto next/prev diagnostic with gk/gj when lsp is attached
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
	callback = function()
		vim.keymap.set("n", "gk", function()
			vim.diagnostic.jump({ count = 1 })
		end)
		vim.keymap.set("n", "gj", function()
			vim.diagnostic.jump({ count = -1 })
		end)
	end,
})

-- lazyload cloak.nvim when opening a .env file
vim.api.nvim_create_autocmd("BufRead", {
	callback = function()
		require("afnan.cloak")
	end,
})
--
-- vim.api.nvim_create_autocmd("LspProgress", {
-- 	buffer = vim.api.nvim_get_current_buf(),
-- 	callback = function(ev)
-- 		local value = ev.data.params.value
-- 		vim.api.nvim_echo({ { value.message or "done" } }, false, {
-- 			id = "lsp." .. ev.data.client_id,
-- 			kind = "progress",
-- 			source = "vim.lsp",
-- 			title = value.title,
-- 			status = value.kind ~= "end" and "running" or "success",
-- 			percent = value.percentage,
-- 		})
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("LspProgress", {
--     callback = function(ev)
--         local value = ev.data.params.value or {}
--         if not value.kind then return end
--
--         local status = value.kind == "end" and 0 or 1
--         local percent = value.percentage or 0
--
--         local osc_seq = string.format("\27]9;4;%d;%d\a", status, percent)
--
--         if os.getenv("TMUX") then
--             osc_seq = string.format("\27Ptmux;\27%s\27\\", osc_seq)
--         end
--
--         io.stdout:write(osc_seq)
--         io.stdout:flush()
--     end,
-- })
--
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local value = ev.data.params.value or {}
		local msg = value.message or "done"

		-- rust analyszer in particular has really long LSP messages so truncate them
		if #msg > 40 then
			msg = msg:sub(1, 37) .. "..."
		end

		-- :h LspProgress
		vim.api.nvim_echo({ { value.title or value.message or "LSP" } }, false, {
			id = "lsp",
			kind = "progress",
			title = value.title,
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
			source = "lua_ls",
		})

		-- vim.api.nvim_echo({ { value.title or value.message or "LSP" } }, false, {
		--      id = "lsp_progress",
		--      kind = "progress", -- This 'kind' is key for Ghostty integration
		--    })
	end,
})
