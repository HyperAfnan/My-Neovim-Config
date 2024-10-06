return {
	--[[ "stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		})
	end, ]]
}
