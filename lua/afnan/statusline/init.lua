local M = {}

vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })

vim.cmd.packadd("nvim-web-devicons")

local colors = {
	bg = "#0f1117",
	bg_dark = "#0b0d12",
	fg = "#c0caf5",

	blue = "#7aa2f7",
	green = "#9ece6a",
	purple = "#bb9af7",
	magenta = "#c678dd",
	orange = "#ff9e64",
	yellow = "#e0af68",
	red = "#f7768e",
	cyan = "#7dcfff",

	gitBg = "#1a1f2a",
	lspBg = "#1a1f2a",
	fileinfoBg = "#1a1f2a",

	replacecolor = "#f7768e",
}

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts or {})
end

local function hi()
	hl("SLNormal", { fg = colors.fg, bg = colors.bg })
	hl("SLDim", { fg = "#7a7f8a", bg = colors.bg })

	hl("SLGitIcon", { fg = colors.bg_dark, bg = colors.green, bold = true })
	hl("SLGitText", { fg = colors.fg, bg = colors.gitBg })
	hl("SLGitAdd", { fg = colors.green, bg = colors.gitBg })
	hl("SLGitMod", { fg = colors.yellow, bg = colors.gitBg })
	hl("SLGitDel", { fg = colors.red, bg = colors.gitBg })

	hl("SLLspIcon", { fg = colors.bg_dark, bg = colors.blue, bold = true })
	hl("SLLspText", { fg = colors.fg, bg = colors.lspBg })
	hl("SLLspErr", { fg = colors.red, bg = colors.lspBg })
	hl("SLLspWarn", { fg = colors.yellow, bg = colors.lspBg })
	hl("SLLspHint", { fg = colors.cyan, bg = colors.lspBg })
	hl("SLLspInfo", { fg = colors.blue, bg = colors.lspBg })

	hl("SLFileIcon", { fg = colors.bg_dark, bg = colors.orange, bold = true })
	hl("SLFileText", { fg = colors.fg, bg = colors.fileinfoBg })
end

local sep_cache = {}
local function sep_hl(fg, bg)
	local key = (fg or "nil") .. ":" .. (bg or "nil")
	if sep_cache[key] then
		return sep_cache[key]
	end
	local name = "SLSep_" .. key:gsub("[^%w]", "_")
	hl(name, { fg = fg, bg = bg })
	sep_cache[key] = name
	return name
end

local function mode_color(m)
	local mode_colors = {
		n = colors.blue,
		i = colors.green,
		v = colors.purple,
		V = colors.purple,
		[""] = colors.purple,
		c = colors.magenta,
		no = colors.blue,
		s = colors.orange,
		S = colors.orange,
		ic = colors.yellow,
		R = colors.red,
		Rv = colors.red,
		cv = colors.blue,
		ce = colors.blue,
		r = colors.replacecolor,
		rm = colors.replacecolor,
		["r?"] = colors.cyan,
		["!"] = colors.blue,
		t = colors.blue,
	}
	return mode_colors[m] or colors.blue
end

local function get_cursor_position()
	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	return string.format("%3d:%2d", line, col)
end

local function get_file_icon()
	if vim.o.ft == "" then
		print("ss")
		return ""
	else
		local icon, icon_hl = require("nvim-web-devicons").get_icon_by_filetype(vim.o.ft)
		return icon, icon_hl
	end
end

-- TODO: complete this git provider stuff after setting up gitsigns

-- -------------------------------------------------------------------------
-- MOCK Git provider (replace this with real git logic later)
-- -------------------------------------------------------------------------
local function in_git_workspace_mock()
	-- Real implementation would check if current file is inside a git repo.
	-- e.g. run `git rev-parse --is-inside-work-tree` (external command) or use libgit.
	return false
end

local function get_git_mock()
	-- This is the shape your statusline expects.
	-- Replace this function with a real provider when you decide to depend on git again.
	--
	-- Expected real data example:
	-- {
	--   branch = "main", -- string (current branch name)
	--   diff = { added = 3, modified = 1, removed = 0 } -- numbers for current buffer/project
	-- }
	return {
		branch = "mock-branch",
		diff = { added = 0, modified = 0, removed = 0 },
	}
end

