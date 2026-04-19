local M = {}

local devicons = require("nvim-web-devicons")

function M.FileCondition()
	return vim.fn.expand("%:t") ~= ""
end

function M.GetCursorPostion()
	local line = vim.fn.line(".")
	local column = vim.fn.col(".")
	return string.format("%3d:%2d", line, column)
end

function M.GetCursorPercentage()
	return " :" .. math.floor(vim.fn.line(".") / vim.fn.line("$") * 100) .. "%"
end

function M.GetCurrentFileIcon()
	local icon = devicons.get_icon_by_filetype(vim.o.ft, {})
	if icon then
		return icon
	else
		return " "
	end
end
return M
