local gl = require("galaxyline")
local condition = require("galaxyline.condition")
local colors = require("afnan.core.statusline.colors")
local gls = gl.section
-- local status_ok, notifications = pcall(require, "github-notifications")
-- if not status_ok then
-- 	return ""
-- end

--[[
-- Useful functions
--]]
local function mode_color(m)
	local mode_colors = {
		n = colors.blue,
		i = colors.green,
		v = colors.purple,
		vs = colors.purple,
		["^V"] = colors.purple,
		V = colors.purple,
		["\22"] = colors.purple,
		["\22s"] = colors.purple,
		Vs = colors.purple,
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
	return mode_colors[m]
end

local function CommonCondition()
	return true
end

local function LspCondition()
	return true
end

local function GetGitBranch()
	return require("galaxyline.providers.vcs").get_git_branch()
end

-- local function GetGitNotifications()
-- 	return notifications.statusline_notification_count() .. ""
-- end

local function GetCursorPostion()
	local line = vim.fn.line(".")
	local column = vim.fn.col(".")
	return string.format("%3d:%2d", line, column)
end

local function GetModeColor()
	local m = vim.fn.mode() or vim.fn.visualmode()
	local color = mode_color(m)
	vim.api.nvim_command("hi GalaxyModeColor guibg=" .. color)
	vim.api.nvim_command("hi GalaxyModeColorReverse guifg=" .. color)
	return " "
end

local function GetLeftBracket()
	return " " .. ""
end

local function GetRightBracket()
	return "" .. " "
end

-- Left Section

local a = 1
gls.left[a] = {
	ModeColor = {
		icon = "  󰣇 ",
		separator = "",
		separator_highlight = "GalaxyModeColorReverse",
		highlight = { colors.bg, mode_color() },
		provider = GetModeColor,
		condition = CommonCondition,
	},
}

a = a + 1
gls.left[a] = {
	GitSectionBracket1 = {
		provider = GetLeftBracket,
		highlight = { colors.green, colors.bg },
		condition = condition.check_git_workspace,
	},
}
a = a + 1
gls.left[a] = {
	GitIcon = {
		provider = function()
			return "  "
		end,
		highlight = { colors.bg, colors.green },
		condition = condition.check_git_workspace,
	},
}
a = a + 1
gls.left[a] = {
	GitSectionBracket2 = {
		provider = GetRightBracket,
		highlight = { colors.green, colors.gitBg },
		condition = condition.check_git_workspace,
	},
}

a = a + 1
-- gls.left[a] = {
-- 	GithubNotifications = {
-- 		provider = GetGitNotifications,
-- 		highlight = { colors.orange, colors.gitBg },
-- 		condition = condition.check_git_workspace,
-- 	},
-- }
-- a = a + 1
gls.left[a] = {
	GitBranch = {
		provider = GetGitBranch,
		highlight = { colors.fg, colors.gitBg },
		condition = condition.check_git_workspace,
	},
}
a = a + 1
gls.left[a] = {
	GitSectionExtraSpace = {
		provider = function()
			return " "
		end,
		highlight = { colors.green, colors.gitBg },
		condition = condition.check_git_workspace,
	},
}
a = a + 1
gls.left[a] = {
	DiffAdd = {
		provider = "DiffAdd",
		icon = "  ",
		highlight = { colors.green, colors.gitBg },
		condition = condition.check_git_workspace,
	},
}
a = a + 1
gls.left[a] = {
	DiffModified = {
		provider = "DiffModified",
		icon = "  ",
		highlight = { colors.yellow, colors.gitBg },
		condition = condition.check_git_workspace,
	},
}
a = a + 1
gls.left[a] = {
	DiffRemove = {
		provider = "DiffRemove",
		icon = "  ",
		highlight = { colors.red, colors.gitBg },
		condition = condition.check_git_workspace,
	},
}
a = a + 1
gls.left[a] = {
	GitSectionBracket3 = {
		provider = GetRightBracket,
		highlight = { colors.gitBg, colors.bg },
		condition = condition.check_git_workspace,
	},
}

a = a + 1
gls.left[a] = {
	LspSectionBracket1 = {
		provider = GetLeftBracket,
		highlight = { colors.blue, colors.bg },
		condition = LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	LspIcon = {
		provider = function()
			return ""
		end,
		highlight = { colors.bg, colors.blue },
		condition = LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	LspSectionBracket2 = {
		provider = GetRightBracket,
		highlight = { colors.blue, colors.lspBg },
		condition = LspCondition,
	},
}

a = a + 1

function getclients()
	msg = "No Lsp"
	ignored_servers = {}

	local clients = vim.lsp.get_clients()
	if next(clients) == nil then
		return msg
	end

	local client_names = ""
	for _, client in pairs(clients) do
		if not vim.tbl_contains(ignored_servers, client.name) then
			if string.len(client_names) < 1 then
				client_names = client_names .. client.name
			else
				client_names = client_names .. ", " .. client.name
			end
		end
	end
	return string.len(client_names) > 0 and client_names or msg
end

gls.left[a] = {
	LspName = {
		provider = getclients,
		highlight = { colors.fg, colors.lspBg },
		condition = LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiagnosticError = {
		provider = "DiagnosticError",
		icon = "   ",
		highlight = { colors.red, colors.lspBg },
		condition = LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiagnosticWarn = {
		provider = "DiagnosticWarn",
		icon = "   ",
		highlight = { colors.yellow, colors.lspBg },
		condition = LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiagnosticHint = {
		provider = "DiagnosticHint",
		icon = "   ",
		highlight = { colors.cyan, colors.lspBg },
		condition = LspCondition,
	},
}

a = a + 1
gls.left[a] = {
	DiagnosticInfo = {
		provider = "DiagnosticInfo",
		icon = "   ",
		highlight = { colors.blue, colors.lspBg },
		condition = LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	LspSectionBracket3 = {
		provider = GetRightBracket,
		highlight = { colors.lspBg, colors.bg },
		condition = LspCondition,
	},
}

-- Right Section

local b = 1
gls.right[b] = {
	FileInfoSectionBracket1 = {
		provider = GetLeftBracket,
		highlight = { colors.orange, colors.bg },
		condition = CommonCondition,
	},
}
b = b + 1
gls.right[b] = {
	FileIcon = {
		provider = "FileIcon",
		highlight = { colors.bg, colors.orange },
		condition = CommonCondition,
	},
}
b = b + 1
gls.right[b] = {
	FileInfoSectionBracket2 = {
		provider = GetRightBracket,
		highlight = { colors.orange, colors.fileinfoBg },
		condition = CommonCondition,
	},
}
b = b + 1
gls.right[b] = {
	CursorPosition = {
		provider = GetCursorPostion,
		highlight = { colors.fg, colors.fileinfoBg },
		condition = CommonCondition,
	},
}
b = b + 1
gls.right[b] = {
	FileInfoSectionBracket3 = {
		provider = GetRightBracket,
		highlight = { colors.fileinfoBg, colors.bg },
		condition = CommonCondition,
	},
}