-- TODO: complete this lsp stuff after adding lsp setup
-- -------------------------------------------------------------------------
-- LSP + Diagnostics (built-in, but we still keep "mock fallback" comments)
-- -------------------------------------------------------------------------
local function get_lsp_clients(bufnr)
	bufnr = bufnr or 0

	if vim.lsp and vim.lsp.get_active_clients then
		local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
		if not clients or vim.tbl_isempty(clients) then
			return {}
		end
		local names = {}
		for _, c in ipairs(clients) do
			table.insert(names, c.name)
		end
		return names
	end

	return {}
end

local function diag_counts(bufnr)
	bufnr = bufnr or 0
	if not vim.diagnostic then
		return { err = 0, warn = 0, hint = 0, info = 0 }
	end
	local err = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
	local warn = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
	local hint = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO })
	return { err = err, warn = warn, hint = hint, info = info }
end

-- -------------------------------------------------------------------------
-- Segment builders
-- -------------------------------------------------------------------------
local LEFT_BRACKET = " "
local RIGHT_BRACKET = " "

local function seg(text, group)
	return "%#" .. group .. "#" .. (text or "")
end

local function bracket_left(fg, bg)
	local g = sep_hl(fg, bg)
	return seg(LEFT_BRACKET, g)
end

local function bracket_right(fg, bg)
	local g = sep_hl(fg, bg)
	return seg(RIGHT_BRACKET, g)
end

local function build_mode_segment()
	local m = vim.fn.mode()
	local mc = mode_color(m)

	hl("SLModeBG", { fg = colors.bg_dark, bg = mc, bold = true })
	hl("SLModeSep", { fg = mc, bg = colors.bg })

	local icon = " 󰣇 "
	local out = {}
	table.insert(out, seg(icon, "SLModeBG"))
	table.insert(out, seg("", "SLModeSep"))
	return table.concat(out, "")
end

local function build_git_segment()
	if not in_git_workspace_mock() then
		return ""
	end

	local git = get_git_mock()

	table.insert({}, bracket_left(colors.green, colors.bg))
	table.insert({}, seg("  ", "SLGitIcon"))
	table.insert({}, bracket_right(colors.green, colors.gitBg))

	table.insert({}, seg((git.branch or ""), "SLGitText"))
	table.insert({}, seg(" ", "SLGitText"))

	local d = git.diff or { added = 0, modified = 0, removed = 0 }
	table.insert({}, seg(("  %d"):format(d.added or 0), "SLGitAdd"))
	table.insert({}, seg(("  %d"):format(d.modified or 0), "SLGitMod"))
	table.insert({}, seg(("  %d"):format(d.removed or 0), "SLGitDel"))

	table.insert({}, bracket_right(colors.gitBg, colors.bg))
	return table.concat({}, "")
end

local function build_lsp_segment()
	table.insert({}, bracket_left(colors.blue, colors.bg))
	table.insert({}, seg("", "SLLspIcon"))
	table.insert({}, bracket_right(colors.blue, colors.lspBg))

	local clients = get_lsp_clients(0)
	local client_text = "No Lsp"
	if #clients > 0 then
		client_text = table.concat(clients, ", ")
	end
	table.insert({}, seg(client_text, "SLLspText"))

	local d = diag_counts(0)
	table.insert({}, seg(("   %d"):format(d.err), "SLLspErr"))
	table.insert({}, seg(("   %d"):format(d.warn), "SLLspWarn"))
	table.insert({}, seg(("   %d"):format(d.hint), "SLLspHint"))
	table.insert({}, seg(("   %d"):format(d.info), "SLLspInfo"))

	table.insert({}, bracket_right(colors.lspBg, colors.bg))
	return table.concat({}, "")
end

local function build_right_fileinfo_segment()
	if vim.o.ft == "" then
		return ""
	end
	local out = {}
	table.insert(out, bracket_left(colors.orange, colors.bg))
	table.insert(out, seg((" %s "):format(get_file_icon()), "SLFileIcon"))
	table.insert(out, bracket_right(colors.orange, colors.fileinfoBg))

	table.insert(out, seg(get_cursor_position(), "SLFileText"))
	table.insert(out, bracket_right(colors.fileinfoBg, colors.bg))
	return table.concat(out, "")
end

function M.statusline()
	if not M._hi_done then
		hi()
		M._hi_done = true
	end

	local left = table.concat({
		build_mode_segment(),
		build_git_segment(),
		build_lsp_segment(),
	}, "")

	local right = build_right_fileinfo_segment()

	return table.concat({ seg(" ", "SLNormal"), left, "%=", right, seg(" ", "SLNormal") }, "")
end

vim.o.statusline = "%!v:lua.require('afnan.statusline.init').statusline()"

return M
