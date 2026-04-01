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

return M
