--[[
-- Winbar configuration from https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/winbar.lua
-- Thanks MariaSolOs!
--]]

local M = {}
local folder_icon = "󰉋"

function M.render()
	local path = vim.fs.normalize(vim.fn.expand("%:p"))

	if vim.startswith(path, "diffview") then
		return string.format("%%#Winbar#%s", path)
	end

	local separator = " %#WinbarSeparator# "

	local prefix, prefix_path = "", ""

	if vim.api.nvim_win_get_width(0) < math.floor(vim.o.columns / 3) then
		path = vim.fn.pathshorten(path)
	else
		local special_dirs = { DOTFILES = vim.env.XDG_CONFIG_HOME, HOME = vim.env.HOME }
		for dir_name, dir_path in pairs(special_dirs) do
			if vim.startswith(path, vim.fs.normalize(dir_path)) and #dir_path > #prefix_path then
				prefix, prefix_path = dir_name, dir_path
			end
		end
		if prefix ~= "" then
			path = path:gsub("^" .. vim.pesc(prefix_path), "")
			prefix = string.format("%%#WinBarDir#%s %s%s", folder_icon, prefix, separator)
		end
	end

	path = path:gsub("^/", "")

	return table.concat({
		prefix,
		table.concat(
			vim.iter(vim.split(path, "/"))
				:map(function(segment)
					if segment == vim.fn.fnamemodify(path, ":t") then
						local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
						local ok, devicons = pcall(require, "nvim-web-devicons")
						local is_not_saved = vim.api.nvim_get_option_value("modified", { buf = 0 })

						if ok then
							local icon = devicons.get_icon_by_filetype(filetype, {})
							local file_status = string.format(
								"%%#WinbarFile#%s %s %s",
								icon,
								segment,
								is_not_saved and "" or ""
							)
							return file_status
						else
							return string.format("%%#Winbar#%s", segment)
						end
					end
					return string.format("%%#WinbarSeparator#%s", segment)
				end)
				:totable(),
			separator
		),
	})
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("hyperAfnan/winbar", { clear = true }),
	desc = "Attach winbar",
	callback = function(args)
		if
			not vim.api.nvim_win_get_config(0).zindex
			and vim.bo[args.buf].buftype == ""
			and vim.api.nvim_buf_get_name(args.buf) ~= ""
			and not vim.wo[0].diff
		then
			vim.wo.winbar = "%{%v:lua.require'afnan.winbar'.render()%}"
		end
	end,
})

return M
