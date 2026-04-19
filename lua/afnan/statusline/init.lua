local gh = require("afnan.pack").gh

vim.pack.add({
	{ src = gh("vimposter/vim-tpipeline") },
	{ src = gh("nvim-tree/nvim-web-devicons") },
})

vim.cmd.packadd("nvim-web-devicons")
vim.cmd.packadd("vim-tpipeline")

local git = require("afnan.statusline.provider_git")
local lsp = require("afnan.statusline.provider_lsp")
local file = require("afnan.statusline.provider_file")
local mode = require("afnan.statusline.provider_mode")

local function GetLeftBracket()
	return ""
end
local function GetRightBracket()
	return ""
end

vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })

local M = {}

M.get_neovim_component = function()
	return table.concat({
		"%#StatuslineModeColorReverse#%*",
		"%#StatuslineModeColor#  %*",
		"%#StatuslineModeColorReverse#",
		GetRightBracket(),
		"%*",
		" ",
	})
end

M.get_git_component = function()
   if not git.GitCondition() then return "" end

   local function has_value(val)
      return val and val ~= "" and tonumber(val) and tonumber(val) ~= 0
   end

   local branch  = git.GetGitBranch()
   local added   = git.GetAddGitStatus()
   local removed = git.GetRemovedGitStatus()
   local modified= git.GetModifiedGitStatus()

   local subComponents = {
      "%#StatuslineGitPrimary#", GetLeftBracket(), "%*",
      "%#StatuslineGitPrimaryReverse#", " ", "%*",
      "%#StatuslineGitPrimary#", GetRightBracket(), "%*",
      "%#StatuslineGitSecondary# %*",
   }

   if branch and branch ~= "" then
      table.insert(subComponents, "%#StatuslineGitSecondary#")
      table.insert(subComponents, branch)
      table.insert(subComponents, "%*")
   end

   if has_value(added) then
      table.insert(subComponents, "%#StatuslineGitSecondary# %*")
      table.insert(subComponents, "%#StatuslineGitAdd#")
      table.insert(subComponents, " ")
      table.insert(subComponents, added)
      table.insert(subComponents, "%*")
   end

   if has_value(removed) then
      table.insert(subComponents, "%#StatuslineGitSecondary# %*")
      table.insert(subComponents, "%#StatuslineGitRemoved#")
      table.insert(subComponents, " ")
      table.insert(subComponents, removed)
      table.insert(subComponents, "%*")
   end

   if has_value(modified) then
      table.insert(subComponents, "%#StatuslineGitSecondary# %*")
      table.insert(subComponents, "%#StatuslineGitModified#")
      table.insert(subComponents, " ")
      table.insert(subComponents, modified)
      table.insert(subComponents, "%*")
   end

   table.insert(subComponents, "%#StatuslineGitSecondaryReverse#")
   table.insert(subComponents, GetRightBracket())
   table.insert(subComponents, "%*")
   table.insert(subComponents, " ")

   return table.concat(subComponents)
end

M.get_lsp_component = function()
   if not lsp.LspCondition() then return "" end

   local function has_value(val)
      return val and val ~= "" and tonumber(val) and tonumber(val) ~= 0
   end

   local clients = lsp.GetLspClients()
   local err  = lsp.GetLspError()
   local warn = lsp.GetLspWarn()
   local info = lsp.GetLspInfo()
   local hint = lsp.GetLspHint()

   if (not clients or clients == "")
      and not (has_value(err) or has_value(warn) or has_value(info) or has_value(hint)) then
      return ""
   end

   local parts = {
      "%#StatuslineLspPrimary#", GetLeftBracket(), "%*",
      "%#StatuslineLspPrimaryReverse#", " ", "%*",
      "%#StatuslineLspPrimary#", GetRightBracket(), "%*",
      "%#StatuslineLspSecondary# %*",
   }

   if clients and clients ~= "" then
      table.insert(parts, "%#StatuslineLspSecondary#")
      table.insert(parts, clients)
      table.insert(parts, "%*")
      table.insert(parts, "%#StatuslineLspSecondary# %*")
   end

   if has_value(err) then
      table.insert(parts, "%#StatuslineLspError#")
      table.insert(parts, " ")
      table.insert(parts, err)
      table.insert(parts, "%*")
      table.insert(parts, "%#StatuslineLspSecondary# %*")
   end

   if has_value(warn) then
      table.insert(parts, "%#StatuslineLspWarn#")
      table.insert(parts, " ")
      table.insert(parts, warn)
      table.insert(parts, "%*")
      table.insert(parts, "%#StatuslineLspSecondary# %*")
   end

   if has_value(info) then
      table.insert(parts, "%#StatuslineLspInfo#")
      table.insert(parts, " ")
      table.insert(parts, info)
      table.insert(parts, "%*")
      table.insert(parts, "%#StatuslineLspSecondary# %*")
   end

   if has_value(hint) then
      table.insert(parts, "%#StatuslineLspHint#")
      table.insert(parts, " ")
      table.insert(parts, hint)
      table.insert(parts, "%*")
   end

   table.insert(parts, "%#StatuslineLspSecondaryReverse#")
   table.insert(parts, GetRightBracket())
   table.insert(parts, "%*")
   table.insert(parts, " ")

   return table.concat(parts)
end

M.get_file_component = function()
   if not file.FileCondition() then return "" end
	return table.concat({
		"%#StatuslineFilePrimary#",
		GetLeftBracket(),
		"%*",
		"%#StatuslineFilePrimaryReverse#",
		file.GetCurrentFileIcon(), " %*",
		"%#StatuslineFilePrimary#",
		GetRightBracket(),
		"%*",

		"%#StatuslineFileSecondary#",
		" %l:%c:%p %*",
		"%*",
		"%#StatuslineFileSecondaryReverse#",
		GetRightBracket(),
		"%*",
		" ",
	})
end

M.render = function()
   mode.SetupHighlights()
	return table.concat({
		M.get_neovim_component(),
		M.get_git_component(),
		M.get_lsp_component(),
		"%=",
		M.get_file_component(),
	})
end

vim.opt.statusline = "%!v:lua.require('afnan.statusline').render()"

return M
