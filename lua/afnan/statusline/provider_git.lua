local M = {}

function M.GitCondition()
	return vim.b[0].gitsigns_head ~= nil
end

local function get_gitsigns_status()
	local ok, dict = pcall(function()
		return vim.api.nvim_buf_get_var(0, "gitsigns_status_dict")
	end)

	if not ok or type(dict) ~= "table" then
		return nil
	end

	return dict
end

function M.GetGitBranch()
	return vim.b[0].gitsigns_head or ""
end

function M.GetAddGitStatus()
	local status = get_gitsigns_status()
	return status and status.added
end

function M.GetModifiedGitStatus()
	local status = get_gitsigns_status()
	return status and status.changed
end

function M.GetRemovedGitStatus()
	local status = get_gitsigns_status()
	return status and status.removed
end

return M
