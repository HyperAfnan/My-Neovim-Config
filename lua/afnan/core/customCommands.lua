local function openurl()
	return vim.ui.open(vim.fn.expand("<cWORD>"))
end

vim.api.nvim_create_user_command("OpenUrl", openurl, {})
