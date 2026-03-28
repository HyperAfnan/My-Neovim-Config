local function complete_packages()
	return vim.iter(vim.pack.get())
		:map(function(pack)
			return pack.spec.name
		end)
		:totable()
end

vim.api.nvim_create_user_command("PackRemove", function(opts)
	vim.pack.del(info.fargs, { force = info.bang })
end, { desc = "Remove packages", nargs = "*", complete = complete_packages, bang = true })

vim.api.nvim_create_user_command("PackUpdate", function(info)
	if #info.fargs ~= 0 then
		vim.pack.update(info.fargs, { force = info.bang })
	else
		vim.pack.update(nil, { force = info.bang })
	end
end, { desc = "Update packages", nargs = "*", bang = true, complete = complete_packages })

local M = {}

M.gh = function(x)
	return "https://github.com/" .. x
end

return M
