local M = {}

M.colors = {
	bg_dark = "#1a1b26",
	bg = "NONE",
	bg_highlight = "#292e42",
	terminal_black = "#414868",
	fg = "#c0caf5",
	fg_dark = "#a9b1d6",
	fg_gutter = "#3b4261",
	dark3 = "#545c7e",
	comment = "#565f89",
	dark5 = "#737aa2",
	blue0 = "#3d59a1",
	blue = "#7aa2f7",
	cyan = "#7dcfff",
	blue1 = "#2ac3de",
	blue2 = "#0db9d7",
	blue5 = "#89ddff",
	blue6 = "#B4F9F8",
	blue7 = "#394b70",
	magenta = "#bb9af7",
	magenta2 = "#ff007c",
	purple = "#9d7cd8",
	orange = "#ff9e64",
	yellow = "#e0af68",
	green = "#9ece6a",
	green1 = "#73daca",
	green2 = "#41a6b5",
	teal = "#1abc9c",
	red = "#f7768e",
	red1 = "#db4b4b",
	replacecolor = "#E06C75",

	gitBg = "#304B2E",
	lspBg = "#364463",
	fileinfoBg = "#5C2C2E",
}


function M.ModeColor(m)
	local mode_colors = {
		n = M.colors.blue,
		i = M.colors.green,
		v = M.colors.purple,
		vs = M.colors.purple,
		["^V"] = M.colors.purple,
		V = M.colors.purple,
		["\22"] = M.colors.purple,
		["\22s"] = M.colors.purple,
		Vs = M.colors.purple,
		c = M.colors.magenta,
		no = M.colors.blue,
		s = M.colors.orange,
		S = M.colors.orange,
		ic = M.colors.yellow,
		R = M.colors.red,
		Rv = M.colors.red,
		cv = M.colors.blue,
		ce = M.colors.blue,
		r = M.colors.replacecolor,
		rm = M.colors.replacecolor,
		["r?"] = M.colors.cyan,
		["!"] = M.colors.blue,
		t = M.colors.blue,
	}
	return mode_colors[m]
end


function M.GetModeColor()
	local m = vim.fn.mode() or vim.fn.visualmode()
	local color = M.ModeColor(m)
	vim.api.nvim_command("hi GalaxyModeColor guibg=" .. color)
	vim.api.nvim_command("hi GalaxyModeColorReverse guifg=" .. color)
	return " "
end


return M
