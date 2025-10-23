---@diagnostic disable: cast-local-type, undefined-field
return {
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function sort_by_mtime(a, b)
				local astat = vim.loop.fs_stat(a.path)
				local bstat = vim.loop.fs_stat(b.path)
				local mod_a = astat and astat.mtime.sec or 0
				local mod_b = bstat and bstat.mtime.sec or 0
				return mod_a > mod_b
			end

			local function diagnostics_indicator(_, _, diagnostics)
				local symbols = { error = " ", warning = " ", info = " " }
				local result = {}
				for name, count in pairs(diagnostics) do
					if symbols[name] and count > 0 then
						table.insert(result, symbols[name] .. count)
					end
				end
				result = table.concat(result, " ")
				return #result > 0 and result or ""
			end

			require("bufferline").setup({
				options = {
					numbers = "none",
					close_command = "bdelete! %d",
					diagnostics = "nvim_lsp",
					diagnostics_indicator = diagnostics_indicator,
					sort_by = sort_by_mtime,
					indicator_icon = "  ",
					buffer_close_icon = "",
					modified_icon = "●",
					show_buffer_icons = true,
					-- highlights = require("catppuccin.groups.integrations.bufferline"),
					show_buffer_close_icons = true,
					show_close_icon = true,
					show_tab_indicators = true,
					persist_buffer_sort = true,
					right_trunc_marker = "",
					always_show_bufferline = true,
					separator_style = "slope",
					hover = { enabled = true, delay = 200, reveal = { "close" } },
				},
			})
		end,
	},
}
