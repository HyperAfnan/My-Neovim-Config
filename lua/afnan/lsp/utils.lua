local M = {}

M.kind_icons = {
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
}

M.kind_map = {}
for i, name in ipairs(vim.lsp.protocol.CompletionItemKind) do
	M.kind_map[i] = M.kind_icons[name] or name
end

function M.prefix(diagnostic, i, total)
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
M.has_words_before = function()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	if col == 0 then
		return false
	end
	local line = vim.api.nvim_get_current_line()
	return line:sub(col, col):match("%s") == nil
end

local CompletionItemKind = vim.lsp.protocol.CompletionItemKind

M.kind_rank = {
	[CompletionItemKind.Method] = 1,
	[CompletionItemKind.Function] = 2,
	[CompletionItemKind.Constructor] = 3,
	[CompletionItemKind.Field] = 4,
	[CompletionItemKind.Property] = 5,
	[CompletionItemKind.Variable] = 6,
	[CompletionItemKind.Constant] = 7,
	[CompletionItemKind.Class] = 8,
	[CompletionItemKind.Interface] = 9,
	[CompletionItemKind.Struct] = 10,
	[CompletionItemKind.Enum] = 11,
	[CompletionItemKind.EnumMember] = 12,
	[CompletionItemKind.Module] = 13,
	[CompletionItemKind.Keyword] = 14,
	[CompletionItemKind.Snippet] = 15,
	[CompletionItemKind.File] = 16,
	[CompletionItemKind.Folder] = 17,
	[CompletionItemKind.Reference] = 18,
	[CompletionItemKind.Unit] = 19,
	[CompletionItemKind.Value] = 20,
	[CompletionItemKind.Color] = 21,
	[CompletionItemKind.Event] = 22,
	[CompletionItemKind.Operator] = 23,
	[CompletionItemKind.TypeParameter] = 24,
	[CompletionItemKind.Text] = 25,
}

function M.get_sort_key(item)
	local lsp_item = vim.tbl_get(item, "user_data", "nvim", "lsp", "completion_item") or {}
	return lsp_item.sortText or lsp_item.label or item.abbr or item.word or ""
end

function M.get_kind_rank(item)
	local kind = vim.tbl_get(item, "user_data", "nvim", "lsp", "completion_item", "kind")
	return M.kind_rank[kind] or 100
end

return M
