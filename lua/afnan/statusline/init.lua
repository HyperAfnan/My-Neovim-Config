local gh = require("afnan.pack").gh

vim.pack.add({
	{ src = gh("jamesyoon11/galaxyline.nvim") },
	{ src = gh("nvim-tree/nvim-web-devicons") },
})

vim.cmd.packadd("nvim-web-devicons")
vim.cmd.packadd("galaxyline.nvim")

local gl = require("galaxyline")
local git = require("afnan.statusline.provider_git")
local lsp = require("afnan.statusline.provider_lsp")
local file = require("afnan.statusline.provider_file")
local mode = require("afnan.statusline.provider_mode")
local gls = gl.section

local function GetLeftBracket()
	return " " .. ""
end
local function GetRightBracket()
	return "" .. " "
end

vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })

local a = 1
local b = 1

---------------------------------------------------------------

gls.left[a] = {
	ModeColor = {
		icon = "  󰣇",
		separator = "",
		separator_highlight = "GalaxyModeColorReverse",
		highlight = { mode.colors.bg_dark, mode.ModeColor() },
		provider = mode.GetModeColor,
	},
}

a = a + 1
gls.left[a] = {
	GitSectionBracket1 = {
		provider = GetLeftBracket,
		highlight = { mode.colors.green, mode.colors.bg },
		condition = git.GitCondition,
	},
}
a = a + 1
gls.left[a] = {
	GitIcon = {
		provider = function()
			return "  "
		end,
		highlight = { mode.colors.bg_dark, mode.colors.green },
		condition = git.GitCondition,
	},
}
a = a + 1
gls.left[a] = {
	GitSectionBracket2 = {
		provider = GetRightBracket,
		highlight = { mode.colors.green, mode.colors.gitBg },
		condition = git.GitCondition,
	},
}

a = a + 1
gls.left[a] = {
	GitBranch = {
		provider = git.GetGitBranch,
		highlight = { mode.colors.fg, mode.colors.gitBg },
		condition = git.GitCondition,
	},
}
a = a + 1
gls.left[a] = {
	GitSectionExtraSpace = {
		provider = function()
			return " "
		end,
		highlight = { mode.colors.green, mode.colors.gitBg },
		condition = git.GitCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiffAdd = {
		provider = git.GetAddGitStatus,
		icon = "  ",
		highlight = { mode.colors.green, mode.colors.gitBg },
		condition = git.GitCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiffModified = {
		provider = git.GetModifiedGitStatus,
		icon = "   ",
		highlight = { mode.colors.yellow, mode.colors.gitBg },
		condition = git.GitCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiffRemove = {
		provider = git.GetRemovedGitStatus,
		icon = "   ",
		highlight = { mode.colors.red, mode.colors.gitBg },
		condition = git.GitCondition,
	},
}
a = a + 1
gls.left[a] = {
	GitSectionBracket3 = {
		provider = GetRightBracket,
		highlight = { mode.colors.gitBg, mode.colors.bg },
		condition = git.GitCondition,
	},
}

a = a + 1
gls.left[a] = {
	LspSectionBracket1 = {
		provider = GetLeftBracket,
		highlight = { mode.colors.blue, mode.colors.bg },
		condition = lsp.LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	LspIcon = {
		provider = function()
			return "  "
		end,
		highlight = { mode.colors.bg_dark, mode.colors.blue },
		condition = lsp.LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	LspSectionBracket2 = {
		provider = GetRightBracket,
		highlight = { mode.colors.blue, mode.colors.lspBg },
		condition = lsp.LspCondition,
	},
}

a = a + 1

gls.left[a] = {
	LspName = {
		provider = lsp.GetLspClients,
		highlight = { mode.colors.fg, mode.colors.lspBg },
		condition = lsp.LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiagnosticError = {
		provider = lsp.GetLspError,
		icon = "   ",
		highlight = { mode.colors.red, mode.colors.lspBg },
		condition = lsp.LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiagnosticWarn = {
		provider = lsp.GetLspWarn,
		icon = "   ",
		highlight = { mode.colors.yellow, mode.colors.lspBg },
		condition = lsp.LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	DiagnosticHint = {
		provider = lsp.GetLspHint,
		icon = "   ",
		highlight = { mode.colors.cyan, mode.colors.lspBg },
		condition = lsp.LspCondition,
	},
}

a = a + 1
gls.left[a] = {
	DiagnosticInfo = {
		provider = lsp.GetLspInfo,
		icon = "   ",
		highlight = { mode.colors.blue, mode.colors.lspBg },
		condition = lsp.LspCondition,
	},
}
a = a + 1
gls.left[a] = {
	LspSectionBracket3 = {
		provider = GetRightBracket,
		highlight = { mode.colors.lspBg, mode.colors.bg },
		condition = lsp.LspCondition,
	},
}

---------------------------------------------------------------

gls.right[b] = {
	FileInfoSectionBracket1 = {
		provider = GetLeftBracket,
		highlight = { mode.colors.orange, mode.colors.bg },
		condition = file.FileCondition,
	},
}
b = b + 1
gls.right[b] = {
	FileIcon = {
		provider = file.getCurrentFileIcon,
		highlight = { mode.colors.bg_dark, mode.colors.orange },
		condition = file.FileCondition,
	},
}
b = b + 1
gls.right[b] = {
	FileInfoSectionBracket2 = {
		provider = GetRightBracket,
		highlight = { mode.colors.orange, mode.colors.fileinfoBg },
		condition = file.FileCondition,
	},
}
b = b + 1
gls.right[b] = {
	CursorPosition = {
		provider = file.GetCursorPostion,
		highlight = { mode.colors.fg, mode.colors.fileinfoBg },
		condition = file.FileCondition,
	},
}
b = b + 1
gls.right[b] = {
	FileProgress = {
		provider = file.GetCursorPercentage,
		highlight = { mode.colors.fg, mode.colors.fileinfoBg },
		condition = file.FileCondition,
	},
}
b = b + 1
gls.right[b] = {
	FileInfoSectionBracket3 = {
		provider = GetRightBracket,
		highlight = { mode.colors.fileinfoBg, mode.colors.bg },
		condition = file.FileCondition,
	},
}
