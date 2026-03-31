local M = {}


function M.GetLspClients()
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

local function get_nvim_lsp_diagnostic(diag_type)
  if next(vim.lsp.buf_get_clients(0)) == nil then return '' end
  local active_clients = vim.lsp.get_active_clients()

  if active_clients then
    local result = vim.diagnostic.get(vim.api.nvim_get_current_buf(), { severity = diag_type })
    if result and #result ~= 0 then return #result .. ' ' end
  end
end

function M.GetLspError()
   if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return get_nvim_lsp_diagnostic(vim.diagnostic.severity.ERROR)
  end
  return ''
end

function M.GetLspWarn()
   if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return get_nvim_lsp_diagnostic(vim.diagnostic.severity.WARN)
  end
  return ''
end

function M.GetLspInfo()
   if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return get_nvim_lsp_diagnostic(vim.diagnostic.severity.INFO)
  end
  return ''
end

function M.GetLspHint()
   if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return get_nvim_lsp_diagnostic(vim.diagnostic.severity.HINT)
  end
  return ''
end

return M
