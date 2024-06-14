---@diagnostic disable: cast-local-type
return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local function sort_by_mtime(a, b)
				local astat = vim.loop.fs_stat(a.path)
				local bstat = vim.loop.fs_stat(b.path)
				local mod_a = astat and astat.mtime.sec or 0
				local mod_b = bstat and bstat.mtime.sec or 0
				return mod_a > mod_b
			end

			local function diagnostics_indicator(_, _, diagnostics)
				local symbols = { error = " ", warning = " ", info = " " }
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
					diagnostics_update_in_insert = true,
					diagnostics_indicator = diagnostics_indicator,
					sort_by = sort_by_mtime,
					indicator_icon = "  ",
					buffer_close_icon = "",
					modified_icon = "●",
					show_buffer_icons = true,
					show_buffer_close_icons = true,
					show_close_icon = false,
					show_tab_indicators = true,
					persist_buffer_sort = true,
					right_trunc_marker = "",
					always_show_bufferline = true,
					separator_style = "slant",
					highlights = {
						fill = {
							guifg = { attribute = "fg", highlight = "Normal" },
							guibg = { attribute = "bg", highlight = "StatusLineNC" },
						},
						background = {
							guifg = { attribute = "fg", highlight = "Normal" },
							guibg = { attribute = "bg", highlight = "StatusLine" },
						},
						buffer_visible = {
							gui = "",
							guifg = { attribute = "fg", highlight = "Normal" },
							guibg = { attribute = "bg", highlight = "Normal" },
						},
						buffer_selected = {
							gui = "",
							guifg = { attribute = "fg", highlight = "Normal" },
							guibg = { attribute = "bg", highlight = "Normal" },
						},
						separator = {
							guifg = { attribute = "bg", highlight = "Normal" },
							guibg = { attribute = "bg", highlight = "StatusLine" },
						},
						separator_selected = {
							guifg = { attribute = "fg", highlight = "Special" },
							guibg = { attribute = "bg", highlight = "Normal" },
						},
						separator_visible = {
							guifg = { attribute = "fg", highlight = "Normal" },
							guibg = { attribute = "bg", highlight = "StatusLineNC" },
						},
						close_button = {
							guifg = { attribute = "fg", highlight = "Normal" },
							guibg = { attribute = "bg", highlight = "StatusLine" },
						},
						close_button_selected = {
							guifg = { attribute = "fg", highlight = "normal" },
							guibg = { attribute = "bg", highlight = "normal" },
						},
						close_button_visible = {
							guifg = { attribute = "fg", highlight = "normal" },
							guibg = { attribute = "bg", highlight = "normal" },
						},
					},
				},
			})
		end,
	},
}
