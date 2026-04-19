local M = {}

local bufnr = vim.api.nvim_get_current_buf()

function M.LspCondition()
	return not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = bufnr }))
end

function M.GetLspClients()
	msg = "No Lsp"
	ignored_servers = {}

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if next(clients) == nil then
		return msg
	end

	local client_names = ""
	local ignored_servers = { "copilot", "snippets_ls" }
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

local function get_nvim_lsp_diagnostic(diag_type)
	local active_clients = vim.lsp.get_clients({ bufnr = bufnr })

	if active_clients then
		local result = vim.diagnostic.get(bufnr, { severity = diag_type })
		if result and #result ~= 0 then
			return #result
		end
	end
end

function M.GetLspError()
	return get_nvim_lsp_diagnostic(vim.diagnostic.severity.ERROR) or ""
end

function M.GetLspWarn()
	return get_nvim_lsp_diagnostic(vim.diagnostic.severity.WARN) or ""
end

function M.GetLspInfo()
	return get_nvim_lsp_diagnostic(vim.diagnostic.severity.INFO) or ""
end

function M.GetLspHint()
	return get_nvim_lsp_diagnostic(vim.diagnostic.severity.HINT) or ""
end

function M.ErrorClicked()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end

function M.WarnClicked()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
end

function M.InfoClicked()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.INFO })
end

function M.HintClicked()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.HINT })
end

function M.OpenInQFix()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end

-- TODO: move diagnosetic soruce to vim.lsp.diagnose.count

return M
