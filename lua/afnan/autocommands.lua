-- Highlights selects on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- -- Hides tmux statusline when in neovim
-- local tmux_group = vim.api.nvim_create_augroup("TmuxStatusControl", { clear = true })
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	group = tmux_group,
-- 	callback = function()
-- 		if os.getenv("TMUX") then
-- 			os.execute("tmux set status off")
-- 		end
-- 	end,
-- })
--
-- -- Restores tmux statuslie on leaving neovim
-- vim.api.nvim_create_autocmd("VimLeave", {
-- 	group = tmux_group,
-- 	callback = function()
-- 		if os.getenv("TMUX") then
-- 			os.execute("tmux set status on")
-- 		end
-- 	end,
-- })

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

-- -- shows LSP progress in the command line (and also integrates with Ghostty)
-- vim.api.nvim_create_autocmd("LspProgress", {
-- 	callback = function(ev)
-- 		local value = ev.data.params.value or {}
-- 		local msg = value.message or "done"
--
-- 		if #msg > 40 then
-- 			msg = msg:sub(1, 37) .. "..."
-- 		end
--
-- 		vim.api.nvim_echo({ { value.title or value.message or "LSP" } }, false, {
-- 			id = "lsp",
-- 			kind = "progress",
-- 			title = value.title,
-- 			status = value.kind ~= "end" and "running" or "success",
-- 			percent = value.percentage,
-- 			source = "lua_ls",
-- 		})
-- 	end,
-- })

-- sets custom statusline on various events to ensure it updates correctly
-- vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "VimEnter", "ColorScheme" }, {
--	callback = function()
-- vim.opt.statusline = "%!v:lua.require('afnan.statusline').MyStatusLine()"
--	end,
-- })

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
